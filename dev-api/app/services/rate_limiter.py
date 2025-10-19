"""
Rate limiting service for API key management
"""
import asyncio
import time
from typing import Dict, Optional, Tuple
from datetime import datetime, timedelta
import logging

logger = logging.getLogger(__name__)


class InMemoryRateLimiter:
    """
    In-memory rate limiter using token bucket algorithm.
    For production, consider using Redis for distributed rate limiting.
    """
    
    def __init__(self):
        """Initialize the rate limiter with in-memory storage."""
        self._buckets: Dict[str, Dict] = {}
        self._lock = asyncio.Lock()
        
    async def is_allowed(
        self,
        api_key_id: str,
        rate_limit: int,
        window_seconds: int = 3600  # 1 hour default
    ) -> Tuple[bool, Dict[str, int]]:
        """
        Check if a request is allowed for the given API key.
        
        Args:
            api_key_id: The API key identifier
            rate_limit: Maximum requests allowed in the window
            window_seconds: Time window in seconds (default: 1 hour)
            
        Returns:
            Tuple of (is_allowed, rate_limit_info)
            rate_limit_info contains: limit, remaining, reset_time
        """
        async with self._lock:
            now = time.time()
            
            # Initialize bucket if not exists
            if api_key_id not in self._buckets:
                self._buckets[api_key_id] = {
                    'tokens': rate_limit,
                    'last_refill': now,
                    'rate_limit': rate_limit,
                    'window_seconds': window_seconds
                }
            
            bucket = self._buckets[api_key_id]
            
            # Update bucket configuration if changed
            if bucket['rate_limit'] != rate_limit or bucket['window_seconds'] != window_seconds:
                bucket['rate_limit'] = rate_limit
                bucket['window_seconds'] = window_seconds
                # Reset tokens if limit increased
                if rate_limit > bucket['tokens']:
                    bucket['tokens'] = rate_limit
            
            # Calculate tokens to add based on time elapsed
            time_passed = now - bucket['last_refill']
            tokens_to_add = int((time_passed / window_seconds) * rate_limit)
            
            if tokens_to_add > 0:
                bucket['tokens'] = min(rate_limit, bucket['tokens'] + tokens_to_add)
                bucket['last_refill'] = now
            
            # Check if request is allowed
            if bucket['tokens'] >= 1:
                bucket['tokens'] -= 1
                allowed = True
            else:
                allowed = False
            
            # Calculate reset time (when bucket will be full again)
            tokens_needed = rate_limit - bucket['tokens']
            reset_time = int(now + (tokens_needed * window_seconds / rate_limit))
            
            rate_limit_info = {
                'limit': rate_limit,
                'remaining': int(bucket['tokens']),
                'reset_time': reset_time,
                'retry_after': max(1, int(window_seconds / rate_limit)) if not allowed else None
            }
            
            return allowed, rate_limit_info
    
    async def get_usage_info(self, api_key_id: str) -> Optional[Dict[str, int]]:
        """Get current usage information for an API key."""
        async with self._lock:
            if api_key_id not in self._buckets:
                return None
                
            bucket = self._buckets[api_key_id]
            now = time.time()
            
            # Calculate current tokens
            time_passed = now - bucket['last_refill']
            tokens_to_add = int((time_passed / bucket['window_seconds']) * bucket['rate_limit'])
            current_tokens = min(bucket['rate_limit'], bucket['tokens'] + tokens_to_add)
            
            return {
                'limit': bucket['rate_limit'],
                'remaining': int(current_tokens),
                'used': bucket['rate_limit'] - int(current_tokens),
                'reset_time': int(now + ((bucket['rate_limit'] - current_tokens) * bucket['window_seconds'] / bucket['rate_limit']))
            }
    
    async def reset_bucket(self, api_key_id: str) -> bool:
        """Reset the rate limit bucket for an API key (admin function)."""
        async with self._lock:
            if api_key_id in self._buckets:
                bucket = self._buckets[api_key_id]
                bucket['tokens'] = bucket['rate_limit']
                bucket['last_refill'] = time.time()
                return True
            return False
    
    async def cleanup_expired_buckets(self, max_idle_hours: int = 24) -> int:
        """
        Clean up buckets that haven't been used for a while.
        Returns the number of buckets removed.
        """
        async with self._lock:
            now = time.time()
            cutoff_time = now - (max_idle_hours * 3600)
            
            expired_keys = [
                key for key, bucket in self._buckets.items()
                if bucket['last_refill'] < cutoff_time
            ]
            
            for key in expired_keys:
                del self._buckets[key]
                
            if expired_keys:
                logger.info(f"Cleaned up {len(expired_keys)} expired rate limit buckets")
                
            return len(expired_keys)


class RedisRateLimiter:
    """
    Redis-based rate limiter for production use.
    This is a placeholder implementation - requires Redis dependency.
    """
    
    def __init__(self, redis_url: str = "redis://localhost:6379"):
        """Initialize Redis rate limiter."""
        self.redis_url = redis_url
        self._redis = None
        
    async def initialize(self):
        """Initialize Redis connection."""
        try:
            import redis.asyncio as redis
            self._redis = redis.from_url(self.redis_url)
            await self._redis.ping()
            logger.info("Redis rate limiter initialized successfully")
        except ImportError:
            logger.error("Redis not available. Please install: pip install redis")
            raise
        except Exception as e:
            logger.error(f"Failed to connect to Redis: {e}")
            raise
    
    async def is_allowed(
        self,
        api_key_id: str,
        rate_limit: int,
        window_seconds: int = 3600
    ) -> Tuple[bool, Dict[str, int]]:
        """
        Check if request is allowed using Redis sliding window.
        """
        if not self._redis:
            raise RuntimeError("Redis not initialized")
            
        now = time.time()
        key = f"rate_limit:{api_key_id}"
        
        # Use Redis sliding window log algorithm
        pipeline = self._redis.pipeline()
        
        # Remove expired entries
        pipeline.zremrangebyscore(key, 0, now - window_seconds)
        
        # Count current requests
        pipeline.zcard(key)
        
        # Add current request
        pipeline.zadd(key, {str(now): now})
        
        # Set expiration
        pipeline.expire(key, window_seconds)
        
        results = await pipeline.execute()
        current_requests = results[1]
        
        allowed = current_requests < rate_limit
        
        if not allowed:
            # Remove the request we just added
            await self._redis.zrem(key, str(now))
        
        rate_limit_info = {
            'limit': rate_limit,
            'remaining': max(0, rate_limit - current_requests),
            'reset_time': int(now + window_seconds),
            'retry_after': 1 if not allowed else None
        }
        
        return allowed, rate_limit_info


# Global rate limiter instance
_rate_limiter: Optional[InMemoryRateLimiter] = None


def get_rate_limiter() -> InMemoryRateLimiter:
    """Get the global rate limiter instance."""
    global _rate_limiter
    if _rate_limiter is None:
        _rate_limiter = InMemoryRateLimiter()
    return _rate_limiter


async def check_rate_limit(
    api_key_id: str,
    rate_limit: int,
    window_seconds: int = 3600
) -> Tuple[bool, Dict[str, int]]:
    """
    Convenience function to check rate limits.
    
    Args:
        api_key_id: API key identifier
        rate_limit: Requests per window
        window_seconds: Time window in seconds
        
    Returns:
        Tuple of (is_allowed, rate_limit_info)
    """
    limiter = get_rate_limiter()
    return await limiter.is_allowed(api_key_id, rate_limit, window_seconds)


async def get_rate_limit_info(api_key_id: str) -> Optional[Dict[str, int]]:
    """Get current rate limit info for an API key."""
    limiter = get_rate_limiter()
    return await limiter.get_usage_info(api_key_id)


# Cleanup task to run periodically
async def cleanup_rate_limit_buckets():
    """Background task to clean up expired rate limit buckets."""
    limiter = get_rate_limiter()
    while True:
        try:
            await asyncio.sleep(3600)  # Run every hour
            await limiter.cleanup_expired_buckets()
        except Exception as e:
            logger.error(f"Error in rate limit cleanup task: {e}")
            await asyncio.sleep(300)  # Wait 5 minutes on error
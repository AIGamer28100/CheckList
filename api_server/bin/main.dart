import 'dart:io';
import 'package:logging/logging.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_cors_headers/shelf_cors_headers.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_static/shelf_static.dart';
import 'package:dotenv/dotenv.dart';

import 'src/routes/api_routes.dart';
import 'src/middleware/auth_middleware.dart';
import 'src/middleware/logging_middleware.dart';
import 'src/middleware/error_middleware.dart';
import 'src/database/database.dart';
import 'src/services/auth_service.dart';

void main(List<String> args) async {
  // Initialize logging
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    print('${record.time}: ${record.level.name}: ${record.message}');
    if (record.error != null) {
      print('Error: ${record.error}');
    }
    if (record.stackTrace != null) {
      print('Stack trace: ${record.stackTrace}');
    }
  });

  final logger = Logger('CheckListAPI');

  // Load environment variables
  final env = DotEnv()..load(['api_server/.env']);

  // Initialize database
  final database = AppDatabase();
  await database.initialize();

  // Initialize services
  final authService = AuthService(database);

  // Create router for API routes
  final apiRouter = ApiRoutes(database, authService).router;

  // Create main router
  final router = Router()
    ..mount('/api/v1/', apiRouter.call)
    ..mount('/docs/', createStaticHandler('api_server/docs/'))
    ..get('/health', (Request request) {
      return Response.ok(
        '{"status": "healthy", "timestamp": "${DateTime.now().toIso8601String()}"}',
        headers: {'Content-Type': 'application/json'},
      );
    })
    ..get('/', (Request request) {
      return Response.ok(
        '''
<!DOCTYPE html>
<html>
<head>
    <title>CheckList API</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; background: #f5f5f5; }
        .container { max-width: 800px; margin: 0 auto; background: white; padding: 30px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
        h1 { color: #1976d2; }
        .endpoint { background: #f8f9fa; padding: 15px; margin: 10px 0; border-left: 4px solid #1976d2; }
        .method { font-weight: bold; color: #28a745; }
        .method.post { color: #ffc107; }
        .method.put { color: #17a2b8; }
        .method.delete { color: #dc3545; }
    </style>
</head>
<body>
    <div class="container">
        <h1>🚀 CheckList API Server</h1>
        <p>Welcome to the CheckList API! This server provides RESTful endpoints for task management.</p>
        
        <h2>📋 Available Endpoints</h2>
        
        <div class="endpoint">
            <span class="method">GET</span> <code>/health</code> - Server health check
        </div>
        
        <div class="endpoint">
            <span class="method">GET</span> <code>/api/v1/tasks</code> - List all tasks
        </div>
        
        <div class="endpoint">
            <span class="method post">POST</span> <code>/api/v1/tasks</code> - Create new task
        </div>
        
        <div class="endpoint">
            <span class="method">GET</span> <code>/api/v1/tasks/{id}</code> - Get specific task
        </div>
        
        <div class="endpoint">
            <span class="method put">PUT</span> <code>/api/v1/tasks/{id}</code> - Update task
        </div>
        
        <div class="endpoint">
            <span class="method delete">DELETE</span> <code>/api/v1/tasks/{id}</code> - Delete task
        </div>
        
        <div class="endpoint">
            <span class="method post">POST</span> <code>/api/v1/auth/login</code> - User authentication
        </div>
        
        <div class="endpoint">
            <span class="method post">POST</span> <code>/api/v1/auth/register</code> - User registration
        </div>
        
        <h2>📚 Documentation</h2>
        <p><a href="/docs/">API Documentation</a></p>
        
        <h2>🔐 Authentication</h2>
        <p>API requires JWT authentication. Include the token in the Authorization header:</p>
        <code>Authorization: Bearer YOUR_JWT_TOKEN</code>
    </div>
</body>
</html>''',
        headers: {'Content-Type': 'text/html'},
      );
    });

  // Create middleware pipeline
  final handler = Pipeline()
      .addMiddleware(corsHeaders())
      .addMiddleware(loggingMiddleware())
      .addMiddleware(errorMiddleware())
      .addHandler(router.call);

  // Get port from environment or use default
  final port = int.parse(env['PORT'] ?? '8080');
  final host = env['HOST'] ?? 'localhost';

  // Start server
  final server = await serve(handler, host, port);
  logger.info(
    '🚀 CheckList API server started at http://${server.address.host}:${server.port}',
  );
  logger.info(
    '📚 API Documentation: http://${server.address.host}:${server.port}/docs/',
  );
  logger.info(
    '💻 Health Check: http://${server.address.host}:${server.port}/health',
  );

  // Handle graceful shutdown
  ProcessSignal.sigint.watch().listen((signal) async {
    logger.info('Received SIGINT, shutting down server...');
    await server.close();
    await database.close();
    exit(0);
  });
}

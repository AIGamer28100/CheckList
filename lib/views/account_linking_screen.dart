import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/linked_provider.dart';
import '../services/account_linking_service.dart';

class AccountLinkingScreen extends StatefulWidget {
  const AccountLinkingScreen({super.key});

  @override
  State<AccountLinkingScreen> createState() => _AccountLinkingScreenState();
}

class _AccountLinkingScreenState extends State<AccountLinkingScreen> {
  final AccountLinkingService _accountLinkingService = AccountLinkingService();
  List<LinkedProvider> _linkedProviders = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLinkedProviders();
  }

  Future<void> _loadLinkedProviders() async {
    setState(() => _isLoading = true);
    try {
      final providers = await _accountLinkingService.getLinkedProviders();
      setState(() {
        _linkedProviders = providers;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error loading providers: $e')));
      }
    }
  }

  Future<void> _linkGoogleAccount() async {
    try {
      await _accountLinkingService.linkGoogleAccount();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Google account linked successfully!')),
        );
      }
      await _loadLinkedProviders();
    } on FirebaseAuthException catch (e) {
      String message = 'Error linking Google account';
      if (e.code == 'provider-already-linked') {
        message = 'This Google account is already linked';
      } else if (e.code == 'credential-already-in-use') {
        message = 'This Google account is used by another user';
      }
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  Future<void> _linkEmailPassword() async {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Link Email & Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Link'),
          ),
        ],
      ),
    );

    if (result == true) {
      try {
        await _accountLinkingService.linkEmailPassword(
          email: emailController.text.trim(),
          password: passwordController.text,
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Email/password linked successfully!'),
            ),
          );
        }
        await _loadLinkedProviders();
      } on FirebaseAuthException catch (e) {
        String message = 'Error linking email/password';
        if (e.code == 'provider-already-linked') {
          message = 'Email/password is already linked';
        } else if (e.code == 'email-already-in-use') {
          message = 'This email is already in use by another account';
        } else if (e.code == 'weak-password') {
          message = 'Password is too weak';
        }
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(message)));
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error: $e')));
        }
      }
    }
  }

  Future<void> _unlinkProvider(LinkedProvider provider) async {
    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Unlink Provider'),
        content: Text(
          'Are you sure you want to unlink ${provider.providerType.displayName}? '
          'You won\'t be able to sign in with this provider anymore.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Unlink'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await _accountLinkingService.unlinkProvider(provider.providerId);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '${provider.providerType.displayName} unlinked successfully!',
              ),
            ),
          );
        }
        await _loadLinkedProviders();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error: $e')));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Linked Accounts')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadLinkedProviders,
              child: Column(
                children: [
                  // Header section
                  Container(
                    padding: const EdgeInsets.all(16),
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Account Security',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Link multiple sign-in methods to your account for easier access and better security.',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),

                  // Linked providers list
                  Expanded(
                    child: _linkedProviders.isEmpty
                        ? const Center(child: Text('No providers linked'))
                        : ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: _linkedProviders.length,
                            itemBuilder: (context, index) {
                              final provider = _linkedProviders[index];
                              return Card(
                                margin: const EdgeInsets.only(bottom: 12),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage: provider.photoUrl != null
                                        ? NetworkImage(provider.photoUrl!)
                                        : null,
                                    child: provider.photoUrl == null
                                        ? Icon(_getProviderIcon(provider))
                                        : null,
                                  ),
                                  title: Text(
                                    provider.providerType.displayName,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (provider.email.isNotEmpty)
                                        Text(provider.email),
                                      if (provider.isPrimary)
                                        const Chip(
                                          label: Text('Primary'),
                                          materialTapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                        ),
                                    ],
                                  ),
                                  trailing:
                                      provider.providerType.canUnlink &&
                                          _linkedProviders.length > 1
                                      ? IconButton(
                                          icon: const Icon(Icons.link_off),
                                          color: Colors.red,
                                          onPressed: () =>
                                              _unlinkProvider(provider),
                                        )
                                      : null,
                                ),
                              );
                            },
                          ),
                  ),

                  // Add provider buttons
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, -2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Add Sign-In Method',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 12),
                        if (!_accountLinkingService.isProviderLinked(
                          AuthProviderType.google,
                        ))
                          ElevatedButton.icon(
                            onPressed: _linkGoogleAccount,
                            icon: const Icon(Icons.email),
                            label: const Text('Link Google Account'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(16),
                            ),
                          ),
                        const SizedBox(height: 8),
                        if (!_accountLinkingService.isProviderLinked(
                          AuthProviderType.email,
                        ))
                          ElevatedButton.icon(
                            onPressed: _linkEmailPassword,
                            icon: const Icon(Icons.lock),
                            label: const Text('Link Email & Password'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(16),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  IconData _getProviderIcon(LinkedProvider provider) {
    switch (provider.providerType) {
      case AuthProviderType.google:
        return Icons.email;
      case AuthProviderType.github:
        return Icons.code;
      case AuthProviderType.email:
        return Icons.lock;
      case AuthProviderType.apple:
        return Icons.apple;
      case AuthProviderType.microsoft:
        return Icons.business;
      case AuthProviderType.anonymous:
        return Icons.person_outline;
    }
  }
}

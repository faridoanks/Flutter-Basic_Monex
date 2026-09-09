import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_links/app_links.dart';

import 'package:monex/core/network/internet_listener.dart';
import 'package:monex/core/theme/app_theme.dart';

import 'package:monex/core/routes/app_router.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const ProviderScope(child: MyApp()));
}



class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  StreamSubscription<Uri>? _linkSubscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
    _initDeepLinks();
  });
  }

  Future<void> _initDeepLinks() async {
    final appLinks = AppLinks();

    _linkSubscription = appLinks.uriLinkStream.listen(
      (uri) {
        debugPrint('Deep Link received: $uri');

        

        final nestedLink = uri.queryParameters['link'];

        if (nestedLink == null || nestedLink.isEmpty) {
          debugPrint('Link parameter not found');
          
          return;
        }

        debugPrint('Firebase action link found');

        final actionUri = Uri.tryParse(nestedLink);

        if (actionUri == null) {
          debugPrint('Failed to parse Firebase action link');
          return;
        }

        final mode = actionUri.queryParameters['mode'];
        final oobCode = actionUri.queryParameters['oobCode'];

        debugPrint('Mode: $mode');

        if (mode != 'resetPassword') {
          debugPrint('Not a reset password action');
          return;
        }

        if (oobCode == null || oobCode.isEmpty) {
          debugPrint('oobCode not found');
          return;
        }

        debugPrint('Reset Password oobCode found');

        router.go('/reset-password?oobCode=${Uri.encodeComponent(oobCode)}');
      },
      onError: (error) {
        debugPrint('Deep Link Error: $error');
      },
    );
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Monex',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      builder: (context, child) {
        return InternetListener(child: child!);
      },
    );
  }
}

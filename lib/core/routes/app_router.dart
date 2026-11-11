import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:monex/features/auth/forgotPassword/forgot_password_page.dart';
import 'package:monex/features/auth/forgotPassword/reset_password_page.dart';
import 'package:monex/features/dashboard/overview_card_page.dart';
import 'package:monex/features/login/login_page.dart';
import 'package:monex/features/register/register_page.dart';

import 'package:monex/features/onboarding/introduction_page.dart';
import 'package:monex/features/onboarding/onboarding_page.dart';

import 'package:monex/features/dashboard/dashboard_page.dart';
import 'package:monex/features/profile/profile_page.dart';
import 'package:monex/features/profile/setting_page.dart';

import 'package:monex/features/reminders/add_reminders_page.dart';
import 'package:monex/features/reminders/reminders_page.dart';
import 'package:monex/features/savings/add_goals_page.dart';

import 'package:monex/features/savings/add_savings_page.dart';
import 'package:monex/features/savings/savings_page.dart';

import 'package:monex/features/notifications/notifications_page.dart';
import 'package:monex/features/home/home_page.dart';
import 'package:monex/features/noConnection/no_connection_page.dart';
import 'package:monex/features/transactions/add_transaction_page.dart';
import 'package:monex/widgets/custom_add_card.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'root',
);

final GoRouter router = GoRouter(
  initialLocation: '/',
  navigatorKey: rootNavigatorKey,

  routes: <RouteBase>[
    GoRoute(path: '/', builder: (context, state) => IntroductionPage()),

    GoRoute(
      path: '/no_connection',
      builder: (context, state) => const NoConnectionPage(),
    ),

    GoRoute(
      path: '/onboarding',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          transitionDuration: const Duration(milliseconds: 500),
          child: OnBoardingPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position:
                  Tween<Offset>(
                    begin: const Offset(1.0, 0.0),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(parent: animation, curve: Curves.easeInOut),
                  ),
              child: child,
            );
          },
        );
      },
    ),

    GoRoute(path: '/register', builder: (context, state) => RegisterPage()),

    GoRoute(
      path: '/login',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          transitionDuration: const Duration(milliseconds: 200),
          child: LoginPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position:
                  Tween<Offset>(
                    begin: const Offset(1.0, 0.0),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(parent: animation, curve: Curves.easeInOut),
                  ),
              child: child,
            );
          },
        );
      },
    ),

    GoRoute(
      path: '/forgotpassword',
      builder: (context, state) => ForgotPasswordPage(),
    ),

    GoRoute(
      path: '/reset-password',
      builder: (context, state) {
        final oobCode = state.uri.queryParameters['oobCode'];

        if (oobCode == null || oobCode.isEmpty) {
          return const Scaffold(
            body: Center(child: Text('Invalid reset password link.')),
          );
        }

        return ResetPasswordPage(oobCode: oobCode);
      },
    ),
    GoRoute(
      path: '/overview-card-page',
      builder: (context, state) {
        final type = state.uri.queryParameters['type'] ?? "Balance";
        return OverviewCardPage(type: type);
      },
    ),
    GoRoute(
      path: '/custom-add-card',
      builder: (context, state) {
        final type = state.uri.queryParameters['type'] ?? "Transaction";
        return AddTransactionPage(type: type);
      },
    ),

    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return HomePage(navigationShell: navigationShell);
      },

      branches: [
        // Dashboard
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/dashboard',
              builder: (context, state) {
                return DashboardPage();
              },
            ),
          ],
        ),

        // Savings
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/savings',
              builder: (context, state) {
                return SavingsPage();
              },
            ),
          ],
        ),

        // Reminders
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/reminders',
              builder: (context, state) {
                return RemindersPage();
              },
            ),
          ],
        ),

        // Notifications
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/notifications',
              builder: (context, state) {
                return NotificationsPage();
              },
            ),
          ],
        ),
      ],
    ),

    GoRoute(
      path: '/addreminders',
      builder: (context, state) => AddRemindersPage(),
    ),

    GoRoute(
      path: '/addsavings',
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => AddSavingsPage(),
    ),
    GoRoute(path: '/addgoals', builder: (context, state) => AddGoalsPage()),

    GoRoute(path: '/profile', builder: (context, state) => ProfilePage()),

    GoRoute(path: '/settings', builder: (context, state) => SettingPage()),
  ],
);

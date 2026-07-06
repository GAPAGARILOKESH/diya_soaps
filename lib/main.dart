import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'models/packages.dart';
import 'screens/home_screen.dart';
import 'screens/shop_screen.dart';
import 'screens/contact_screen.dart';
import 'screens/register_screen.dart';
import 'screens/policy_screens.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

// Router configuration using GoRouter
final GoRouter _router = GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return MainTabsShell(child: child);
      },
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/shop',
          builder: (context, state) => const ShopScreen(),
        ),
        GoRoute(
          path: '/contact',
          builder: (context, state) => const ContactScreen(),
        ),
      ],
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) {
        final packTypeStr = state.uri.queryParameters['packType'] ?? 'NORMAL';
        final qtyStr = state.uri.queryParameters['qty'] ?? '1';
        final packType = PackType.fromApiString(packTypeStr);
        final qty = int.tryParse(qtyStr) ?? 1;
        return RegisterScreen(packType: packType, qty: qty);
      },
    ),
    GoRoute(
      path: '/privacy',
      builder: (context, state) => const PrivacyScreen(),
    ),
    GoRoute(
      path: '/terms',
      builder: (context, state) => const TermsScreen(),
    ),
    GoRoute(
      path: '/refund',
      builder: (context, state) => const RefundScreen(),
    ),
    GoRoute(
      path: '/shipping',
      builder: (context, state) => const ShippingScreen(),
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Diya Soaps',
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: const Color(0xFFD97706),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFD97706),
          primary: const Color(0xFFD97706),
          secondary: const Color(0xFFF5C518),
          background: const Color(0xFFFFFBEB),
        ),
      ),
    );
  }
}

class MainTabsShell extends StatelessWidget {
  final Widget child;
  const MainTabsShell({super.key, required this.child});

  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    if (location == '/shop') return 1;
    if (location == '/contact') return 2;
    return 0; // Default is /
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/');
        break;
      case 1:
        context.go('/shop');
        break;
      case 2:
        context.go('/contact');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _calculateSelectedIndex(context);

    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Color(0xFFFDE68A),
              width: 2.0,
            ),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: (index) => _onItemTapped(index, context),
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFFD97706),
          unselectedItemColor: const Color(0xFF9CA3AF),
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 11.0),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 11.0),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Ionicons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Ionicons.bag),
              label: 'Shop',
            ),
            BottomNavigationBarItem(
              icon: Icon(Ionicons.call),
              label: 'Contact',
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/env.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  Future<void> _openWhatsApp() async {
    final url = 'https://wa.me/${Env.whatsappNumber}?text=Hi!%20I\'m%20interested%20in%20Diya%20Soaps';
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _callNow() async {
    final uri = Uri.parse('tel:${Env.phoneNumber}');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: false,
        bottom: false,
        child: Column(
          children: [
            // Dark Header matching linear gradient
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF1A1A1A), Color(0xFF2D2D2D)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              padding: const EdgeInsets.only(
                left: 20.0,
                right: 20.0,
                top: 50.0,
                bottom: 14.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.network(
                    'https://www.diyasoaps.com/assets/logo-CeP7dR-J.png',
                    width: 40.0,
                    height: 40.0,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Ionicons.cube_outline, color: Color(0xFFF5C518), size: 40.0),
                  ),
                  const Text(
                    'Diya Soaps',
                    style: TextStyle(
                      color: Color(0xFFF5C518),
                      fontSize: 22.0,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(width: 40.0), // Spacer to balance layout
                ],
              ),
            ),

            // Main Content Area
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Trust Bar
                    Container(
                      color: const Color(0xFFFEF3C7),
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Secure Payment',
                            style: TextStyle(
                              fontSize: 11.0,
                              color: Color(0xFF92400E),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text('|', style: TextStyle(color: Color(0xFFD97706))),
                          ),
                          Text(
                            'Free Delivery',
                            style: TextStyle(
                              fontSize: 11.0,
                              color: Color(0xFF92400E),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text('|', style: TextStyle(color: Color(0xFFD97706))),
                          ),
                          Text(
                            'Natural Ingredients',
                            style: TextStyle(
                              fontSize: 11.0,
                              color: Color(0xFF92400E),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Hero Banner
                    Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFFFEF3C7), Color(0xFFFDE68A), Color(0xFFFBBF24)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 32.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.network(
                            'https://www.diyasoaps.com/assets/logo-CeP7dR-J.png',
                            width: 100.0,
                            height: 60.0,
                            errorBuilder: (context, error, stackTrace) =>
                                const SizedBox(height: 60.0),
                          ),
                          const SizedBox(height: 12.0),
                          const Text(
                            'Premium Natural Soaps',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 28.0,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF1A1A1A),
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          const Text(
                            'Handcrafted with love using plant-based oils and gentle, skin-friendly formulas.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15.0,
                              color: Color(0xFF44403C),
                              height: 1.47,
                            ),
                          ),
                          const SizedBox(height: 20.0),

                          // Badges
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildHeroBadge('100% Natural'),
                              const SizedBox(width: 10.0),
                              _buildHeroBadge('Handmade'),
                            ],
                          ),
                          const SizedBox(height: 24.0),

                          // Shop Now CTA
                          ElevatedButton(
                            onPressed: () => context.go('/shop'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1A1A1A),
                              foregroundColor: const Color(0xFFF5C518),
                              elevation: 4.0,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32.0,
                                vertical: 14.0,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ),
                            child: const Text(
                              'Shop Now →',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Why Diya Soaps Section
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            'Why Diya Soaps?',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 22.0,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF92400E),
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          _buildFeatureCard(
                            icon: Ionicons.leaf,
                            title: 'Natural Ingredients',
                            desc: 'Handmade soaps crafted with plant-based oils and gentle formulas.',
                          ),
                          _buildFeatureCard(
                            icon: Ionicons.heart,
                            title: 'Skin Friendly',
                            desc: 'Gentle on all skin types — perfect for everyday use.',
                          ),
                          _buildFeatureCard(
                            icon: Ionicons.shield_checkmark,
                            title: 'Trusted Quality',
                            desc: 'Small-batch handmade soaps made with care and attention to detail.',
                          ),
                          _buildFeatureCard(
                            icon: Ionicons.car,
                            title: 'Free Delivery',
                            desc: 'Delivered right to your doorstep across India.',
                          ),
                        ],
                      ),
                    ),

                    // Call To Action Section
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                      padding: const EdgeInsets.all(28.0),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFD97706), Color(0xFFB45309)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'Ready to Order?',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 22.0,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          const Text(
                            'Choose from Starter, Value, Bumper packs or our Red Sandal Premium Kit.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13.0,
                              color: Colors.white,
                              height: 1.46,
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          ElevatedButton(
                            onPressed: () => context.go('/shop'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: const Color(0xFFD97706),
                              elevation: 0.0,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 28.0,
                                vertical: 13.0,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                            ),
                            child: const Text(
                              'Browse Products →',
                              style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Quick Floating Contacts Row
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: _openWhatsApp,
                              borderRadius: BorderRadius.circular(14.0),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 13.0),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF25D366),
                                  borderRadius: BorderRadius.circular(14.0),
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Ionicons.logo_whatsapp, size: 20.0, color: Colors.white),
                                    SizedBox(width: 8.0),
                                    Text(
                                      'WhatsApp',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12.0),
                          Expanded(
                            child: InkWell(
                              onTap: _callNow,
                              borderRadius: BorderRadius.circular(14.0),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 13.0),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFD97706),
                                  borderRadius: BorderRadius.circular(14.0),
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Ionicons.call, size: 20.0, color: Colors.white),
                                    SizedBox(width: 8.0),
                                    Text(
                                      'Call Us',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20.0),

                    // Footer
                    Container(
                      color: const Color(0xFF1A1A1A),
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        children: [
                          const Text(
                            'Diya Soaps',
                            style: TextStyle(
                              color: Color(0xFFF5C518),
                              fontSize: 18.0,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 12.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildFooterLink(context, 'Privacy', '/privacy'),
                              const SizedBox(width: 16.0),
                              _buildFooterLink(context, 'Terms', '/terms'),
                              const SizedBox(width: 16.0),
                              _buildFooterLink(context, 'Refund', '/refund'),
                              const SizedBox(width: 16.0),
                              _buildFooterLink(context, 'Shipping', '/shipping'),
                            ],
                          ),
                          const SizedBox(height: 12.0),
                          const Text(
                            '© 2026 Diya Soaps. All rights reserved.',
                            style: TextStyle(color: Color(0xFF6B7280), fontSize: 11.0),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroBadge(String text) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(20.0),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12.0,
          fontWeight: FontWeight.w700,
          color: Color(0xFF92400E),
        ),
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String desc,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(14.0),
        border: Border.all(color: const Color(0xFFFDE68A)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44.0,
            height: 44.0,
            decoration: BoxDecoration(
              color: const Color(0xFFFEF3C7),
              borderRadius: BorderRadius.circular(22.0),
            ),
            child: Icon(icon, color: const Color(0xFFD97706), size: 24.0),
          ),
          const SizedBox(width: 14.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 3.0),
                Text(
                  desc,
                  style: const TextStyle(
                    fontSize: 13.0,
                    color: Color(0xFF6B7280),
                    height: 1.38,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooterLink(BuildContext context, String label, String route) {
    return InkWell(
      onTap: () => context.go(route),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFF9CA3AF),
          fontSize: 12.0,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

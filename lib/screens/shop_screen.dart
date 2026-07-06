import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import '../models/packages.dart';
import '../providers/providers.dart';

const List<PackType> packOrder = [
  PackType.normal,
  PackType.halfYear,
  PackType.annual,
  PackType.redSandal,
];

class ShopScreen extends ConsumerWidget {
  const ShopScreen({super.key});

  void _handleBuy(BuildContext context, PackType packType, int qty) {
    context.go('/register?packType=${packType.toApiString()}&qty=$qty');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quantities = ref.watch(shopQuantitiesProvider);
    final quantitiesNotifier = ref.read(shopQuantitiesProvider.notifier);

    return Scaffold(
      backgroundColor: const Color(0xFFFFFBEB),
      body: SafeArea(
        top: false,
        bottom: false,
        child: Column(
          children: [
            // Dark Header matching linear gradient
            Container(
              width: double.infinity,
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
                bottom: 20.0,
              ),
              child: const Column(
                children: [
                  Text(
                    '🛍️ Shop',
                    style: TextStyle(
                      color: Color(0xFFF5C518),
                      fontSize: 24.0,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    'Premium Handmade Soaps',
                    style: TextStyle(
                      color: Color(0xFF9CA3AF),
                      fontSize: 13.0,
                    ),
                  ),
                ],
              ),
            ),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Choose Your Package',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF92400E),
                      ),
                    ),
                    const SizedBox(height: 14.0),

                    // Package list
                    ...packOrder.map((packType) {
                      final cfg = packConfig[packType]!;
                      final qty = quantities[packType] ?? 1;
                      final details = getPackageDetails(qty, packType);
                      final isHighlight = cfg.highlight;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 14.0),
                        decoration: BoxDecoration(
                          gradient: isHighlight
                              ? const LinearGradient(
                                  colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                )
                              : null,
                          color: isHighlight ? null : Colors.white,
                          borderRadius: BorderRadius.circular(18.0),
                          border: isHighlight
                              ? null
                              : Border.all(color: const Color(0xFFFDE68A)),
                          boxShadow: [
                            if (isHighlight)
                              BoxShadow(
                                color: const Color(0xFFD97706).withOpacity(0.3),
                                blurRadius: 12.0,
                                offset: const Offset(0, 6),
                              )
                            else
                              BoxShadow(
                                color: Colors.black.withOpacity(0.06),
                                blurRadius: 8.0,
                                offset: const Offset(0, 2),
                              ),
                          ],
                        ),
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Best Offer Badge
                            if (cfg.tag != null) ...[
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12.0,
                                  vertical: 4.0,
                                ),
                                margin: const EdgeInsets.only(bottom: 10.0),
                                child: Text(
                                  '🏆 ${cfg.tag}',
                                  style: const TextStyle(
                                    fontSize: 11.0,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFFD97706),
                                  ),
                                ),
                              ),
                            ],

                            // Header row with Emoji and Title
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  cfg.emoji,
                                  style: const TextStyle(fontSize: 32.0),
                                ),
                                const SizedBox(width: 12.0),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        cfg.label,
                                        style: TextStyle(
                                          fontSize: 17.0,
                                          fontWeight: FontWeight.w800,
                                          color: isHighlight
                                              ? Colors.white
                                              : const Color(0xFF1A1A1A),
                                        ),
                                      ),
                                      const SizedBox(height: 2.0),
                                      Text(
                                        cfg.description,
                                        style: TextStyle(
                                          fontSize: 12.0,
                                          color: isHighlight
                                              ? Colors.white70
                                              : const Color(0xFF6B7280),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14.0),

                            // Features
                            Column(
                              children: [
                                if (cfg.isKit)
                                  _buildFeatureRow(
                                    '${cfg.soapsPerBox} Premium Products per Kit',
                                    isHighlight,
                                  )
                                else ...[
                                  _buildFeatureRow(
                                    '${cfg.soapsPerBox} Premium Soap${cfg.soapsPerBox > 1 ? "s" : ""} per box',
                                    isHighlight,
                                  ),
                                  _buildFeatureRow(
                                      'Natural Ingredients', isHighlight),
                                  _buildFeatureRow(
                                      'Skin Friendly Formula', isHighlight),
                                ],
                                _buildFeatureRow(
                                  'Free Delivery across India',
                                  isHighlight,
                                ),
                              ],
                            ),
                            const SizedBox(height: 14.0),

                            // Quantity Selector
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              decoration: const BoxDecoration(
                                border: Border(
                                  top: BorderSide(
                                    color: Colors.black12,
                                    width: 1.0,
                                  ),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Quantity',
                                    style: TextStyle(
                                      fontSize: 13.0,
                                      fontWeight: FontWeight.w700,
                                      color: isHighlight
                                          ? Colors.white
                                          : const Color(0xFF374151),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () => quantitiesNotifier
                                            .updateQty(packType, -1),
                                        child: Container(
                                          width: 32.0,
                                          height: 32.0,
                                          decoration: BoxDecoration(
                                            color: isHighlight
                                                ? Colors.white
                                                : const Color(0xFFFEF3C7),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            Ionicons.remove,
                                            size: 18.0,
                                            color: isHighlight
                                                ? const Color(0xFFD97706)
                                                : const Color(0xFF374151),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12.0),
                                      Text(
                                        '$qty',
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w800,
                                          color: isHighlight
                                              ? Colors.white
                                              : const Color(0xFF1A1A1A),
                                        ),
                                      ),
                                      const SizedBox(width: 12.0),
                                      GestureDetector(
                                        onTap: () => quantitiesNotifier
                                            .updateQty(packType, 1),
                                        child: Container(
                                          width: 32.0,
                                          height: 32.0,
                                          decoration: BoxDecoration(
                                            color: isHighlight
                                                ? Colors.white
                                                : const Color(0xFFFEF3C7),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            Ionicons.add,
                                            size: 18.0,
                                            color: isHighlight
                                                ? const Color(0xFFD97706)
                                                : const Color(0xFF374151),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12.0),

                            // Footer (Price & Buy Button)
                            Container(
                              padding: const EdgeInsets.only(top: 12.0),
                              decoration: const BoxDecoration(
                                border: Border(
                                  top: BorderSide(
                                    color: Colors.black12,
                                    width: 1.0,
                                  ),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (details.mrp != null) ...[
                                        Text(
                                          formatPrice(details.mrp!),
                                          style: TextStyle(
                                            fontSize: 13.0,
                                            color: isHighlight
                                                ? Colors.white60
                                                : const Color(0xFF9CA3AF),
                                            decoration:
                                                TextDecoration.lineThrough,
                                          ),
                                        ),
                                      ],
                                      Text(
                                        formatPrice(details.price),
                                        style: TextStyle(
                                          fontSize: 24.0,
                                          fontWeight: FontWeight.w900,
                                          color: isHighlight
                                              ? Colors.white
                                              : const Color(0xFFD97706),
                                        ),
                                      ),
                                      if (details.savings > 0) ...[
                                        Text(
                                          'Save ${formatPrice(details.savings)}',
                                          style: TextStyle(
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.w700,
                                            color: isHighlight
                                                ? Colors.white
                                                : const Color(0xFF16A34A),
                                          ),
                                        ),
                                      ],
                                      if (!cfg.isKit && qty > 1) ...[
                                        Text(
                                          '${details.soaps} soaps total',
                                          style: TextStyle(
                                            fontSize: 11.0,
                                            color: isHighlight
                                                ? Colors.white70
                                                : const Color(0xFF6B7280),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                  ElevatedButton(
                                    onPressed: () =>
                                        _handleBuy(context, packType, qty),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: isHighlight
                                          ? Colors.white
                                          : const Color(0xFFD97706),
                                      foregroundColor: isHighlight
                                          ? const Color(0xFFD97706)
                                          : Colors.white,
                                      elevation: 0,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 18.0,
                                        vertical: 10.0,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Text(
                                          'Buy Now',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 14.0,
                                            color: isHighlight
                                                ? const Color(0xFFD97706)
                                                : Colors.white,
                                          ),
                                        ),
                                        const SizedBox(width: 6.0),
                                        Icon(
                                          Ionicons.arrow_forward,
                                          size: 16.0,
                                          color: isHighlight
                                              ? const Color(0xFFD97706)
                                              : Colors.white,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                    const SizedBox(height: 10.0),

                    // Secure Checkout Trust Card
                    Container(
                      padding: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0FDF4),
                        borderRadius: BorderRadius.circular(16.0),
                        border: Border.all(color: const Color(0xFFBBF7D0)),
                      ),
                      child: const Column(
                        children: [
                          Icon(Ionicons.shield_checkmark,
                              size: 24.0, color: Color(0xFF16A34A)),
                          SizedBox(height: 8.0),
                          Text(
                            'Secure Checkout',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF16A34A),
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            'Payments secured by Razorpay. UPI, Cards, Net Banking & Wallets accepted.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13.0,
                              color: Color(0xFF374151),
                              height: 1.54,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20.0),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureRow(String text, bool isWhite) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Row(
        children: [
          Icon(
            Ionicons.checkmark_circle,
            size: 16.0,
            color: isWhite ? Colors.white : const Color(0xFF16A34A),
          ),
          const SizedBox(width: 8.0),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13.0,
                fontWeight: FontWeight.w500,
                color: isWhite ? Colors.white : const Color(0xFF374151),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

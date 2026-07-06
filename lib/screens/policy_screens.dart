import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/env.dart';

// --- PRIVACY SCREEN ---
class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  Future<void> _openWebPolicy() async {
    final uri = Uri.parse(Env.privacyPolicyUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final sections = [
      _Section(
        title: 'Overview',
        body: 'Diya Soaps (“we”, “us”) operates this mobile app to sell handmade soap products. This policy explains what data we collect, how we use it, and your choices.',
      ),
      _Section(
        title: 'Information we collect',
        body: '• Account & order details: name, email, mobile number, delivery address (house, street, city, pincode).\n'
            '• Order metadata: package type, quantity, order ID, payment status.\n'
            '• Contact form: name, email, phone (optional), and message.\n'
            '• Technical data: basic app usage and API requests needed to process orders.',
      ),
      _Section(
        title: 'How we use your data',
        body: 'We use your information to:\n'
            '• Process and deliver product orders\n'
            '• Verify payments and confirm orders\n'
            '• Respond to support and contact requests\n'
            'We do not sell your personal data to third parties.',
      ),
      _Section(
        title: 'Third-party services',
        body: '• Razorpay — payment processing (card, UPI, net banking, wallets). Razorpay handles payment credentials; we receive payment status and order references only.\n'
            '• Our backend (hosted on Render) — order creation, payment verification, and member records.\n'
            'Each provider has its own privacy policy. We share only the data needed to complete your transaction.',
      ),
      _Section(
        title: 'Data retention',
        body: 'We retain order and contact records as long as needed for delivery, accounting, dispute resolution, and legal compliance. You may request deletion when no longer required for these purposes.',
      ),
      _Section(
        title: 'Your rights & data deletion',
        body: 'You may request access, correction, or deletion of your personal data by emailing ${Env.supportEmail} with your Order ID and registered email. We will respond within a reasonable time (typically within 30 days). Deleting order data may not be possible where retention is required by law.',
      ),
      _Section(
        title: 'Security',
        body: 'We use HTTPS for API calls and rely on Razorpay for secure payment handling. No payment card numbers are stored in the app.',
      ),
      _Section(
        title: 'Children',
        body: 'This app is not directed at children under 13. We do not knowingly collect data from children.',
      ),
      _Section(
        title: 'Changes',
        body: 'We may update this policy. The in-app version and the web URL below will reflect the latest version.',
      ),
      _Section(
        title: 'Contact',
        body: 'Questions: ${Env.supportEmail}',
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Privacy Policy'),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF92400E),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Privacy Policy',
              style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w800, color: Color(0xFF92400E)),
            ),
            const SizedBox(height: 4.0),
            const Text(
              'Last updated: June 2026',
              style: TextStyle(fontSize: 12.0, color: Color(0xFF9CA3AF)),
            ),
            const SizedBox(height: 12.0),

            InkWell(
              onTap: _openWebPolicy,
              borderRadius: BorderRadius.circular(10.0),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFBEB),
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(color: const Color(0xFFFDE68A)),
                ),
                child: const Text(
                  'View full policy on diyasoaps.com →',
                  style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.w700, color: Color(0xFFD97706)),
                ),
              ),
            ),
            const SizedBox(height: 16.0),

            ...sections.map((s) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      s.title,
                      style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w800, color: Color(0xFF92400E)),
                    ),
                    const SizedBox(height: 6.0),
                    Text(
                      s.body,
                      style: const TextStyle(fontSize: 14.0, color: Color(0xFF374151), height: 1.57),
                    ),
                    const SizedBox(height: 16.0),
                  ],
                )),
            const SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }
}

// --- TERMS AND CONDITIONS SCREEN ---
class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sections = [
      _Section(
        title: 'General terms',
        body: 'By purchasing from Diya Soaps through this app, you agree to these Terms & Conditions. Each order includes physical soap products shipped to the address you provide. We may update packages, pricing, and promotions with reasonable notice where required.',
      ),
      _Section(
        title: 'Products & delivery',
        body: 'Orders include physical handmade soap products shipped to the address you provide. Delivery timelines and shipping terms are described in our Shipping Policy. Risk of loss passes to you upon delivery to the carrier unless otherwise required by law.',
      ),
      _Section(
        title: 'Payments',
        body: 'Payments are processed securely by Razorpay. Your order is confirmed only after successful payment verification on our servers. If verification fails after payment, contact support with your Order ID.',
      ),
      _Section(
        title: 'Refunds',
        body: 'Product refunds follow our Refund Policy. Refund requests must be submitted within the timeframe stated in that policy.',
      ),
      _Section(
        title: 'Limitation of liability',
        body: 'To the fullest extent permitted by law, Diya Soaps is not liable for indirect or consequential damages arising from use of the app. Our total liability for a given order is limited to the amount you paid for that order.',
      ),
      _Section(
        title: 'Contact',
        body: 'Questions about these terms: ${Env.supportEmail}',
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Terms & Conditions'),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF92400E),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Terms & Conditions',
              style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w800, color: Color(0xFF92400E)),
            ),
            const SizedBox(height: 4.0),
            const Text(
              'Last updated: June 2026',
              style: TextStyle(fontSize: 12.0, color: Color(0xFF9CA3AF)),
            ),
            const SizedBox(height: 16.0),

            ...sections.map((s) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      s.title,
                      style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w800, color: Color(0xFF92400E)),
                    ),
                    const SizedBox(height: 6.0),
                    Text(
                      s.body,
                      style: const TextStyle(fontSize: 14.0, color: Color(0xFF374151), height: 1.57),
                    ),
                    const SizedBox(height: 16.0),
                  ],
                )),
            const SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }
}

// --- REFUND POLICY SCREEN ---
class RefundScreen extends StatelessWidget {
  const RefundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Refund Policy'),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF92400E),
        elevation: 0,
      ),
      body: const SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Refund Policy',
              style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w800, color: Color(0xFF92400E)),
            ),
            SizedBox(height: 12.0),
            Text(
              'Refunds are accepted within 7 days of delivery if the product is damaged or defective. To '
              'request a refund, contact us at support@diyasoaps.com with your Order ID and photos of the '
              'issue. Refunds are processed within 5–7 business days after approval.',
              style: TextStyle(fontSize: 14.0, color: Color(0xFF374151), height: 1.57),
            ),
          ],
        ),
      ),
    );
  }
}

// --- SHIPPING POLICY SCREEN ---
class ShippingScreen extends StatelessWidget {
  const ShippingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Shipping Policy'),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF92400E),
        elevation: 0,
      ),
      body: const SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Shipping Policy',
              style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w800, color: Color(0xFF92400E)),
            ),
            SizedBox(height: 12.0),
            Text(
              'We deliver across India within 5–7 business days after order confirmation. Shipping is free on all orders. You will receive a tracking link via email once your order is dispatched. For delivery issues, contact support@diyasoaps.com with your Order ID.',
              style: TextStyle(fontSize: 14.0, color: Color(0xFF374151), height: 1.57),
            ),
          ],
        ),
      ),
    );
  }
}

// --- HELPER MODEL ---
class _Section {
  final String title;
  final String body;
  _Section({required this.title, required this.body});
}

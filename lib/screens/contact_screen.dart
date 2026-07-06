import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ionicons/ionicons.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/env.dart';
import '../providers/providers.dart';

class ContactScreen extends ConsumerStatefulWidget {
  const ContactScreen({super.key});

  @override
  ConsumerState<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends ConsumerState<ContactScreen> {
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _phoneCtrl = TextEditingController();
  final TextEditingController _messageCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _messageCtrl.dispose();
    super.dispose();
  }

  Future<void> _launchUrl(String url, {bool external = false}) async {
    final uri = Uri.parse(url);

    try {
      final success = await launchUrl(
        uri,
        mode: external
            ? LaunchMode.externalApplication
            : LaunchMode.platformDefault,
      );

      if (!success) {
        _showAlert("Error", "Could not open link");
      }
    } catch (e) {
      _showAlert("Error", e.toString());
    }
  }

  void _showAlert(String title, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(message),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('OK', style: TextStyle(color: Color(0xFFD97706), fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Future<void> _handleSend() async {
    final name = _nameCtrl.text;
    final email = _emailCtrl.text;
    final phone = _phoneCtrl.text;
    final message = _messageCtrl.text;

    final notifier = ref.read(contactFormProvider.notifier);
    notifier.updateField('name', name);
    notifier.updateField('email', email);
    notifier.updateField('phone', phone);
    notifier.updateField('message', message);

    final success = await notifier.sendContactMail();
    if (success) {
      _showAlert('✅ Sent!', "We'll get back to you soon.");
      _nameCtrl.clear();
      _emailCtrl.clear();
      _phoneCtrl.clear();
      _messageCtrl.clear();
    } else {
      final error = ref.read(contactFormProvider).error;
      _showAlert('Error', error ?? 'Failed to send. Try WhatsApp instead.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(contactFormProvider);

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
                    '📞 Contact Us',
                    style: TextStyle(
                      color: Color(0xFFF5C518),
                      fontSize: 24.0,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    "We're here to help you",
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
                    // Quick Contacts Row
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () => _launchUrl('https://wa.me/${Env.whatsappNumber}', external: true),
                            borderRadius: BorderRadius.circular(14.0),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 14.0),
                              decoration: BoxDecoration(
                                color: const Color(0xFF25D366),
                                borderRadius: BorderRadius.circular(14.0),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Ionicons.logo_whatsapp, size: 22.0, color: Colors.white),
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
                            onTap: () => _launchUrl('tel:${Env.phoneNumber}'),
                            borderRadius: BorderRadius.circular(14.0),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 14.0),
                              decoration: BoxDecoration(
                                color: const Color(0xFFD97706),
                                borderRadius: BorderRadius.circular(14.0),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Ionicons.call, size: 22.0, color: Colors.white),
                                  SizedBox(width: 8.0),
                                  Text(
                                    'Call Now',
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
                    const SizedBox(height: 16.0),

                    // Contact Form Card
                    Container(
                      padding: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.0),
                        border: Border.all(color: const Color(0xFFFDE68A)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            '📝 Send a Message',
                            style: TextStyle(
                              fontSize: 17.0,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF92400E),
                            ),
                          ),
                          const SizedBox(height: 14.0),

                          _buildTextField(
                            controller: _nameCtrl,
                            label: 'Your Name',
                            placeholder: 'Full name',
                          ),
                          const SizedBox(height: 12.0),

                          _buildTextField(
                            controller: _emailCtrl,
                            label: 'Email',
                            placeholder: 'your@email.com',
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: 12.0),

                          _buildTextField(
                            controller: _phoneCtrl,
                            label: 'Phone (Optional)',
                            placeholder: 'Mobile number',
                            keyboardType: TextInputType.phone,
                          ),
                          const SizedBox(height: 12.0),

                          _buildTextField(
                            controller: _messageCtrl,
                            label: 'Message',
                            placeholder: 'Your message...',
                            maxLines: 4,
                          ),
                          const SizedBox(height: 16.0),

                          ElevatedButton(
                            onPressed: state.isLoading ? null : _handleSend,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFD97706),
                              foregroundColor: Colors.white,
                              disabledBackgroundColor: const Color(0xFFD97706).withOpacity(0.6),
                              padding: const EdgeInsets.symmetric(vertical: 14.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14.0),
                              ),
                              elevation: 0,
                            ),
                            child: state.isLoading
                                ? const SizedBox(
                                    height: 20.0,
                                    width: 20.0,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.0,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  )
                                : const Text(
                                    'Send Message',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 15.0,
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16.0),

                    // Info Card
                    Container(
                      padding: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.0),
                        border: Border.all(color: const Color(0xFFFDE68A)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '📍 Business Info',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF92400E),
                            ),
                          ),
                          const SizedBox(height: 12.0),
                          _buildInfoRow('📧 support@diyasoaps.com'),
                          _buildInfoRow('📱 ${Env.phoneNumber}'),
                          _buildInfoRow('🕐 Mon–Sat, 9 AM – 6 PM'),
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String placeholder,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12.0,
            fontWeight: FontWeight.w700,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 4.0),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          style: const TextStyle(fontSize: 14.0, color: Color(0xFF1A1A1A)),
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
            filled: true,
            fillColor: const Color(0xFFFFFBEB),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 11.0),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: const BorderSide(color: Color(0xFFFDE68A), width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: const BorderSide(color: Color(0xFFD97706), width: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14.0,
          color: Color(0xFF374151),
          height: 1.43,
        ),
      ),
    );
  }
}

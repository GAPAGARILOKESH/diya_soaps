import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../models/packages.dart';
import '../providers/providers.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  final PackType packType;
  final int qty;

  const RegisterScreen({
    super.key,
    required this.packType,
    required this.qty,
  });

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _fullNameCtrl = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _mobileCtrl = TextEditingController();
  final TextEditingController _houseNoCtrl = TextEditingController();
  final TextEditingController _streetCtrl = TextEditingController();
  final TextEditingController _cityCtrl = TextEditingController();
  final TextEditingController _pincodeCtrl = TextEditingController();

  WebViewController? _webViewController;

  @override
  void dispose() {
    _fullNameCtrl.dispose();
    _emailCtrl.dispose();
    _mobileCtrl.dispose();
    _houseNoCtrl.dispose();
    _streetCtrl.dispose();
    _cityCtrl.dispose();
    _pincodeCtrl.dispose();
    super.dispose();
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

  Future<void> _handleSubmit() async {
    final notifier = ref.read(checkoutFormProvider.notifier);

    // Sync controllers to Riverpod state
    notifier.updateField('fullName', _fullNameCtrl.text);
    notifier.updateField('email', _emailCtrl.text);
    notifier.updateField('mobile', _mobileCtrl.text);
    notifier.updateField('houseNo', _houseNoCtrl.text);
    notifier.updateField('street', _streetCtrl.text);
    notifier.updateField('city', _cityCtrl.text);
    notifier.updateField('pincode', _pincodeCtrl.text);

    await notifier.submitOrder(widget.qty, widget.packType);

    final updatedState = ref.read(checkoutFormProvider);
    if (updatedState.error != null) {
      _showAlert('Error', updatedState.error!);
    }
  }

  void _handleWebViewMessage(String messageJson) {
    try {
      final Map<String, dynamic> data = jsonDecode(messageJson);
      final notifier = ref.read(checkoutFormProvider.notifier);

      if (data['type'] == 'PAYMENT_CANCELLED') {
        notifier.hideWebView();
        _showAlert('Cancelled', "Payment was cancelled. You can try again whenever you're ready.");
        return;
      }

      if (data['type'] == 'PAYMENT_FAILED') {
        notifier.hideWebView();
        _showAlert('Payment Failed', data['error'] ?? 'Payment failed. Please try again.');
        return;
      }

      if (data['type'] == 'PAYMENT_SUCCESS') {
        final paymentId = data['razorpay_payment_id'];
        final orderId = data['razorpay_order_id'] ?? '';
        final signature = data['razorpay_signature'] ?? '';

        if (paymentId == null || paymentId.toString().isEmpty) {
          notifier.hideWebView();
          _showAlert('Incomplete Response', 'Payment data incomplete. Please contact support.');
          return;
        }

        notifier.verifyPayment(
          razorpayOrderId: orderId,
          razorpayPaymentId: paymentId,
          razorpaySignature: signature,
        ).then((_) {
          final updatedState = ref.read(checkoutFormProvider);
          if (updatedState.error != null) {
            _showAlert('Verification Issue', updatedState.error!);
          }
        });
      }
    } catch (e) {
      ref.read(checkoutFormProvider.notifier).hideWebView();
      _showAlert('Error', 'Something went wrong processing your payment.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(checkoutFormProvider);
    final pkg = getPackageDetails(widget.qty, widget.packType);

    // 1. Success State
    if (state.isSuccess) {
      return Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFD1FAE5), Colors.white],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Ionicons.checkmark_circle, size: 80.0, color: Color(0xFF16A34A)),
              const SizedBox(height: 16.0),
              const Text(
                'Order Confirmed!',
                style: TextStyle(
                  fontSize: 26.0,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF16A34A),
                ),
              ),
              const SizedBox(height: 8.0),
              const Text(
                'Your payment was successful',
                style: TextStyle(fontSize: 14.0, color: Color(0xFF6B7280)),
              ),
              const SizedBox(height: 24.0),

              // Success Summary Card
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.0),
                  border: Border.all(color: const Color(0xFFD1FAE5)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    _buildSummaryRow('Order ID', state.localOrderId ?? ''),
                    _buildSummaryRow('Package', pkg.label),
                    _buildSummaryRow(
                      pkg.isKit ? 'Quantity' : 'No. of Soaps',
                      pkg.isKit ? '${widget.qty} kit(s)' : '${pkg.soaps} soaps',
                    ),
                    _buildSummaryRow('Amount Paid', formatPrice(pkg.price)),
                    if (pkg.savings > 0)
                      _buildSummaryRow('You Saved', formatPrice(pkg.savings)),
                    const Divider(height: 20.0, color: Color(0xFFE5E7EB)),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Delivery Address',
                        style: TextStyle(
                          fontSize: 13.0,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF374151),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6.0),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '${_houseNoCtrl.text}, ${_streetCtrl.text}',
                        style: const TextStyle(fontSize: 13.0, color: Color(0xFF6B7280)),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '${_cityCtrl.text} - ${_pincodeCtrl.text}',
                        style: const TextStyle(fontSize: 13.0, color: Color(0xFF6B7280)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              Text(
                'Confirmation email sent to ${_emailCtrl.text}',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12.0, color: Color(0xFF6B7280)),
              ),
              const SizedBox(height: 24.0),

              ElevatedButton(
                onPressed: () {
                  ref.read(checkoutFormProvider.notifier).reset();
                  context.go('/shop');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD97706),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 14.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Back to Shop',
                  style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w800),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // 2. Main Page Render (Form input & WebView overlay)
    return Scaffold(
      backgroundColor: const Color(0xFFFFFBEB),
      body: SafeArea(
        top: false,
        bottom: false,
        child: Stack(
          children: [
            Column(
              children: [
                // Dark Header with Back Action
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF1A1A1A), Color(0xFF2D2D2D)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                ),
                  ),
                  padding: const EdgeInsets.only(
                    left: 16.0,
                    right: 16.0,
                    top: 50.0,
                    bottom: 14.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => context.go('/shop'),
                        child: Container(
                          padding: const EdgeInsets.all(6.0),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Ionicons.arrow_back, size: 22.0, color: Color(0xFFF5C518)),
                        ),
                      ),
                      const Text(
                        'Complete Order',
                        style: TextStyle(
                          color: Color(0xFFF5C518),
                          fontSize: 18.0,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(width: 38.0), // Spacer
                    ],
                  ),
                ),

                // Form Scroll Area
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Order Summary Card
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16.0),
                              border: Border.all(color: const Color(0xFFFDE68A), width: 1.5),
                            ),
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const Text(
                                  'Order Summary',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF92400E),
                                  ),
                                ),
                                const SizedBox(height: 12.0),
                                _buildSummaryRow('Package', pkg.label),
                                _buildSummaryRow(
                                  pkg.isKit ? 'Quantity' : 'Soaps',
                                  pkg.isKit ? '${widget.qty} kit(s)' : '${pkg.soaps} soaps',
                                ),
                                if (pkg.mrp != null)
                                  _buildSummaryRow('MRP', formatPrice(pkg.mrp!)),
                                if (pkg.savings > 0)
                                  _buildSummaryRow('Savings', '-${formatPrice(pkg.savings)}'),

                                const Divider(height: 16.0, color: Color(0xFFFDE68A)),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Total',
                                      style: TextStyle(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w800,
                                        color: Color(0xFF1A1A1A),
                                      ),
                                    ),
                                    Text(
                                      formatPrice(pkg.price),
                                      style: const TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.w900,
                                        color: Color(0xFFD97706),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16.0),

                          const Text(
                            'Your Details',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF92400E),
                            ),
                          ),
                          const SizedBox(height: 12.0),

                          _buildInputField(
                            controller: _fullNameCtrl,
                            label: 'Full Name',
                            placeholder: 'Enter your full name',
                          ),
                          const SizedBox(height: 12.0),

                          _buildInputField(
                            controller: _emailCtrl,
                            label: 'Email Address',
                            placeholder: 'Enter your email',
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: 12.0),

                          _buildInputField(
                            controller: _mobileCtrl,
                            label: 'Mobile Number',
                            placeholder: '10-digit mobile number',
                            keyboardType: TextInputType.phone,
                          ),
                          const SizedBox(height: 12.0),

                          _buildInputField(
                            controller: _houseNoCtrl,
                            label: 'House / Door No.',
                            placeholder: 'House number or flat',
                          ),
                          const SizedBox(height: 12.0),

                          _buildInputField(
                            controller: _streetCtrl,
                            label: 'Street / Area',
                            placeholder: 'Street or area name',
                          ),
                          const SizedBox(height: 12.0),

                          _buildInputField(
                            controller: _cityCtrl,
                            label: 'City',
                            placeholder: 'Your city',
                          ),
                          const SizedBox(height: 12.0),

                          _buildInputField(
                            controller: _pincodeCtrl,
                            label: 'Pincode',
                            placeholder: '6-digit pincode',
                            keyboardType: TextInputType.number,
                          ),
                          const SizedBox(height: 20.0),

                          ElevatedButton(
                            onPressed: state.isLoading ? null : _handleSubmit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFD97706),
                              foregroundColor: Colors.white,
                              disabledBackgroundColor: const Color(0xFFD97706).withOpacity(0.6),
                              padding: const EdgeInsets.symmetric(vertical: 16.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                              elevation: 4.0,
                              shadowColor: const Color(0xFFD97706).withOpacity(0.4),
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
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Ionicons.lock_closed, size: 18.0),
                                      const SizedBox(width: 10.0),
                                      Text(
                                        'Pay ${formatPrice(pkg.price)} Securely',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 16.0,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                          const SizedBox(height: 10.0),
                          const Text(
                            'Secured by Razorpay • UPI, Cards, Net Banking, Wallets',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 12.0, color: Color(0xFF9CA3AF)),
                          ),
                          const SizedBox(height: 30.0),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // WebView Overlay Dialog
            if (state.showWebView && state.razorpayHtml != null) ...[
              Positioned.fill(
                child: Container(
                  color: const Color(0xFF1A1A1A),
                  child: Column(
                    children: [
                      // Webview Header
                      Container(
                        padding: const EdgeInsets.only(
                          left: 16.0,
                          right: 16.0,
                          top: 50.0,
                          bottom: 12.0,
                        ),
                        color: const Color(0xFF1A1A1A),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () => ref.read(checkoutFormProvider.notifier).hideWebView(),
                              child: Container(
                                padding: const EdgeInsets.all(6.0),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Ionicons.close, size: 22.0, color: Colors.white),
                              ),
                            ),
                            Text(
                              'Secure Payment — ${formatPrice(pkg.price)}',
                              style: const TextStyle(
                                color: Color(0xFFF5C518),
                                fontSize: 15.0,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(width: 36.0), // Spacer
                          ],
                        ),
                      ),

                      // WebView Instance
                      Expanded(
                        child: Builder(
                          builder: (context) {
                            if (_webViewController == null) {
                              _webViewController = WebViewController()
                                ..setJavaScriptMode(JavaScriptMode.unrestricted)
                                ..addJavaScriptChannel(
                                  'PaymentInterface',
                                  onMessageReceived: (JavaScriptMessage message) {
                                    _handleWebViewMessage(message.message);
                                  },
                                )
                                ..setNavigationDelegate(
                                  NavigationDelegate(
                                    onNavigationRequest: (NavigationRequest request) async {
                                      final url = request.url;
                                      if (url.contains('razorpay.com') ||
                                          url.contains('razorpay.io') ||
                                          url.contains('checkout.razorpay')) {
                                        return NavigationDecision.navigate;
                                      }
                                      if (url.startsWith('upi://') ||
                                          url.startsWith('intent://') ||
                                          url.startsWith('tel:') ||
                                          url.startsWith('smsto:')) {
                                        final uri = Uri.parse(url);
                                        if (await canLaunchUrl(uri)) {
                                          await launchUrl(uri, mode: LaunchMode.externalApplication);
                                        }
                                        return NavigationDecision.prevent;
                                      }
                                      if (url.startsWith('data:') || url.startsWith('about:')) {
                                        return NavigationDecision.navigate;
                                      }
                                      return NavigationDecision.prevent;
                                    },
                                  ),
                                )
                                ..loadHtmlString(state.razorpayHtml!);
                            }
                            return WebViewWidget(controller: _webViewController!);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 13.0, color: Color(0xFF6B7280))),
          Text(value, style: const TextStyle(fontSize: 13.0, fontWeight: FontWeight.w600, color: Color(0xFF374151))),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String placeholder,
    TextInputType keyboardType = TextInputType.text,
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
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          style: const TextStyle(fontSize: 14.0, color: Color(0xFF1A1A1A)),
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
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
}

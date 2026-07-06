import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../constants/env.dart';
import '../models/packages.dart';

// --- SHOP STATE ---
class ShopQuantitiesNotifier extends StateNotifier<Map<PackType, int>> {
  ShopQuantitiesNotifier()
      : super({
          PackType.normal: 1,
          PackType.halfYear: 1,
          PackType.annual: 1,
          PackType.redSandal: 1,
        });

  void updateQty(PackType packType, int delta) {
    final current = state[packType] ?? 1;
    final newVal = (current + delta).clamp(1, 10);
    state = {
      ...state,
      packType: newVal,
    };
  }
}

final shopQuantitiesProvider =
    StateNotifierProvider<ShopQuantitiesNotifier, Map<PackType, int>>((ref) {
  return ShopQuantitiesNotifier();
});

// --- CONTACT FORM STATE ---
class ContactFormState {
  final String name;
  final String email;
  final String phone;
  final String message;
  final bool isLoading;
  final String? error;
  final bool isSuccess;

  ContactFormState({
    this.name = '',
    this.email = '',
    this.phone = '',
    this.message = '',
    this.isLoading = false,
    this.error,
    this.isSuccess = false,
  });

  ContactFormState copyWith({
    String? name,
    String? email,
    String? phone,
    String? message,
    bool? isLoading,
    String? error,
    bool? isSuccess,
  }) {
    return ContactFormState(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      message: message ?? this.message,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}

class ContactFormNotifier extends StateNotifier<ContactFormState> {
  ContactFormNotifier() : super(ContactFormState());

  void updateField(String key, String value) {
    if (key == 'name') state = state.copyWith(name: value);
    if (key == 'email') state = state.copyWith(email: value);
    if (key == 'phone') state = state.copyWith(phone: value);
    if (key == 'message') state = state.copyWith(message: value);
  }

  void reset() {
    state = ContactFormState();
  }

  Future<bool> sendContactMail() async {
    if (state.name.trim().isEmpty ||
        state.email.trim().isEmpty ||
        state.message.trim().isEmpty) {
      state = state.copyWith(error: 'Please fill all required fields');
      return false;
    }

    state = state.copyWith(isLoading: true, error: null, isSuccess: false);
    try {
      final response = await http.post(
        Uri.parse('${Env.backendUrl}/send-contact-mail'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': state.name,
          'email': state.email,
          'phone': state.phone,
          'message': state.message,
        }),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        state = state.copyWith(
          isLoading: false,
          isSuccess: true,
          name: '',
          email: '',
          phone: '',
          message: '',
        );
        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          error: 'Server error: ${response.statusCode}. Please try WhatsApp.',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to send message. Please try WhatsApp.',
      );
      return false;
    }
  }
}

final contactFormProvider =
    StateNotifierProvider<ContactFormNotifier, ContactFormState>((ref) {
  return ContactFormNotifier();
});

// --- CHECKOUT STATE ---
class CheckoutFormState {
  final String fullName;
  final String email;
  final String mobile;
  final String houseNo;
  final String street;
  final String city;
  final String pincode;
  final bool isLoading;
  final String? error;
  final bool isSuccess;
  final bool showWebView;
  final String? razorpayHtml;
  final String? orderId; // Razorpay order id
  final String? localOrderId; // DSP-prefixed ID
  final int verifiedQty;
  final PackType verifiedPackType;

  CheckoutFormState({
    this.fullName = '',
    this.email = '',
    this.mobile = '',
    this.houseNo = '',
    this.street = '',
    this.city = '',
    this.pincode = '',
    this.isLoading = false,
    this.error,
    this.isSuccess = false,
    this.showWebView = false,
    this.razorpayHtml,
    this.orderId,
    this.localOrderId,
    this.verifiedQty = 1,
    this.verifiedPackType = PackType.normal,
  });

  CheckoutFormState copyWith({
    String? fullName,
    String? email,
    String? mobile,
    String? houseNo,
    String? street,
    String? city,
    String? pincode,
    bool? isLoading,
    String? error,
    bool? isSuccess,
    bool? showWebView,
    String? razorpayHtml,
    String? orderId,
    String? localOrderId,
    int? verifiedQty,
    PackType? verifiedPackType,
  }) {
    return CheckoutFormState(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      mobile: mobile ?? this.mobile,
      houseNo: houseNo ?? this.houseNo,
      street: street ?? this.street,
      city: city ?? this.city,
      pincode: pincode ?? this.pincode,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isSuccess: isSuccess ?? this.isSuccess,
      showWebView: showWebView ?? this.showWebView,
      razorpayHtml: razorpayHtml ?? this.razorpayHtml,
      orderId: orderId ?? this.orderId,
      localOrderId: localOrderId ?? this.localOrderId,
      verifiedQty: verifiedQty ?? this.verifiedQty,
      verifiedPackType: verifiedPackType ?? this.verifiedPackType,
    );
  }
}

class CheckoutFormNotifier extends StateNotifier<CheckoutFormState> {
  CheckoutFormNotifier() : super(CheckoutFormState());

  void updateField(String key, String value) {
    switch (key) {
      case 'fullName':
        state = state.copyWith(fullName: value);
        break;
      case 'email':
        state = state.copyWith(email: value);
        break;
      case 'mobile':
        state = state.copyWith(mobile: value);
        break;
      case 'houseNo':
        state = state.copyWith(houseNo: value);
        break;
      case 'street':
        state = state.copyWith(street: value);
        break;
      case 'city':
        state = state.copyWith(city: value);
        break;
      case 'pincode':
        state = state.copyWith(pincode: value);
        break;
    }
  }

  void hideWebView() {
    state = state.copyWith(showWebView: false);
  }

  void reset() {
    state = CheckoutFormState();
  }

  bool validate() {
    if (state.fullName.trim().isEmpty ||
        state.email.trim().isEmpty ||
        state.mobile.trim().isEmpty ||
        state.houseNo.trim().isEmpty ||
        state.street.trim().isEmpty ||
        state.city.trim().isEmpty ||
        state.pincode.trim().isEmpty) {
      state = state.copyWith(error: 'Please fill in all details');
      return false;
    }

    if (state.mobile.trim().length != 10 ||
        int.tryParse(state.mobile.trim()) == null) {
      state = state.copyWith(error: 'Enter a valid 10-digit mobile number');
      return false;
    }

    if (state.pincode.trim().length != 6 ||
        int.tryParse(state.pincode.trim()) == null) {
      state = state.copyWith(error: 'Enter a valid 6-digit pincode');
      return false;
    }

    state = state.copyWith(error: null);
    return true;
  }

  Map<String, dynamic> _buildCustomerPayload() {
    return {
      'customer': {
        'name': state.fullName.trim(),
        'phone': state.mobile.trim(),
        'email': state.email.trim(),
        'houseNo': state.houseNo.trim(),
        'street': state.street.trim(),
        'city': state.city.trim(),
        'pincode': state.pincode.trim(),
      },
      'fullName': state.fullName.trim(),
      'email': state.email.trim(),
      'mobile': state.mobile.trim(),
      'houseNo': state.houseNo.trim(),
      'street': state.street.trim(),
      'city': state.city.trim(),
      'pincode': state.pincode.trim(),
    };
  }

  Future<void> submitOrder(int qty, PackType packType) async {
    if (!validate()) return;
    if (Env.razorpayKey.isEmpty) {
      state = state.copyWith(error: 'Payment configuration error. Please contact support.');
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await http.post(
        Uri.parse('${Env.backendUrl}/create-order'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'qty': qty,
          'packType': packType.toApiString(),
          ..._buildCustomerPayload(),
        }),
      );

      if (response.statusCode < 200 || response.statusCode >= 300) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final String errorMsg = data['message'] ?? data['error'] ?? 'Order creation failed';
        state = state.copyWith(isLoading: false, error: errorMsg);
        return;
      }

      final Map<String, dynamic> orderData = jsonDecode(response.body);
      final String generatedOrderId = 'DSP' + DateTime.now().millisecondsSinceEpoch.toString().substring(5);

      final pkg = getPackageDetails(qty, packType);
      final html = _buildRazorpayHtml(orderData, pkg);

      state = state.copyWith(
        isLoading: false,
        orderId: generatedOrderId,
        localOrderId: generatedOrderId,
        razorpayHtml: html,
        showWebView: true,
        verifiedQty: qty,
        verifiedPackType: packType,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Error: ${e.toString()}');
    }
  }

  Future<void> verifyPayment({
    required String razorpayOrderId,
    required String razorpayPaymentId,
    required String razorpaySignature,
  }) async {
    state = state.copyWith(isLoading: true, error: null, showWebView: false);

    try {
      final response = await http.post(
        Uri.parse('${Env.backendUrl}/verify-payment'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'razorpay_order_id': razorpayOrderId,
          'razorpay_payment_id': razorpayPaymentId,
          'razorpay_signature': razorpaySignature,
          'qty': state.verifiedQty,
          'packType': state.verifiedPackType.toApiString(),
          ..._buildCustomerPayload(),
          'orderId': state.localOrderId,
        }),
      );

      final Map<String, dynamic> verifyData = jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300 && verifyData['success'] == true) {
        state = state.copyWith(isLoading: false, isSuccess: true);
      } else {
        final errorMsg = verifyData['message'] ?? verifyData['error'] ?? 'Verification failed';
        state = state.copyWith(
          isLoading: false,
          error: 'Payment received but verification failed: $errorMsg\nOrder ID: ${state.localOrderId}\nPlease contact support.',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: "Payment done but verification failed: ${e.toString()}\nOrder ID: ${state.localOrderId}\nPlease contact support.",
      );
    }
  }

  String _buildRazorpayHtml(Map<String, dynamic> orderData, PackageDetails pkg) {
    final String key = Env.razorpayKey;
    final String rzpOrderId = orderData['id'] ?? '';
    final int amount = orderData['amount'] ?? 0;
    final String desc = '${pkg.label} — ${pkg.isKit ? '${state.verifiedQty} kit(s)' : '${pkg.soaps} soaps'}';
    final String name = state.fullName;
    final String email = state.email;
    final String contact = state.mobile;

    return '''<!DOCTYPE html>
<html>
<head>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta charset="UTF-8">
  <script src="https://checkout.razorpay.com/v1/checkout.js"></script>
  <style>
    body { margin: 0; background: #1a1a1a; display: flex; justify-content: center; align-items: center; height: 100vh; font-family: sans-serif; }
    .container { text-align: center; color: #fff; }
    .msg { color: #f5c518; font-size: 16px; padding: 20px; }
    .error { color: #ff6b6b; }
    .spinner { display: inline-block; animation: spin 1s linear infinite; }
    @keyframes spin { 0% { transform: rotate(0deg); } 100% { transform: rotate(360deg); } }
  </style>
</head>
<body>
  <div class="container">
    <div class="msg" id="msg"><span class="spinner">⏳</span> Opening secure payment...</div>
  </div>
  <script>
    var retryCount = 0;
    var maxRetries = 5;

    function sendMessage(type, data) {
      try {
        if (window.PaymentInterface && window.PaymentInterface.postMessage) {
          window.PaymentInterface.postMessage(JSON.stringify({ type: type, ...data }));
        }
      } catch (err) {}
    }

    function initRazorpay() {
      if (typeof Razorpay === 'undefined') {
        if (retryCount < maxRetries) {
          retryCount++;
          setTimeout(initRazorpay, 500);
          return;
        }
        document.getElementById("msg").innerHTML = '<span class="error">Payment system not available. Please try again.</span>';
        setTimeout(function() { sendMessage('PAYMENT_FAILED', { error: 'Payment system not available.' }); }, 2000);
        return;
      }

      try {
        var rzp = new Razorpay({
          key: "$key",
          amount: $amount,
          currency: "INR",
          order_id: "$rzpOrderId",
          name: "Diya Soaps",
          description: "$desc",
          prefill: { name: "$name", email: "$email", contact: "$contact" },
          theme: { color: "#d97706", backdrop: true },
          handler: function(response) {
            sendMessage('PAYMENT_SUCCESS', {
              razorpay_order_id: response.razorpay_order_id || "",
              razorpay_payment_id: response.razorpay_payment_id || "",
              razorpay_signature: response.razorpay_signature || ""
            });
          },
          modal: {
            ondismiss: function() { sendMessage('PAYMENT_CANCELLED', {}); }
          }
        });

        rzp.on("payment.failed", function(response) {
          sendMessage('PAYMENT_FAILED', { error: response?.error?.description || 'Payment failed.' });
        });

        rzp.open();
        document.getElementById("msg").innerText = "Completing your payment...";
      } catch (err) {
        sendMessage('PAYMENT_FAILED', { error: 'Error initializing payment.' });
      }
    }

    if (document.readyState === 'loading') {
      document.addEventListener('DOMContentLoaded', initRazorpay);
    } else {
      setTimeout(initRazorpay, 100);
    }
  </script>
</body>
</html>''';
  }
}

final checkoutFormProvider =
    StateNotifierProvider<CheckoutFormNotifier, CheckoutFormState>((ref) {
  return CheckoutFormNotifier();
});

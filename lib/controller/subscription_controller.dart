import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'auth_controller.dart';

class SubscriptionController extends GetxController {
  late Razorpay _razorpay;

  var isPremiumSubscriber = false.obs;
  var subscriptionExpiryDate = DateTime.now().obs;

  @override
  void onInit() {
    super.onInit();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    _loadSubscriptionStatus(); // Load initial subscription status
  }

  @override
  void onClose() {
    super.onClose();
    _razorpay.clear();
  }

  void initiateSubscriptionPayment() {
    var options = {
      'key': 'rzp_test_cDa0MyUrUlSnWd', // Add your Razorpay key here
      'amount': 89900, // Rs 899 in paise
      'name': 'eLibrary',
      'description': 'Monthly Premium Subscription',
      'prefill': {
        'contact': 'phone_number', // User's contact number
        'email': 'email_address', // User's email address
      },
      'currency': 'INR',
      'subscription': {
        'period': 'monthly',
        'interval': 1
      },
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      Fluttertoast.showToast(msg: "Error: $e");
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    final userId = Get.find<AuthController>().user?.uid;
    if (userId != null) {
      FirebaseFirestore.instance.collection('users').doc(userId).update({
        'is_premium_subscriber': true,
        'subscription_expiry': DateTime.now().add(Duration(days: 30)) // Expire after one month
      }).then((_) {
        // Update local state
        isPremiumSubscriber.value = true;
        subscriptionExpiryDate.value = DateTime.now().add(Duration(days: 30));
        Fluttertoast.showToast(msg: "Payment Successful");
      }).catchError((error) {
        Fluttertoast.showToast(msg: "Error updating subscription status: $error");
      });
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(msg: "Payment Failed: ${response.message}");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(msg: "External Wallet Selected");
  }

  void _loadSubscriptionStatus() async {
    final userId = Get.find<AuthController>().user?.uid;
    if (userId != null) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
      if (doc.exists) {
        final data = doc.data();
        isPremiumSubscriber.value = data?['is_premium_subscriber'] ?? false;
        subscriptionExpiryDate.value = (data?['subscription_expiry'] as Timestamp?)?.toDate() ?? DateTime.now();
      }
    }
  }
}

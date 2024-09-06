import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart'; // Import Razorpay
import 'package:read/controller/book_detail_controller.dart';
import 'package:read/view/pdfviewscreen.dart';

class BookDetailsView extends StatelessWidget {
  final String bookId;
  late Razorpay _razorpay; // Declare Razorpay instance

  BookDetailsView({required this.bookId}) {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    final controller = Get.find<BookDetailsController>();
    controller.markBookAsPurchased(); // Mark the book as purchased
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Handle payment error
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Handle external wallet
  }

  void _initiatePayment(double amount) {
    var options = {
      'key': 'rzp_test_cDa0MyUrUlSnWd',
      'amount': amount * 100, // Convert amount to paise
      'name': 'Book Purchase',
      'description': 'Purchase of premium book',
      'prefill': {
        'contact': '1234567890',
        'email': 'test@example.com',
      },
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BookDetailsController(bookId: bookId));

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Book Details',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF0A0E21),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Obx(() {
        final book = controller.book.value;
        final isBookPurchased = controller.isBookPurchased.value;
        final isFavorite = controller.isFavorite.value;

        if (book == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              Container(
                height: 250,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(book.coverUrl),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    book.name,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0A0E21),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : Colors.grey,
                      size: 30,
                    ),
                    onPressed: () {
                      if (isFavorite) {
                        controller.removeFromFavorites();
                      } else {
                        controller.addToFavorites();
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Author: ${book.author}',
                style: const TextStyle(
                  fontSize: 20,
                  color: Color(0xFF0A0E21),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Price: ₹${book.price.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 20,
                  color: Color(0xFF0A0E21),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Description',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0A0E21),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                book.description,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Page Count: ${book.pageCount}',
                style: const TextStyle(
                  fontSize: 18,
                  color: Color(0xFF0A0E21),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFA726),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {
                  if (book.isNormalBook || isBookPurchased) {
                    if (book.pdfUrl.isNotEmpty) {
                      Get.to(() => PdfViewerScreen(pdfUrl: book.pdfUrl));
                    } else {
                      // Handle case where PDF is not available
                    }
                  } else {
                    _initiatePayment(book.price);
                  }
                },
                child: Text(
                  isBookPurchased || book.isNormalBook ? 'Read Book' : 'Buy and Read',
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

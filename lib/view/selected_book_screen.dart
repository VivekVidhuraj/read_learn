import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:read/controller/book_detail_controller.dart';
import 'package:read/view/pdfviewscreen.dart'; // Import PdfViewerScreen

class BookDetailsView extends StatelessWidget {
  final String bookId;

  BookDetailsView({required this.bookId});

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
              Text(
                book.name,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0A0E21),
                ),
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
                'Price: \$${book.price.toStringAsFixed(2)}',
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
                  if (book.isNormalBook) {
                    // Display PDF reader
                    if (book.pdfUrl.isNotEmpty) {
                      // Open PDF reader using the PDF URL
                      Get.to(() => PdfViewerScreen(pdfUrl: book.pdfUrl));
                    } else {
                      // Handle case where PDF URL is not available
                      Get.snackbar('Error', 'PDF not available for this book.');
                    }
                  } else {
                    // Show an alert dialog to inform about the premium subscription
                    Get.defaultDialog(
                      title: 'Premium Subscription Required',
                      middleText: 'This book is available only for premium subscribers. Please subscribe to access this book.',
                      textConfirm: 'Subscribe',
                      textCancel: 'Cancel',
                      confirmTextColor: Colors.white,
                      onConfirm: () {
                        // Handle the subscription logic or show a message
                        Get.snackbar('Premium Subscription', 'Please visit our subscription page to subscribe.');
                      },
                      onCancel: () {
                        // Handle cancel action if needed
                      },
                    );
                  }
                },
                child: const Text(
                  'Read Book',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

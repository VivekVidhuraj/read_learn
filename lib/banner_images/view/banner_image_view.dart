import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:read/controller/banner_image_controller.dart';

class BannerImageScreen extends StatelessWidget {
  final BannerImageController controller = Get.put(BannerImageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Banner Images')),
      body: Obx(
            () {
          if (controller.bannerImages.isEmpty) {
            return Center(child: Text('No banners found'));
          }
          return CarouselSlider(
            options: CarouselOptions(
              height: 200.h,
              autoPlay: true,
              enlargeCenterPage: true,
            ),
            items: controller.bannerImages.map((banner) {
              return Builder(
                builder: (BuildContext context) {
                  return Column(
                    children: [
                      Image.network(
                        width: MediaQuery.of(context).size.width,
                        banner.imageUrl,
                        fit: BoxFit.fill,
                        height: 150.h,
                      ),
                      SizedBox(height: 10.h),
                      // Text(
                      //   'ID: ${banner.bannerid}',
                      //   style: TextStyle(fontSize: 16.sp),
                      // ),
                      // Text(
                      //   'Uploaded at: ${banner.uploadedAt}',
                      //   style: TextStyle(fontSize: 14.sp),
                      // ),
                    ],
                  );
                },
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
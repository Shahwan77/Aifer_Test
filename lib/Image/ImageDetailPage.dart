import 'package:aifer/AppRoutes/AppRoutes.dart';
import 'package:aifer/Home/controller/HomeController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ImageDetailPage extends StatelessWidget {
  final String? imageUrl;
  final String? id;
  final String? altDescription;

  const ImageDetailPage({Key? key, this.imageUrl, this.altDescription, this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.put(HomeController());
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            Center(
              child: Image.network(
                imageUrl!,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  }
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                          : null,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  );
                },
                errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                  return Center(
                    child: Text(
                      'Failed to load image',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.h),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      Get.offAllNamed(AppRoutes.Home);
                    },
                    child: Icon(Icons.arrow_back_ios_new_outlined, color: Colors.white),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 16.h,
              right: 16.w,
              child: FloatingActionButton(
                onPressed: () {
                  String
                  highResImageUrl =
                      "${imageUrl}";
                  String
                  fileName =
                      '${id}.jpg'; // Photo ID
                  controller.downloadImage(
                      highResImageUrl,
                      fileName,
                      context);
                  print("Download Pressed!");
                },
                backgroundColor: Colors.grey.shade800,
                child: Icon(Icons.download,color: Colors.white70,),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
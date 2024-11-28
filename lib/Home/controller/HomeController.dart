import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'dart:convert';
import 'dart:io';

import '../models/HomeModels.dart';

class HomeController extends GetxController with SingleGetTickerProviderMixin {
  var isLoading = false.obs;
  var isImageLoaded = false.obs;
  var photos = <UnsplashPhoto>[].obs;
  var currentPage = 1.obs;
  var totalPages = 1.obs;
  late TabController tabController;

  final String clientId = 'HjvpzkU7OX_2MBO1ab0QTHylSxF3i_q4RLF_H5wTDHc';
  final String query = 'india';

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 3, vsync: this);
    fetchPhotos();
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  Future<void> fetchPhotos() async {
    if (isLoading.value || currentPage.value > totalPages.value) return;

    isLoading.value = true;
    try {
      final response = await http.get(
        Uri.parse(
            'https://api.unsplash.com/search/photos?page=${currentPage.value}&query=$query&client_id=$clientId'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        totalPages.value = data['total_pages'];
        List<dynamic> result = data['results'];
        photos.addAll(result.map((e) => UnsplashPhoto.fromJson(e)).toList());
        currentPage.value++;
      } else {
        throw Exception('Failed to load photos');
      }
    } catch (e) {
      print('Error fetching photos: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> downloadImage(String imageUrl, String fileName, BuildContext context) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Row(
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 20),
                Text("Downloading..."),
              ],
            ),
          );
        },
      );
      if (Platform.isAndroid) {
        if (await Permission.manageExternalStorage.isDenied || await Permission.storage.isDenied) {
          final status = await Permission.manageExternalStorage.request();
          if (!status.isGranted) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Storage permission is required. Please grant it in settings.')),
            );
            openAppSettings();
            return;
          }
        }
      }
      Directory downloadsDirectory = Directory('/storage/emulated/0/Download');
      if (!await downloadsDirectory.exists()) {
        await downloadsDirectory.create(recursive: true);
      }
      String savePath = '${downloadsDirectory.path}/$fileName';
      Dio dio = Dio();
      await dio.download(imageUrl, savePath);
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Image downloaded to: $savePath')),
      );
    } catch (e) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error downloading image: $e')),
      );
    }
  }

}

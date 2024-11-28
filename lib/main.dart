import 'dart:io';

import 'package:aifer/AppPages/AppPages.dart';
import 'package:aifer/AppRoutes/AppRoutes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:permission_handler/permission_handler.dart';

import 'Home/controller/HomeController.dart';
import 'Home/HomePage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterDownloader.initialize();
  runApp(const MyApp());
  Get.put(HomeController());
  await _requestPermissions();
}
Future<void> _requestPermissions() async {
  if (Platform.isAndroid) {
    if (await Permission.manageExternalStorage.isDenied) {
      PermissionStatus status = await Permission.manageExternalStorage.request();
      if (!status.isGranted) {
        openAppSettings();
        return;
      }
    }
    if (await Permission.storage.isDenied) {
      await Permission.storage.request();
    }
  }
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      child: GetMaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        // home: CustomBottomNavBarPage(),
        initialRoute: AppRoutes.Home,
        getPages: AppPages.Lists,
        // home: DownloadImagePage(),
      ),
    );
  }
}
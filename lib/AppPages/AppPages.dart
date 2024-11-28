import 'package:aifer/AppRoutes/AppRoutes.dart';
import 'package:aifer/Home/HomePage.dart';
import 'package:aifer/Image/ImageDetailPage.dart';
import 'package:get/get.dart';

class AppPages{
  static var Lists = [
    GetPage(name: AppRoutes.Home, page: () => HomePage(),),
    GetPage(name: AppRoutes.ImagePage, page: () => ImageDetailPage(),)
  ];
}
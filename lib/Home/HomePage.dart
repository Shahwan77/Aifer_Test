import 'package:aifer/Image/ImageDetailPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shimmer/shimmer.dart';
import 'controller/HomeController.dart';

class HomePage extends StatelessWidget {
  final ScrollController _scrollController = ScrollController();
  final HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CircleAvatar(
                  radius: 22.r,
                  backgroundImage: NetworkImage(
                    'https://t4.ftcdn.net/jpg/03/64/21/11/360_F_364211147_1qgLVxv1Tcq0Ohz3FawUfrtONzz8nq3e.jpg',
                  ),
                ),
                SizedBox(
                  width: 18.w,
                ),
                ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(Colors.red)),
                    onPressed: () {},
                    child: Text(
                      "Follow",
                      style: TextStyle(color: Colors.white),
                    )),
                SizedBox(
                  width: 18.w,
                ),
              ],
            ),
            SizedBox(
              height: 20.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.w),
              child: TabBar(
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30.r)),
                dividerColor: Colors.transparent,
                indicatorColor: Colors.white,
                controller: controller.tabController,
                labelStyle:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                tabs: [
                  Tab(
                    text: 'Activity',
                  ),
                  Tab(text: 'Community'),
                  Tab(text: 'Shop'),
                ],
              ),
            ),
            SizedBox(
              height: 15.h,
            ),
            Expanded(
              child: GetX<HomeController>(
                init: HomeController(),
                builder: (controller) {
                  _scrollController.addListener(() {
                    if (_scrollController.position.pixels ==
                            _scrollController.position.maxScrollExtent &&
                        !controller.isLoading.value &&
                        controller.currentPage.value <=
                            controller.totalPages.value) {
                      controller.fetchPhotos();
                    }
                  });

                  return controller.isLoading.value && controller.photos.isEmpty
                      ? Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5.w),
                          child: Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: StaggeredGrid.count(
                              crossAxisCount: 2,
                              crossAxisSpacing: 8.0,
                              mainAxisSpacing: 8.0,
                              children: List.generate(6, (index) {
                                // Number of shimmer items
                                return Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(10.r),
                                  ),
                                );
                              }),
                            ),
                          ),
                        )
                      : Stack(
                          children: [
                            // White container with images
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(30.r),
                                      topLeft: Radius.circular(30.r))),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 13.h,
                                  ),
                                  Text("All Places", style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 15.h,
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 5.w),
                                      child: CustomScrollView(
                                        controller: _scrollController,
                                        slivers: [
                                          SliverToBoxAdapter(
                                            child: StaggeredGrid.count(
                                              crossAxisCount: 2,
                                              crossAxisSpacing: 8.0,
                                              mainAxisSpacing: 8.0,
                                              children: List.generate(
                                                  controller.photos.length + 1,
                                                  (index) {
                                                if (index ==
                                                    controller.photos.length) {
                                                  return Padding(
                                                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                                                    child: Shimmer.fromColors(
                                                      baseColor: Colors.grey[300]!,
                                                      highlightColor: Colors.grey[100]!,
                                                      child: Container(
                                                        height: 148.h,
                                                        decoration: BoxDecoration(
                                                          borderRadius:BorderRadius.circular(10.r),
                                                          color: Colors.grey[300],
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                }
                                                String _getFormattedText(
                                                    String text) {
                                                  String capitalize(
                                                      String str) {
                                                    if (str.isEmpty) return str;
                                                    return str[0].toUpperCase() + str.substring(1);
                                                  }

                                                  text = capitalize(text);
                                                  List<String> words = text.split(' ');
                                                  if (words.length > 3) {
                                                    String firstLine = words
                                                        .sublist(0, 3)
                                                        .join(' ');
                                                    String secondLine = words
                                                        .sublist(3)
                                                        .join(' ');
                                                    List<String>
                                                        secondLineWords =
                                                        secondLine.split(' ');

                                                    if (secondLineWords.length >
                                                        3) {
                                                      secondLine = secondLineWords.sublist(0, 3).join(' ') + '...';
                                                    }

                                                    return '$firstLine\n$secondLine';
                                                  } else {
                                                    return text;
                                                  }
                                                }

                                                final photo = controller.photos[index];
                                                return Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:BorderRadius.circular(10.r),
                                                  ),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      Get.to(
                                                        ImageDetailPage(
                                                          id: photo.id,
                                                          imageUrl: photo
                                                              .FullimageUrl,
                                                          altDescription: photo
                                                              .altDescription,
                                                        ),
                                                      );
                                                    },
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        ClipRRect(
                                                          borderRadius: BorderRadius.circular(10.r),
                                                          child: Image.network(
                                                            photo.imageUrl,
                                                            fit: BoxFit.cover,
                                                            loadingBuilder:
                                                                (context, child,
                                                                    loadingProgress) {
                                                              if (loadingProgress == null) {
                                                                controller.isImageLoaded.value = true;
                                                                return child;
                                                              }
                                                              return Center(
                                                                child: Shimmer.fromColors(
                                                                  baseColor: Colors.grey[300]!,
                                                                  highlightColor: Colors.grey[100]!,
                                                                  child: Container(
                                                                    height: 148.h,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      borderRadius: BorderRadius.circular(10.r),
                                                                      color: Colors.grey[300],
                                                                    ),
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                            errorBuilder:
                                                                (context, error,
                                                                    stackTrace) {
                                                              return Icon(
                                                                  Icons.error,
                                                                  size: 50.sp);
                                                            },
                                                          ),
                                                        ),
                                                        Obx(() {
                                                          return controller.isImageLoaded.value
                                                              ? Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    Row(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      children: [
                                                                        Text(
                                                                          (photo.altDescription?.isNotEmpty ?? false)
                                                                              ? _getFormattedText(photo.altDescription!)
                                                                              : 'No description',
                                                                          style: TextStyle(
                                                                            color: Colors.black, fontSize: 10.sp,
                                                                            fontWeight: FontWeight.bold,
                                                                          ),
                                                                          maxLines: 2,
                                                                          overflow: TextOverflow.ellipsis,
                                                                        ),
                                                                        PopupMenuButton<
                                                                            String>(
                                                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                                                          icon: Icon(CupertinoIcons.ellipsis),
                                                                          onSelected: (value) {
                                                                            if (value ==
                                                                                'download') {
                                                                              String highResImageUrl = photo.FullimageUrl;
                                                                              String fileName = '${photo.id}.jpg';
                                                                              controller.downloadImage(highResImageUrl, fileName, context);
                                                                            }
                                                                          },
                                                                          itemBuilder: (BuildContext context) {
                                                                            return [
                                                                              PopupMenuItem<String>(
                                                                                value: 'download',
                                                                                child: Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                  children: [
                                                                                    Text('Download Image'),
                                                                                    Icon(Icons.download)
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ];
                                                                          },
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                )
                                                              : Container();
                                                        }),
                                                        SizedBox(
                                                          height: 10,
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              }),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              left: 0,
                              right: 0,
                              bottom: 0,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 40.w, vertical: 20.h),
                                child: Container(
                                  height: 50.h,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(35),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 10.r,
                                        offset: Offset(0, 5),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      BarItem(
                                          img: Image.asset(
                                            "assets/1.png",
                                            width: 26.w,
                                          ),
                                          index: 0),
                                      BarItem(
                                          icon: Icons.search, index: 1),
                                      BarItem(
                                          icon: Icons.notifications, index: 2),
                                      BarItem(
                                          icon: Icons.person, index: 3),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget BarItem({IconData? icon, required int index, Image? img}) {
    return GestureDetector(
      onTap: () {},
      child: img ??
          Icon(
            icon,
            size: 30,
            color: Colors.black,
          ),
    );
  }
}

import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:knn_wortel/getx/navigation.dart';
import 'package:knn_wortel/pages/home_page.dart';
import 'package:knn_wortel/pages/info_page.dart';
import 'package:knn_wortel/pages/setting_page.dart';
import 'package:knn_wortel/pages/training_page.dart';
import 'package:knn_wortel/widgets/app_color.dart';

class FoundationPage extends StatelessWidget {
  FoundationPage({Key? key}) : super(key: key);

  final NavigationController navigationController =
      Get.put(NavigationController());
  static final List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    TrainingPage(),
    SettingPage(),
    const AboutPage()
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 2,
          backgroundColor: AppColor.orange,
          title: GetBuilder<NavigationController>(
            builder: (_) => Text(navigationController.appBarTitle),
          ),
        ),
        body: GetBuilder<NavigationController>(
            builder: (_) =>
                _widgetOptions.elementAt(navigationController.currentIndex)),
        bottomNavigationBar: GetBuilder<NavigationController>(
          builder: (_) => BottomNavyBar(
            selectedIndex: navigationController.currentIndex,
            onItemSelected: (index) {
              navigationController.updateCurrentIndex(index);
            },
            items: <BottomNavyBarItem>[
              BottomNavyBarItem(
                  title: const Text('Beranda'),
                  icon: const Icon(Icons.home),
                  activeColor: AppColor.orange,
                  inactiveColor: Colors.grey),
              BottomNavyBarItem(
                  title: const Text('Data Training'),
                  icon: const Icon(Icons.list),
                  activeColor: AppColor.orange,
                  inactiveColor: Colors.grey),
              BottomNavyBarItem(
                  title: const Text('Pengaturan'),
                  icon: const Icon(Icons.settings),
                  activeColor: AppColor.orange,
                  inactiveColor: Colors.grey),
              BottomNavyBarItem(
                  title: const Text('Tentang'),
                  icon: const Icon(Icons.info),
                  activeColor: AppColor.orange,
                  inactiveColor: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}

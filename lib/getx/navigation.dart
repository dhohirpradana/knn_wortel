import 'package:get/get.dart';

class NavigationController extends GetxController {
  int currentIndex = 0;
  String appBarTitle = 'KNN KLASIFIKASI WORTEL';

  void updateCurrentIndex(data) {
    appBarTitle = (data == 0)
        ? 'KNN KLASIFIKASI WORTEL'
        : (data == 1)
            ? 'DATA TRAINING'
            : (data == 1)
                ? 'PENGATURAN'
                : 'TENTANG';
    currentIndex = data;
    update(); // Tell your widgets that you have changed the counter
  }
}

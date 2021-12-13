import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:knn_wortel/pages/foundation_page.dart';

import 'getx/image_picker.dart';
import 'getx/knn.dart';
import 'getx/knn_kualitas.dart';
import 'getx/palette_generator.dart';

Future<void> main() async {
  //start get storage (Store Management)
  await GetStorage.init();

  //inisialisasi get yang ada di app
  final controller = Get.put(ImagePickerController());
  final knnController = Get.put(KNNController());
  final knnKualitasController = Get.put(KNNKualitasController());
  final paletteGeneratorController = Get.put(PaletteController());

  //deklarasi get storage/ inisialisasi
  final box = GetStorage();

  //membaca data get storage
  final imagePath = box.read('imagePath');
  final knnData = box.read('knn');
  final kualitasData = box.read('kualitas');
  final rgbhsl = box.read('rgbhsl');
  final n = box.read('n') ?? 3;

  //jika data tidak kosong maka ...
  if (imagePath != null &&
      imagePath != '' &&
      knnData != null &&
      kualitasData != null &&
      rgbhsl != null) {
    controller.updateImagePath(imagePath);
    knnController.updateKNN(knnData);
    paletteGeneratorController.getStorageRGBHSL(rgbhsl);
    knnKualitasController.updateN(n);
    await knnKualitasController.updateKualitas(kualitasData);
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'KNN WORTEL',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: FoundationPage(),
    );
  }
}

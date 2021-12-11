import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:palette_generator/palette_generator.dart';

import 'knn.dart';

class PaletteController extends GetxController {
  PickedFile? imageFile;

  PaletteGenerator? paletteGenerator;
  List rgbhsl = [];
  final box = GetStorage();
  final knnController = Get.put(KNNController());
  Future<void> updatePalette(File file) async {
    //mengambil warna dari gambar
    paletteGenerator = await PaletteGenerator.fromImageProvider(
      Image.file(file).image,
    );
    final color = paletteGenerator!.dominantColor!.color;
    final hsl = HSLColor.fromColor(color);
    rgbhsl = [
      color.red,
      color.green,
      color.blue,
      hsl.hue,
      hsl.saturation,
      hsl.lightness
    ];
    update();
    print(rgbhsl);
    box.write('rgbhsl', rgbhsl);
    // knnController.hitungKNN(paletteGenerator!);
  }

  void getStorageRGBHSL(List rgbhslData) {
    rgbhsl = rgbhslData;
    update();
  }
}

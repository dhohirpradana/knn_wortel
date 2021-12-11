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
    final color = (paletteGenerator!.darkMutedColor != null)
        ? paletteGenerator!.darkMutedColor!.color
        : paletteGenerator!.darkVibrantColor!.color;
    final darkPopulation = (paletteGenerator!.darkMutedColor != null)
        ? paletteGenerator!.darkMutedColor!.population
        : 0;
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
    print('$rgbhsl' + darkPopulation.toString());
    box.write('rgbhsl', rgbhsl);
    // knnController.hitungKNN(paletteGenerator!);
  }

  void getStorageRGBHSL(List rgbhslData) {
    rgbhsl = rgbhslData;
    update();
  }
}

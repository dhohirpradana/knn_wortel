import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:knn_wortel/data/data_training.dart';
import 'package:palette_generator/palette_generator.dart';
import 'knn_kualitas.dart';

class KNNController extends GetxController {
  final knnKualitasController = Get.put(KNNKualitasController());
  final box = GetStorage();
  List knn = [];
  void hitungKNN(PaletteGenerator paletteGenerator) {
    List edList = [];
    final darkPopulation = (paletteGenerator.darkMutedColor != null)
        ? paletteGenerator.darkMutedColor!.population
        : 0;
    final color = (darkPopulation > 100)
        ? paletteGenerator.darkMutedColor!.color
        : (paletteGenerator.darkVibrantColor != null)
            ? paletteGenerator.darkVibrantColor!.color
            : (paletteGenerator.darkMutedColor != null)
                ? paletteGenerator.darkMutedColor!.color
                : paletteGenerator.dominantColor!.color;
    //convert warna data testing ke HSL
    var hsl = HSLColor.fromColor(color);
    for (var i = 0; i < dataTraining.length; i++) {
      //selisih diukuadratkan
      // rgb

      // fuzzifikasi
      final r1 = dataTraining[i]['r'] / 255;
      final g1 = dataTraining[i]['g'] / 255;
      final b1 = dataTraining[i]['b'] / 255;
      final h1 = dataTraining[i]['h'] / 360;
      final s1 = dataTraining[i]['s'];
      final l1 = dataTraining[i]['l'];

      final r2 = color.red / 255;
      final g2 = color.green / 255;
      final b2 = color.blue / 255;
      final h2 = hsl.hue / 360;
      final s2 = hsl.saturation;
      final l2 = hsl.lightness;

      // jarak rgb
      final rd = (r1 - r2) * (r1 - r2);
      final gd = (g1 - g2) * (g1 - g2);
      final bd = (b1 - b2) * (b1 - b2);
      //hue distance/ jarak hue
      final hd = (h1 - h2) * (h1 - h2);
      //jarak saturation
      final sd = (s1 - s2) * (s1 - s2);
      //jarak lightness
      final ld = (l1 - l2) * (l1 - l2);

      final sum = rd + gd + bd + hd + sd + ld;

      //eulidience distance
      //RUMUS : akar/ sqrt dari jumlah
      final ed = sqrt(sum);
      edList.add(
        {
          'jarak': ed,
          'r': dataTraining[i]['r'],
          'g': dataTraining[i]['g'],
          'b': dataTraining[i]['b'],
          'h': dataTraining[i]['h'],
          's': dataTraining[i]['s'],
          'l': dataTraining[i]['l'],
          'kualitas': dataTraining[i]['q'],
        },
      );
      //sort dari terdekat
      edList.sort((a, b) => a['jarak'].compareTo(b['jarak']));
    }
    knn = edList;
    update();
    // Navigator.of(Get.overlayContext!).pop();
    knnKualitasController.getKualitas(edList);
    box.write('knn', knn);
  }

  void updateKNN(List knnData) {
    knn = knnData;
    update();
  }
}

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

      final rd = (dataTraining[i]['r'] - color.red) *
          (dataTraining[i]['r'] - color.red);
      final gd = (dataTraining[i]['g'] - color.green) *
          (dataTraining[i]['g'] - color.green);
      final bd = (dataTraining[i]['b'] - color.blue) *
          (dataTraining[i]['b'] - color.blue);
      //hue distance/ jarak hue
      final hd =
          (dataTraining[i]['h'] - hsl.hue) * (dataTraining[i]['h'] - hsl.hue);
      //jarak saturation
      final sd = (dataTraining[i]['s'] - hsl.saturation) *
          (dataTraining[i]['s'] - hsl.saturation);
      //jarak lightness
      final ld = (dataTraining[i]['l'] - hsl.lightness) *
          (dataTraining[i]['l'] - hsl.lightness);
      //eulidience distance
      //RUMUS : akar/ sqrt dari jumlah hd + sd + ld
      final ed = sqrt(rd + gd + bd + hd + sd + ld);
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

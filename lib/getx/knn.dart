import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
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
    //convert warna data testing ke HSL
    var hsl = HSLColor.fromColor(paletteGenerator.dominantColor!.color);
    for (var i = 0; i < dataTraining.length; i++) {
      //selisih diukuadratkan
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
      final ed = sqrt(hd + sd + ld);
      edList.add(
        {
          'jarak': ed,
          'kualitas': dataTraining[i]['q'],
        },
      );
      //sort dari terdekat
      edList.sort((a, b) => a['jarak'].compareTo(b['jarak']));
    }
    knn = edList;
    update();
    Navigator.of(Get.overlayContext!).pop();
    knnKualitasController.getKualitas(edList);
    box.write('knn', knn);
  }

  void updateKNN(List knnData) {
    knn = knnData;
    update();
  }
}

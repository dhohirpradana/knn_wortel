import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'palette_generator.dart';

class ImagePickerController extends GetxController {
  final box = GetStorage();
  PickedFile? imageFile;
  final paletteController = Get.put(PaletteController());
  void updateImageFile(PickedFile data) {
    imageFile = data;
    update();
    box.write('imagePath', imageFile!.path);
    paletteController.updatePalette(File(imageFile!.path));
    Navigator.of(Get.overlayContext!).pop();
  }
}

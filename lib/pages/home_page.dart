import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:knn_wortel/getx/image_picker.dart';
import 'package:knn_wortel/getx/palette_generator.dart';
import 'package:knn_wortel/widgets/app_color.dart';

class HomePage extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  HomePage({Key? key}) : super(key: key);

  final ImagePickerController imagePickerController =
      Get.put(ImagePickerController());
  final PaletteController paletteController = Get.put(PaletteController());

  void _openCamera(BuildContext context) async {
    // ignore: deprecated_member_use
    final pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
    );
    if (pickedFile != null) {
      _cropImage(pickedFile);
    }
  }

  void _openGallery(BuildContext context) async {
    // ignore: deprecated_member_use
    final pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      _cropImage(pickedFile);
    }
  }

  Future _cropImage(PickedFile pickedFile) async {
    File? croppedFile = await ImageCropper.cropImage(
        sourcePath: pickedFile.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9
              ]
            : [
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio5x3,
                CropAspectRatioPreset.ratio5x4,
                CropAspectRatioPreset.ratio7x5,
                CropAspectRatioPreset.ratio16x9
              ],
        androidUiSettings: const AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: const IOSUiSettings(
          title: 'Cropper',
        ));
    if (croppedFile != null) {
      imagePickerController.updateImageFile(PickedFile(croppedFile.path));
    }
  }

  Future<void> _showChoiceDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              "Pilih",
              style: TextStyle(color: Colors.blue),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  const Divider(
                    height: 1,
                    color: Colors.blue,
                  ),
                  ListTile(
                    onTap: () {
                      _openGallery(context);
                    },
                    title: const Text("Galeri"),
                    leading: const Icon(
                      Icons.photo_album,
                      color: Colors.blue,
                    ),
                  ),
                  const Divider(
                    height: 1,
                    color: Colors.blue,
                  ),
                  ListTile(
                    onTap: () {
                      _openCamera(context);
                    },
                    title: const Text("Kamera"),
                    leading: const Icon(
                      Icons.camera,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          GetBuilder<ImagePickerController>(
            builder: (_) => Card(
              child: (imagePickerController.imageFile == null)
                  ? SizedBox(
                      width: Get.width,
                      height: Get.height / 4,
                      child: Icon(
                        Icons.photo_album,
                        size: Get.width / 3,
                        color: Colors.grey,
                      ))
                  : Row(
                      children: [
                        Image.file(
                          File(imagePickerController.imageFile!.path),
                          height: Get.height / 4,
                          width: Get.width / 1.7,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        GetBuilder<PaletteController>(
                          builder: (_) => (paletteController.rgbhsl.isNotEmpty)
                              ? SizedBox(
                                  height: Get.height / 4,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text('Data Image :'),
                                      Text('R : ' +
                                          paletteController.rgbhsl[0]
                                              .toString()),
                                      Text('G : ' +
                                          paletteController.rgbhsl[1]
                                              .toString()),
                                      Text('B : ' +
                                          paletteController.rgbhsl[2]
                                              .toString()),
                                      Text('H : ' +
                                          paletteController.rgbhsl[3]
                                              .toString()
                                              .substring(
                                                  0,
                                                  (paletteController.rgbhsl[3]
                                                              .toString()
                                                              .length >
                                                          5)
                                                      ? 5
                                                      : paletteController
                                                          .rgbhsl[3]
                                                          .toString()
                                                          .length)),
                                      Text('S : ' +
                                          paletteController.rgbhsl[4]
                                              .toString()
                                              .substring(
                                                  0,
                                                  (paletteController.rgbhsl[4]
                                                              .toString()
                                                              .length >
                                                          5)
                                                      ? 5
                                                      : paletteController
                                                          .rgbhsl[4]
                                                          .toString()
                                                          .length)),
                                      Text('L : ' +
                                          paletteController.rgbhsl[5]
                                              .toString()
                                              .substring(
                                                  0,
                                                  (paletteController.rgbhsl[5]
                                                              .toString()
                                                              .length >
                                                          5)
                                                      ? 5
                                                      : paletteController
                                                          .rgbhsl[5]
                                                          .toString()
                                                          .length))
                                    ],
                                  ),
                                )
                              : const SizedBox(),
                        )
                      ],
                    ),
            ),
          ),
          MaterialButton(
            minWidth: Get.width,
            textColor: Colors.white,
            color: AppColor.orange,
            onPressed: () {
              _showChoiceDialog(context);
            },
            child: const Text("Pilih Image"),
          ),
          GetBuilder<PaletteController>(
            builder: (_) => Container(
              height: 90,
              color: (paletteController.paletteGenerator != null)
                  ? (paletteController.paletteGenerator!.dominantColor != null)
                      ? paletteController.paletteGenerator!.dominantColor!.color
                      : paletteController
                          .paletteGenerator!.darkVibrantColor!.color
                  : Colors.white,
            ),
          ),
          GetBuilder<PaletteController>(
            builder: (_) => Container(
              height: 90,
              color: (paletteController.paletteGenerator != null)
                  ? (paletteController.paletteGenerator!.darkMutedColor != null)
                      ? paletteController
                          .paletteGenerator!.darkMutedColor!.color
                      : paletteController
                          .paletteGenerator!.darkVibrantColor!.color
                  : Colors.white,
              child: Center(
                  child: Text(
                (paletteController.paletteGenerator != null)
                    ? (paletteController.paletteGenerator!.darkMutedColor !=
                            null)
                        ? paletteController
                            .paletteGenerator!.darkMutedColor!.population
                            .toString()
                        : '0'
                    : 'No Data',
                style: const TextStyle(color: Colors.yellow),
              )),
            ),
          )
        ],
      ),
    );
  }
}

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:knn_wortel/getx/image_picker.dart';
import 'package:knn_wortel/getx/knn.dart';
import 'package:knn_wortel/getx/knn_kualitas.dart';
import 'package:knn_wortel/getx/palette_generator.dart';
import 'package:knn_wortel/widgets/app_color.dart';

class HomePage extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  HomePage({Key? key}) : super(key: key);

  final ImagePickerController imagePickerController =
      Get.put(ImagePickerController());
  final knnController = Get.put(KNNController());
  final kualitasController = Get.put(KNNKualitasController());
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
          GetBuilder<KNNKualitasController>(
            builder: (_) => SizedBox(
              child: GetBuilder<PaletteController>(
                builder: (_) => Container(
                  padding: const EdgeInsets.all(5),
                  width: Get.width,
                  color: (paletteController.paletteGenerator != null)
                      ? (paletteController.paletteGenerator!.darkMutedColor !=
                              null)
                          ? paletteController
                              .paletteGenerator!.darkMutedColor!.color
                          : paletteController
                              .paletteGenerator!.darkVibrantColor!.color
                      : Colors.white,
                  child: Center(
                    child: Text(
                      (kualitasController.kualitas == null)
                          ? 'Tidak ada image'
                          : kualitasController.kualitas!.toUpperCase(),
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
            ),
          ),
          //listview
          Expanded(
            flex: 1,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
              child: GetBuilder<KNNController>(
                builder: (_) => (knnController.knn.isEmpty)
                    ? const SizedBox()
                    : ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: kualitasController.n,
                        itemBuilder: (context, index) {
                          return ListTile(
                            tileColor:
                                (knnController.knn[index]['kualitas'] == 1)
                                    ? Colors.green[50]
                                    : Colors.red[50],
                            leading: Text((index + 1).toString()),
                            title: Text(
                                (knnController.knn[index]['kualitas'] == 1)
                                    ? 'Layak'
                                    : 'Tidak Layak'),
                            subtitle: Text('Jarak : ' +
                                knnController.knn[index]['jarak'].toString()),
                          );
                        },
                      ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

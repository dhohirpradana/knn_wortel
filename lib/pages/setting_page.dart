import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:knn_wortel/data/data_training.dart';
import 'package:knn_wortel/getx/knn.dart';
import 'package:knn_wortel/getx/knn_kualitas.dart';
import 'package:knn_wortel/widgets/app_color.dart';

// ignore: must_be_immutable
class SettingPage extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  SettingPage({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  final knnController = Get.put(KNNController());
  final knnKualitasController = Get.put(KNNKualitasController());
  final kualitasController = Get.put(KNNKualitasController());
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              decoration: const InputDecoration(
                icon: Icon(
                  Icons.tag,
                  color: Colors.black,
                ),
                // hintText: 'Masukan nilai N',
                labelText: 'Nilai N',
              ),
              keyboardType: TextInputType.number,
              controller: controller,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Tidak boleh kosong!';
                } else if (value == '0') {
                  return 'Tidak boleh nol!';
                } else if (int.parse(value) == knnKualitasController.n) {
                  return 'Tidak ada perubahan nilai!';
                }
                return null;
              },
            ),
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(AppColor.orange)),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  final int value =
                      (int.parse(controller.text) > dataTraining.length)
                          ? dataTraining.length
                          : int.parse(controller.text);
                  knnKualitasController.updateN(value);
                  kualitasController.getKualitas(knnController.knn);
                  FocusScope.of(context).unfocus();
                  showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (_) => WillPopScope(
                      onWillPop: () async => false,
                      child: Dialog(
                        child: Container(
                          alignment: FractionalOffset.center,
                          height: 80.0,
                          padding: const EdgeInsets.all(20.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircularProgressIndicator(
                                color: Colors.green[300],
                              ),
                              const Padding(
                                padding: EdgeInsets.only(left: 10.0),
                                child: Text("Menyimpan..."),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                  await Future.delayed(const Duration(seconds: 2));
                  Get.back();
                  await Future.delayed(const Duration(milliseconds: 150));
                  AwesomeDialog(
                    dismissOnTouchOutside: false,
                    dismissOnBackKeyPress: false,
                    context: context,
                    animType: AnimType.SCALE,
                    dialogType: DialogType.SUCCES,
                    body: const Center(
                      child: Text(
                        'Berhasil update nilai N',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                    title: 'Update nilai N',
                    desc: 'Ini adalah proses update nilai N',
                    btnOkOnPress: () {},
                  ).show();
                }
              },
              child: const Text('SIMPAN'),
            ),
          ],
        ),
      ),
    );
  }
}

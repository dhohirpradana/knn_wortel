import 'package:flutter/material.dart';

class TrainingPage extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  TrainingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        cacheExtent: 9,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 0,
          mainAxisSpacing: 0,
        ),
        itemCount: 60,
        itemBuilder: (BuildContext context, i) {
          final String no = (i < 30)
              ? '1/' + (i + 1).toString() + '.jpg'
              : '0/' + (i - 29).toString() + '.jpg';
          return Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage('lib/assets/image/$no'),
                  ),
                ),
              ),
              // Center(
              // child:
              (i < 31)
                  ? Padding(
                      padding: const EdgeInsets.only(top: 3),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 2, horizontal: 3),
                            color: Colors.white,
                            child: const Text('LAYAK'),
                          ),
                        ],
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(top: 3),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(2.5),
                            color: Colors.white,
                            child: const Text('TIDAK LAYAK'),
                          ),
                        ],
                      ),
                    ),
              // )
            ],
          );
        });
  }
}

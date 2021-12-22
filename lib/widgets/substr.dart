import 'package:flutter/material.dart';

Widget substringText(data) => Text(data
    .toString()
    .substring(0, (data.toString().length > 5) ? 5 : data.toString().length));

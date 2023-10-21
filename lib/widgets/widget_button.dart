// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:iceproj/utility/app_constant.dart';

class WidgetButton extends StatelessWidget {
  const WidgetButton({
    Key? key,
    required this.data,
    required this.pressFunc,
    this.radius,
  }) : super(key: key);

  final String data;
  final Function() pressFunc;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: pressFunc,
      child: Text(data),
      style: ElevatedButton.styleFrom(
          backgroundColor: AppContant.mainColor,
          foregroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius ?? 12))),
    );
  }
}

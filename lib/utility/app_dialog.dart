import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iceproj/widgets/widget_text_button.dart';

class AppDialog {
  void normalDialog({
    Widget? iconWidget,
    required String title,
    Widget? contentWidget,
    Widget? actionWidget,
    Widget? action2Widget,
  }) {
    Get.dialog(
      AlertDialog(
        icon: iconWidget,
        title: Text(title),
        content: contentWidget,
        actions: [
          actionWidget ?? const SizedBox(),
          action2Widget ?? const SizedBox(),
          WidgetTextButton(
            data: actionWidget == null ? 'OK' : 'Cancel',
            pressFunc: () => Get.back(),
          )
        ],
      ),
      barrierDismissible: false,
    );
  }
}

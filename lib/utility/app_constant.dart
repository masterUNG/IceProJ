import 'package:flutter/material.dart';

class AppContant {
  static String urlLogo =
      'https://firebasestorage.googleapis.com/v0/b/iceproj.appspot.com/o/avatar%2F708774_cartoon_cone_cream_emoji_ice_icon.png?alt=media&token=adf060c5-4373-4023-b8a5-cc2ab304eda0';

  BoxDecoration bgBox() => const BoxDecoration(
      gradient: RadialGradient(colors: <Color>[Colors.white, Colors.purple], radius: 1.2));
}

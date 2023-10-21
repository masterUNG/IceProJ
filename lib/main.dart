// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:iceproj/states/authen.dart';
import 'package:iceproj/states/chat.dart';
import 'package:iceproj/utility/app_controller.dart';
import 'package:iceproj/utility/app_service.dart';

var getPages = <GetPage<dynamic>>[
  GetPage(
    name: '/authen',
    page: () => const Authen(),
  ),
  GetPage(
    name: '/chat',
    page: () => const Chat(),
  ),
];

String? firstPage;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp().then((value) {
    FirebaseAuth.instance.authStateChanges().listen((event) async {
      print('event ---> $event');

      if (event == null) {
        //LogOut
        firstPage = '/authen';
        runApp(const MyApp());
      } else {
        
        String uidLogin = event.uid;
        await AppService().findUserModelFromUid(uid: uidLogin).then((value) {
          AppController appController = Get.put(AppController());
          if (value != null) {
            appController.userModles.add(value);
            firstPage = '/chat';
            runApp(const MyApp());
          }
        });
      }
    });
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // home: const Authen(),
      getPages: getPages,
      initialRoute: firstPage,
      theme: ThemeData(useMaterial3: true),
    );
  }
}

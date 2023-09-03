// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:iceproj/model/chat_model.dart';
import 'package:iceproj/model/user_model.dart';
import 'package:iceproj/states/chat.dart';
import 'package:iceproj/utility/app_constant.dart';
import 'package:iceproj/utility/app_controller.dart';

class AppService {
  AppController appController = Get.put(AppController());

  Future<void> processSignInWithCredential() async {
    GoogleSignInAccount? googleSignInAccount = await GoogleSignIn().signIn();
    GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount!.authentication;
    OAuthCredential oAuthCredential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);

    await FirebaseAuth.instance
        .signInWithCredential(oAuthCredential)
        .then((value) async {
      String uid = value.user!.uid;

      print('Sign Success uid ----> $uid');

      UserModel? userModel = await findUserModelFromUid(uid: uid);

      if (userModel == null) {
        //Insert New User
        UserModel userModel = UserModel(
            name: value.user!.displayName ?? '',
            avatar: value.user!.photoURL ?? AppContant.urlLogo,
            uid: uid);

        await insertNewUser(userModel: userModel).then((value) {
          appController.userModles.add(userModel);
        });

        print('userMOdel ---> ${userModel.toMap()}');
      } else {
        //Read Current User
        print('Read Current User');
        appController.userModles.add(userModel);
      }

      Get.snackbar('Sign In Success', 'Welcome to My App');
      Get.offAll(const Chat());
    }).catchError((onError) {
      Get.snackbar(onError.code, onError.message);
    });
  }

  Future<void> insertNewUser({required UserModel userModel}) async {
    await FirebaseFirestore.instance
        .collection('user')
        .doc(userModel.uid)
        .set(userModel.toMap());
  }

  Future<UserModel?> findUserModelFromUid({required String uid}) async {
    UserModel? userModel;

    var result =
        await FirebaseFirestore.instance.collection('user').doc(uid).get();

    print('result ===> ${result.data()}');

    if (result.data() != null) {
      userModel = UserModel.fromMap(result.data()!);
    }

    return userModel;
  }

  Future<void> processSignInWithGmail() async {
    GoogleSignIn googleSignIn = GoogleSignIn(
      scopes: [
        'email',
        'https://www.googleapis.com/auth/contacts.readonly',
      ],
    );

    await googleSignIn.signIn().then((value) {
      Get.snackbar('Sign In Success', 'Welcome to My App');
      Get.offAll(const Chat());
    }).catchError((onError) {
      Get.snackbar(onError.code, onError.message);
    });
  }

  Future<void> readChat() async {
    FirebaseFirestore.instance.collection('chat').orderBy('timestamp', descending: false)
    .snapshots()
    .listen((event) {
      if (appController.chatModels.isNotEmpty) {
        appController.chatModels.clear();
      }

      if (event.docs.isNotEmpty) {
        for (var element in event.docs) {
          ChatModel chatModel = ChatModel.fromMap(element.data());
          appController.chatModels.add(chatModel);
        }
      }
    });
  }
}

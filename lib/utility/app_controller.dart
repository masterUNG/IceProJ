import 'dart:io';

import 'package:get/get.dart';
import 'package:iceproj/model/chat_model.dart';
import 'package:iceproj/model/user_model.dart';

class AppController extends GetxController{

  RxList<UserModel> userModles = <UserModel>[].obs;
  RxList<ChatModel> chatModels = <ChatModel>[].obs;

  RxList<File> files = <File>[].obs;
  RxList<String> nameFiles = <String>[].obs;
  
}
// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iceproj/model/private_chat_model.dart';

import 'package:iceproj/model/user_model.dart';
import 'package:iceproj/utility/app_controller.dart';
import 'package:iceproj/utility/app_service.dart';
import 'package:iceproj/widgets/widget_form.dart';
import 'package:iceproj/widgets/widget_icon_button.dart';
import 'package:iceproj/widgets/widget_image_avatar.dart';

class PrivateChat extends StatefulWidget {
  const PrivateChat({
    Key? key,
    required this.frinedUserModel,
  }) : super(key: key);

  final UserModel frinedUserModel;

  @override
  State<PrivateChat> createState() => _PrivateChatState();
}

class _PrivateChatState extends State<PrivateChat> {
  AppController appController = Get.put(AppController());

  @override
  void initState() {
    super.initState();
    AppService()
        .findDocIdPrivateChat(friendUserModel: widget.frinedUserModel)
        .then((value) async {
      print(
          'ขนาดของ docIdPrivateChat ----> ${appController.docIdPrivteChats.length}');

      if (appController.docIdPrivteChats.isEmpty) {
        // First Call

        var friendKeys = <String>[];
        friendKeys.add(appController.userModles.last.uid);
        friendKeys.add(widget.frinedUserModel.uid);

        PrivateChatModel privateChatModel =
            PrivateChatModel(friendKeys: friendKeys);

        DocumentReference documentReference =
            FirebaseFirestore.instance.collection('privateChat').doc();

        await documentReference.set(privateChatModel.toMap()).then((value) {
          appController.docIdPrivteChats.add(documentReference.id);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            WidgetImageAvatar(urlImage: widget.frinedUserModel.avatar),
            Text(widget.frinedUserModel.name),
          ],
        ),
      ),
      body: Obx(
       () {
          return appController.docIdPrivteChats.isEmpty ?  const SizedBox() : Text(appController.docIdPrivteChats.last);
        }
      ),
      bottomSheet: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(
            width: 250,
            child: WidgetForm(
              hint: 'Message',
            ),
          ),
          WidgetIconButton(
            iconData: Icons.send,
            pressFunc: () {},
          )
        ],
      ),
    );
  }
}

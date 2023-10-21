// ignore_for_file: avoid_print

import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iceproj/model/chat_model.dart';
import 'package:iceproj/model/user_model.dart';
import 'package:iceproj/states/edit_profile.dart';
import 'package:iceproj/utility/app_controller.dart';
import 'package:iceproj/utility/app_dialog.dart';
import 'package:iceproj/utility/app_service.dart';
import 'package:iceproj/widgets/widget_form.dart';
import 'package:iceproj/widgets/widget_icon_button.dart';
import 'package:iceproj/widgets/widget_image_avatar.dart';
import 'package:iceproj/widgets/widget_image_network.dart';
import 'package:iceproj/widgets/widget_menu.dart';
import 'package:iceproj/widgets/widget_text_button.dart';

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  AppController appController = Get.put(AppController());
  TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();

    AppService().readChat();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, BoxConstraints boxConstraints) {
      return Obx(() {
        print('##21oct userModels ---> ${appController.userModles.length}');
        return Scaffold(
          appBar: mainAppBar(),
          endDrawer: Drawer(
            child: Column(
              children: [
                appController.userModles.isEmpty
                    ? const SizedBox()
                    : UserAccountsDrawerHeader(
                        accountName: Text(appController.userModles.last.name),
                        accountEmail: null,
                        currentAccountPicture: WidgetImageNetwork(
                          urlImage: appController.userModles.last.avatar,
                        ),
                      ),
                WidgetMenu(
                  titleWidget: const Text('Edit Profilt'),
                  tapFunc: () {
                    Get.back();
                    Get.to(const EditProfile())?.then((value) async {
                      UserModel? userModel = await AppService()
                          .findUserModelFromUid(
                              uid: appController.userModles.last.uid);
                      appController.userModles.add(userModel!);
                      print(
                          '##21oct ขนาดของ userMOdels ---> ${appController.userModles.length}');
                    });
                  },
                ),
                const Spacer(),
                WidgetMenu(
                  titleWidget: const Text('Sign Out'),
                  tapFunc: () {
                    Get.back();
                    AppDialog().normalDialog(
                        title: 'Sign Out ?',
                        iconWidget: const SizedBox(
                          width: 120,
                          height: 120,
                          child: WidgetImageNetwork(),
                        ),
                        contentWidget: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Please Confirm SignOut'),
                          ],
                        ),
                        actionWidget: WidgetTextButton(
                          data: 'Confirm',
                          pressFunc: () {
                            Get.back();
                            AppService().processSignOut();
                          },
                        ));
                  },
                ),
              ],
            ),
          ),
          body: SafeArea(
            child: GestureDetector(
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              child: SizedBox(
                width: boxConstraints.maxWidth,
                height: boxConstraints.maxHeight - 150,
                // color: Colors.grey,
                child: appController.chatModels.isEmpty
                    ? const SizedBox()
                    : ListView.builder(
                        itemCount: appController.chatModels.length,
                        itemBuilder: (context, index) => Row(
                          mainAxisAlignment: appController
                                      .chatModels[index].mapSender['uid'] ==
                                  appController.userModles.last.uid
                              ? MainAxisAlignment.end
                              : MainAxisAlignment.start,
                          children: [
                            appController.chatModels[index].mapSender['uid'] ==
                                    appController.userModles.last.uid
                                ? const SizedBox()
                                : WidgetImageAvatar(
                                    urlImage: appController
                                        .chatModels[index].mapSender['avatar']),
                            BubbleSpecialThree(
                              text: appController.chatModels[index].message,
                              color: Colors.purple,
                              textStyle: const TextStyle(color: Colors.white),
                              isSender: appController
                                      .chatModels[index].mapSender['uid'] ==
                                  appController.userModles.last.uid,
                            ),
                          ],
                        ),
                      ),
              ),
            ),
          ),
          bottomSheet: Container(
            color: Colors.white,
            child: Row(
              children: [
                SizedBox(
                  width: boxConstraints.maxWidth - 50,
                  child: WidgetForm(
                    textEditingController: textEditingController,
                    hint: 'Message',
                  ),
                ),
                WidgetIconButton(
                  iconData: Icons.send,
                  pressFunc: () async {
                    if (textEditingController.text.isEmpty) {
                      Get.snackbar('Message ?', 'Please Fill Message',
                          backgroundColor: Colors.red.shade700,
                          colorText: Colors.white);
                    } else {
                      ChatModel chatModel = ChatModel(
                          message: textEditingController.text,
                          timestamp: Timestamp.fromDate(DateTime.now()),
                          mapSender: appController.userModles.last.toMap());

                      print('##2sep chatModel ----> ${chatModel.toMap()}');

                      FirebaseFirestore.instance
                          .collection('chat')
                          .doc()
                          .set(chatModel.toMap())
                          .then((value) {
                        textEditingController.text = '';
                      });
                    }
                  },
                )
              ],
            ),
          ),
        );
      });
    });
  }

  AppBar mainAppBar() {
    return AppBar(
      leading: Obx(() {
        return appController.userModles.isEmpty
            ? const SizedBox()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  WidgetImageAvatar(
                    urlImage: appController.userModles.last.avatar,
                    radius: 20,
                  ),
                ],
              );
      }),
      title: appController.userModles.isEmpty
          ? const SizedBox()
          : Text(appController.userModles.last.name),
    );
  }
}

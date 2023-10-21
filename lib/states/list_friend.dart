import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iceproj/states/private_chat.dart';
import 'package:iceproj/utility/app_controller.dart';
import 'package:iceproj/utility/app_service.dart';
import 'package:iceproj/widgets/widget_image_avatar.dart';

class ListFriend extends StatefulWidget {
  const ListFriend({super.key});

  @override
  State<ListFriend> createState() => _ListFriendState();
}

class _ListFriendState extends State<ListFriend> {
  AppController appController = Get.put(AppController());

  @override
  void initState() {
    super.initState();
    AppService().readAllFriend();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Friend'),
      ),
      body: Obx(() {
        return appController.friendUserModles.isEmpty
            ? const SizedBox()
            : ListView.builder(
                itemCount: appController.friendUserModles.length,
                itemBuilder: (context, index) => InkWell(
                  onTap: () {
                    Get.to(PrivateChat(
                        frinedUserModel:
                            appController.friendUserModles[index]));
                  },
                  child: Row(
                    children: [
                      WidgetImageAvatar(
                          urlImage:
                              appController.friendUserModles[index].avatar),
                      Text(appController.friendUserModles[index].name),
                    ],
                  ),
                ),
              );
      }),
    );
  }
}

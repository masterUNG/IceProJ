import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iceproj/utility/app_constant.dart';
import 'package:iceproj/utility/app_controller.dart';
import 'package:iceproj/utility/app_dialog.dart';
import 'package:iceproj/utility/app_service.dart';
import 'package:iceproj/widgets/widget_button.dart';
import 'package:iceproj/widgets/widget_form.dart';
import 'package:iceproj/widgets/widget_icon_button.dart';
import 'package:iceproj/widgets/widget_image_network.dart';
import 'package:iceproj/widgets/widget_text_button.dart';
import 'package:image_picker/image_picker.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  AppController appController = Get.put(AppController());

  TextEditingController textEditingController = TextEditingController();

  bool changeDisplayName = false;

  @override
  void initState() {
    super.initState();
    textEditingController.text = appController.userModles.last.name;

    if (appController.files.isNotEmpty) {
      appController.files.clear();
      appController.nameFiles.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: LayoutBuilder(builder: (context, BoxConstraints boxConstraints) {
        return GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: ListView(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Obx(() {
                    return Stack(
                      children: [
                        appController.files.isEmpty
                            ? WidgetImageNetwork(
                                urlImage: appController.userModles.last.avatar,
                                size: boxConstraints.maxWidth * 0.75,
                              )
                            : Image.file(
                                appController.files.last,
                                fit: BoxFit.cover,
                                width: boxConstraints.maxWidth * 0.75,
                                height: boxConstraints.maxWidth * 0.75,
                              ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: WidgetIconButton(
                            iconData: Icons.add_a_photo,
                            size: 36,
                            color: AppContant.mainColor,
                            pressFunc: () {
                              AppDialog().normalDialog(
                                title: 'Change Image ?',
                                iconWidget: appController.files.isEmpty
                                    ? WidgetImageNetwork(
                                        urlImage: appController
                                            .userModles.last.avatar,
                                      )
                                    : Image.file(
                                        appController.files.last,
                                        fit: BoxFit.cover,
                                      ),
                                contentWidget:
                                    const Text('Please tap Camera or Gallery'),
                                actionWidget: WidgetTextButton(
                                  data: 'Camera',
                                  pressFunc: () {
                                    Get.back();
                                    AppService().processTakePhoto(
                                        imageSource: ImageSource.camera);
                                  },
                                ),
                                action2Widget: WidgetTextButton(
                                  data: 'Gallery',
                                  pressFunc: () {
                                    Get.back();
                                    AppService().processTakePhoto(
                                        imageSource: ImageSource.gallery);
                                  },
                                ),
                              );
                            },
                          ),
                        )
                      ],
                    );
                  }),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 16),
                    width: boxConstraints.maxWidth * 0.75,
                    child: WidgetForm(
                      changeFunc: (p0) {
                        changeDisplayName = true;
                      },
                      labelWidget: const Text('Display Name :'),
                      textEditingController: textEditingController,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 64,
              ),
            ],
          ),
        );
      }),
      bottomSheet: SizedBox(
        width: double.infinity,
        child: WidgetButton(
          data: 'Edit Profile',
          pressFunc: () async {
            if ((changeDisplayName) || appController.files.isNotEmpty) {
              //Have Cange

              if (appController.files.isNotEmpty) {
                //Have Image
                String? avatar = await AppService().processUploadImage();

                print('new avatar ---> $avatar');

                Map<String, dynamic> map =
                    appController.userModles.last.toMap();

                map['avatar'] = avatar;
                map['name'] = textEditingController.text;

                AppService()
                    .procesEditProfile(
                  map: map,
                  docIdUser: appController.userModles.last.uid,
                )
                    .then((value) {
                  Get.back();
                });
              } else {
                //Change Only DisplayName
                Map<String, dynamic> map =
                    appController.userModles.last.toMap();
                map['name'] = textEditingController.text;
                AppService()
                    .procesEditProfile(map: map, docIdUser: map['uid'])
                    .then((value) => Get.back());
              }
            } else {
              AppDialog().normalDialog(title: 'ยังไม่มีการเปลี่ยนแปลง');
            }
          },
          radius: 0,
        ),
      ),
    );
  }
}

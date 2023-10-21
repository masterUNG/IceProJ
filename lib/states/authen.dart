import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:iceproj/utility/app_constant.dart';
import 'package:iceproj/utility/app_service.dart';
import 'package:iceproj/widgets/widget_image_network.dart';

class Authen extends StatelessWidget {
  const Authen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(decoration: AppContant().bgBox(),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const WidgetImageNetwork(size: 250,),
                SizedBox(
                  height: 50,
                  child: SignInButton(
                    Buttons.GoogleDark,
                    onPressed: () {
                      AppService().processSignInWithCredential();
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                        padding: EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

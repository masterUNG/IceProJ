// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class WidgetMenu extends StatelessWidget {
  const WidgetMenu({
    Key? key,
    this.leadWidget,
    required this.titleWidget,
    this.subTitleWidget,
  }) : super(key: key);

  final Widget? leadWidget;
  final Widget titleWidget;
  final Widget? subTitleWidget;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: titleWidget,
      leading: leadWidget,
      subtitle: subTitleWidget,
    );
  }
}

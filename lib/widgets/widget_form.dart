// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class WidgetForm extends StatelessWidget {
  const WidgetForm({
    Key? key,
    this.hint,
    this.textEditingController,
  }) : super(key: key);

  final String? hint;
  final TextEditingController? textEditingController;

  @override
  Widget build(BuildContext context) {
    return TextFormField(controller: textEditingController,
      decoration: InputDecoration(
        filled: true,
        border: InputBorder.none,
        hintText: hint,
      ),
    );
  }
}

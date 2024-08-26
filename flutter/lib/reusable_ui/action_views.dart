import 'package:done_today/reusable_ui/new_post_bottom_sheet.dart';
import 'package:done_today/reusable_ui/segmented_controller.dart';
import 'package:flutter/material.dart';

class ActionViews {
  static final ActionViews _instance = ActionViews._internal();

  factory ActionViews() {
    return _instance;
  }

  ActionViews._internal();

  void showPopupDrawer(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      constraints: BoxConstraints(
        minWidth: MediaQuery.of(context).size.width,
        maxWidth: MediaQuery.of(context).size.width,
        minHeight: MediaQuery.of(context).size.height * 0.5,
      ),
      builder: (BuildContext context) {
        return NewPostBottomSheet();
      },
    );
  }
}

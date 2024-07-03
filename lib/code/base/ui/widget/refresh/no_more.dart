import 'package:flutter/material.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/styles.dart';

class NoMoreWidget extends StatelessWidget {
  const NoMoreWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Padding(
            padding: EdgeInsets.all(8),
            child: Text("--我是有底线的--",
                style: SlcStyles.getTextColorHintStyleByTheme(
                    Theme.of(context)))));
  }
}

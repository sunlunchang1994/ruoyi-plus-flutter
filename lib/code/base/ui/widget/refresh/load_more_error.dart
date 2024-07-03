import 'package:flutter/material.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/styles.dart';

class LoadMoreErrorWidget extends StatelessWidget {
  const LoadMoreErrorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Padding(
            padding: EdgeInsets.all(8),
            child: Text("加载失败",
                style: SlcStyles.getTextColorSecondaryStyleByTheme(
                    Theme.of(context)))));
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/styles.dart';

import '../../../../../generated/l10n.dart';

class LoadMoreErrorWidget extends StatelessWidget {
  const LoadMoreErrorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Padding(
            padding: EdgeInsets.all(8),
            child: Text(S.current.label_refresh_load_failed,
                style: SlcStyles.getTextColorSecondaryStyleByTheme(
                    Theme.of(context)))));
  }
}

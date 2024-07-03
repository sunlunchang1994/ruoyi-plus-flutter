import 'package:flutter/material.dart';

import '../../../../generated/l10n.dart';

///快速dialog工具
class FastDialogUtils {
  ///获取常用的action
  static List<Widget> getCommonlyAction(BuildContext context,
      {String? negativeText,
      String? positiveText,
      VoidCallback? negativeLister,
      VoidCallback? positiveLister}) {
    return [
      TextButton(
        onPressed: negativeLister ??
            () {
              Navigator.pop(context);
            },
        child: Text(negativeText ?? S.current.action_cancel),
      ),
      TextButton(
          onPressed: positiveLister ??
              () {
                Navigator.pop(context);
              },
          child: Text(positiveText ?? S.current.action_ok))
    ];
  }
}

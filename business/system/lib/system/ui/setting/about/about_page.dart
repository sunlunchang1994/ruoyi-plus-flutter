import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:boxes_flutter/flutter/slc/res/dimens.dart';
import 'package:boxes_flutter/flutter/slc/res/theme_extension.dart';
import 'package:boxes_flutter/flutter/slc/res/theme_util.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:base/base/ui/app_mvvm.dart';

import '../../../../../../gen/assets.gen.dart';
import '../../../../../../gen/app_l10n.dart';

class AboutPage extends AppBaseStatelessWidget<_AboutVm> {
  static const String routeName = '/setting/about';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => _AboutVm(),
        builder: (context, child) {
          registerEvent(context);
          ThemeData themeData = Theme.of(context);
          return Scaffold(
            appBar: AppBar(title: Text(S.current.sys_label_setting_item_about)),
            body: FutureBuilder(
                future: PackageInfo.fromPlatform(),
                builder: (BuildContext context, AsyncSnapshot<PackageInfo> snapshot) {
                  return Column(
                    children: [
                      const Spacer(flex: 1),
                      Expanded(
                          flex: 3,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(child: Assets.images.icLauncher.image(width: 56, height: 56)),
                              ThemeUtil.getSizedBox(height: SlcDimens.appDimens12),
                              Text(snapshot.data?.appName ?? "",
                                  style: themeData.textTheme.titleMedium),
                              Text(snapshot.data?.version ?? "",
                                  style: themeData.slcTidyUpStyle
                                      .getTextColorSecondaryStyleByTheme(themeData))
                            ],
                          )),
                      Expanded(flex: 3, child: Center()),
                      const Spacer(flex: 1),
                    ],
                  );
                }),
          );
        });
  }
}

class _AboutVm extends AppBaseVm {}

import 'dart:ui';

import 'package:fast/gen/fast_l10n.dart';
import 'package:flutter/material.dart';
import 'package:boxes_flutter/flutter/slc/res/dimens.dart';
import 'package:boxes_flutter/flutter/slc/res/theme_util.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:base/base/ui/app_mvvm.dart';
import 'package:base/base/ui/utils/fast_dialog_utils.dart';
import 'package:base/base/vm/global_vm.dart';
import 'package:fast/fast/utils/app_toast.dart';
import 'package:fast/fast/utils/widget_utils.dart';
import 'package:system/gen/sys_l10n.dart';
import 'package:system/system/ui/setting/about/about_page.dart';

import 'package:base/base/repository/local/app_config.dart';
import 'package:bizapi/user/vm/user_share_vm.dart';

class SettingPage extends AppBaseStatelessWidget<SettingVm> {

  @override
  build(context) {
    return ChangeNotifierProvider(
        create: (context) => SettingVm(),
        builder: (context, child) {
          ThemeData themeData = Theme.of(context);
          registerEvent(context);
          getVm().initVm();
          return Scaffold(
              appBar: AppBar(title: Text(S.current.sys_label_setting)),
              body: Column(
                children: [
                  Expanded(
                      child: SingleChildScrollView(
                          child: ListBody(
                    children: [
                      ListTile(
                          title: Text(S.current.sys_label_setting_item_theme_mode),
                          onTap: () {
                            _showSwitchThemeModeDialog(context);
                          }),
                      ListTile(
                          title: Text(S.current.sys_label_setting_item_check_updates),
                          onTap: () {
                            AppToastUtil.showToast(msg: FastS.current.title_already_the_latest_version);
                          }),
                      ListTile(
                          title: Text(S.current.sys_label_setting_item_about),
                          onTap: () async {
                            getVm().pushNamed(AboutPage.routeName);
                          })
                    ],
                  ))),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: SlcDimens.appDimens16, vertical: SlcDimens.appDimens12),
                    child: SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                            onPressed: () {
                              UserShareVm().logOut(context);
                            },
                            child: Text(S.current.sys_label_sign_out))),
                  )
                ],
              ));
        });
  }

  void _showSwitchThemeModeDialog(BuildContext context) {
    ThemeMode groupThemeMode = GlobalVm().currentTheme;
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text(S.current.sys_label_setting_item_theme_mode),
            children: [
              SimpleDialogOption(
                  child: Row(
                    children: [
                      Radio(
                          visualDensity: ThemeUtil.minimumDensity,
                          value: ThemeMode.system,
                          groupValue: groupThemeMode,
                          onChanged: (_) {}),
                      Text(S.current.sys_label_setting_follow_system)
                    ],
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    globalVm.switchThemeMode(ThemeMode.system);
                  }),
              SimpleDialogOption(
                  child: Row(
                    children: [
                      Radio(
                          visualDensity: ThemeUtil.minimumDensity,
                          value: ThemeMode.light,
                          groupValue: groupThemeMode,
                          onChanged: (_) {}),
                      Text(S.current.sys_label_setting_light_mode)
                    ],
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    globalVm.switchThemeMode(ThemeMode.light);
                  }),
              SimpleDialogOption(
                  child: Row(
                    children: [
                      Radio(
                          visualDensity: ThemeUtil.minimumDensity,
                          value: ThemeMode.dark,
                          groupValue: groupThemeMode,
                          onChanged: (_) {}),
                      Text(S.current.sys_label_setting_dark_mode)
                    ],
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    globalVm.switchThemeMode(ThemeMode.dark);
                  })
            ],
          );
        });
  }
}

class SettingVm extends AppBaseVm {
  void initVm() {}
}

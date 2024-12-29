import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/colors.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/dimens.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/styles.dart';
import 'package:ruoyi_plus_flutter/code/base/ui/widget/fast_slc_ui_box.dart';
import 'package:ruoyi_plus_flutter/code/base/vm/global_vm.dart';
import 'package:ruoyi_plus_flutter/code/module/user/ui/profile_page.dart';
import '../../../../res/colors.dart';
import '../../../../res/dimens.dart';
import '../../../base/ui/app_mvvm.dart';
import 'package:provider/provider.dart';

import '../../../../generated/l10n.dart';
import '../../../extras/user/entity/user_info_vo.dart';

class MinePage extends StatefulWidget {
  const MinePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MineState();
  }
}

class _MineState extends AppBaseState<MinePage, _MineVm> with AutomaticKeepAliveClientMixin {
  final String title = S.current.main_label_mine;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => _MineVm(),
      builder: (context, child) {
        ThemeData themeData = Theme.of(context);
        registerEvent(context);
        final mainVm = Provider.of<_MineVm>(context, listen: false);
        mainVm.initVm();
        return Scaffold(
            appBar: AppBar(title: Text(title)),
            //图标滚动使用固定大小来解决
            body: Consumer<_MineVm>(builder: (context, value, child) {
              return Column(children: [
                Card(
                  elevation: 0,
                  margin: EdgeInsets.symmetric(horizontal: SlcDimens.appDimens16),
                  child: GestureDetector(
                      onTap: () {
                        getVm().pushNamed(ProfilePage.routeName);
                      },
                      child: Padding(
                          padding: EdgeInsets.all(SlcDimens.appDimens16),
                          child: Row(children: [
                            Expanded(
                                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text(getVm().userInfoVo?.user.deptName ?? S.current.app_label_not_completed,
                                  style: SlcStyles.getTextColorSecondaryStyleByTheme(themeData)),
                              Text(
                                  getVm().userInfoVo?.user.getRoleName() ??
                                      S.current.app_label_not_completed,
                                  style: SlcStyles.getTextColorSecondaryStyleByTheme(themeData)),
                              Padding(
                                  padding: EdgeInsets.only(top: SlcDimens.appDimens8),
                                  child: Text(
                                      getVm().userInfoVo?.user.nickName ??
                                          S.current.app_label_not_completed,
                                      style: themeData.textTheme.titleLarge)),
                            ])),
                            ClipRRect(
                                borderRadius: BorderRadius.all(Radius.circular(AppDimens.appAvatarRadius)),
                                child: CachedNetworkImage(
                                    width: 80,
                                    height: 80,
                                    imageUrl: getVm().userInfoVo?.user.avatar ?? "",
                                    placeholder: (context, url) {
                                      return Image.asset("assets/images/slc/app_ic_def_user_head.png",
                                          width: 80, height: 80);
                                    },
                                    errorWidget: (
                                      context,
                                      error,
                                      stackTrace,
                                    ) {
                                      return Image.asset("assets/images/slc/app_ic_def_user_head.png",
                                          width: 80, height: 80);
                                    }))
                          ]))),
                ),
                Expanded(
                    child: Padding(
                        padding: EdgeInsets.only(top: SlcDimens.appDimens16),
                        child: ListView(children: [
                          ListTile(
                              leading: const Icon(Icons.settings),
                              title: Text(S.current.user_label_setting),
                              visualDensity: VisualDensity.compact,
                              tileColor: SlcColors.getCardColorByTheme(themeData),
                              //根据card规则实现
                              onTap: () {}),
                          SlcUiBoxStyleUtils.getDividerByBg(),
                        ])))
              ]);
            }));
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class _MineVm extends AppBaseVm {
  UserInfoVo? userInfoVo;

  void initVm() {
    _onUserInfoVoChange(notify: false);
    GlobalVm().userVmBox.userInfoOf.addListener(_onUserInfoVoChange);
  }

  void _onUserInfoVoChange({bool notify = true}) {
    userInfoVo = GlobalVm().userVmBox.userInfoOf.value;
    if (notify) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    GlobalVm().userVmBox.userInfoOf.removeListener(_onUserInfoVoChange);
    super.dispose();
  }
}

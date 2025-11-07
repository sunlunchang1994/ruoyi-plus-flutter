import 'package:bizapi/package_bizapi_info.dart';
import 'package:bizapi/system/config/constant_sys_api.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fast/gen/fast_l10n.dart' as fast_l10n;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:boxes_flutter/flutter/slc/res/colors.dart';
import 'package:boxes_flutter/flutter/slc/res/dimens.dart';
import 'package:boxes_flutter/flutter/slc/res/theme_extension.dart';
import 'package:base/base/ui/widget/fast_slc_ui_box.dart';
import 'package:base/base/vm/global_vm.dart';
import 'package:base/gen/base_l10n.dart' as base_l10n;
import 'package:user/gen/user_l10n.dart';
import 'package:user/res/dimens.dart';
import 'profile_page.dart';
import 'package:base/base/ui/app_mvvm.dart';
import 'package:provider/provider.dart';

import 'package:bizapi/user/entity/my_user_info_vo.dart';
import 'package:bizapi/user/vm/user_share_vm.dart';
import 'package:bizapi/gen/assets.gen.dart' as BizApi;

class MinePage extends StatefulWidget {
  const MinePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MineState();
  }
}

class _MineState extends AppBaseState<MinePage, _MineVm> with AutomaticKeepAliveClientMixin {
  final String title = S.current.user_label_mine;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => _MineVm(),
      builder: (context, child) {
        ThemeData themeData = Theme.of(context);
        registerEvent(context);
        getVm().initVm();
        return Scaffold(
            appBar: AppBar(
                title: Text(title),
                automaticallyImplyLeading: false,
                titleSpacing: NavigationToolbar.kMiddleSpacing),
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
                      behavior: HitTestBehavior.opaque,
                      child: Padding(
                          padding: EdgeInsets.all(SlcDimens.appDimens16),
                          child: Row(children: [
                            Expanded(
                                child:
                                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text(
                                  getVm().userInfoVo?.user.deptName ??
                                      base_l10n.BaseS.current.ab_label_not_completed,
                                  style: themeData.slcTidyUpStyle
                                      .getTextColorSecondaryStyleByTheme(themeData)),
                              Text(
                                  getVm().userInfoVo?.user.getRoleName() ??
                                      base_l10n.BaseS.current.ab_label_not_completed,
                                  style: themeData.slcTidyUpStyle
                                      .getTextColorSecondaryStyleByTheme(themeData)),
                              Padding(
                                  padding: EdgeInsets.only(top: SlcDimens.appDimens8),
                                  child: Text(
                                      getVm().userInfoVo?.user.nickName ??
                                          base_l10n.BaseS.current.ab_label_not_completed,
                                      style: themeData.textTheme.titleLarge)),
                            ])),
                            ClipRRect(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(UserDimens.userMineAvatarRadius)),
                                child: CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    width: UserDimens.userMineAvatarSize,
                                    height: UserDimens.userMineAvatarSize,
                                    imageUrl: getVm().userInfoVo?.user.avatar ?? "",
                                    placeholder: (context, url) {
                                      return Image.asset(
                                          BizApi.Assets.images.user.icDefUserHead.path,
                                          package: BizApiPkgInfo.packageName,
                                          width: UserDimens.userMineAvatarSize,
                                          height: UserDimens.userMineAvatarSize);
                                    },
                                    errorWidget: (
                                      context,
                                      url,
                                      error,
                                    ) {
                                      return Image.asset(
                                          BizApi.Assets.images.user.icDefUserHead.path,
                                          package: BizApiPkgInfo.packageName,
                                          width: UserDimens.userMineAvatarSize,
                                          height: UserDimens.userMineAvatarSize);
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
                              tileColor: themeData.slcTidyUpColor.getCardColorByTheme(themeData),
                              //根据card规则实现
                              onTap: () {
                                getVm().pushNamed(ConstantSysApi.ROUTER_SETTING);
                              }),
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
  MyUserInfoVo? userInfoVo;

  void initVm() {
    _onUserInfoVoChange(notify: false);
    UserShareVm().userInfoOf.addListener(_onUserInfoVoChange);
  }

  void _onUserInfoVoChange({bool notify = true}) {
    userInfoVo = UserShareVm().userInfoOf.value;
    if (notify) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    UserShareVm().userInfoOf.removeListener(_onUserInfoVoChange);
    super.dispose();
  }
}

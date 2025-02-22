import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_slc_boxes/flutter/slc/common/screen_util.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/dimens.dart';
import 'package:provider/provider.dart';
import 'package:ruoyi_plus_flutter/code/base/ui/app_mvvm.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/vd/page_data_vd.dart';
import 'package:ruoyi_plus_flutter/code/module/user/ui/role/role_list_page_vd.dart';

import '../../../../../generated/l10n.dart';
import '../../../../lib/fast/utils/widget_utils.dart';

///
/// @author slc
/// 角色单选
///
class RoleListSingleSelectPage extends AppBaseStatelessWidget<_RoleListSingleSelectVm> {
  static const String routeName = '/system/role/single';
  final String title;

  RoleListSingleSelectPage(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => _RoleListSingleSelectVm(),
        builder: (context, child) {
          ThemeData themeData = Theme.of(context);
          registerEvent(context);
          getVm().initVm();
          return Scaffold(
              appBar: AppBar(title: Text(title), actions: [
                IconButton(
                    onPressed: () {
                      WidgetUtils.autoHandlerSearchDrawer(context);
                    },
                    icon: Icon(Icons.search))
              ]),
              endDrawer: RoleListPageVd.getSearchEndDrawer<_RoleListSingleSelectVm>(
                  context, themeData, getVm().listVmSub),
              body: PageDataVd(getVm().listVmSub, getVm(), refreshOnStart: true,
                  child: Consumer<_RoleListSingleSelectVm>(builder: (context, vm, child) {
                return RoleListPageVd.getUserListWidget(themeData, getVm().listVmSub);
              })));
        });
  }
}

///
/// @author slc
/// 角色单选控件
///
class RoleListSingleSelectDialog extends AppBaseStatelessWidget<_RoleListSingleSelectVm> {
  RoleListSingleSelectDialog({super.key});

  static Widget getRoleListSingleSelectDialog({String? title}) {
    return ChangeNotifierProvider(
        create: (context) => _RoleListSingleSelectVm(),
        builder: (context, child) {
          return AlertDialog(
            title: Text(title ?? S.current.user_label_role_name_select),
            titlePadding: EdgeInsets.all(SlcDimens.appDimens16),
            content: RoleListSingleSelectDialog(),
            contentPadding: EdgeInsets.zero,
            insetPadding: EdgeInsets.zero,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    registerEvent(context);
    getVm().initVm();
    return SizedBox(
        width: ScreenUtil.getInstance().screenWidthDpr,
        child: PageDataVd(getVm().listVmSub, getVm(), refreshOnStart: true,
            child: Consumer<_RoleListSingleSelectVm>(builder: (context, vm, child) {
          return RoleListPageVd.getUserListWidget(themeData, getVm().listVmSub);
        })));
  }
}

class _RoleListSingleSelectVm extends AppBaseVm {
  late RolePageDataVmSub listVmSub;

  _RoleListSingleSelectVm() {
    listVmSub = RolePageDataVmSub();
    listVmSub.setItemClick((index, role) {
      //TODO 选择结果
    });
  }

  void initVm() {
    registerVmSub(listVmSub);
  }
}

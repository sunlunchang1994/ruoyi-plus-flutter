import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_slc_boxes/flutter/slc/common/log_util.dart';
import 'package:flutter_slc_boxes/flutter/slc/common/screen_util.dart';
import 'package:flutter_slc_boxes/flutter/slc/common/text_util.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/dimens.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/styles.dart';
import 'package:provider/provider.dart';
import 'package:ruoyi_plus_flutter/code/base/ui/app_mvvm.dart';
import 'package:ruoyi_plus_flutter/code/feature/bizapi/user/entity/dept.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/utils/widget_utils.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/vd/page_data_vd.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/widget/form/form_operate_with_provider.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/widget/form/input_decoration_utils.dart';
import 'package:ruoyi_plus_flutter/code/module/user/ui/user/user_list_page_vd.dart';

import '../../../../../generated/l10n.dart';
import '../../../../feature/bizapi/user/entity/user.dart';
import '../../../../feature/component/dict/repository/local/local_dict_lib.dart';
import '../../../../feature/component/dict/utils/dict_ui_utils.dart';
import '../../../../lib/fast/provider/fast_select.dart';
import '../../../../lib/fast/vd/refresh/content_empty.dart';
import '../../../../lib/fast/widget/form/fast_form_builder_text_field.dart';

///
/// 用户选择列表
///
class UserListSingleSelectPage
    extends AppBaseStatelessWidget<_UserListSingleSelectVm> {
  static const String routeName = '/system/user/single';

  final String title;
  final Dept? dept;

  UserListSingleSelectPage(this.title, {super.key, this.dept});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => _UserListSingleSelectVm(),
      builder: (context, child) {
        ThemeData themeData = Theme.of(context);
        registerEvent(context);
        getVm().initVm(dept);
        return Scaffold(
            appBar: AppBar(
              title: Text(title),
              actions: [
                Builder(builder: (context) {
                  return IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      WidgetUtils.autoHandlerSearchDrawer(context);
                    },
                  );
                })
              ],
            ),
            endDrawer: UserListPageVd.getSearchEndDrawer<_UserListSingleSelectVm>(
                context, themeData, getVm().listVmSub),
            body: PageDataVd(getVm().listVmSub, getVm(), refreshOnStart: true,
                child: Consumer<_UserListSingleSelectVm>(
                    builder: (context, vm, child) {
              return UserListPageVd.getUserListWidget(
                  themeData, getVm().listVmSub);
            })));
      },
    );
  }
}

class _UserListSingleSelectVm extends AppBaseVm {
  late UserPageDataVmSub listVmSub;

  _UserListSingleSelectVm() {
    listVmSub = UserPageDataVmSub();
  }

  void initVm(Dept? dept) {
    listVmSub.searchUser.deptId = dept?.deptId;
    listVmSub.searchUser.deptName = dept?.deptName;
    registerVmSub(listVmSub);
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/dimens.dart';
import 'package:provider/provider.dart';
import 'package:ruoyi_plus_flutter/code/base/ui/app_mvvm.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/utils/widget_utils.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/vd/page_data_vd.dart';
import 'package:ruoyi_plus_flutter/code/module/user/ui/role/role_list_page_vd.dart';

///
/// @author slc
/// 角色列表
class RoleListBrowserPage extends AppBaseStatelessWidget<_RoleListBrowserVm> {
  static const String routeName = '/system/role';
  final String title;

  RoleListBrowserPage(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => _RoleListBrowserVm(),
        builder: (context, child) {
          ThemeData themeData = Theme.of(context);
          registerEvent(context);
          getVm().initVm();
          return Scaffold(
              appBar: AppBar(title: Text(title), actions: [
                Builder(builder: (context) {
                  return IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      WidgetUtils.autoHandlerSearchDrawer(context);
                    },
                  );
                })
              ]),
              endDrawer: RoleListPageVd.getSearchEndDrawer<_RoleListBrowserVm>(
                  context, themeData, getVm().listVmSub),
              body: PageDataVd(getVm().listVmSub, getVm(), refreshOnStart: true,
                  child: Consumer<_RoleListBrowserVm>(builder: (context, vm, child) {
                return RoleListPageVd.getUserListWidget(themeData, getVm().listVmSub);
              })));
        });
  }
}

class _RoleListBrowserVm extends AppBaseVm {
  late RolePageDataVmSub listVmSub;

  _RoleListBrowserVm() {
    listVmSub = RolePageDataVmSub();
    listVmSub.setItemClick((index, role) {});
  }

  void initVm() {
    registerVmSub(listVmSub);
  }
}

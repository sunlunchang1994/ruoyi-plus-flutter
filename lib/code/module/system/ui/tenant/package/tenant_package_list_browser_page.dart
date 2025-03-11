import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ruoyi_plus_flutter/code/base/ui/app_mvvm.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/provider/fast_select.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/vd/page_data_vd.dart';
import 'package:ruoyi_plus_flutter/code/module/system/ui/tenant/package/tenant_package_add_edit_page.dart';

import '../../../../../lib/fast/utils/widget_utils.dart';
import 'tenant_package_list_page_vd.dart';

///
/// @author slc
/// 租户套餐列表
class TenantPackageListBrowserPage extends AppBaseStatelessWidget<_TenantPackageListBrowserVm> {
  static const String routeName = '/tenant/tenantPackage';
  final String title;

  TenantPackageListBrowserPage(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => _TenantPackageListBrowserVm(),
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
              endDrawer:
                  TenantPackageListPageWidget.getSearchEndDrawer<_TenantPackageListBrowserVm>(
                      context, themeData, getVm().listVmSub),
              floatingActionButton: FloatingActionButton(
                  child: Icon(Icons.add),
                  onPressed: () {
                    getVm().onAddItem();
                  }),
              body: PageDataVd(getVm().listVmSub, getVm(),
                  refreshOnStart: true,
                  child:
                      NqSelector<_TenantPackageListBrowserVm, int>(builder: (context, vm, child) {
                    return TenantPackageListPageWidget.getDataListWidget(
                        themeData, getVm().listVmSub);
                  }, selector: (context, vm) {
                    return vm.listVmSub.shouldSetState.version;
                  })));
        });
  }
}

class _TenantPackageListBrowserVm extends AppBaseVm {
  late TenantPackageListDataVmSub listVmSub;

  _TenantPackageListBrowserVm() {
    listVmSub = TenantPackageListDataVmSub();
    listVmSub.onSuffixClick = (itemData) {
      /*pushNamed(NoticeAddEditPage.routeName,
          arguments: {ConstantSys.KEY_SYS_NOTICE: itemData}).then((result) {
        if (result != null) {
          //更新列表
          listVmSub.sendRefreshEvent();
        }
      });*/
    };
  }

  void initVm() {
    registerVmSub(listVmSub);
  }

  ///添加租户套餐
  void onAddItem() {
    pushNamed(TenantPackageAddEditPage.routeName).then((result) {
      if (result != null) {
        //更新列表
        listVmSub.sendRefreshEvent();
      }
    });
  }
}

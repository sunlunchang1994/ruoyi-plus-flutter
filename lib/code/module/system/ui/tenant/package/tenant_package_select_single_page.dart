import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ruoyi_plus_flutter/code/base/ui/app_mvvm.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/provider/fast_select.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/vd/page_data_vd.dart';
import 'package:ruoyi_plus_flutter/code/module/system/ui/tenant/package/tenant_package_add_edit_page.dart';

import '../../../../../lib/fast/utils/widget_utils.dart';
import '../../../../../lib/fast/vd/list_data_vd.dart';
import 'tenant_package_list_page_vd.dart';

///
/// @author slc
/// 租户套餐单选列表
class TenantPackageSelectSinglePage extends AppBaseStatelessWidget<_TenantPackageSelectSingleVm> {
  static const String routeName = '/tenant/tenantPackage/selectSingle';
  final String title;

  TenantPackageSelectSinglePage(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => _TenantPackageSelectSingleVm(),
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
                  TenantPackageListPageWidget.getSearchEndDrawer<_TenantPackageSelectSingleVm>(
                      context, themeData, getVm().listVmSub.tenantPackageSearchHelper),
              body: ListDataVd(getVm().listVmSub, getVm(),
                  refreshOnStart: true,
                  child:
                      NqSelector<_TenantPackageSelectSingleVm, int>(builder: (context, vm, child) {
                    return TenantPackageListPageWidget.getDataListWidget(
                        themeData, getVm().listVmSub);
                  }, selector: (context, vm) {
                    return vm.listVmSub.shouldSetState.version;
                  })));
        });
  }
}

class _TenantPackageSelectSingleVm extends AppBaseVm {
  late TenantPackageSelectVmSub listVmSub;

  _TenantPackageSelectSingleVm() {
    listVmSub = TenantPackageSelectVmSub();
  }

  void initVm() {
    registerVmSub(listVmSub);
  }

}

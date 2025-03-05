import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:ruoyi_plus_flutter/code/base/ui/app_mvvm.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/provider/fast_select.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/vd/page_data_vd.dart';
import 'package:ruoyi_plus_flutter/code/module/system/ui/log/sys_log_page.dart';
import 'package:ruoyi_plus_flutter/code/module/system/ui/log/sys_logininfor_list_page_vd.dart';

class SysLogininforListBrowserPage extends StatefulWidget {
  final String title;

  const SysLogininforListBrowserPage(this.title, {super.key});

  @override
  State<StatefulWidget> createState() {
    return _SysLogininforListBrowserPage(title);
  }
}

///
/// @author slc
/// 登录日志列表
class _SysLogininforListBrowserPage extends AppBaseState<
    SysLogininforListBrowserPage,
    _SysLogininforListBrowserVm> with AutomaticKeepAliveClientMixin {
  final String title;

  _SysLogininforListBrowserPage(this.title);

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => _SysLogininforListBrowserVm(),
        builder: (context, child) {
          ThemeData themeData = Theme.of(context);
          registerEvent(context);
          _bindingSearchVm(context);
          getVm().initVm();
          return Scaffold(
              endDrawer: SysLogininforListPageWidget.getSearchEndDrawer(context, themeData),
              body: PageDataVd(getVm().listVmSub, getVm(),
                  refreshOnStart: true,
                  child: NqSelector<_SysLogininforListBrowserVm, int>(
                      builder: (context, vm, child) {
                    return SysLogininforListPageWidget.getDataListWidget(
                        themeData, getVm().listVmSub);
                  }, selector: (context, vm) {
                    return vm.listVmSub.shouldSetState.version;
                  })));
        });
  }

  //绑定搜索vm
  void _bindingSearchVm(BuildContext context) {
    LogLoginSearchVm searchVm = Provider.of<LogLoginSearchVm>(context);
    searchVm.onResetSearchEvent = () {
      getVm().listVmSub.currentSearch = searchVm.currentSearch;
    };
    searchVm.onSearchEvent = () {
      getVm().listVmSub.sendRefreshEvent();
    };
    getVm().listVmSub.currentSearch = searchVm.currentSearch;
  }
}

class _SysLogininforListBrowserVm extends AppBaseVm {
  late LogininforListDataVmSub listVmSub;

  _SysLogininforListBrowserVm() {
    listVmSub = LogininforListDataVmSub();
    listVmSub.onSuffixClick = (itemData) {};
  }

  void initVm() {
    registerVmSub(listVmSub);
  }
}

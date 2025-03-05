import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:ruoyi_plus_flutter/code/base/ui/app_mvvm.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/provider/fast_select.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/vd/page_data_vd.dart';
import 'package:ruoyi_plus_flutter/code/module/system/ui/log/sys_log_page.dart';

import 'sys_oper_log_list_page_vd.dart';

class SysOperLogListBrowserPage extends StatefulWidget {
  final String title;

  const SysOperLogListBrowserPage(this.title, {super.key});

  @override
  State<StatefulWidget> createState() {
    return _SysOperLogListBrowserPage(title);
  }
}

///
/// @author slc
/// 操作日志列表
class _SysOperLogListBrowserPage
    extends AppBaseState<SysOperLogListBrowserPage, _SysOperLogListBrowserVm>
    with AutomaticKeepAliveClientMixin {
  final String title;

  _SysOperLogListBrowserPage(this.title);

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => _SysOperLogListBrowserVm(),
        builder: (context, child) {
          ThemeData themeData = Theme.of(context);
          registerEvent(context);
          _bindingSearchVm(context);
          getVm().initVm();
          return Scaffold(
              body: PageDataVd(getVm().listVmSub, getVm(),
                  refreshOnStart: true,
                  child: NqSelector<_SysOperLogListBrowserVm, int>(
                      builder: (context, vm, child) {
                    return SysOperLogListPageWidget.getDataListWidget(
                        themeData, getVm().listVmSub);
                  }, selector: (context, vm) {
                    return vm.listVmSub.shouldSetState.version;
                  })));
        });
  }

  //绑定搜索vm
  void _bindingSearchVm(BuildContext context) {
    LogOperSearchVm searchVm = Provider.of<LogOperSearchVm>(context);
    searchVm.onResetSearchEvent = () {
      getVm().listVmSub.currentSearch = searchVm.currentSearch;
    };
    searchVm.onSearchEvent = () {
      getVm().listVmSub.sendRefreshEvent();
    };
    getVm().listVmSub.currentSearch = searchVm.currentSearch;
  }
}

class _SysOperLogListBrowserVm extends AppBaseVm {
  late SysOperLogListDataVmSub listVmSub;

  _SysOperLogListBrowserVm() {
    listVmSub = SysOperLogListDataVmSub();
    listVmSub.onSuffixClick = (itemData) {};
  }

  void initVm() {
    registerVmSub(listVmSub);
  }
}

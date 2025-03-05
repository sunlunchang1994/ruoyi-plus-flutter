import 'package:flutter/material.dart';
import 'package:flutter_slc_boxes/flutter/slc/common/log_util.dart';
import 'package:flutter_slc_boxes/flutter/slc/common/slc_num_util.dart';
import 'package:flutter_slc_boxes/flutter/slc/mvvm/base_mvvm.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/provider/fast_select.dart';
import 'package:ruoyi_plus_flutter/code/module/system/ui/log/sys_logininfor_list_browser_page.dart';
import 'package:ruoyi_plus_flutter/code/module/system/ui/log/sys_logininfor_list_page_vd.dart';
import 'package:ruoyi_plus_flutter/code/module/system/ui/log/sys_oper_log_list_browser_page.dart';
import 'package:ruoyi_plus_flutter/code/module/system/ui/log/sys_oper_log_list_page_vd.dart';
import '../../../../base/ui/app_mvvm.dart';
import '../../../../feature/bizapi/system/entity/router_vo.dart';
import 'package:provider/provider.dart';

import '../../../../feature/component/dict/entity/tree_dict.dart';
import '../../../../lib/fast/utils/widget_utils.dart';
import '../../../../lib/fast/widget/form/form_operate_with_provider.dart';
import '../../entity/sys_logininfor.dart';
import '../../entity/sys_oper_log.dart';

class SysLogPage extends AppBaseStatelessWidget<_LogVm> {
  static const String routeName = '/system/log';

  final RouterVo logRouterInfo;

  SysLogPage(this.logRouterInfo, {super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: _LogVm()),
          ChangeNotifierProvider.value(value: LogOperSearchVm()),
          ChangeNotifierProvider.value(value: LogLoginSearchVm())
        ],
        builder: (context, child) {
          ThemeData themeData = Theme.of(context);
          registerEvent(context);
          getVm().initVm(logRouterInfo);
          return DefaultTabController(
              length: logRouterInfo.children!.length,
              child: Scaffold(
                  appBar: AppBar(
                      title: Text(logRouterInfo.meta!.title),
                      bottom: TabBar(
                          tabs:
                              getVm().logRouterInfo.children!.map((routerItem) {
                        return Tab(text: routerItem.meta!.title);
                      }).toList()),
                      actions: [
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
                      NqSelector<_LogVm, int>(builder: (context, value, child) {
                    return value == 0
                        ? SysOperLogListPageWidget.getSearchEndDrawer(
                            context, themeData)
                        : SysLogininforListPageWidget.getSearchEndDrawer(
                            context, themeData);
                  }, selector: (context, vm) {
                    return DefaultTabController.of(context).index;
                  }),
                  body: TabBarView(
                    children: getVm().logRouterInfo.children!.map((routerItem) {
                      if (routerItem.path == "operlog") {
                        return SysOperLogListBrowserPage(
                            routerItem.meta!.title);
                      } else if (routerItem.path == "logininfor") {
                        return SysLogininforListBrowserPage(
                            routerItem.meta!.title);
                      } else {
                        return Text("暂未实现");
                      }
                    }).toList(),
                  )));
        });
  }
}

class _LogVm extends AppBaseVm {
  int currentPageIndex = 0;

  late RouterVo _logRouterInfo;

  RouterVo get logRouterInfo => _logRouterInfo;

  void initVm(RouterVo logRouterInfo) {
    this._logRouterInfo = logRouterInfo;
  }

  void updateTabIndex(int index) {
    currentPageIndex = index;
    notifyListeners();
  }
}

class LogOperSearchVm extends AbsoluteChangeNotifier {
  final FormOperateWithProvider formOperate = FormOperateWithProvider();

  SysOperLog _currentSysOperLogSearch = SysOperLog();

  SysOperLog get currentSearch => _currentSysOperLogSearch;

  void Function()? onResetSearchEvent;
  void Function()? onSearchEvent;

  LogOperSearchVm() {
    LogUtil.d("初始化");
  }

  void setSelectBusinessType(ITreeDict<dynamic>? treeDict) {
    _currentSysOperLogSearch.businessType =
        SlcNumUtil.getIntByValueStr(treeDict?.tdDictValue);
    _currentSysOperLogSearch.businessTypeName = treeDict?.tdDictLabel;
    formOperate.formBuilderState
        ?.patchField("businessType", _currentSysOperLogSearch.businessTypeName);
  }

  void setSelectStatus(ITreeDict<dynamic>? treeDict) {
    _currentSysOperLogSearch.status = treeDict?.tdDictValue;
    _currentSysOperLogSearch.statusName = treeDict?.tdDictLabel;
    formOperate.formBuilderState
        ?.patchField("statusName", _currentSysOperLogSearch.statusName);
  }

  //重置
  void onResetSearch() {
    _currentSysOperLogSearch = SysOperLog();
    formOperate.clearAll();
    notifyListeners();
    onResetSearchEvent?.call();
  }

  //搜索
  void onSearch() {
    formOperate.formBuilderState?.save();
    onSearchEvent?.call();
  }
}

class LogLoginSearchVm extends AbsoluteChangeNotifier {
  final FormOperateWithProvider formOperate = FormOperateWithProvider();

  SysLogininfor _currentSysLogininforSearch = SysLogininfor();

  SysLogininfor get currentSearch => _currentSysLogininforSearch;

  void Function()? onResetSearchEvent;
  void Function()? onSearchEvent;

  LogLoginSearchVm() {
    LogUtil.d("初始化");
  }

  void setSelectStatus(ITreeDict<dynamic>? treeDict) {
    _currentSysLogininforSearch.status = treeDict?.tdDictValue;
    _currentSysLogininforSearch.statusName = treeDict?.tdDictLabel;
    formOperate.formBuilderState
        ?.patchField("statusName", _currentSysLogininforSearch.statusName);
  }


  //重置
  void onResetSearch() {
    _currentSysLogininforSearch = SysLogininfor();
    formOperate.clearAll();
    notifyListeners();
    onResetSearchEvent?.call();
  }

  //搜索
  void onSearch() {
    formOperate.formBuilderState?.save();
    onSearchEvent?.call();
  }
}

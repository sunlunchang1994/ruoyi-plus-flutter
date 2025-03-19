import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_slc_boxes/flutter/slc/adapter/select_box.dart';
import 'package:provider/provider.dart';
import 'package:ruoyi_plus_flutter/code/base/ui/app_mvvm.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/provider/fast_select.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/vd/page_data_vd.dart';
import 'package:ruoyi_plus_flutter/code/module/system/ui/log/sys_log_page.dart';
import 'package:ruoyi_plus_flutter/code/module/system/ui/log/sys_logininfor_list_page_vd.dart';

import '../../../../../generated/l10n.dart';
import '../../../../base/api/base_dio.dart';
import '../../../../lib/fast/utils/app_toast.dart';
import '../../entity/sys_logininfor.dart';
import '../../repository/remote/sys_logininfor_api.dart';

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
class _SysLogininforListBrowserPage
    extends AppBaseState<SysLogininforListBrowserPage, _SysLogininforListBrowserVm>
    with AutomaticKeepAliveClientMixin {
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
          return PopScope(
              canPop: false,
              onPopInvokedWithResult: (canPop, result) {
            if (canPop) {
              return;
            }
            if (getVm().listVmSub.selectModelIsRun) {
              getVm().listVmSub.selectModelIsRun = false;
              return;
            }
            Navigator.pop(context);
          },
          child: Scaffold(
              endDrawer: SysLogininforListPageWidget.getSearchEndDrawer(context, themeData),
              body: PageDataVd(getVm().listVmSub, getVm(),
                  refreshOnStart: true,
                  child:
                      NqSelector<_SysLogininforListBrowserVm, int>(builder: (context, vm, child) {
                    return SysLogininforListPageWidget.getDataListWidget(
                        themeData, getVm().listVmSub, buildTrailing: (currentItem) {
                      return IconButton(
                          onPressed: () {
                            //点击更多事件
                            getVm().listVmSub.onSuffixClick?.call(currentItem);
                          },
                          icon: AnimatedRotation(
                            turns: currentItem.showDetail ? 0.25 : 0, // 0.25 表示旋转 90 度
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            child: Icon(Icons.chevron_right),
                          ));
                    });
                  }, selector: (context, vm) {
                    return vm.listVmSub.shouldSetState.version;
                  }))));
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
    listVmSub.onSuffixClick = (itemData) {
      listVmSub.onHandlerShowDetails(itemData);
    };
  }

  void initVm() {
    registerVmSub(listVmSub);
  }

  //删除事件
  void onDelete({Future<bool?> Function(List<String>)? confirmHandler, List<int>? idList}) {
    if (idList == null) {
      List<SysLogininfor> selectList = SelectUtils.getSelect(listVmSub.dataList) ?? [];
      if (selectList.isEmpty) {
        AppToastUtil.showToast(msg: S.current.sys_label_log_del_select_empty);
        return;
      }
      List<String> nameList = selectList.map<String>((item) => item.infoId!.toString()).toList();
      List<int> idList = selectList.map<int>((item) => item.infoId!).toList();
      confirmHandler?.call(nameList).then((value) {
        if (value == true) {
          onDelete(idList: idList);
        }
      });
      return;
    }
    //删除
    showLoading(text: S.current.label_delete_ing);
    SysLogininforRepository.delete(listVmSub.defCancelToken, ids: idList).then((value) {
      dismissLoading();
      AppToastUtil.showToast(msg: S.current.label_delete_success);
      listVmSub.sendRefreshEvent();
    }, onError: (e) {
      dismissLoading();
      BaseDio.handlerErr(e);
      AppToastUtil.showToast(msg: S.current.label_delete_failed);
    });
  }
}

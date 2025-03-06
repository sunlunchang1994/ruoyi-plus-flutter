import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:ruoyi_plus_flutter/code/base/ui/app_mvvm.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/provider/fast_select.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/utils/widget_utils.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/vd/page_data_vd.dart';

import 'oss_list_page_vd.dart';

///
/// @author slc
/// Oss列表
class OssListBrowserPage extends AppBaseStatelessWidget<_OssListBrowserVm> {
  static const String routeName = '/system/oss';
  final String title;

  OssListBrowserPage(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => _OssListBrowserVm(),
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
              endDrawer: OssListPageWidget.getSearchEndDrawer<_OssListBrowserVm>(
                  context, themeData, getVm().listVmSub),
              /*floatingActionButton: FloatingActionButton(
                  child: Icon(Icons.add),
                  onPressed: () {
                    getVm().onAddItem();
                  }),*/
              body: PageDataVd(getVm().listVmSub, getVm(),
                  refreshOnStart: true,
                  child: NqSelector<_OssListBrowserVm, int>(builder: (context, vm, child) {
                    return OssListPageWidget.getDataListWidget(themeData, getVm().listVmSub);
                  }, selector: (context, vm) {
                    return vm.listVmSub.shouldSetState.version;
                  })));
        });
  }
}

class _OssListBrowserVm extends AppBaseVm {
  late OssListDataVmSub listVmSub;

  _OssListBrowserVm() {
    listVmSub = OssListDataVmSub();
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

  ///添加Oss事件
/*void onAddItem() {
    pushNamed(NoticeAddEditPage.routeName).then((result) {
      if (result != null) {
        listVmSub.sendRefreshEvent();
      }
    });
  }*/
}

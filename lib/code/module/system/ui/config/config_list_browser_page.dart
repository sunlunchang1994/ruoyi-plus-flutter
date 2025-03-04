import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/dimens.dart';
import 'package:provider/provider.dart';
import 'package:ruoyi_plus_flutter/code/base/ui/app_mvvm.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/provider/fast_select.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/utils/widget_utils.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/vd/page_data_vd.dart';

import '../../config/constant_sys.dart';
import 'config_add_edit_page.dart';
import 'config_list_page_vd.dart';

///
/// @author slc
/// 参数配置列表
class ConfigListBrowserPage
    extends AppBaseStatelessWidget<_ConfigListBrowserVm> {
  static const String routeName = '/system/config';
  final String title;

  ConfigListBrowserPage(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => _ConfigListBrowserVm(),
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
                  ConfigListPageWidget.getSearchEndDrawer<_ConfigListBrowserVm>(
                      context, themeData, getVm().listVmSub),
              floatingActionButton: FloatingActionButton(
                  child: Icon(Icons.add),
                  onPressed: () {
                    getVm().onAddItem();
                  }),
              body: PageDataVd(getVm().listVmSub, getVm(),
                  refreshOnStart: true,
                  child: NqSelector<_ConfigListBrowserVm, int>(
                      builder: (context, vm, child) {
                    return ConfigListPageWidget.getDataListWidget(
                        themeData, getVm().listVmSub, (currentItem) {
                      return Ink(
                          child: InkWell(
                              child: Padding(
                                  padding:
                                      EdgeInsets.all(SlcDimens.appDimens12),
                                  child: const Icon(Icons.chevron_right,
                                      size: 24)),
                              onTap: () {
                                //点击更多事件
                                getVm()
                                    .listVmSub
                                    .onSuffixClick
                                    ?.call(currentItem);
                              }));
                    });
                  }, selector: (context, vm) {
                    return vm.listVmSub.shouldSetState.version;
                  })));
        });
  }
}

class _ConfigListBrowserVm extends AppBaseVm {
  late ConfigListDataVmSub listVmSub;

  _ConfigListBrowserVm() {
    listVmSub = ConfigListDataVmSub();
    listVmSub.onSuffixClick = (itemData) {
      pushNamed(DictDataAddEditPage.routeName,
          arguments: {ConstantSys.KEY_SYS_CONFIG: itemData}).then((result) {
        if (result != null) {
          //更新列表
          listVmSub.sendRefreshEvent();
        }
      });
    };
  }

  void initVm() {
    registerVmSub(listVmSub);
  }

  ///添加参数配置事件
  void onAddItem() {
    pushNamed(DictDataAddEditPage.routeName).then((result) {
      if (result != null) {
        listVmSub.sendRefreshEvent();
      }
    });
  }
}

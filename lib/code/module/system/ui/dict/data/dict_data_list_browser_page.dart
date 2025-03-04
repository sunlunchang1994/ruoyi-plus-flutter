import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/dimens.dart';
import 'package:provider/provider.dart';
import 'package:ruoyi_plus_flutter/code/base/ui/app_mvvm.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/provider/fast_select.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/utils/widget_utils.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/vd/page_data_vd.dart';

import '../../../config/constant_sys.dart';
import 'dict_data_add_edit_page.dart';
import 'dict_data_list_page_vd.dart';

///
/// @author slc
/// 字典数据列表
class DictDataListBrowserPage
    extends AppBaseStatelessWidget<_DictDataListBrowserVm> {
  static const String routeName = '/system/dict/data';
  final String title;
  final String dictType;

  DictDataListBrowserPage(this.title, this.dictType, {super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => _DictDataListBrowserVm(),
        builder: (context, child) {
          ThemeData themeData = Theme.of(context);
          registerEvent(context);
          getVm().initVm(dictType);
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
              endDrawer: DictTypeListPageWidget.getSearchEndDrawer<
                      _DictDataListBrowserVm>(
                  context, themeData, getVm().listVmSub),
              floatingActionButton: FloatingActionButton(
                  child: Icon(Icons.add),
                  onPressed: () {
                    getVm().onAddItem();
                  }),
              body: PageDataVd(getVm().listVmSub, getVm(),
                  refreshOnStart: true,
                  child: NqSelector<_DictDataListBrowserVm, int>(
                      builder: (context, vm, child) {
                    return DictTypeListPageWidget.getDataListWidget(
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

class _DictDataListBrowserVm extends AppBaseVm {
  late DictDataListDataVmSub listVmSub;

  _DictDataListBrowserVm() {
    listVmSub = DictDataListDataVmSub();
    listVmSub.onSuffixClick = (itemData) {
      pushNamed(DictDataAddEditPage.routeName,
          arguments: {ConstantSys.KEY_DICT_DATA: itemData}).then((result) {
        if (result != null) {
          //更新列表
          listVmSub.sendRefreshEvent();
        }
      });
    };
  }

  void initVm(String dictType) {
    registerVmSub(listVmSub);
    listVmSub.currentSearch.dictType = dictType;
  }

  ///添加字典数据事件
  void onAddItem() {
    pushNamed(DictDataAddEditPage.routeName, arguments: {
      ConstantSys.KEY_DICT_PARENT_TYPE: listVmSub.currentSearch.dictType
    }).then((result) {
      if (result != null) {
        listVmSub.sendRefreshEvent();
      }
    });
  }
}

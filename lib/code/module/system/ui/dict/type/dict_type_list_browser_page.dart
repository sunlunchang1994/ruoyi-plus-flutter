import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/dimens.dart';
import 'package:provider/provider.dart';
import 'package:ruoyi_plus_flutter/code/base/ui/app_mvvm.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/provider/fast_select.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/utils/widget_utils.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/vd/page_data_vd.dart';
import 'package:ruoyi_plus_flutter/code/module/user/config/constant_user.dart';
import 'package:ruoyi_plus_flutter/code/module/user/ui/post/post_add_edit_page.dart';
import 'package:ruoyi_plus_flutter/code/module/user/ui/post/post_list_page_vd.dart';
import 'package:ruoyi_plus_flutter/code/module/user/ui/role/role_list_page_vd.dart';

import '../../../config/constant_sys.dart';
import 'dict_type_add_edit_page.dart';
import 'dict_type_list_page_vd.dart';

///
/// @author slc
/// 字典类型列表
class DictTypeListBrowserPage
    extends AppBaseStatelessWidget<_DictTypeListBrowserVm> {
  static const String routeName = '/system/dict';
  final String title;

  DictTypeListBrowserPage(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => _DictTypeListBrowserVm(),
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
              endDrawer: DictTypeListPageWidget.getSearchEndDrawer<
                      _DictTypeListBrowserVm>(
                  context, themeData, getVm().listVmSub),
              floatingActionButton: FloatingActionButton(
                  child: Icon(Icons.add),
                  onPressed: () {
                    getVm().onAddPost();
                  }),
              body: PageDataVd(getVm().listVmSub, getVm(),
                  refreshOnStart: true,
                  child: NqSelector<_DictTypeListBrowserVm, int>(
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

class _DictTypeListBrowserVm extends AppBaseVm {
  late DictTypeListDataVmSub listVmSub;

  _DictTypeListBrowserVm() {
    listVmSub = DictTypeListDataVmSub();
    listVmSub.onSuffixClick = (itemData) {
      pushNamed(DictTypeAddEditPage.routeName,
          arguments: {ConstantSys.KEY_DICT_TYPE: itemData}).then((result) {
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

  ///添加字典类型事件
  void onAddPost() {
    /*pushNamed(PostAddEditPage.routeName).then((result) {
      if (result != null) {
        listVmSub.sendRefreshEvent();
      }
    });*/
  }
}

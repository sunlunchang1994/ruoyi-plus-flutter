import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/dimens.dart';
import 'package:provider/provider.dart';
import 'package:ruoyi_plus_flutter/code/base/ui/app_mvvm.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/provider/fast_select.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/utils/widget_utils.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/vd/page_data_vd.dart';

import 'user_online_list_page_vd.dart';

///
/// @author slc
/// 在线用户列表
class UserOnlineListBrowserPage extends AppBaseStatelessWidget<_UserOnlineListBrowserVm> {
  static const String routeName = '/monitor/online';
  final String title;

  UserOnlineListBrowserPage(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => _UserOnlineListBrowserVm(),
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
              endDrawer: NoticeListPageWidget.getSearchEndDrawer<_UserOnlineListBrowserVm>(
                  context, themeData, getVm().listVmSub),
              /*floatingActionButton: FloatingActionButton(
                  child: Icon(Icons.add),
                  onPressed: () {
                    getVm().onAddItem();
                  }),*/
              body: PageDataVd(getVm().listVmSub, getVm(),
                  refreshOnStart: true,
                  child: NqSelector<_UserOnlineListBrowserVm, int>(builder: (context, vm, child) {
                    return NoticeListPageWidget.getDataListWidget(themeData, getVm().listVmSub,
                        (currentItem) {
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
                  })));
        });
  }
}

class _UserOnlineListBrowserVm extends AppBaseVm {
  late UserOnlineListDataVmSub listVmSub;

  _UserOnlineListBrowserVm() {
    listVmSub = UserOnlineListDataVmSub();
    listVmSub.onSuffixClick = (itemData) {
      listVmSub.onHandlerShowDetails(itemData);
    };
  }

  void initVm() {
    registerVmSub(listVmSub);
  }

  ///添加通知公告事件
/*void onAddItem() {
    pushNamed(NoticeAddEditPage.routeName).then((result) {
      if (result != null) {
        listVmSub.sendRefreshEvent();
      }
    });
  }*/
}

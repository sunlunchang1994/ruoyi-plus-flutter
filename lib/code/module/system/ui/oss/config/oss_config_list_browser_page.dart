import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:ruoyi_plus_flutter/code/base/ui/app_mvvm.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/provider/fast_select.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/vd/page_data_vd.dart';

import '../../../../../../generated/l10n.dart';
import '../../../../../lib/fast/utils/widget_utils.dart';
import 'oss_list_config_page_vd.dart';

///
/// @author slc
/// OssConfig列表
class OssConfigListBrowserPage extends AppBaseStatelessWidget<_OssConfigListBrowserVm> {
  static const String routeName = '/system/oss/config';

  OssConfigListBrowserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => _OssConfigListBrowserVm(),
        builder: (context, child) {
          ThemeData themeData = Theme.of(context);
          registerEvent(context);
          getVm().initVm();
          return Scaffold(
              appBar: AppBar(title: Text(S.current.sys_label_oss_config_name), actions: [
                Builder(builder: (context) {
                  return IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      WidgetUtils.autoHandlerSearchDrawer(context);
                    },
                  );
                })
              ]),
              endDrawer: OssConfigListPageWidget.getSearchEndDrawer<_OssConfigListBrowserVm>(
                  context, themeData, getVm().listVmSub),
              body: PageDataVd(getVm().listVmSub, getVm(),
                  refreshOnStart: true,
                  child: NqSelector<_OssConfigListBrowserVm, int>(builder: (context, vm, child) {
                    return OssConfigListPageWidget.getDataListWidget(themeData, getVm().listVmSub);
                  }, selector: (context, vm) {
                    return vm.listVmSub.shouldSetState.version;
                  })));
        });
  }
}

class _OssConfigListBrowserVm extends AppBaseVm {
  late OssConfigListDataVmSub listVmSub;

  _OssConfigListBrowserVm() {
    listVmSub = OssConfigListDataVmSub();
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

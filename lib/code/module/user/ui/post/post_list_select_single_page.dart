import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_slc_boxes/flutter/slc/common/screen_util.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/dimens.dart';
import 'package:provider/provider.dart';
import 'package:ruoyi_plus_flutter/code/base/ui/app_mvvm.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/provider/fast_select.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/vd/page_data_vd.dart';
import 'package:ruoyi_plus_flutter/code/module/user/ui/post/post_list_page_vd.dart';
import 'package:ruoyi_plus_flutter/code/module/user/ui/role/role_list_page_vd.dart';

import '../../../../../generated/l10n.dart';
import '../../../../lib/fast/utils/widget_utils.dart';

///
/// @author slc
/// 岗位单选
///
class PostListSingleSelectPage
    extends AppBaseStatelessWidget<_PostListSingleSelectVm> {
  static const String routeName = '/system/post/single';
  final String title;

  PostListSingleSelectPage(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => _PostListSingleSelectVm(),
        builder: (context, child) {
          ThemeData themeData = Theme.of(context);
          registerEvent(context);
          getVm().initVm();
          return Scaffold(
              appBar: AppBar(title: Text(title), actions: [
                IconButton(
                    onPressed: () {
                      WidgetUtils.autoHandlerSearchDrawer(context);
                    },
                    icon: Icon(Icons.search))
              ]),
              endDrawer:
                  PostListPageVd.getSearchEndDrawer<_PostListSingleSelectVm>(
                      context, themeData, getVm().listVmSub),
              body: PageDataVd(getVm().listVmSub, getVm(),
                  refreshOnStart: true,
                  child: NqSelector<_PostListSingleSelectVm, int>(
                      builder: (context, vm, child) {
                    return PostListPageVd.getUserListWidget(
                        themeData, getVm().listVmSub);
                  }, selector: (context, vm) {
                    return vm.listVmSub.shouldSetState.version;
                  })));
        });
  }
}

///
/// @author slc
/// 岗位单选控件
///
class PostListSingleSelectDialog
    extends AppBaseStatelessWidget<_PostListSingleSelectVm> {
  PostListSingleSelectDialog({super.key});

  static Widget getRoleListSingleSelectDialog({String? title}) {
    return ChangeNotifierProvider(
        create: (context) => _PostListSingleSelectVm(),
        builder: (context, child) {
          return AlertDialog(
            title: Text(title ?? S.current.user_label_post_name_select),
            titlePadding: EdgeInsets.all(SlcDimens.appDimens16),
            content: PostListSingleSelectDialog(),
            contentPadding: EdgeInsets.zero,
            insetPadding: EdgeInsets.zero,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    registerEvent(context);
    getVm().initVm();
    return SizedBox(
        width: ScreenUtil.getInstance().screenWidthDpr,
        child: PageDataVd(getVm().listVmSub, getVm(), refreshOnStart: true,
            child: Consumer<_PostListSingleSelectVm>(
                builder: (context, vm, child) {
          return PostListPageVd.getUserListWidget(themeData, getVm().listVmSub);
        })));
  }
}

class _PostListSingleSelectVm extends AppBaseVm {
  late PostPageDataVmSub listVmSub;

  _PostListSingleSelectVm() {
    listVmSub = PostPageDataVmSub();
    listVmSub.setItemClick((index, itemData) {
      //TODO 选择结果
    });
  }

  void initVm() {
    registerVmSub(listVmSub);
  }
}

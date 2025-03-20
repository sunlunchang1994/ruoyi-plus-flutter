import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_slc_boxes/flutter/slc/adapter/select_box.dart';
import 'package:flutter_slc_boxes/flutter/slc/common/text_util.dart';
import 'package:provider/provider.dart';
import 'package:ruoyi_plus_flutter/code/base/ui/app_mvvm.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/provider/fast_select.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/utils/widget_utils.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/vd/page_data_vd.dart';
import 'package:ruoyi_plus_flutter/code/module/user/config/constant_user.dart';
import 'package:ruoyi_plus_flutter/code/module/user/ui/post/post_add_edit_page.dart';
import 'package:ruoyi_plus_flutter/code/module/user/ui/post/post_list_page_vd.dart';

import '../../../../../generated/l10n.dart';
import '../../../../base/api/base_dio.dart';
import '../../../../base/ui/utils/fast_dialog_utils.dart';
import '../../../../feature/bizapi/user/entity/post.dart';
import '../../../../lib/fast/utils/app_toast.dart';
import '../../repository/remote/post_api.dart';

///
/// @author slc
/// 岗位列表
class PostListBrowserPage extends AppBaseStatelessWidget<_PostListBrowserVm> {
  static const String routeName = '/system/post';
  final String title;

  PostListBrowserPage(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => _PostListBrowserVm(),
        builder: (context, child) {
          ThemeData themeData = Theme.of(context);
          registerEvent(context);
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
                  appBar: AppBar(
                      leading:
                          NqSelector<_PostListBrowserVm, bool>(builder: (context, value, child) {
                        return WidgetUtils.getAnimCrossFade(const CloseButton(), const BackButton(),
                            showOne: value);
                      }, selector: (context, vm) {
                        return vm.listVmSub.selectModelIsRun;
                      }),
                      title: Text(title),
                      actions: [
                        NqSelector<_PostListBrowserVm, bool>(builder: (context, value, child) {
                          return AnimatedSize(
                              duration: WidgetUtils.adminDurationNormal,
                              child: Row(
                                children: [
                                  ...() {
                                    List<Widget> actions = [];
                                    if (value) {
                                      actions
                                          .addAll(WidgetUtils.getDeleteFamilyAction(onDelete: () {
                                        getVm().onDelete(confirmHandler: (nameList) {
                                          return FastDialogUtils.showDelConfirmDialog(context,
                                              contentText: TextUtil.format(
                                                  S.current.user_label_post_del_prompt,
                                                  [nameList.join(TextUtil.COMMA)]));
                                        });
                                      }, onSelectAll: () {
                                        getVm().listVmSub.onSelectAll(true);
                                      }, onDeselect: () {
                                        getVm().listVmSub.onSelectAll(false);
                                      }));
                                    } else {
                                      actions.add(Builder(builder: (context) {
                                        return IconButton(
                                          icon: const Icon(Icons.search),
                                          onPressed: () {
                                            WidgetUtils.autoHandlerSearchDrawer(context);
                                          },
                                        );
                                      }));
                                    }
                                    return actions;
                                  }.call()
                                ],
                              ));
                        }, selector: (context, vm) {
                          return vm.listVmSub.selectModelIsRun;
                        }),
                      ]),
                  endDrawer: PostListPageVd.getSearchEndDrawer<_PostListBrowserVm>(
                      context, themeData, getVm().listVmSub),
                  floatingActionButton:
                      NqSelector<_PostListBrowserVm, bool>(builder: (context, value, child) {
                    return WidgetUtils.getAnimVisibility(
                        !value,
                        FloatingActionButton(
                            child: Icon(Icons.add),
                            onPressed: () {
                              getVm().onAddPost();
                            }));
                  }, selector: (context, vm) {
                    return vm.listVmSub.selectModelIsRun;
                  }),
                  body: PageDataVd(getVm().listVmSub, getVm(),
                      refreshOnStart: true,
                      child: NqSelector<_PostListBrowserVm, int>(builder: (context, vm, child) {
                        return PostListPageVd.getUserListWidget(themeData, getVm().listVmSub);
                      }, selector: (context, vm) {
                        return vm.listVmSub.shouldSetState.version;
                      }))));
        });
  }
}

class _PostListBrowserVm extends AppBaseVm {
  late PostPageDataVmSub listVmSub;

  _PostListBrowserVm() {
    listVmSub = PostPageDataVmSub();
    listVmSub.enableSelectModel = true;
    listVmSub.setItemClick((index, itemData) {
      pushNamed(PostAddEditPage.routeName, arguments: {ConstantUser.KEY_POST: itemData})
          .then((result) {
        if (result != null) {
          listVmSub.sendRefreshEvent();
        }
      });
    });
  }

  void initVm() {
    registerVmSub(listVmSub);
  }

  ///添加岗位事件
  void onAddPost() {
    pushNamed(PostAddEditPage.routeName).then((result) {
      if (result != null) {
        listVmSub.sendRefreshEvent();
      }
    });
  }

  //删除事件
  void onDelete({Future<bool?> Function(List<String>)? confirmHandler, List<int>? idList}) {
    if (idList == null) {
      List<Post> selectList = SelectUtils.getSelect(listVmSub.dataList) ?? [];
      if (selectList.isEmpty) {
        AppToastUtil.showToast(msg: S.current.user_label_post_del_select_empty);
        return;
      }
      List<String> nameList = selectList.map<String>((item) => item.postName!).toList();
      List<int> idList = selectList.map<int>((item) => item.postId!).toList();
      confirmHandler?.call(nameList).then((value) {
        if (value == true) {
          onDelete(idList: idList);
        }
      });
      return;
    }
    //删除
    showLoading(text: S.current.label_delete_ing);
    PostRepository.delete(listVmSub.defCancelToken, postIds: idList).then((value) {
      dismissLoading();
      AppToastUtil.showToast(msg: S.current.label_delete_success);
      listVmSub.sendRefreshEvent();
    },
        onError: BaseDio.errProxyFunc(
            defErrMsg: S.current.label_delete_failed,
            onError: (error) {
              dismissLoading();
            }));
  }
}

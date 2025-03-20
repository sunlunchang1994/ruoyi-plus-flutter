import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_slc_boxes/flutter/slc/adapter/page_model.dart';
import 'package:flutter_slc_boxes/flutter/slc/adapter/select_box.dart';
import 'package:flutter_slc_boxes/flutter/slc/common/screen_util.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/dimens.dart';
import 'package:provider/provider.dart';
import 'package:ruoyi_plus_flutter/code/base/ui/app_mvvm.dart';
import 'package:ruoyi_plus_flutter/code/base/ui/utils/fast_dialog_utils.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/provider/fast_select.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/vd/page_data_vd.dart';
import 'package:ruoyi_plus_flutter/code/module/user/ui/post/post_list_page_vd.dart';

import '../../../../../generated/l10n.dart';
import '../../../../base/api/base_dio.dart';
import '../../../../base/api/result_entity.dart';
import '../../../../base/repository/remote/data_transform_utils.dart';
import '../../../../feature/bizapi/user/entity/post.dart';
import '../../../../lib/fast/utils/widget_utils.dart';
import '../../../../lib/fast/vd/list_data_component.dart';
import '../../repository/remote/post_api.dart';

///
/// @author slc
/// 岗位多选
///
class PostListMultipleSelectPage extends AppBaseStatelessWidget<_PostListMultipleSelectVm> {
  static const String routeName = '/system/post/multiple';
  final String title;
  final List<int>? selectDataId;
  final List<Post>? dataSrc;

  PostListMultipleSelectPage(this.title, {super.key, this.selectDataId, this.dataSrc});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) =>
            _PostListMultipleSelectVm(selectDataIds: selectDataId, dataSrc: dataSrc),
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
              endDrawer: PostListPageVd.getSearchEndDrawer<_PostListMultipleSelectVm>(
                  context, themeData, getVm().listVmSub),
              body: PageDataVd(getVm().listVmSub, getVm(), refreshOnStart: true,
                  child: Consumer<_PostListMultipleSelectVm>(builder: (context, vm, child) {
                return PostListPageVd.getUserListWidget(themeData, getVm().listVmSub,
                    buildTrailing: (currentItem) {
                  //选择按钮
                  return NqSelector<_PostListMultipleSelectVm, bool>(
                      builder: (context, value, child) {
                    return Checkbox(
                        value: value,
                        onChanged: (checkValue) {
                          currentItem.boxChecked = !currentItem.isBoxChecked();
                          getVm().notifyListeners();
                        });
                  }, selector: (context, vm) {
                    return currentItem.isBoxChecked();
                  });
                });
              })));
        });
  }
}

///
/// @author slc
/// 岗位多选控件
///
class PostListMultipleSelectDialog extends AppBaseStatelessWidget<_PostListMultipleSelectVm> {
  PostListMultipleSelectDialog({super.key});

  static Widget getPostListSelectDialog(
      {String? title, List<int>? selectDataIds, List<Post>? dataSrc}) {
    _PostListMultipleSelectVm vm =
        _PostListMultipleSelectVm(selectDataIds: selectDataIds, dataSrc: dataSrc);
    return ChangeNotifierProvider(
        create: (context) => vm,
        builder: (context, child) {
          return FastDialogUtils.getBottomAlertDialog(
            title: Text(title ?? S.current.user_label_post_name_select),
            content: PostListMultipleSelectDialog(),
            actions: [
              TextButton(
                  onPressed: () {
                    vm.finish();
                  },
                  child: Text(S.current.action_cancel)),
              TextButton(
                  onPressed: () {
                    vm.finish(result: SelectUtils.getSelect<Post, Post>(vm.listVmSub.dataList));
                  },
                  child: Text(S.current.action_ok))
            ],
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
        child: PageDataVd(getVm().listVmSub, getVm(),
            refreshOnStart: true,
            child: NqSelector<_PostListMultipleSelectVm, int>(builder: (context, vm, child) {
              return PostListPageVd.getUserListWidget(themeData, getVm().listVmSub,
                  buildTrailing: (currentItem) {
                //选择按钮
                return NqSelector<_PostListMultipleSelectVm, bool>(
                    builder: (context, value, child) {
                  return Checkbox(
                      value: value,
                      onChanged: (checkValue) {
                        currentItem.boxChecked = !currentItem.isBoxChecked();
                        getVm().notifyListeners();
                      });
                }, selector: (context, vm) {
                  return currentItem.isBoxChecked();
                });
              });
            }, selector: (context, vm) {
              return vm.listVmSub.shouldSetState.version;
            })));
  }
}

class _PostListMultipleSelectVm extends AppBaseVm {
  late PostPageDataVmSub listVmSub;

  _PostListMultipleSelectVm({List<int>? selectDataIds, List<Post>? dataSrc}) {
    listVmSub = PostPageDataVmSub(loadMore: (loadMoreFormat) async {
      DataWrapper<PageModel<Post>> dataWrapper;
      if (dataSrc != null) {
        dataWrapper = DataWrapper.createSuccess(PageModel(
            current: loadMoreFormat.offset,
            size: loadMoreFormat.size,
            isLastPage: true,
            records: dataSrc));
      } else {
        try {
          IntensifyEntity<PageModel<Post>> result = await PostRepository.list(loadMoreFormat.offset,
              loadMoreFormat.size, listVmSub.searchPost, listVmSub.defCancelToken);
          //返回数据结构
          dataWrapper = DataTransformUtils.entity2LDWrapper(result);
        } catch (e) {
          ResultEntity resultEntity = BaseDio.handlerErr(e, showToast: false);
          dataWrapper = DataWrapper.createFailed(code: resultEntity.code, msg: resultEntity.msg);
        }
      }
      if (dataWrapper.isSuccess() && selectDataIds != null) {
        dataWrapper.data?.records?.forEach((item) {
          item.initSelectBox(checked: selectDataIds.contains(item.postId));
        });
      }
      return dataWrapper;
    });
    listVmSub.setItemClick((index, itemData) {
      itemData.boxChecked = !itemData.isBoxChecked();
      notifyListeners();
    });
  }

  void initVm() {
    registerVmSub(listVmSub);
  }
}

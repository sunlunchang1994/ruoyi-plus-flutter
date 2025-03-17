import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_slc_boxes/flutter/slc/adapter/page_model.dart';
import 'package:flutter_slc_boxes/flutter/slc/common/screen_util.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/colors.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/dimens.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/styles.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/theme_extension.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/theme_util.dart';
import 'package:provider/provider.dart';
import 'package:ruoyi_plus_flutter/code/feature/bizapi/user/entity/post.dart';
import 'package:ruoyi_plus_flutter/code/feature/bizapi/user/entity/role.dart';
import 'package:ruoyi_plus_flutter/code/feature/component/dict/entity/tree_dict.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/vd/list_data_component.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/vd/refresh/content_empty.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/vd/request_token_manager.dart';
import 'package:ruoyi_plus_flutter/code/lib/form/form_operate_with_provider.dart';

import '../../../../../generated/l10n.dart';
import '../../../../../res/styles.dart';
import '../../../../base/api/base_dio.dart';
import '../../../../base/api/result_entity.dart';
import '../../../../base/config/constant_base.dart';
import '../../../../base/repository/remote/data_transform_utils.dart';
import '../../../../base/vm/global_vm.dart';
import '../../../../feature/bizapi/user/entity/dept.dart';
import '../../../../feature/bizapi/system/repository/local/local_dict_lib.dart';
import '../../../../feature/component/dict/utils/dict_ui_utils.dart';
import '../../../../lib/fast/provider/fast_select.dart';
import '../../../../lib/fast/utils/widget_utils.dart';
import '../../../../lib/fast/vd/page_data_vm_sub.dart';
import '../../../../lib/form/fast_form_builder_text_field.dart';
import '../../../../lib/form/input_decoration_utils.dart';
import '../../repository/remote/post_api.dart';
import '../dept/dept_list_select_single_page.dart';

class PostListPageVd {
  static Widget getUserListWidget(ThemeData themeData, IListDataVmSub<Post> listVmSub,
      {Widget? Function(Post currentItem)? buildTrailing}) {
    assert(listVmSub is ListenerItemSelect<dynamic>);
    if (listVmSub.dataList.isEmpty) {
      return const ContentEmptyWrapper();
    }
    return ListView.separated(
        clipBehavior: Clip.none,
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.zero,
        itemCount: listVmSub.dataList.length,
        itemBuilder: (context, index) {
          Post listItem = listVmSub.dataList[index];
          return getUserListItem(
              themeData, listVmSub as ListenerItemSelect<dynamic>, index, listItem,
              buildTrailing: buildTrailing);
        },
        separatorBuilder: (context, index) {
          return themeData.slcTidyUpStyle.getDefDividerByTheme(themeData);
        });
  }

  static Widget getUserListItem(
      ThemeData themeData, ListenerItemSelect<dynamic> listenerItemSelect, int index, Post listItem,
      {Widget? Function(Post currentItem)? buildTrailing}) {
    return ListTile(
        contentPadding: EdgeInsets.only(left: SlcDimens.appDimens16),
        title: Row(children: [Text(listItem.postName!), Text("·"), Text(listItem.deptName!)]),
        subtitle: Text(listItem.postCode!),
        trailing: buildTrailing?.call(listItem),
        visualDensity: VisualDensity.compact,
        //tileColor: SlcColors.getCardColorByTheme(themeData),
        onTap: () {
          listenerItemSelect.onItemClick(index, listItem);
        });
  }

  ///搜索侧滑栏视图
  static Widget getSearchEndDrawer<A>(
      BuildContext context, ThemeData themeData, PostPageDataVmSub listVmSub,
      {List<Widget>? Function(String? name)? formItemSlot}) {
    return Container(
        color: themeData.colorScheme.surface,
        width: ScreenUtil.getInstance().screenWidthDpr * 0.73,
        padding: EdgeInsets.only(
            top: ScreenUtil.getInstance().statusBarHeightDpr,
            left: SlcDimens.appDimens16,
            right: SlcDimens.appDimens16,
            bottom: SlcDimens.appDimens14),
        child: Selector0<Post>(builder: (context, value, child) {
          return FormBuilder(
              key: listVmSub.formOperate.formKey,
              child: Column(
                children: [
                  Container(
                      alignment: Alignment.centerLeft,
                      height: themeData.appBarTheme.toolbarHeight,
                      child: Text(S.current.user_label_search_role,
                          style: themeData.slcTidyUpStyle.getTitleTextStyle(themeData))),
                  ThemeUtil.getSizedBox(height: SlcDimens.appDimens16),
                  MyFormBuilderSelect(
                      name: "deptName",
                      initialValue: listVmSub.searchPost.deptName,
                      onTap: () => listVmSub.onSelectDept(),
                      decoration: MySelectDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        labelText: S.current.user_label_post_owner_dept,
                        hintText: S.current.app_label_please_choose,
                        border: const UnderlineInputBorder(),
                        suffixIcon: NqNullSelector<A, String?>(builder: (context, value, child) {
                          return InputDecUtils.autoClearSuffixBySelectVal(
                              listVmSub.searchPost.deptName, onPressed: () {
                            listVmSub.setSelectDept(null);
                          });
                        }, selector: (context, vm) {
                          return listVmSub.searchPost.deptName;
                        }),
                      ),
                      textInputAction: TextInputAction.next),
                  ThemeUtil.getSizedBox(height: SlcDimens.appDimens16),
                  MyFormBuilderTextField(
                      name: "postName",
                      initialValue: listVmSub.searchPost.postName,
                      decoration: MyInputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelText: S.current.user_label_role_name,
                          hintText: S.current.app_label_please_input,
                          border: const UnderlineInputBorder(),
                          suffixIcon: NqNullSelector<A, String?>(builder: (context, value, child) {
                            return InputDecUtils.autoClearSuffixByInputVal(value,
                                formOperate: listVmSub.formOperate, formFieldName: "postName");
                          }, selector: (context, vm) {
                            return listVmSub.searchPost.postName;
                          })),
                      onChanged: (value) {
                        listVmSub.searchPost.postName = value;
                        listVmSub.notifyListeners();
                      },
                      textInputAction: TextInputAction.next),
                  ThemeUtil.getSizedBox(height: SlcDimens.appDimens16),
                  FormBuilderTextField(
                      name: "postCode",
                      initialValue: listVmSub.searchPost.postCode,
                      decoration: MyInputDecoration(
                          contentPadding: EdgeInsets.zero,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelText: S.current.user_label_role_key,
                          hintText: S.current.app_label_please_input,
                          border: const UnderlineInputBorder(),
                          suffixIcon: NqNullSelector<A, String?>(builder: (context, value, child) {
                            return InputDecUtils.autoClearSuffixByInputVal(value,
                                formOperate: listVmSub.formOperate, formFieldName: "postCode");
                          }, selector: (context, vm) {
                            return listVmSub.searchPost.postCode;
                          })),
                      onChanged: (value) {
                        listVmSub.searchPost.postCode = value;
                        listVmSub.notifyListeners();
                      },
                      textInputAction: TextInputAction.next),
                  ThemeUtil.getSizedBox(height: SlcDimens.appDimens16),
                  MyFormBuilderSelect(
                      name: "status",
                      initialValue: listVmSub.searchPost.statusName,
                      onTap: () {
                        DictUiUtils.showSelectDialog(context, LocalDictLib.CODE_SYS_NORMAL_DISABLE,
                            (value) {
                          //选择后设置性别
                          listVmSub.setSelectStatus(value);
                        });
                      },
                      decoration: MySelectDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelText: S.current.user_label_status,
                          hintText: S.current.app_label_please_choose,
                          border: const UnderlineInputBorder(),
                          suffixIcon: NqSelector<A, String?>(builder: (context, value, child) {
                            return InputDecUtils.autoClearSuffixBySelectVal(
                              value,
                              onPressed: () {
                                listVmSub.setSelectStatus(null);
                              },
                            );
                          }, selector: (context, vm) {
                            return listVmSub.searchPost.statusName;
                          })),
                      textInputAction: TextInputAction.next),
                  Expanded(child: Builder(builder: (context) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                            child: OutlinedButton(
                                onPressed: () {
                                  listVmSub.onResetSearch();
                                },
                                child: Text(S.current.action_reset))),
                        ThemeUtil.getSizedBox(width: SlcDimens.appDimens16),
                        Expanded(
                            child: FilledButton(
                                onPressed: () {
                                  WidgetUtils.autoHandlerSearchDrawer(context);
                                  listVmSub.onSearch();
                                },
                                child: Text(S.current.action_search)))
                      ],
                    );
                  }))
                ],
              ));
        }, selector: (context) {
          return listVmSub.searchPost;
        }, shouldRebuild: (oldVal, newVal) {
          return false;
        }));
  }
}

class PostPageDataVmSub extends FastBaseListDataPageVmSub<Post> with CancelTokenAssist {
  final FormOperateWithProvider formOperate = FormOperateWithProvider();
  Post searchPost = Post();

  void Function(Post data)? onSuffixClick;

  PostPageDataVmSub({LoadMore<Post>? loadMore}) {
    setLoadData(loadMore ??
        (loadMoreFormat) async {
          try {
            IntensifyEntity<PageModel<Post>> result = await PostRepository.list(
                loadMoreFormat.offset, loadMoreFormat.size, searchPost, defCancelToken);
            //返回数据结构
            DataWrapper<PageModel<Post>> dataWrapper = DataTransformUtils.entity2LDWrapper(result);
            return dataWrapper;
          } catch (e) {
            ResultEntity resultEntity = BaseDio.getError(e);
            return DataWrapper.createFailed(code: resultEntity.code, msg: resultEntity.msg);
          }
        });
  }

  void onSelectDept() {
    pushNamed(DeptListSingleSelectPage.routeName,
            arguments: {ConstantBase.KEY_INTENT_TITLE: S.current.user_label_dept_select})
        .then((result) {
      if (result != null) {
        setSelectDept(result);
      }
    });
  }

  void setSelectDept(Dept? dept) {
    searchPost.deptId = dept?.deptId;
    searchPost.deptName = dept?.deptName;
    formOperate.patchField("deptName", searchPost.deptName);
    notifyListeners();
  }

  void setSelectStatus(ITreeDict<dynamic>? data) {
    searchPost.status = data?.tdDictValue;
    searchPost.statusName = data?.tdDictLabel;
    formOperate.patchField("status", searchPost.statusName);
    notifyListeners();
  }

  //重置
  void onResetSearch() {
    searchPost = Post();
    formOperate.clearAll();
    notifyListeners();
  }

  //搜索
  void onSearch() {
    formOperate.formBuilderState?.save();
    sendRefreshEvent();
  }
}

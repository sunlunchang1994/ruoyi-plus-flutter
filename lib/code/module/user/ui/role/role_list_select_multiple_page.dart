import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_slc_boxes/flutter/slc/adapter/page_model.dart';
import 'package:flutter_slc_boxes/flutter/slc/adapter/select_box.dart';
import 'package:flutter_slc_boxes/flutter/slc/common/screen_util.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/dimens.dart';
import 'package:provider/provider.dart';
import 'package:ruoyi_plus_flutter/code/base/ui/app_mvvm.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/provider/fast_select.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/vd/page_data_vd.dart';
import 'package:ruoyi_plus_flutter/code/module/user/ui/role/role_list_page_vd.dart';

import '../../../../../generated/l10n.dart';
import '../../../../base/api/base_dio.dart';
import '../../../../base/api/result_entity.dart';
import '../../../../base/repository/remote/data_transform_utils.dart';
import '../../../../feature/bizapi/user/entity/role.dart';
import '../../../../lib/fast/utils/widget_utils.dart';
import '../../../../lib/fast/vd/list_data_component.dart';
import '../../repository/remote/role_api.dart';

///
/// @author slc
/// 角色单选
///
class RoleListMultipleSelectPage extends AppBaseStatelessWidget<_RoleListMultipleSelectVm> {
  static const String routeName = '/system/role/multiple';
  final String title;
  final List<int>? selectRoleId;

  RoleListMultipleSelectPage(this.title, this.selectRoleId, {super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => _RoleListMultipleSelectVm(this.selectRoleId),
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
              endDrawer: RoleListPageVd.getSearchEndDrawer<_RoleListMultipleSelectVm>(
                  context, themeData, getVm().listVmSub),
              body: PageDataVd(getVm().listVmSub, getVm(), refreshOnStart: true,
                  child: Consumer<_RoleListMultipleSelectVm>(builder: (context, vm, child) {
                return RoleListPageVd.getUserListWidget(themeData, getVm().listVmSub,
                    buildTrailing: (currentItem) {
                  //选择按钮
                  return NqSelector<_RoleListMultipleSelectVm, bool>(builder: (context, value, child) {
                    return Checkbox(
                        value: value,
                        onChanged: (checkValue) {
                          currentItem.isChecked = !currentItem.isChecked;
                          getVm().notifyListeners();
                        });
                  }, selector: (context, vm) {
                    return currentItem.isChecked;
                  });
                });
              })));
        });
  }
}

///
/// @author slc
/// 角色单选控件
///
class RoleListMultipleSelectDialog extends AppBaseStatelessWidget<_RoleListMultipleSelectVm> {
  RoleListMultipleSelectDialog({super.key});

  static Widget getRoleListSelectDialog({String? title, List<int>? selectRoleId}) {
    _RoleListMultipleSelectVm vm = _RoleListMultipleSelectVm(selectRoleId);
    return ChangeNotifierProvider(
        create: (context) => vm,
        builder: (context, child) {
          return AlertDialog(
            title: Text(title ?? S.current.user_label_role_name_select),
            titlePadding: EdgeInsets.all(SlcDimens.appDimens16),
            content: RoleListMultipleSelectDialog(),
            contentPadding: EdgeInsets.zero,
            insetPadding: EdgeInsets.zero,
            actions: [
              TextButton(
                  onPressed: () {
                    vm.finish();
                  },
                  child: Text(S.current.action_cancel)),
              TextButton(
                  onPressed: () {
                    vm.finish(result: SelectUtils.getSelect(vm.listVmSub.dataList));
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
        child: PageDataVd(getVm().listVmSub, getVm(), refreshOnStart: true,
            child: Consumer<_RoleListMultipleSelectVm>(builder: (context, vm, child) {
          return RoleListPageVd.getUserListWidget(themeData, getVm().listVmSub,
              buildTrailing: (currentItem) {
            //选择按钮
            return NqSelector<_RoleListMultipleSelectVm, bool>(builder: (context, value, child) {
              return Checkbox(
                  value: value,
                  onChanged: (checkValue) {
                    currentItem.isChecked = !currentItem.isChecked;
                    getVm().notifyListeners();
                  });
            }, selector: (context, vm) {
              return currentItem.isChecked;
            });
          });
        })));
  }
}

class _RoleListMultipleSelectVm extends AppBaseVm {
  late RolePageDataVmSub listVmSub;

  _RoleListMultipleSelectVm(List<int>? selectRoleId) {
    listVmSub = RolePageDataVmSub(loadMore: (loadMoreFormat) async {
      try {
        IntensifyEntity<PageModel<Role>> result = await RoleRepository.list(loadMoreFormat.getOffset(),
            loadMoreFormat.getSize(), listVmSub.searchRole, listVmSub.cancelToken);
        //返回数据结构
        DataWrapper<PageModel<Role>> dateWrapper = DataTransformUtils.entity2LDWrapper(result);
        if (selectRoleId != null) {
          dateWrapper.data?.records?.forEach((item) {
            item.initSelectBox(checked: selectRoleId.contains(item.roleId));
          });
        }
        return dateWrapper;
      } catch (e) {
        ResultEntity resultEntity = BaseDio.getError(e);
        return DataWrapper.createFailed(code: resultEntity.code, msg: resultEntity.msg);
      }
    });
    listVmSub.setItemClick((index, role) {
      role.isChecked = !role.isChecked;
      notifyListeners();
    });
  }

  void initVm() {
    registerVmSub(listVmSub);
  }
}

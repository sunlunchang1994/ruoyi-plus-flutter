import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_slc_boxes/flutter/slc/dialog/dialog_loading_vm.dart';
import 'package:flutter_slc_boxes/flutter/slc/mvvm/status_widget.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/dimens.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';
import 'package:provider/provider.dart';
import 'package:ruoyi_plus_flutter/code/base/ui/utils/fast_dialog_utils.dart';
import 'package:ruoyi_plus_flutter/code/base/utils/app_toast.dart';
import 'package:ruoyi_plus_flutter/code/feature/bizapi/user/entity/dept.dart';
import 'package:ruoyi_plus_flutter/code/module/user/repository/remote/dept_api.dart';

import '../../../../../generated/l10n.dart';
import '../../../../base/api/base_dio.dart';
import '../../../../base/api/result_entity.dart';
import '../../../../base/ui/app_mvvm.dart';

///部门信息新增修改
class DeptAddEditPage extends AppBaseStatelessWidget<_DeptAddEditModel> {
  static const String routeName = '/system/dept/add_edit';

  final Dept? deptInfo;
  final Dept? parentDept;

  DeptAddEditPage({super.key, this.deptInfo, this.parentDept});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => _DeptAddEditModel(),
      builder: (context, child) {
        ThemeData themeData = Theme.of(context);
        registerEvent(context);
        getVm().initVm(deptInfo, parentDept);
        return PopScope(
            canPop: false,
            onPopInvokedWithResult: (canPop, result) {
              if (canPop) {
                return;
              }
              if (getVm().canPop()) {
                Navigator.pop(context);
                return;
              }
              //没有保存则显示提示保存对话框
              _showPromptSaveDialog(context);
            },
            child: Scaffold(
                appBar: AppBar(
                    title: Text(
                        deptInfo == null ? S.current.user_label_dept_add : S.current.user_label_dept_edit),
                    actions: [
                      IconButton(
                          onPressed: () {
                            getVm().save();
                          },
                          icon: const Icon(Icons.save))
                    ]),
                body: getStatusBody(context)));
      },
    );
  }

  @override
  Widget getSuccessWidget(BuildContext context, {Map<String, dynamic>? params}) {
    return Center(child: Text("请完善"));
  }

  ///显示提示保存对话框
  void _showPromptSaveDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: Text(S.current.label_prompt),
              content: Text(S.current.app_label_data_save_prompt),
              actions: FastDialogUtils.getCommonlyAction(context, positiveText: S.current.action_exit,
                  positiveLister: () {
                Navigator.pop(context);
                getVm().abandonEdit();
              }));
        });
  }
}

class _DeptAddEditModel extends AppBaseVm {
  final CancelToken cancelToken = CancelToken();

  Dept? deptInfo;

  bool _infoChange = false;

  void initVm(Dept? deptInfo, Dept? parentDept) {
    if (deptInfo == null && parentDept == null) {
      AppToastBridge.showToast(msg: S.current.label_select_parameter_is_missing);
      finish();
      return;
    }
    if (deptInfo == null) {
      this.deptInfo = Dept();
      this.deptInfo!.parentId = parentDept!.deptId;
      this.deptInfo!.parentName = parentDept.deptName;
      setLoadingStatus(LoadingStatus.success);
    } else {
      DeptRepository.getInfo(deptInfo.deptId!, cancelToken).then((result) {
        this.deptInfo = result.data;
        setLoadingStatus(LoadingStatus.success);
      }, onError: (e) {
        ResultEntity resultEntity = BaseDio.getError(e);
        AppToastBridge.showToast(msg: resultEntity.msg);
        finish();
      });
    }
  }

  //应用信息更改
  void applyInfoChange() {
    _infoChange = true;
  }

  //放弃修改
  void abandonEdit() {
    _infoChange = false;
    finish();
  }

  bool canPop() {
    return !_infoChange;
  }

  //检查保存参数
  bool _checkSaveParams() {
    return true;
  }

  void save() {
    if (!_checkSaveParams()) {
      AppToastBridge.showToast(msg: S.current.app_label_required_information_cannot_be_empty);
      return;
    }
    showLoading(text: S.current.label_save_ing);
    /*UserProfileServiceRepository.updateProfile(
            userInfo.nickName!, userInfo.email!, userInfo.phonenumber!, userInfo.sex!)
        .then((result) {
      //更新成功了把当前的值设置给全局（此处应该重新调用获取用户信息的接口重新赋值，暂时先这么写）
      GlobalVm().userShareVm.userInfoOf.value!.user = userInfo;
      AppToastBridge.showToast(msg: S.current.toast_edit_success);
      dismissLoading();
      //保存成功后要设置
      _infoChange = false;
    }, onError: (e) {
      AppToastBridge.showToast(msg: S.current.toast_edit_failure);
      dismissLoading();
    });*/
  }

  @override
  void dispose() {
    cancelToken.cancel("cancelled");
    super.dispose();
  }
}

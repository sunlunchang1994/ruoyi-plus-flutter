import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_slc_boxes/flutter/slc/common/text_util.dart';
import 'package:flutter_slc_boxes/flutter/slc/mvvm/status_widget.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/dimens.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/styles.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/theme_util.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';
import 'package:provider/provider.dart';
import 'package:ruoyi_plus_flutter/code/base/config/constant_base.dart';
import 'package:ruoyi_plus_flutter/code/base/ui/utils/fast_dialog_utils.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/utils/app_toast.dart';
import 'package:ruoyi_plus_flutter/code/feature/bizapi/system/repository/local/local_dict_lib.dart';
import 'package:ruoyi_plus_flutter/code/feature/component/dict/utils/dict_ui_utils.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/vd/request_token_manager.dart';
import 'package:ruoyi_plus_flutter/code/lib/form/fast_form_builder_field_option.dart';
import 'package:ruoyi_plus_flutter/code/lib/form/form_operate_with_provider.dart';
import 'package:ruoyi_plus_flutter/code/lib/form/input_decoration_utils.dart';
import 'package:ruoyi_plus_flutter/code/module/system/entity/sys_menu.dart';

import '../../../../../generated/l10n.dart';
import '../../../../base/api/base_dio.dart';
import '../../../../base/api/result_entity.dart';
import '../../../../base/ui/app_mvvm.dart';
import '../../../../base/vm/global_vm.dart';
import '../../../../lib/fast/provider/fast_select.dart';
import '../../../../lib/form/fast_form_builder_text_field.dart';
import '../../config/constant_sys.dart';
import '../../repository/remote/menu_api.dart';
import 'menu_list_select_single_page.dart';

///部门信息新增修改
class MenuAddEditPage extends AppBaseStatelessWidget<_MenuAddEditModel> {
  static const String routeName = '/system/menu/add_edit';

  final SysMenu? sysMenuInfo;
  final SysMenu? parentSysMenu;

  MenuAddEditPage({super.key, this.sysMenuInfo, this.parentSysMenu});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => _MenuAddEditModel(),
      builder: (context, child) {
        ThemeData themeData = Theme.of(context);
        registerEvent(context);
        getVm().initVm(sysMenuInfo, parentSysMenu);
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
                    title: Text(sysMenuInfo == null
                        ? S.current.sys_label_menu_add
                        : S.current.sys_label_menu_edit),
                    actions: [
                      if ((globalVm.userShareVm.hasPermiAny(["system:menu:edit"]) &&
                              sysMenuInfo != null) ||
                          (globalVm.userShareVm.hasPermiAny(["system:menu:add"]) &&
                              sysMenuInfo == null))
                        IconButton(
                            onPressed: () {
                              getVm().onSave();
                            },
                            icon: const Icon(Icons.save)),
                      if (sysMenuInfo != null &&
                          (globalVm.userShareVm.hasPermiAny(["system:menu:remove"])))
                        PopupMenuButton(itemBuilder: (context) {
                          return [
                            if (globalVm.userShareVm.hasPermiAny(["system:menu:remove"]))
                              PopupMenuItem(
                                child: Text(S.current.action_delete),
                                onTap: () {
                                  FastDialogUtils.showDelConfirmDialog(context,
                                      contentText: TextUtil.format(
                                          S.current.sys_label_menu_del_prompt,
                                          [sysMenuInfo?.menuName ?? ""])).then((confirm) {
                                    if (confirm == true) {
                                      getVm().onDelete();
                                    }
                                  });
                                },
                              )
                          ];
                        })
                    ]),
                body: getStatusBody(context)));
      },
    );
  }

  @override
  Widget getSuccessWidget(BuildContext context, {Map<String, dynamic>? params}) {
    return KeyboardAvoider(
        autoScroll: true,
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: SlcDimens.appDimens16),
            child: FormBuilder(
                key: getVm()._formKey,
                onChanged: () {
                  //这里要不要应该无所谓，因为本表单的数据存在vm的实例中
                  //getVm()._formKey.currentState?.save();
                },
                child: NqSelector<_MenuAddEditModel, String>(builder: (context, value, child) {
                  return Column(
                    children: getFormItem(),
                  );
                }, selector: (context, vm) {
                  return vm.sysMenuInfo!.menuType!;
                }))));
  }

  //获取表单的item
  List<Widget> getFormItem() {
    List<Widget> formItemArray = List.empty(growable: true);
    formItemArray.addAll(<Widget>{
      ThemeUtil.getSizedBox(height: SlcDimens.appDimens8),
      MyFormBuilderSelect(
          name: "parentName",
          initialValue: getVm().sysMenuInfo!.parentName,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          onTap: () => getVm().onSelectParentMenu(),
          decoration: MySelectDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.always,
            labelText: S.current.sys_label_menu_parent_name,
            hintText: S.current.app_label_please_choose,
            border: const UnderlineInputBorder(),
            suffixIcon:
                NqNullSelector<_MenuAddEditModel, String?>(builder: (context, value, child) {
              return InputDecUtils.autoClearSuffixBySelectVal(getVm().sysMenuInfo!.parentName,
                  onPressed: () {
                getVm().setSelectParentMenu(null);
              });
            }, selector: (context, vm) {
              return vm.sysMenuInfo!.parentName;
            }),
          ),
          textInputAction: TextInputAction.next),
      ThemeUtil.getSizedBox(height: SlcDimens.appDimens16),
      FormBuilderRadioGroup<OptionVL<String>>(
        decoration: MyInputDecoration(labelText: S.current.sys_label_menu_type),
        name: "menuType",
        initialValue: DictUiUtils.dict2OptionVL(GlobalVm().dictShareVm.findDict(
            LocalDictLib.CODE_MENU_TYPE, getVm().sysMenuInfo!.menuType,
            defDictKey: LocalDictLib.KEY_MENU_TYPE_MULU)),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        options: DictUiUtils.dictList2FromOption(
            globalVm.dictShareVm.dictMap[LocalDictLib.CODE_MENU_TYPE]!),
        onChanged: (value) {
          //此处需改成选择的
          getVm().applyInfoChange();
          getVm().sysMenuInfo!.menuType = value?.value;
          getVm().notifyListeners();
        },
      ),
      ThemeUtil.getSizedBox(height: SlcDimens.appDimens16),
      FormBuilderTextField(
          name: "menuName",
          initialValue: getVm().sysMenuInfo!.menuName,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: MyInputDecoration(
              contentPadding: EdgeInsets.zero,
              floatingLabelBehavior: FloatingLabelBehavior.always,
              label: InputDecUtils.getRequiredLabel(S.current.sys_label_menu_name),
              hintText: S.current.app_label_please_input,
              border: const UnderlineInputBorder()),
          onChanged: (value) {
            getVm().applyInfoChange();
            getVm().sysMenuInfo!.menuName = value;
          },
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.required(),
          ]),
          textInputAction: TextInputAction.next),
      ThemeUtil.getSizedBox(height: SlcDimens.appDimens16),
      FormBuilderTextField(
        name: "orderNum",
        initialValue: () {
          int? orderNum = getVm().sysMenuInfo!.orderNum;
          return orderNum.toString();
        }.call(),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: MyInputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.always,
            label: InputDecUtils.getRequiredLabel(S.current.app_label_show_sort),
            hintText: S.current.app_label_please_input,
            border: const UnderlineInputBorder()),
        onChanged: (value) {
          getVm().applyInfoChange();
          getVm().sysMenuInfo!.orderNum = value == null ? null : int.tryParse(value);
        },
        validator: FormBuilderValidators.compose([
          FormBuilderValidators.required(),
          FormBuilderValidators.numeric(),
        ]),
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.next,
      ),
      ...() {
        List<Widget> menuTypeWidgetList = List.empty(growable: true);
        if (LocalDictLib.KEY_MENU_TYPE_CAIDAN == getVm().sysMenuInfo?.menuType ||
            LocalDictLib.KEY_MENU_TYPE_MULU == getVm().sysMenuInfo?.menuType) {
          menuTypeWidgetList.addAll([
            ThemeUtil.getSizedBox(height: SlcDimens.appDimens16),
            FormBuilderRadioGroup<OptionVL<String>>(
              name: "isFrame",
              initialValue: DictUiUtils.dict2OptionVL(GlobalVm().dictShareVm.findDict(
                  LocalDictLib.CODE_SYS_YES_NO_INT, getVm().sysMenuInfo!.isFrame,
                  defDictKey: LocalDictLib.KEY_SYS_YES_NO_INT_N)),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              options: DictUiUtils.dictList2FromOption(
                  globalVm.dictShareVm.dictMap[LocalDictLib.CODE_SYS_YES_NO_INT]!),
              decoration: MyInputDecoration(
                labelText: S.current.sys_label_menu_is_frame,
              ),
              onChanged: (value) {
                getVm().applyInfoChange();
                getVm().sysMenuInfo!.isFrame = value?.value;
              },
            )
          ]);
        }
        return menuTypeWidgetList;
      }.call(),
      ThemeUtil.getSizedBox(height: SlcDimens.appDimens16),
      FormBuilderTextField(
        name: "path",
        initialValue: () {
          return getVm().sysMenuInfo!.path;
        }.call(),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: MyInputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.always,
            label: InputDecUtils.getRequiredLabel(S.current.sys_label_menu_path),
            hintText: S.current.app_label_please_input,
            border: const UnderlineInputBorder()),
        onChanged: (value) {
          getVm().applyInfoChange();
          getVm().sysMenuInfo!.path = value;
        },
        validator: FormBuilderValidators.compose([
          FormBuilderValidators.required(),
        ]),
        textInputAction: TextInputAction.next,
      ),
      ...() {
        List<Widget> menuTypeWidgetList = List.empty(growable: true);
        if (LocalDictLib.KEY_MENU_TYPE_CAIDAN == getVm().sysMenuInfo?.menuType) {
          menuTypeWidgetList.addAll([
            ThemeUtil.getSizedBox(height: SlcDimens.appDimens16),
            FormBuilderTextField(
              name: "component",
              initialValue: () {
                return getVm().sysMenuInfo!.component;
              }.call(),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: MyInputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  labelText: S.current.sys_label_menu_component_path,
                  hintText: S.current.app_label_please_input,
                  border: const UnderlineInputBorder()),
              onChanged: (value) {
                getVm().applyInfoChange();
                getVm().sysMenuInfo!.component = value;
              },
              textInputAction: TextInputAction.next,
            )
          ]);
        }
        if (LocalDictLib.KEY_MENU_TYPE_CAIDAN == getVm().sysMenuInfo?.menuType ||
            LocalDictLib.KEY_MENU_TYPE_ACTION == getVm().sysMenuInfo?.menuType) {
          menuTypeWidgetList.addAll([
            ThemeUtil.getSizedBox(height: SlcDimens.appDimens16),
            FormBuilderTextField(
              name: "perms",
              initialValue: () {
                return getVm().sysMenuInfo!.perms;
              }.call(),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: MyInputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  labelText: S.current.sys_label_menu_permission_characters,
                  hintText: S.current.app_label_please_input,
                  border: const UnderlineInputBorder()),
              onChanged: (value) {
                getVm().applyInfoChange();
                getVm().sysMenuInfo!.perms = value;
              },
              textInputAction: TextInputAction.next,
            )
          ]);
        }
        if (LocalDictLib.KEY_MENU_TYPE_CAIDAN == getVm().sysMenuInfo?.menuType) {
          menuTypeWidgetList.addAll([
            ThemeUtil.getSizedBox(height: SlcDimens.appDimens16),
            FormBuilderTextField(
              name: "queryParam",
              initialValue: () {
                return getVm().sysMenuInfo!.queryParam;
              }.call(),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: MyInputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  labelText: S.current.sys_label_menu_route_parameters,
                  hintText: S.current.app_label_please_input,
                  border: const UnderlineInputBorder()),
              onChanged: (value) {
                getVm().applyInfoChange();
                getVm().sysMenuInfo!.queryParam = value;
              },
              textInputAction: TextInputAction.next,
            ),
            ThemeUtil.getSizedBox(height: SlcDimens.appDimens16),
            FormBuilderRadioGroup<OptionVL<String>>(
              name: "isCache",
              initialValue: DictUiUtils.dict2OptionVL(GlobalVm().dictShareVm.findDict(
                  LocalDictLib.CODE_SYS_YES_NO_INT, getVm().sysMenuInfo!.isCache,
                  defDictKey: LocalDictLib.KEY_SYS_YES_NO_Y)),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              options: DictUiUtils.dictList2FromOption(
                  globalVm.dictShareVm.dictMap[LocalDictLib.CODE_SYS_YES_NO_INT]!),
              decoration: MyInputDecoration(
                labelText: S.current.sys_label_menu_cache_status,
              ),
              onChanged: (value) {
                getVm().applyInfoChange();
                getVm().sysMenuInfo!.isCache = value?.value;
              },
            )
          ]);
        }
        if (LocalDictLib.KEY_MENU_TYPE_CAIDAN == getVm().sysMenuInfo?.menuType ||
            LocalDictLib.KEY_MENU_TYPE_MULU == getVm().sysMenuInfo?.menuType) {
          menuTypeWidgetList.addAll([
            ThemeUtil.getSizedBox(height: SlcDimens.appDimens16),
            FormBuilderRadioGroup<OptionVL<String>>(
              name: "visible",
              initialValue: DictUiUtils.dict2OptionVL(GlobalVm().dictShareVm.findDict(
                  LocalDictLib.CODE_SYS_SHOW_HIDE, getVm().sysMenuInfo!.visible,
                  defDictKey: LocalDictLib.KEY_SYS_SHOW_HIDE_S)),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              options: DictUiUtils.dictList2FromOption(
                  globalVm.dictShareVm.dictMap[LocalDictLib.CODE_SYS_SHOW_HIDE]!),
              decoration: MyInputDecoration(
                labelText: S.current.sys_label_menu_display_status,
              ),
              onChanged: (value) {
                getVm().applyInfoChange();
                getVm().sysMenuInfo!.visible = value?.value;
              },
            )
          ]);
        }
        return menuTypeWidgetList;
      }.call(),
      ThemeUtil.getSizedBox(height: SlcDimens.appDimens16),
      FormBuilderRadioGroup<OptionVL<String>>(
        decoration: MyInputDecoration(labelText: S.current.user_label_dept_status),
        name: "status",
        initialValue: DictUiUtils.dict2OptionVL(GlobalVm()
            .dictShareVm
            .findDict(LocalDictLib.CODE_SYS_NORMAL_DISABLE, getVm().sysMenuInfo!.status)),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        options: DictUiUtils.dictList2FromOption(
            globalVm.dictShareVm.dictMap[LocalDictLib.CODE_SYS_NORMAL_DISABLE]!),
        onChanged: (value) {
          //此处需改成选择的
          getVm().applyInfoChange();
          getVm().sysMenuInfo!.status = value?.value;
        },
        validator: FormBuilderValidators.compose([FormBuilderValidators.required()]),
      )
    });
    return formItemArray;
  }

  ///显示提示保存对话框
  void _showPromptSaveDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: Text(S.current.label_prompt),
              content: Text(S.current.app_label_data_save_prompt),
              actions: FastDialogUtils.getCommonlyAction(context,
                  positiveText: S.current.action_exit, positiveLister: () {
                Navigator.pop(context);
                getVm().abandonEdit();
              }));
        });
  }
}

class _MenuAddEditModel extends AppBaseVm with CancelTokenAssist {
  final _formKey = GlobalKey<FormBuilderState>();

  SysMenu? sysMenuInfo;

  bool _infoChange = false;

  void initVm(SysMenu? menuInfo, SysMenu? parentMenu) {
    if (menuInfo == null && parentMenu == null) {
      AppToastUtil.showToast(msg: S.current.label_select_parameter_is_missing);
      finish();
      return;
    }
    if (menuInfo == null) {
      sysMenuInfo = SysMenu();
      sysMenuInfo!.parentId = parentMenu!.menuId;
      sysMenuInfo!.parentName = parentMenu.menuName;
      //父部门不是跟节点则不赋值，让用户选择
      sysMenuInfo!.menuType = LocalDictLib.KEY_MENU_TYPE_MULU;
      sysMenuInfo!.isFrame = LocalDictLib.KEY_SYS_YES_NO_INT_N;
      sysMenuInfo!.isCache = LocalDictLib.KEY_SYS_YES_NO_INT_Y;
      sysMenuInfo!.visible = LocalDictLib.KEY_SYS_SHOW_HIDE_S;
      sysMenuInfo!.status = LocalDictLib.KEY_SYS_NORMAL_DISABLE_NORMAL;
      sysMenuInfo!.orderNum = 0;
      setLoadingStatusWithNotify(LoadingStatus.success, notify: false);
    } else {
      MenuRepository.getInfo(menuInfo.menuId!, defCancelToken, fillParentName: true).then((result) {
        sysMenuInfo = result.data;
        setLoadingStatus(LoadingStatus.success);
      }, onError: BaseDio.errProxyFunc(onError: (error) {
        if (error.isUnauthorized()) {
          return;
        }
        finish();
      }));
    }
  }

  //选择父节点
  void onSelectParentMenu() {
    pushNamed(MenuListSelectSinglePage.routeName, arguments: {
      ConstantBase.KEY_INTENT_TITLE: S.current.sys_label_menu_parent_name_select,
      ConstantSys.KEY_MENU_ID: sysMenuInfo?.menuId ?? -1
    }).then((result) {
      if (result != null) {
        setSelectParentMenu(result);
      }
    });
  }

  void setSelectParentMenu(SysMenu? sysMenu) {
    sysMenuInfo!.parentId = sysMenu?.menuId;
    sysMenuInfo!.parentName = sysMenu?.menuName;
    _formKey.currentState?.patchField("parentName", sysMenuInfo!.parentName);
    applyInfoChange();
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
    return _formKey.currentState?.validate() ?? false;
  }

  void onSave() {
    if (!_checkSaveParams()) {
      AppToastUtil.showToast(msg: S.current.app_label_form_check_hint);
      return;
    }
    showLoading(text: S.current.label_save_ing);
    MenuRepository.submit(sysMenuInfo!, defCancelToken).then((value) {
      AppToastUtil.showToast(msg: S.current.label_submitted_success);
      dismissLoading();
      //保存成功后要设置
      _infoChange = false;
      finish(result: sysMenuInfo);
    }, onError: BaseDio.errProxyFunc(onError: (error) {
      dismissLoading();
    }));
  }

  //删除菜单
  void onDelete() {
    showLoading(text: S.current.label_delete_ing);
    MenuRepository.delete(defCancelToken, menuId: sysMenuInfo!.menuId).then((value) {
      dismissLoading();
      AppToastUtil.showToast(msg: S.current.label_delete_success);
      finish(result: true);
    },
        onError: BaseDio.errProxyFunc(
            defErrMsg: S.current.label_delete_failed,
            onError: (error) {
              dismissLoading();
            }));
  }
}

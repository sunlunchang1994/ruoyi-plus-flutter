//个人资料
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_slc_boxes/flutter/slc/common/text_util.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/dimens.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/styles.dart';
import 'package:form_builder_image_picker/form_builder_image_picker.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';
import 'package:ruoyi_plus_flutter/code/base/ui/utils/fast_dialog_utils.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/utils/app_toast.dart';
import 'package:ruoyi_plus_flutter/code/feature/bizapi/user/repository/remote/user_profile_api.dart';
import 'package:ruoyi_plus_flutter/code/feature/component/dict/entity/tree_dict.dart';
import 'package:ruoyi_plus_flutter/code/feature/component/dict/repository/local/local_dict_lib.dart';
import 'package:ruoyi_plus_flutter/code/feature/component/dict/utils/dict_ui_utils.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/widget/form/form_operate_with_provider.dart';
import 'package:ruoyi_plus_flutter/res/dimens.dart';
import '../../../../../base/api/result_entity.dart';
import '../../../../../lib/fast/widget/form/image_picker/form_builder_single_image_picker.dart';
import '../../../../../lib/fast/widget/form/fast_form_builder_text_field.dart';
import '../../../../../base/vm/global_vm.dart';
import '../../../../../feature/component/crop/crop_image.dart';
import '../../../../../feature/bizapi/user/entity/avatar_vo.dart';
import '../../../../../feature/bizapi/user/entity/user.dart';
import 'package:provider/provider.dart';

import '../../../../../../generated/l10n.dart';
import '../../../../../base/ui/app_mvvm.dart';

class ProfilePage extends AppBaseStatelessWidget<_ProfileModel> {
  static const String routeName = '/profile';

  final String title = S.current.app_label_personal_information;

  ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => _ProfileModel(),
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
              if (getVm().canPop()) {
                Navigator.pop(context);
                return;
              }
              //没有保存则显示提示保存对话框
              _showPromptSaveDialog(context);
            },
            child: Scaffold(
                appBar: AppBar(title: Text(title), actions: [
                  IconButton(
                      onPressed: () {
                        getVm().save();
                      },
                      icon: const Icon(Icons.save))
                ]),
                body: KeyboardAvoider(
                    autoScroll: true,
                    child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: SlcDimens.appDimens16),
                        child: FormBuilder(
                            key: getVm().formOperate.formKey,
                            child: Column(
                              children: [
                                FormBuilderSingleImagePicker(
                                  name: 'avatar',
                                  initialValue: getVm().userInfo.avatar,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  previewWidth: 96,
                                  previewHeight: 96,
                                  placeholderImage: const AssetImage(
                                      "assets/images/slc/app_ic_def_user_head.png"),
                                  imageErrorBuilder: (
                                    context,
                                    error,
                                    stackTrace,
                                  ) {
                                    return Image.asset(
                                        "assets/images/slc/app_ic_def_user_head.png",
                                        width: 96,
                                        height: 96);
                                  },
                                  //TODO 此处应该加个缓存，内部的FadeInImage改成CachedNetworkImage
                                  transformImageWidget: (context, child) {
                                    return ClipRRect(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(AppDimens
                                                .userMineAvatarRadius)),
                                        child: child);
                                  },
                                  decoration: InputDecoration(
                                    labelText: S.current.user_label_avatar,
                                  ),
                                  onImageSelect: (image) async {
                                    if (image == null) {
                                      return Future.value(null);
                                    }
                                    String? cropImagePath =
                                        await Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                      return CropImage(image);
                                    }));
                                    XFile imageXFile = cropImagePath == null
                                        ? image
                                        : XFile(cropImagePath);
                                    getVm().onSelectAvatarPath(imageXFile.path);
                                    return imageXFile;
                                  },
                                ),
                                SlcStyles.getSizedBox(
                                    height: SlcDimens.appDimens16),
                                FormBuilderTextField(
                                    name: "nickName",
                                    initialValue: getVm().userInfo.nickName,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    decoration: MyInputDecoration(
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.always,
                                        labelText:
                                            S.of(context).user_label_nike_name,
                                        hintText: S
                                            .of(context)
                                            .app_label_please_input,
                                        border: const UnderlineInputBorder()),
                                    onChanged: (value) {
                                      getVm().applyInfoChange();
                                      getVm().userInfo.nickName = value;
                                    }),
                                SlcStyles.getSizedBox(
                                    height: SlcDimens.appDimens16),
                                FormBuilderTextField(
                                    name: "phonenumber",
                                    initialValue: getVm().userInfo.phonenumber,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    decoration: MyInputDecoration(
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.always,
                                        labelText: S
                                            .of(context)
                                            .user_label_phone_number,
                                        hintText: S
                                            .of(context)
                                            .app_label_please_input,
                                        border: const UnderlineInputBorder()),
                                    onChanged: (value) {
                                      getVm().applyInfoChange();
                                      getVm().userInfo.phonenumber = value;
                                    }),
                                SlcStyles.getSizedBox(
                                    height: SlcDimens.appDimens16),
                                FormBuilderTextField(
                                    name: "email",
                                    initialValue: getVm().userInfo.email,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    decoration: MyInputDecoration(
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.always,
                                        labelText:
                                            S.of(context).user_label_mailbox,
                                        hintText: S
                                            .of(context)
                                            .app_label_please_input,
                                        border: const UnderlineInputBorder()),
                                    onChanged: (value) {
                                      getVm().applyInfoChange();
                                      getVm().userInfo.email = value;
                                    }),
                                SlcStyles.getSizedBox(
                                    height: SlcDimens.appDimens16),
                                MyFormBuilderSelect(
                                    name: "sex",
                                    initialValue: getVm().userInfo.sexName,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    onTap: () => _showSelectSexDialog(context),
                                    decoration: MySelectDecoration(
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.always,
                                        labelText: S.of(context).user_label_sex,
                                        hintText: S
                                            .of(context)
                                            .app_label_please_input,
                                        border: const UnderlineInputBorder())),
                              ],
                            ))))));
      },
    );
  }

  ///显示选择性别对话框
  void _showSelectSexDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          List<SimpleDialogOption> dialogItem = DictUiUtils.dictList2DialogItem(
              context, LocalDictLib.DICT_MAP[LocalDictLib.CODE_SEX]!, (value) {
            //选择后设置性别
            getVm().setSelectSex(value);
          });
          return SimpleDialog(
              title: Text(S.current.user_label_sex_select_prompt),
              children: dialogItem);
        });
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

class _ProfileModel extends AppBaseVm {
  final CancelToken cancelToken = CancelToken();

  final FormOperateWithProvider formOperate = FormOperateWithProvider();

  late User userInfo;

  String? _selectAvatarPath;

  bool _infoChange = false;

  void initVm() {
    userInfo = User.copyUser(GlobalVm().userShareVm.userInfoOf.value!.user);
    userInfo.sexName =
        LocalDictLib.findDictByCodeKey(LocalDictLib.CODE_SEX, userInfo.sex)
            ?.tdDictLabel;
  }

  void onSelectAvatarPath(String selectAvatarPath) {
    _selectAvatarPath = selectAvatarPath;
    applyInfoChange();
  }

  //选择性别
  void setSelectSex(ITreeDict<dynamic> item) {
    userInfo.sex = item.tdDictValue!;
    userInfo.sexName = item.tdDictLabel!;
    formOperate.patchField("sex", userInfo.sexName);
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
    return TextUtil.isNotEmpty(userInfo.nickName) &&
        TextUtil.isNotEmpty(userInfo.email) &&
        TextUtil.isNotEmpty(userInfo.phonenumber) &&
        TextUtil.isNotEmpty(userInfo.sex);
  }

  void save() {
    if (!_checkSaveParams()) {
      AppToastBridge.showToast(
          msg: S.current.app_label_required_information_cannot_be_empty);
      return;
    }
    showLoading(text: S.current.label_save_ing);
    if (_selectAvatarPath != null) {
      UserProfileServiceRepository.avatar(_selectAvatarPath!).then(
          (IntensifyEntity<AvatarVo> value) {
        //提交成功了设置头像路径为空，防止后续提交信息时重复提交
        _selectAvatarPath = null;
        //AppToastBridge.showToast(msg: S.current.user_label_avatar_uploaded_success);
        //dismissLoading();
        _saveProfile();
      }, onError: (e) {
        AppToastBridge.showToast(
            msg: S.current.user_label_avatar_upload_failed);
        dismissLoading();
      });
      return;
    }
    _saveProfile();
  }

  void _saveProfile() {
    //上传用户信息
    UserProfileServiceRepository.updateProfile(userInfo.nickName!,
            userInfo.email!, userInfo.phonenumber!, userInfo.sex!)
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
    });
  }

  @override
  void dispose() {
    cancelToken.cancel("dispose");
    super.dispose();
  }
}

//个人资料
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_slc_boxes/flutter/slc/dialog/dialog_loading_vm.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/dimens.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/styles.dart';
import 'package:form_builder_image_picker/form_builder_image_picker.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';
import 'package:ruoyi_plus_flutter/code/base/utils/app_toast.dart';
import 'package:ruoyi_plus_flutter/code/extras/user/repository/remote/user_profile_api.dart';
import 'package:ruoyi_plus_flutter/res/dimens.dart';
import '../../../base/api/result_entity.dart';
import '../../../base/ui/widget/form_builder_image_picker/form_builder_single_image_picker.dart';
import '../../../base/ui/widget/my_form_builder_text_field.dart';
import '../../../base/vm/global_vm.dart';
import '../../../extras/component/crop/crop_image.dart';
import '../../../extras/user/entity/avatar_vo.dart';
import '../../../extras/user/entity/user.dart';
import 'package:provider/provider.dart';

import '../../../../generated/l10n.dart';
import '../../../base/ui/app_mvvm.dart';

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
              _showPromptSaveDialog();
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
                        padding: EdgeInsets.symmetric(horizontal: SlcDimens.appDimens16),
                        child: FormBuilder(
                            child: Column(
                          children: [
                            FormBuilderSingleImagePicker(
                              name: 'avatar',
                              initialValue: getVm().userInfo.avatar,
                              previewWidth: 96,
                              previewHeight: 96,
                              placeholderImage:
                                  const AssetImage("assets/images/slc/app_ic_def_user_head.png"),
                              imageErrorBuilder: (
                                context,
                                error,
                                stackTrace,
                              ) {
                                return Image.asset("assets/images/slc/app_ic_def_user_head.png",
                                    width: 96, height: 96);
                              },
                              //TODO 此处加个缓存，内部的FadeInImage改成CachedNetworkImage
                              transformImageWidget: (context, child) {
                                return ClipRRect(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(AppDimens.appAvatarRadius)),
                                    child: child);
                              },
                              decoration: InputDecoration(
                                labelText: S.current.user_label_avatar,
                                hintText: S.current.user_label_select_tenant,
                              ),
                              onImageSelect: (image) async {
                                if (image == null) {
                                  return Future.value(null);
                                }
                                String? cropImagePath =
                                    await Navigator.push(context, MaterialPageRoute(builder: (context) {
                                  return CropImage(image);
                                }));
                                XFile imageXFile = cropImagePath == null ? image : XFile(cropImagePath);
                                getVm().onSelectAvatarPath(imageXFile.path);
                                return imageXFile;
                              },
                            ),
                            SlcStyles.getSizedBox(height: SlcDimens.appDimens16),
                            Selector<_ProfileModel, String?>(builder: (context, value, child) {
                              return FormBuilderTextField(
                                  name: "nickName",
                                  controller: TextEditingController(text: value),
                                  decoration: MyInputDecoration(
                                      contentPadding: EdgeInsets.zero,
                                      floatingLabelBehavior: FloatingLabelBehavior.always,
                                      labelText: S.of(context).user_label_nike_name,
                                      hintText: S.of(context).app_label_please_input,
                                      border: const UnderlineInputBorder()),
                                  onChanged: (value) {
                                    getVm().applyInfoChange();
                                    getVm().userInfo.nickName = value;
                                  });
                            }, selector: (context, vm) {
                              return vm.userInfo.nickName;
                            }, shouldRebuild: (oldVal, newVal) {
                              return oldVal != newVal;
                            }),
                            SlcStyles.getSizedBox(height: SlcDimens.appDimens16),
                            Selector<_ProfileModel, String?>(builder: (context, value, child) {
                              return FormBuilderTextField(
                                  name: "phonenumber",
                                  controller: TextEditingController(text: value),
                                  decoration: MyInputDecoration(
                                      contentPadding: EdgeInsets.zero,
                                      floatingLabelBehavior: FloatingLabelBehavior.always,
                                      labelText: S.of(context).user_label_phone_number,
                                      hintText: S.of(context).app_label_please_input,
                                      border: const UnderlineInputBorder()),
                                  onChanged: (value) {
                                    getVm().applyInfoChange();
                                    getVm().userInfo.phonenumber = value;
                                  });
                            }, selector: (context, vm) {
                              return vm.userInfo.phonenumber;
                            }, shouldRebuild: (oldVal, newVal) {
                              return oldVal != newVal;
                            }),
                            SlcStyles.getSizedBox(height: SlcDimens.appDimens16),
                            Selector<_ProfileModel, String?>(builder: (context, value, child) {
                              return FormBuilderTextField(
                                  name: "email",
                                  controller: TextEditingController(text: value),
                                  decoration: MyInputDecoration(
                                      contentPadding: EdgeInsets.zero,
                                      floatingLabelBehavior: FloatingLabelBehavior.always,
                                      labelText: S.of(context).user_label_mailbox,
                                      hintText: S.of(context).app_label_please_input,
                                      border: const UnderlineInputBorder()),
                                  onChanged: (value) {
                                    getVm().applyInfoChange();
                                    getVm().userInfo.email = value;
                                  });
                            }, selector: (context, vm) {
                              return vm.userInfo.email;
                            }, shouldRebuild: (oldVal, newVal) {
                              return oldVal != newVal;
                            }),
                            SlcStyles.getSizedBox(height: SlcDimens.appDimens16),
                            Selector<_ProfileModel, String?>(builder: (context, value, child) {
                              return FormBuilderTextField(
                                  name: "email",
                                  controller: TextEditingController(text: value),
                                  decoration: MyInputDecoration(
                                      contentPadding: EdgeInsets.zero,
                                      floatingLabelBehavior: FloatingLabelBehavior.always,
                                      labelText: S.of(context).user_label_sex,
                                      hintText: S.of(context).app_label_please_input,
                                      border: const UnderlineInputBorder()),
                                  onChanged: (value) {
                                    getVm().applyInfoChange();
                                    getVm().userInfo.sex = value;
                                  });
                            }, selector: (context, vm) {
                              return vm.userInfo.sex;
                            }, shouldRebuild: (oldVal, newVal) {
                              return oldVal != newVal;
                            }),
                          ],
                        ))))));
      },
    );
  }

  ///显示提示保存对话框
  void _showPromptSaveDialog() {}
}

class _ProfileModel extends AppBaseVm {
  final CancelToken cancelToken = CancelToken();

  late User userInfo;

  String? _selectAvatarPath;

  bool _infoChange = false;

  void initVm() {
    userInfo = User.copyUser(GlobalVm().userShareVm.userInfoOf.value!.user);
  }

  void onSelectAvatarPath(String selectAvatarPath) {
    _selectAvatarPath = selectAvatarPath;
    applyInfoChange();
  }

  //应用信息更改
  void applyInfoChange() {
    _infoChange = true;
  }

  bool canPop() {
    return !_infoChange;
  }

  void save() {
    if (_selectAvatarPath != null) {
      showLoading(text: S.current.label_save_ing);
      UserProfileServiceRepository.avatar(_selectAvatarPath!).then((IntensifyEntity<AvatarVo> value) {
        AppToastBridge.showToast(msg: S.current.user_label_avatar_uploaded_success);
        dismissLoading();
        _saveProfile();
      }, onError: (e) {
        AppToastBridge.showToast(msg: S.current.user_label_avatar_upload_failed);
        dismissLoading();
      });
      return;
    }
    _saveProfile();
    //上传文件，提交信息
    //保存成功后要设置 _infoChange=true
  }

  void _saveProfile() {
    //上传用户信息
  }

  @override
  void dispose() {
    cancelToken.cancel("cancelled");
    super.dispose();
  }
}

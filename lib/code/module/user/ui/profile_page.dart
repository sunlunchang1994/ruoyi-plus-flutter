//个人资料
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/dimens.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/styles.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';
import 'package:ruoyi_plus_flutter/res/dimens.dart';
import '../../../base/ui/widget/form_builder_image_picker/form_builder_single_image_picker.dart';
import '../../../base/ui/widget/my_form_builder_text_field.dart';
import '../../../base/vm/global_vm.dart';
import '../../../extras/component/crop/crop_image.dart';
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
        return Scaffold(
            appBar: AppBar(title: Text(title)),
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
                          placeholderImage: const AssetImage("assets/images/slc/app_ic_def_user_head.png"),
                          imageErrorBuilder: (
                            context,
                            error,
                            stackTrace,
                          ) {
                            return Image.asset("assets/images/slc/app_ic_def_user_head.png",
                                width: 96, height: 96);
                          },
                          transformImageWidget: (context, child) {
                            return ClipRRect(
                                borderRadius: BorderRadius.all(Radius.circular(AppDimens.appAvatarRadius)),
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
                            await Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return CropImage(image);
                            }));
                            return image;
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
                              onChanged: (value) => getVm().userInfo.nickName = value);
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
                              onChanged: (value) => getVm().userInfo.phonenumber = value);
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
                              onChanged: (value) => getVm().userInfo.email = value);
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
                              onChanged: (value) => getVm().userInfo.sex = value);
                        }, selector: (context, vm) {
                          return vm.userInfo.sex;
                        }, shouldRebuild: (oldVal, newVal) {
                          return oldVal != newVal;
                        }),
                      ],
                    )))));
      },
    );
  }
}

class _ProfileModel extends AppBaseVm {
  final CancelToken cancelToken = CancelToken();

  late User userInfo;

  void initVm() {
    userInfo = User.copyUser(GlobalVm().userVmBox.userInfoOf.value!.user);
  }

  @override
  void dispose() {
    cancelToken.cancel("cancelled");
    super.dispose();
  }
}

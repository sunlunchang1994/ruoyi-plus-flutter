//个人资料

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_image_picker/form_builder_image_picker.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';
import 'package:ruoyi_plus_flutter/code/base/config/env_config.dart';
import 'package:ruoyi_plus_flutter/code/extras/system/repository/remote/auth_api.dart';
import 'package:ruoyi_plus_flutter/code/extras/system/repository/remote/menu_api.dart';
import '../../../base/api/base_dio.dart';
import '../../../base/ui/widget/my_form_builder_text_field.dart';
import '../../../extras/system/entity/captcha.dart';
import '../../../extras/system/entity/login_tenant_vo.dart';
import '../../../extras/system/entity/router_vo.dart';
import '../../../extras/system/entity/tenant_list_vo.dart';
import '../../../extras/user/entity/user_info_vo.dart';
import '../../../extras/user/repository/remote/user_api.dart';
import '../../biz_main/ui/main_page.dart';
import 'package:flutter_slc_boxes/flutter/slc/common/text_util.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/dimens.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/styles.dart';
import 'package:provider/provider.dart';

import '../../../../generated/l10n.dart';
import '../../../base/api/result_entity.dart';
import '../../../base/ui/app_mvvm.dart';
import '../../../base/ui/utils/bar_utils.dart';
import '../../../base/utils/app_toast.dart';
import '../repository/local/sp_user_config.dart';

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
                child: Column(
                  children: [
                    FormBuilderImagePicker(
                      name: 'avatar',
                      previewBuilder: (ctx,children,addBtn){
                        return Text('data');
                      },
                      decoration: InputDecoration(
                        labelText: S.current.user_label_avatar,
                        hintText: S.current.user_label_select_tenant,
                      ),
                      maxImages: 1,
                    ),
                  ],
                )));
      },
    );
  }
}

class _ProfileModel extends AppBaseVm {
  final CancelToken cancelToken = CancelToken();

  void initVm() {}

  @override
  void dispose() {
    cancelToken.cancel("cancelled");
    super.dispose();
  }
}

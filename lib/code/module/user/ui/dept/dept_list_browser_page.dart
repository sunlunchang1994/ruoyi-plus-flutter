import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/colors.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/dimens.dart';
import 'package:provider/provider.dart';
import 'package:ruoyi_plus_flutter/code/base/config/constant_base.dart';
import 'package:ruoyi_plus_flutter/code/base/ui/app_mvvm.dart';
import 'package:ruoyi_plus_flutter/code/base/ui/vd/list_data_vd.dart';
import 'package:ruoyi_plus_flutter/code/extras/system/repository/remote/dept_api.dart';
import 'package:ruoyi_plus_flutter/code/extras/user/repository/remote/user_api.dart';

import '../../../../base/api/base_dio.dart';
import '../../../../base/api/result_entity.dart';
import '../../../../base/repository/remote/data_transform_utils.dart';
import '../../../../base/ui/vd/list_data_component.dart';
import '../../../../base/ui/vd/list_data_vm_box.dart';
import '../../../../base/ui/vd/refresh/content_empty.dart';
import '../../../../base/ui/widget/fast_slc_ui_box.dart';
import '../../../../extras/system/entity/router_vo.dart';
import '../../../../extras/user/entity/dept.dart';
import '../../../../extras/user/entity/dept_tree.dart';

class DeptListBrowserPage extends AppBaseStatelessWidget<_DeptListBrowserVm> {
  static const String routeName = '/dept_list_browser';

  final String title;

  DeptListBrowserPage(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => _DeptListBrowserVm(),
      builder: (context, child) {
        ThemeData themeData = Theme.of(context);
        registerEvent(context);
        getVm().initVm();
        return Scaffold(
            appBar: AppBar(title: Text(title)),
            //图标滚动使用固定大小来解决
            body: ListDataVd(getVm().listVmBox, getVm(),
                child: Consumer<_DeptListBrowserVm>(builder: (context, vm, child) {
              if (vm.listVmBox.dataList.isEmpty) {
                return const ContentEmptyWrapper();
              }
              return ListView.builder(
                clipBehavior: Clip.none,
                scrollDirection: Axis.vertical,
                padding: EdgeInsets.zero,
                itemCount: vm.listVmBox.dataList.length,
                itemBuilder: (ctx, index) {
                  Dept listItem = vm.listVmBox.dataList[index];
                  return Padding(
                      padding: const EdgeInsets.only(bottom: 1),
                      child: ListTile(
                          trailing: Ink(
                              child: InkWell(
                                  child: Padding(
                                      padding: EdgeInsets.all(SlcDimens.appDimens12),
                                      child: const Icon(Icons.chevron_right, size: 24)),
                                  onTap: () {
                                    //点击事件
                                  })),
                          contentPadding: EdgeInsets.only(left: SlcDimens.appDimens16),
                          title: Text(listItem.deptNameVo()),
                          visualDensity: VisualDensity.compact,
                          tileColor: SlcColors.getCardColorByTheme(themeData),
                          //根据card规则实现
                          onTap: () {}));
                },
              );
            })));
      },
    );
  }
}

//TODO d点击列表直接切换数据 存储上级数据列表 返回时直接获取上级加载
class _DeptListBrowserVm extends AppBaseVm {
  final FastBaseListDataVmBox<Dept> listVmBox = FastBaseListDataVmBox();

  Dept _currentSearch = Dept(parentId: ConstantBase.VALUE_PARENT_ID_DEF);

  void initVm() {
    listVmBox.setRefresh(() async {
      try {
        IntensifyEntity<List<Dept>> intensifyEntity = await DeptServiceRepository.list(_currentSearch);
        DateWrapper<List<Dept>> dateWrapper = DateTransformUtils.entity2LDWrapper(intensifyEntity);
        return dateWrapper;
      } catch (e) {
        ResultEntity resultEntity = BaseDio.getError(e);
        return DateWrapper.createFailed(code: resultEntity.code, msg: resultEntity.msg);
      }
    });
  }
}

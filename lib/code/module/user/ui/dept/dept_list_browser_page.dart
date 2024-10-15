import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ruoyi_plus_flutter/code/base/ui/app_mvvm.dart';
import 'package:ruoyi_plus_flutter/code/base/ui/vd/list_data_vd.dart';
import 'package:ruoyi_plus_flutter/code/extras/user/repository/remote/user_api.dart';

import '../../../../base/api/base_dio.dart';
import '../../../../base/api/result_entity.dart';
import '../../../../base/repository/remote/data_transform_utils.dart';
import '../../../../base/ui/vd/list_data_component.dart';
import '../../../../base/ui/vd/list_data_vm_box.dart';
import '../../../../base/ui/vd/refresh/content_empty.dart';
import '../../../../base/ui/widget/fast_slc_ui_box.dart';
import '../../../../extras/system/entity/router_vo.dart';
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
                  DeptTree listItem = vm.listVmBox.dataList[index];
                  return Padding(
                      padding: const EdgeInsets.only(bottom: 1),
                      child: Ink(
                          color: themeData.cardColor,
                          child: InkWell(
                              child: SimpleListItemLayout(
                                  child: Padding(
                                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                                      child: Text(listItem.label))),
                              onTap: () {
                                //点击事件
                              })));
                },
              );
            })));
      },
    );
  }
}

class _DeptListBrowserVm extends AppBaseVm {
  final FastBaseListDataVmBox<DeptTree> listVmBox = FastBaseListDataVmBox();

  void initVm() {
    listVmBox.setRefresh(() async {
      try {
        IntensifyEntity<List<DeptTree>> intensifyEntity = await UserServiceRepository.deptTree(null);
        DateWrapper<List<DeptTree>> dateWrapper = DateTransformUtils.entity2LDWrapper(intensifyEntity);
        return dateWrapper;
      } catch (e) {
        ResultEntity resultEntity = BaseDio.getError(e);
        return DateWrapper.createFailed(code: resultEntity.code, msg: resultEntity.msg);
      }
    });
  }
}

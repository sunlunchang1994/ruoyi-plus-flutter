import 'package:base/base/repository/remote/data_transform_utils.dart';
import 'package:boxes_flutter/flutter/slc/adapter/load_more_format.dart';
import 'package:boxes_flutter/flutter/slc/adapter/page_model.dart';
import 'package:fast/fast/provider/fast_select.dart';
import 'package:fast/fast/vd/list_data_component.dart';
import 'package:fast/fast/vd/page_data_vm_sub.dart';
import 'package:fast/fast/vd/request_token_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_extra/form/fast_form_builder_text_field.dart';
import 'package:form_extra/form/form_operate_with_provider.dart';
import 'package:form_extra/form/input_decoration_utils.dart';

import '../entity/{{feature}}.dart';
import '../repository/remote/{{feature}}_api.dart';

class {{Feature}}PageVd {
  static Widget getListWidget(ThemeData themeData, {{Feature}}PageDataVmSub listVmSub) {
    return ListView.builder(
      itemCount: listVmSub.dataList.length,
      itemBuilder: (context, index) {
        final item = listVmSub.dataList[index];
        return ListTile(
          title: Text(item.name ?? ''),
          subtitle: Text(item.remark ?? ''),
          onTap: () => listVmSub.onItemClick(index, item),
          onLongPress: () => listVmSub.onItemLongClick(index, item),
        );
      },
    );
  }

  static Widget getSearchEndDrawer(
    BuildContext context,
    ThemeData themeData,
    {{Feature}}PageDataVmSub listVmSub,
  ) {
    return Drawer(
      child: SafeArea(
        child: FormBuilder(
          key: listVmSub.formOperate.formKey,
          child: Column(
            children: [
              MyFormBuilderTextField(
                name: 'name',
                initialValue: listVmSub.currentSearch.name,
                decoration: MyInputDecoration(
                  labelText: '名称',
                  suffixIcon: NqNullSelector<{{Feature}}PageDataVmSub, String?>(
                    selector: (context, vm) => vm.currentSearch.name,
                    builder: (context, value, child) {
                      return IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          listVmSub.currentSearch.name = '';
                          listVmSub.formOperate.patchField('name', '');
                          listVmSub.notifyListeners();
                        },
                      );
                    },
                  ),
                ),
                onChanged: (value) => listVmSub.currentSearch.name = value,
              ),
              ElevatedButton(
                onPressed: () => listVmSub.sendRefreshEvent(),
                child: const Text('搜索'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class {{Feature}}PageDataVmSub extends FastBasePageDataVmSub<{{Entity}}> with CancelTokenAssist {
  final FormOperateWithProvider formOperate = FormOperateWithProvider();
  {{Entity}} currentSearch = {{Entity}}();

  @override
  Future<DataWrapper<PageModel<{{Entity}}>>> onLoadMore(LoadMoreFormat<{{Entity}}> loadMoreFormat) {
    return {{Feature}}Repository
        .list(loadMoreFormat.offset, loadMoreFormat.pageSize, currentSearch, defCancelToken)
        .then(DataTransformUtils.entity2LDWrapper);
  }
}

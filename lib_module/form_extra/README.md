# form_extra

`form_extra` 是基于 `flutter_form_builder` 的表单扩展包，用于统一 ruoyi-flutter-plus 的搜索表单、新增/编辑表单、选择输入、标签显示和单图选择。

## 当前真实能力

- `FormOperateWithProvider`：持有 `GlobalKey<FormBuilderState>`，提供 reset、clear、patch 等表单操作。
- `FormBuilderStateHelper`：给 `FormBuilderState` 增加 resetField、clearField、patchField、clearAll。
- `MyFormBuilderTextField`：保留 `FormBuilderTextField` 能力，作为项目统一文本输入入口。
- `MyFormBuilderSelect`：只读选择输入，适合点击打开选择页或弹窗。
- `MyInputDecoration`、`MySelectDecoration`：统一 content padding、suffix icon 约束、选择箭头。
- `InputDecUtils`：清除按钮、选择箭头、必填 label 等输入装饰工具。
- `VLFormBuilderFieldOption`、`OptionVL`：value/label 选项模型。
- `FormBuilderFlowTag`：把 `List<T>` 渲染成 Chip 标签流。
- `FormBuilderSingleImagePicker`：单图选择和预览，支持 XFile、Uint8List、String URL、ImageProvider、Widget、自定义显示类型。

## 标准使用

搜索表单一般放在列表页 `endDrawer` 或顶部区域，VM 持有 `FormOperateWithProvider`：

```dart
class SearchVm extends ChangeNotifier {
  final formOperate = FormOperateWithProvider();
  String? keyword;
}
```

字段写法：

```dart
MyFormBuilderTextField(
  name: 'keyword',
  decoration: MyInputDecoration(
    labelText: '关键字',
    suffixIcon: InputDecUtils.autoClearSuffixByInputVal(
      vm.keyword,
      formOperate: vm.formOperate,
      formFieldName: 'keyword',
    ),
  ),
  onChanged: (value) {
    vm.keyword = value;
    vm.notifyListeners();
  },
)
```

新增/编辑表单使用 `FormBuilder(key: vm.formOperate.formKey)`，保存前统一 `saveAndValidate()`，保存成功后 `finish(result: data)`，列表页根据返回值刷新。

## 兼容性说明

- `InputDecUtils.autoClearSuffixByInput()` 现在要求：如果没有传 `onPressed`，但传了 `formOperate`，就必须传 `formFieldName`。这避免点击清除时发生 null check 崩溃。
- `FormBuilderSingleImagePicker` 在选择结果为空时不会访问 `image.first`；异步 `onImageSelect` 返回后，如果字段已销毁，不再回写表单。
- `Uint8List` 图片预览使用 `previewHeight`，不再错误复用 `previewWidth`。
- `ImageSourceBottomSheet.preventPop` 依赖 `_isPickingImage` 的状态刷新，选择过程中会阻止关闭。

## 依赖规则

`form_extra` 直接 import 的依赖必须在自己的 `pubspec.yaml` 声明：

- `boxes_flutter`
- `flutter_form_builder`
- `form_builder_image_picker`
- `form_builder_validators`
- `cached_network_image`
- `image_picker`
- `async`
- `fast`

## 不包含的能力

当前包不包含日期时间选择、文件上传、富文本编辑、自定义验证器集合、多语言表单文案。需要这些能力时，应先补实现和示例，再写入 README 或脚手架规则。

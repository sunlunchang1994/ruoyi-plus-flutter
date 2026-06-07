// app_router.dart 中新增 import：
// import 'package:{{Module}}/{{feature}}/ui/{{feature}}_list_page.dart';
// import 'package:{{Module}}/{{feature}}/ui/{{feature}}_add_edit_page.dart';

{{Feature}}ListPage.routeName: (BuildContext context) {
  return {{Feature}}ListPage();
},

{{Feature}}AddEditPage.routeName: (BuildContext context) {
  final info = context.getSlcRouterInfo();
  return {{Feature}}AddEditPage(info?.arguments['{{entity}}']);
},

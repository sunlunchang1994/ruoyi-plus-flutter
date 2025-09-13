///@author sunlunchang
///系统层常量
class ConstantSysApi {
  ///value
  ///路由相关
  static const String VALUE_COMPONENT_LAYOUT = "Layout"; //Layout组件标识
  static const String VALUE_COMPONENT_PARENT_VIEW = "ParentView"; //ParentView组件标识
  static const String VALUE_COMPONENT_INNER_LINK = "InnerLink"; //InnerLink组件标识

  //路由信息
  static const String INTENT_KEY_ROUTER = "router";
  //菜单ID
  static const String INTENT_KEY_MENU_ID = "menuId";

  //路由
  static const String ROUTER_SETTING = '/setting/index';

  //设置-菜单-角色树选择多选
  static const String ROUTER_SETTING_MENU_ROLE_TREE_MULTIPLE_SELECT =
      '/system/menu/role_tree_multiple_select';
}

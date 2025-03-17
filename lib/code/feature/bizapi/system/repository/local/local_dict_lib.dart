import '../../../../component/dict/entity/tree_dict.dart';

class LocalDictLib {
  //系统开关
  static const String CODE_SYS_NORMAL_DISABLE = "sys_normal_disable";

  //系统开关：正常
  static const KEY_SYS_NORMAL_DISABLE_NORMAL = "0";

  //系统开关：停用
  static const KEY_SYS_NORMAL_DISABLE_STOP = "1";

  //系统是否
  static const String CODE_SYS_YES_NO = "sys_yes_no";

  //系统是否：是
  static const KEY_SYS_YES_NO_Y = "Y";

  //系统是否：否
  static const KEY_SYS_YES_NO_N = "N";

  //系统是否 整数
  static const String CODE_SYS_YES_NO_INT = "sys_yes_no_int";

  //系统是否 整：是
  static const KEY_SYS_YES_NO_INT_Y = "0";

  //系统是否 整：否
  static const KEY_SYS_YES_NO_INT_N = "1";

  //菜单显示状态
  static const String CODE_SYS_SHOW_HIDE = "sys_show_hide";

  //菜单显示状态：显示
  static const KEY_SYS_SHOW_HIDE_S = "0";

  //菜单显示状态：隐藏
  static const KEY_SYS_SHOW_HIDE_H = "1";

  //性别
  static const String CODE_SYS_USER_SEX = "sys_user_sex";

  //菜单类型
  static const String CODE_MENU_TYPE = "menu_type";

  //菜单类型：目录
  static const KEY_MENU_TYPE_MULU = "M";

  //菜单类型：菜单
  static const KEY_MENU_TYPE_CAIDAN = "C";

  //菜单类型：事件
  static const KEY_MENU_TYPE_ACTION = "F";

  //通知类型
  static const String CODE_SYS_NOTICE_TYPE = "sys_notice_type";

  //操作类型
  static const String CODE_SYS_OPER_TYPE = "sys_oper_type";

  //系统状态
  static const String CODE_SYS_COMMON_STATUS = "sys_common_status";

  //系统状态：成功
  static const KEY_SYS_COMMON_STATUS_SUCCEED = "0";

  //系统状态：失败
  static const KEY_SYS_COMMON_STATUS_FAILED = "1";

  //系统状态
  static const String CODE_ACCESS_POLICY_TYPE = "access_policy_type";

  //系统状态：私有
  static const KEY_ACCESS_POLICY_TYPE_PRIVATE = "0";

  //系统状态：公开
  static const KEY_ACCESS_POLICY_TYPE_PUBLIC = "1";

  //系统状态：自定义
  static const KEY_ACCESS_POLICY_TYPE_CUSTOM = "2";

  //授权类型
  static const String CODE_SYS_GRANT_TYPE = "sys_grant_type";

  //设备类型
  static const String CODE_SYS_DEVICE_TYPE = "sys_device_type";

  //菜单是否关联显示
  static const String CODE_MENU_CHECK_STRICTLY = "menu_check_strictly";

  //不关联
  static const KEY_MENU_CHECK_STRICTLY_N = "0";

  //关联
  static const KEY_MENU_CHECK_STRICTLY_Y = "1";

  //数据权限
  static const String CODE_ROLE_DATA_PERMISSIONS = "data_permissions";

  //关联
  static const KEY_ROLE_ALL = "1";
  static const KEY_ROLE_CUSTOMIZE = "2";
  static const KEY_ROLE_DEPT = "3";
  static const KEY_ROLE_DEPT_LEVEL = "4";
  static const KEY_ROLE_ONLY_USER = "5";
  static const KEY_ROLE_DEPT_LEVEL_OR_ONLY_USER = "6";

  static final Map<String, List<ITreeDict<dynamic>>> LOCAL_DICT_MAP = {
    CODE_SYS_YES_NO_INT: [
      TreeDict(code: CODE_SYS_YES_NO_INT, dictKey: KEY_SYS_YES_NO_INT_Y, dictValue: "是"),
      TreeDict(code: CODE_SYS_YES_NO_INT, dictKey: KEY_SYS_YES_NO_INT_N, dictValue: "否"),
    ],
    CODE_MENU_TYPE: [
      TreeDict(code: CODE_MENU_TYPE, dictKey: KEY_MENU_TYPE_MULU, dictValue: "目录"),
      TreeDict(code: CODE_MENU_TYPE, dictKey: KEY_MENU_TYPE_CAIDAN, dictValue: "菜单"),
      TreeDict(code: CODE_MENU_TYPE, dictKey: KEY_MENU_TYPE_ACTION, dictValue: "按钮"),
    ],
    CODE_ACCESS_POLICY_TYPE: [
      TreeDict(code: CODE_MENU_TYPE, dictKey: KEY_ACCESS_POLICY_TYPE_PRIVATE, dictValue: "private"),
      TreeDict(code: CODE_MENU_TYPE, dictKey: KEY_ACCESS_POLICY_TYPE_PUBLIC, dictValue: "public"),
      TreeDict(code: CODE_MENU_TYPE, dictKey: KEY_ACCESS_POLICY_TYPE_CUSTOM, dictValue: "custom"),
    ],
    CODE_MENU_CHECK_STRICTLY: [
      TreeDict(
          code: CODE_MENU_CHECK_STRICTLY, dictKey: KEY_MENU_CHECK_STRICTLY_N, dictValue: "不关联"),
      TreeDict(code: CODE_MENU_CHECK_STRICTLY, dictKey: KEY_MENU_CHECK_STRICTLY_Y, dictValue: "关联"),
    ],
    CODE_ROLE_DATA_PERMISSIONS: [
      TreeDict(code: CODE_ROLE_DATA_PERMISSIONS, dictKey: KEY_ROLE_ALL, dictValue: "全部数据权限"),
      TreeDict(code: CODE_ROLE_DATA_PERMISSIONS, dictKey: KEY_ROLE_CUSTOMIZE, dictValue: "自定义数据权限"),
      TreeDict(code: CODE_ROLE_DATA_PERMISSIONS, dictKey: KEY_ROLE_DEPT, dictValue: "本部门及以下数据权限"),
      TreeDict(
          code: CODE_ROLE_DATA_PERMISSIONS, dictKey: KEY_ROLE_DEPT_LEVEL, dictValue: "本部门数据权限"),
      TreeDict(code: CODE_ROLE_DATA_PERMISSIONS, dictKey: KEY_ROLE_ONLY_USER, dictValue: "仅本人数据权限"),
      TreeDict(
          code: CODE_ROLE_DATA_PERMISSIONS,
          dictKey: KEY_ROLE_DEPT_LEVEL_OR_ONLY_USER,
          dictValue: "本部门及以下数据权限或仅本人数据权限"),
    ]
  };
}

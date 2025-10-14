# Auth - 认证授权模块

> **Workspace 模块** | 路径: `feature/auth`

## 📦 模块概述

Auth 模块是应用的认证授权核心模块，提供用户登录、注销、Token 管理、权限验证等功能。支持多租户登录、验证码验证，为应用提供完整的身份认证和授权解决方案。

## ✨ 主要功能

### 🔐 用户认证
- **账号密码登录** - 支持用户名/密码登录
- **验证码验证** - 集成图形验证码、短信验证码
- **多租户支持** - 支持租户选择和切换
- **记住密码** - 本地保存登录信息
- **自动登录** - Token 有效期内自动登录

### 🎫 Token 管理
- **Token 存储** - 安全存储访问令牌和刷新令牌
- **Token 刷新** - 自动刷新过期 Token
- **Token 验证** - 验证 Token 有效性
- **登录状态** - 维护全局登录状态

### 👥 租户管理
- **租户列表** - 获取可用租户列表
- **租户选择** - 支持用户选择登录租户
- **租户信息** - 存储和管理租户信息

### 🚪 登录/登出
- **登录流程** - 完整的登录业务流程
- **登出处理** - 清理登录信息和缓存
- **会话管理** - 管理用户会话状态

### 🌍 国际化支持
- 中文、英文等多语言登录界面

## 🔗 依赖关系

**依赖的 workspace 模块：**
- `fast` - 快速开发工具
- `db_base` - 数据持久化
- `bizapi` - 业务 API 接口

**主要第三方依赖：**
- `provider` - 状态管理
- `retrofit` - 网络请求

## 📖 使用示例

### 1. 用户登录

```dart
import 'package:auth/auth/repository/remote/auth_api.dart';
import 'package:auth/auth/entity/login_tenant_vo.dart';

class LoginViewModel extends ChangeNotifier {
  final AuthApi authApi;
  
  LoginViewModel(this.authApi);
  
  Future<bool> login({
    required String username,
    required String password,
    String? tenantId,
    String? captchaCode,
  }) async {
    try {
      // 调用登录 API
      final result = await authApi.login(
        username: username,
        password: password,
        tenantId: tenantId,
        code: captchaCode,
      );
      
      if (result.isSuccess && result.data != null) {
        // 保存 Token
        await _saveToken(result.data!.accessToken);
        // 保存用户信息
        await _saveUserInfo(result.data!);
        return true;
      }
      return false;
    } catch (e) {
      print('登录失败: $e');
      return false;
    }
  }
  
  Future<void> _saveToken(String token) async {
    await DbSp.setString('access_token', token);
  }
  
  Future<void> _saveUserInfo(LoginTenantVo userInfo) async {
    // 保存用户信息到本地
  }
}
```

### 2. 获取验证码

```dart
import 'package:auth/auth/repository/remote/auth_api.dart';
import 'package:auth/auth/entity/captcha.dart';

Future<Captcha?> getCaptcha() async {
  try {
    final result = await authApi.getCaptcha();
    if (result.isSuccess) {
      return result.data;
    }
  } catch (e) {
    print('获取验证码失败: $e');
  }
  return null;
}

// 在 UI 中显示验证码
Widget buildCaptcha() {
  return FutureBuilder<Captcha?>(
    future: getCaptcha(),
    builder: (context, snapshot) {
      if (snapshot.hasData && snapshot.data != null) {
        final captcha = snapshot.data!;
        return Image.memory(
          base64Decode(captcha.img),
          width: 120,
          height: 40,
        );
      }
      return CircularProgressIndicator();
    },
  );
}
```

### 3. 租户选择

```dart
import 'package:auth/auth/repository/remote/auth_api.dart';
import 'package:auth/auth/entity/login_tenant_vo.dart';

class TenantSelectorPage extends StatefulWidget {
  @override
  State<TenantSelectorPage> createState() => _TenantSelectorPageState();
}

class _TenantSelectorPageState extends State<TenantSelectorPage> {
  List<TenantInfo> tenants = [];
  String? selectedTenantId;
  
  @override
  void initState() {
    super.initState();
    _loadTenants();
  }
  
  Future<void> _loadTenants() async {
    try {
      final result = await authApi.getTenantList();
      if (result.isSuccess && result.data != null) {
        setState(() {
          tenants = result.data!;
        });
      }
    } catch (e) {
      print('加载租户列表失败: $e');
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: tenants.length,
      itemBuilder: (context, index) {
        final tenant = tenants[index];
        return ListTile(
          title: Text(tenant.tenantName),
          subtitle: Text(tenant.tenantId),
          selected: selectedTenantId == tenant.tenantId,
          onTap: () {
            setState(() {
              selectedTenantId = tenant.tenantId;
            });
            Navigator.pop(context, tenant.tenantId);
          },
        );
      },
    );
  }
}
```

### 4. 检查登录状态

```dart
class AuthManager {
  static final AuthManager instance = AuthManager._();
  AuthManager._();
  
  // 检查是否已登录
  Future<bool> isLoggedIn() async {
    final token = await DbSp.getString('access_token');
    if (token == null || token.isEmpty) {
      return false;
    }
    
    // 验证 Token 是否有效
    return await _validateToken(token);
  }
  
  Future<bool> _validateToken(String token) async {
    try {
      // 调用 API 验证 Token
      final result = await authApi.validateToken(token);
      return result.isSuccess;
    } catch (e) {
      return false;
    }
  }
  
  // 获取当前 Token
  Future<String?> getToken() async {
    return await DbSp.getString('access_token');
  }
  
  // 登出
  Future<void> logout() async {
    // 清除本地存储的 Token 和用户信息
    await DbSp.remove('access_token');
    await DbSp.remove('refresh_token');
    await DbSp.remove('user_info');
    
    // 调用服务端登出接口
    try {
      await authApi.logout();
    } catch (e) {
      print('登出失败: $e');
    }
  }
}
```

### 5. 完整的登录页面示例

```dart
import 'package:flutter/material.dart';
import 'package:auth/auth/ui/login_page.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RuoYi App',
      home: FutureBuilder<bool>(
        future: AuthManager.instance.isLoggedIn(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SplashScreen();
          }
          
          if (snapshot.data == true) {
            // 已登录，跳转到主页
            return HomePage();
          } else {
            // 未登录，显示登录页
            return LoginPage();
          }
        },
      ),
    );
  }
}
```

### 6. Token 自动刷新

```dart
import 'package:dio/dio.dart';

class TokenInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // 添加 Token 到请求头
    final token = await AuthManager.instance.getToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
  
  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // Token 过期，尝试刷新
    if (err.response?.statusCode == 401) {
      final refreshed = await _refreshToken();
      if (refreshed) {
        // 重试原请求
        final options = err.requestOptions;
        final token = await AuthManager.instance.getToken();
        options.headers['Authorization'] = 'Bearer $token';
        
        try {
          final response = await Dio().fetch(options);
          handler.resolve(response);
          return;
        } catch (e) {
          // 重试失败
        }
      }
      
      // Token 刷新失败，跳转到登录页
      await AuthManager.instance.logout();
      // 导航到登录页...
    }
    
    handler.next(err);
  }
  
  Future<bool> _refreshToken() async {
    try {
      final refreshToken = await DbSp.getString('refresh_token');
      if (refreshToken == null) return false;
      
      final result = await authApi.refreshToken(refreshToken);
      if (result.isSuccess && result.data != null) {
        await DbSp.setString('access_token', result.data!.accessToken);
        return true;
      }
    } catch (e) {
      print('Token 刷新失败: $e');
    }
    return false;
  }
}
```

## 🎯 核心类说明

| 类名 | 路径 | 说明 |
|-----|------|-----|
| `AuthApi` | `auth/repository/remote/auth_api.dart` | 认证相关 API 接口 |
| `LoginPage` | `auth/ui/login_page.dart` | 登录页面 |
| `Captcha` | `auth/entity/captcha.dart` | 验证码实体 |
| `LoginTenantVo` | `auth/entity/login_tenant_vo.dart` | 登录返回数据 |

## 🚀 使用方式

在根目录 `pubspec.yaml` 中已配置为 workspace 成员，其他模块可直接引用：

```yaml
dependencies:
  auth:  # 自动使用 workspace 版本
```

## 📝 开发命令

```bash
# 进入模块目录
cd feature/auth

# 获取依赖
flutter pub get

# 生成代码（Retrofit、JsonSerializable 等）
dart run build_runner build --delete-conflicting-outputs

# 生成国际化文件
flutter gen-l10n
```

**或使用项目根目录的批量脚本：**

```bash
./scripts/pub_get_all.sh       # 所有模块获取依赖
./scripts/build_runner_all.sh  # 所有模块代码生成
./scripts/gen_l10n_all.sh      # 所有模块国际化生成
```

## 🏗️ 模块结构

```
auth/
├── lib/
│   ├── auth/
│   │   ├── entity/              # 数据实体
│   │   │   ├── captcha.dart     # 验证码
│   │   │   └── login_tenant_vo.dart  # 登录数据
│   │   ├── repository/
│   │   │   └── remote/
│   │   │       └── auth_api.dart     # 认证 API
│   │   └── ui/
│   │       └── login_page.dart  # 登录页面
│   ├── gen/                     # 生成的代码
│   │   └── l10n/                # 国际化
│   └── l10n/                    # 国际化源文件
└── pubspec.yaml                 # 模块配置
```

## 🔄 与其他模块的关系

```
auth (本模块)
 ├─ 被依赖: biz_main, system, user
 ├─ 依赖: fast, db_base, bizapi
 └─ 作用: 为应用提供认证和授权功能
```

## 💡 最佳实践

1. **安全存储 Token** - 使用加密存储敏感信息
2. **Token 自动刷新** - 在拦截器中实现 Token 自动刷新
3. **统一登录状态** - 使用全局状态管理登录状态
4. **错误处理** - 妥善处理网络错误和认证失败
5. **会话超时** - 实现会话超时自动跳转登录
6. **多租户支持** - 合理处理租户切换逻辑

## 🔒 安全建议

- 密码传输前加密处理
- Token 使用 HTTPS 传输
- 实现登录失败次数限制
- 支持双因素认证（2FA）
- 定期更新 Token
- 及时清理过期会话

---

*本模块是 Flutter Workspace 架构的一部分，依赖版本统一在根目录 `pubspec.yaml` 管理。*

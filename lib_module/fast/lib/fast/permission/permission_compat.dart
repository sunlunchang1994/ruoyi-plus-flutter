import 'dart:async';
import 'dart:io';

import 'package:fast/gen/fast_l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:permission_handler/permission_handler.dart';

/// 权限兼容类
class PermissionCompat {
  //仅android执行
  static Future<PermissionStatus> get requestStorage async {
    if (Platform.isAndroid) {
      PermissionStatus status = await Permission.manageExternalStorage.request();
      if (!status.isGranted) {
        status = await Permission.storage.request();
      }
      return status;
    }
    //其他情况暂时允许
    return PermissionStatus.granted;
  }

  static Future<bool> ensureMustStoragePermission(BuildContext context) async {
    PermissionStatus status = await requestStorage;
    if (status.isGranted) {
      return true;
    }

    while (context.mounted && !status.isGranted) {
      final nextStatus = await _showStoragePermissionDialog(context);
      if (nextStatus == null) {
        break;
      }
      status = nextStatus;
    }
    return status.isGranted;
  }

  static Future<PermissionStatus?> _showStoragePermissionDialog(BuildContext context) {
    final completer = Completer<PermissionStatus?>();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!context.mounted) {
        if (!completer.isCompleted) {
          completer.complete(null);
        }
        return;
      }
      final result = await showDialog<PermissionStatus>(
        context: context,
        barrierDismissible: false,
        builder: (ctx) {
          final l10n = FastS.current;
          return AlertDialog(
            title: Text(l10n.title_permission_storage_required),
            content: Text(l10n.label_permission_storage_required),
            actions: [
              TextButton(
                onPressed: () async {
                  final newStatus = await requestStorage;
                  if (ctx.mounted && Navigator.of(ctx).canPop()) {
                    Navigator.of(ctx).pop(newStatus);
                  }
                },
                child: Text(l10n.action_permission_retry),
              ),
              TextButton(
                onPressed: () async {
                  await openAppSettings();
                  final newStatus = await requestStorage;
                  if (ctx.mounted && Navigator.of(ctx).canPop()) {
                    Navigator.of(ctx).pop(newStatus);
                  }
                },
                child: Text(l10n.action_permission_open_settings),
              ),
            ],
          );
        },
      );
      if (!completer.isCompleted) {
        completer.complete(result);
      }
    });
    return completer.future;
  }
}

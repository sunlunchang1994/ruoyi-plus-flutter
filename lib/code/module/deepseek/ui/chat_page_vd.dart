import 'package:flutter/material.dart';
import 'package:flutter_slc_boxes/flutter/slc/common/log_util.dart';
import 'package:flutter_slc_boxes/flutter/slc/common/screen_util.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/theme_extension.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/utils/app_toast.dart';
import 'package:ruoyi_plus_flutter/code/module/deepseek/config/constant_deep_seek.dart';
import 'package:ruoyi_plus_flutter/code/module/deepseek/utils/ChatUtils.dart';

import '../../../lib/deepseek/models.dart';
import '../../../lib/fast/vd/list_data_vm_sub.dart';
import '../../../lib/fast/vd/refresh/content_empty.dart';
import '../../../lib/fast/vd/request_token_manager.dart';
import '../entity/MyChatMessage.dart';
import '../repository/deep_seek_repository.dart';

class ChatListPageWidget {
  ///数据列表控件
  static Widget getDataListWidget(ThemeData themeData, ChatListDataVmSub listVmSub) {
    if (listVmSub.dataList.isEmpty) {
      return const ContentEmptyWrapper();
    }
    return ListView.separated(
        clipBehavior: Clip.none,
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.zero,
        itemCount: listVmSub.dataList.length,
        itemBuilder: (ctx, index) {
          MyChatMessage listItem = listVmSub.dataList[index];
          return getDataListItem(themeData, listVmSub, index, listItem);
        },
        separatorBuilder: (context, index) {
          return themeData.slcTidyUpStyle.getDefDividerByTheme(themeData);
        });
  }

  static Widget getDataListItem(
      ThemeData themeData, ChatListDataVmSub listVmSub, int index, MyChatMessage chatMessage) {
    if (chatMessage.isUser) {
      return Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
        Container(
            width: ScreenUtil.getInstance().screenWidthDpr * 0.7,
            color: Colors.blue,
            child: Text(chatMessage.content))
      ]);
    } else if (chatMessage.isSystem) {
      return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
            width: ScreenUtil.getInstance().screenWidthDpr * 0.7,
            color: Colors.red,
            child: Text(chatMessage.content))
      ]);
    } else {
      return Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Container(
            width: ScreenUtil.getInstance().screenWidthDpr * 0.7,
            color: Colors.green,
            child: Text(chatMessage.content))
      ]);
    }
  }
}

///部门树数据VmSub
class ChatListDataVmSub extends FastBaseListDataVmSub<MyChatMessage> with CancelTokenAssist {
  void sendChat(String content) {
    DeepSeekRepository.createChatCompletion(
            ChatCompletionRequest(
              model: 'deepseek-chat',
              messages: [ChatMessage(role: 'user', content: content)],
              //temperature: 0.7,
              maxTokens: 100,
              stream: true,
            ),
            cancelToken: defCancelToken)
        .listen((result) {
      onSucceed([...dataList,result]);
      LogUtil.d(result.content);
    }, onError: (e) {});
  }

  @override
  void onCleared() {
    CancelTokenAssist.cancelAllIf(this, "VmSub dispose");
    super.onCleared();
  }
}

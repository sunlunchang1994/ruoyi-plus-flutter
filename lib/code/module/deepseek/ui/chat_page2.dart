import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_slc_boxes/flutter/slc/common/log_util.dart';
import 'package:flutter_slc_boxes/flutter/slc/common/screen_util.dart';
import 'package:flutter_slc_boxes/flutter/slc/common/text_util.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/dimens.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/theme_extension.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/theme_util.dart';
import 'package:provider/provider.dart';
import 'package:ruoyi_plus_flutter/code/base/repository/local/app_config.dart';
import 'package:ruoyi_plus_flutter/code/base/ui/app_mvvm.dart';
import 'package:ruoyi_plus_flutter/code/base/vm/global_vm.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/utils/app_toast.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/utils/widget_utils.dart';
import 'package:ruoyi_plus_flutter/code/module/deepseek/config/constant_deep_seek.dart';
import 'package:ruoyi_plus_flutter/code/module/deepseek/ui/scroll_controller_wrap.dart';
import 'package:ruoyi_plus_flutter/code/module/system/ui/router/router_grid.dart';

import '../../../../generated/assets.dart';
import '../../../../generated/l10n.dart';
import '../../../base/ui/utils/fast_dialog_utils.dart';
import '../../../feature/component/tree/vd/tree_data_list_vd.dart';
import '../../../lib/deepseek/models.dart';
import '../../../lib/fast/provider/fast_select.dart';
import '../../../lib/fast/provider/should_set_state.dart';
import '../../../lib/fast/vd/list_data_vd.dart';
import '../../../lib/fast/vd/list_data_vm_sub.dart';
import '../../../lib/fast/vd/request_token_manager.dart';
import '../entity/MyChatMessage.dart';
import '../repository/deep_seek_repository.dart';
import 'chat_page_vd.dart';

class ChatPage2 extends StatefulWidget {
  const ChatPage2({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ChatState();
  }
}

class _ChatState extends AppBaseState<ChatPage2, _ChatStateVm2> with AutomaticKeepAliveClientMixin {
  final TextEditingController inputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(create: (context) {
      return _ChatStateVm2();
    }, builder: (context, child) {
      ThemeData themeData = Theme.of(context);
      registerEvent(context);
      getVm().initVm();
      return Scaffold(
          appBar: AppBar(
              title: Text(S.current.main_label_ai_chat),
              titleSpacing: NavigationToolbar.kMiddleSpacing,
              actions: [
                NqSelector<_ChatStateVm2, bool>(builder: (context, value, child) {
                  if (value) {
                    return TextButton(
                        onPressed: () {
                          getVm().newDialog();
                        },
                        child: Text(S.current.main_action_new_dialog));
                  } else {
                    return TextButton(
                        onPressed: () {
                          showConfigApiKeyDialog(context);
                        },
                        child: Text(S.current.main_action_config_api_key));
                  }
                }, selector: (context, vm) {
                  return TextUtil.isNotEmpty(vm.getApiKey());
                }),
                NqSelector<_ChatStateVm2, bool>(builder: (context, value, child) {
                  if (value) {
                    return PopupMenuButton(itemBuilder: (context) {
                      return [
                        PopupMenuItem(
                            child: Text(S.current.main_action_config_api_key),
                            onTap: () {
                              showConfigApiKeyDialog(context);
                            })
                      ];
                    });
                  } else {
                    return SizedBox.shrink();
                  }
                }, selector: (context, vm) {
                  return TextUtil.isNotEmpty(vm.getApiKey());
                })
              ]),
          //图标滚动使用固定大小来解决
          body: Column(children: [
            Expanded(
                child: NqSelector<_ChatStateVm2, int>(builder: (context, value, child) {
              if (TextUtil.isEmpty(getVm().getApiKey())) {
                return Padding(
                    padding: EdgeInsets.all(SlcDimens.appDimens16),
                    child: Center(child: Text(S.current.main_label_ai_chat_hint_not_api_key)));
              }
              if (getVm().dataList.isEmpty) {
                return Padding(
                    padding: EdgeInsets.all(SlcDimens.appDimens16),
                    child: Center(child: Text(S.current.main_label_no_chat_hint)));
              }
              return ListView.separated(
                  controller: getVm().scrollControllerWrap.scrollController,
                  clipBehavior: Clip.hardEdge,
                  scrollDirection: Axis.vertical,
                  padding: EdgeInsets.zero,
                  itemCount: getVm().dataList.length,
                  itemBuilder: (ctx, index) {
                    MyChatMessage listItem = getVm().dataList[index];
                    return getDataListItem(themeData, index, listItem);
                  },
                  separatorBuilder: (context, index) {
                    return ThemeUtil.getSizedBox(height: 10);
                  });
            }, selector: (context, vm) {
              return getVm().shouldSetState.version;
            })),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(crossAxisAlignment: CrossAxisAlignment.end, spacing: 10, children: [
                  Expanded(
                      child: Container(
                          decoration: BoxDecoration(
                              color: themeData.colorScheme.surfaceContainer,
                              borderRadius: BorderRadius.all(Radius.circular(12))),
                          constraints: BoxConstraints(minHeight: 35),
                          alignment: Alignment.centerLeft,
                          child: TextField(
                            focusNode: getVm().inputFocusNode,
                              minLines: 1,
                              maxLines: 5,
                              keyboardType: TextInputType.multiline,
                              textInputAction: TextInputAction.newline,
                              controller: inputController,
                              textAlignVertical: TextAlignVertical.center,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: S.current.main_label_send_msg_hint,
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(horizontal: 12))))),
                  SizedBox(
                      height: 36,
                      child: NqSelector<_ChatStateVm2, bool>(builder: (context, value, child) {
                        return FilledButton(
                            style: TextButton.styleFrom(enableFeedback: !value),
                            onPressed: value
                                ? null
                                : () {
                                    if (TextUtil.isEmpty(inputController.text)) {
                                      AppToastUtil.showToast(
                                          msg: S.current.label_content_cannot_be_empty_blank);
                                      return;
                                    }
                                    getVm().inputFocusNode.unfocus();
                                    getVm().sendChat(inputController.text);
                                    inputController.text = '';
                                  },
                            child: Text(S.current.action_send));
                      }, selector: (context, vm) {
                        return vm.generating;
                      }))
                ])),
          ]));
    });
  }

  static Widget getDataListItem(ThemeData themeData, int index, MyChatMessage chatMessage) {
    return SizedBox(
        width: double.infinity,
        child: Align(
            alignment: () {
              if (chatMessage.isUser) {
                return Alignment.centerRight;
              } else {
                return Alignment.centerLeft;
              }
            }.call(),
            child: () {
              if (chatMessage.isUser) {
                return ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: ScreenUtil.getInstance().screenWidthDpr * 0.8, // 设置最大宽度
                    ),
                    child: Container(
                        margin: const EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                            color: themeData.colorScheme.surfaceContainer,
                            borderRadius: BorderRadius.all(Radius.circular(16))),
                        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                        child: MarkdownBody(data: chatMessage.content, fitContent: true)));
              } else {
                return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: () {
                      return Row(
                          spacing: 10,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                                backgroundColor: themeData.colorScheme.primaryContainer,
                                radius: 12,
                                child: Image.asset(Assets.icLauncher,
                                    width: 12, height: 12, fit: BoxFit.contain)),
                            Expanded(
                                child: Container(
                                    constraints: BoxConstraints(minHeight: 24),
                                    alignment: Alignment.centerLeft,
                                    child: MarkdownBody(data: chatMessage.content)))
                          ]);
                    }.call());
              }
            }.call()));
  }

  void showConfigApiKeyDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          final TextEditingController inputController = TextEditingController();
          inputController.text = getVm().getApiKey();
          return AlertDialog(
              title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(S.current.label_prompt),
                Text(S.current.main_action_config_api_key_hint,
                    style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor))
              ]),
              content: TextField(
                  controller: inputController,
                  decoration: InputDecoration(hintText: S.current.app_label_please_input)),
              actions: FastDialogUtils.getCommonlyAction(context, positiveLister: () {
                if (TextUtil.isEmpty(inputController.text)) {
                  AppToastUtil.showToast(msg: S.current.label_content_cannot_be_empty_blank);
                  return;
                }
                Navigator.pop(context);
                getVm().saveApiKey(inputController.text);
              }));
        });
  }

  @override
  bool get wantKeepAlive => true;
}

class _ChatStateVm2 extends AppBaseVm with CancelTokenAssist {
  final FocusNode inputFocusNode = FocusNode();
  final List<MyChatMessage> dataList = [];
  final ShouldSetState shouldSetState = ShouldSetState();
  final ScrollControllerWrap scrollControllerWrap = ScrollControllerWrap();

  //是否正在生成
  bool get generating =>
      dataList.isNotEmpty && (dataList.last.isLoading || dataList.last.isGenerate);

  void initVm() {
    //默认不要焦点
    inputFocusNode.unfocus();

    //初始化apiKey
    String apiKey = getApiKey();
    if (TextUtil.isNotEmpty(apiKey)) {
      DeepSeekRepository.create(apiKey: apiKey);
    }
  }

  String getApiKey() {
    return AppConfig().getDp().getString("deepSeekApiKey", defValue: "") ?? "";
  }

  void saveApiKey(String value) {
    AppConfig().getDp().putValue("deepSeekApiKey", value);
    DeepSeekRepository.create(apiKey: value);
    notifyListeners();
  }

  void newDialog() {
    dataList.clear();
    refreshList();
  }

  void refreshList() {
    shouldSetState.updateVersion();
    notifyListeners();
    scrollControllerWrap.scroll2Bottom();
  }

  void sendChat(String content) {
    if (TextUtil.isEmpty(getApiKey())) {
      AppToastUtil.showToast(msg: S.current.main_toast_ai_chat_hint_not_api_key);
      return;
    }
    MyChatMessage send = MyChatMessage.createUser(content);
    dataList.add(send);
    MyChatMessage loading = MyChatMessage.createLoading();
    dataList.add(loading);
    refreshList();

    List<ChatMessage> submitMessages = [];
    for (var element in dataList) {
      if (element.isComplete) {
        submitMessages.add(ChatMessage(
            role:
                TextUtil.isEmpty(element.role) ? MyChatMessage.messageRoleAssistant : element.role,
            content: element.content));
      }
    }

    DeepSeekRepository.createChatCompletion(
            ChatCompletionRequest(
              model: 'deepseek-chat',
              messages: submitMessages,
              //temperature: 0.7,
              //maxTokens: 100,
              stream: true,
            ),
            cancelToken: defCancelToken)
        .listen((result) {
      if (dataList.last.status == MyChatMessage.statusLoading) {
        dataList.last.content = '';
      }
      dataList.last.content = dataList.last.content + result.content;
      dataList.last.status = result.status;
      dataList.last.srcTarget = result.srcTarget;
      dataList.last.role = result.role;

      refreshList();
      LogUtil.d(result.content);
    }, onError: (e) {
      dataList.last.content = e.toString();
      dataList.last.status = MyChatMessage.statusError;
    });
  }
}

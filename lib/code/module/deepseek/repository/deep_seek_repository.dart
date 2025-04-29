import 'package:ruoyi_plus_flutter/code/module/deepseek/entity/MyChatMessage.dart';

import '../../../lib/deepseek/deepseek_api.dart';
import '../../../lib/deepseek/models.dart';
import 'package:dio/dio.dart';

class DeepSeekRepository {
  static DeepSeekAPI? _deepSeek;

  static create({required String apiKey}) {
    _deepSeek?.closeDio();
    _deepSeek = DeepSeekAPI(apiKey: apiKey);
  }

  static Stream<MyChatMessage> createChatCompletion(
    ChatCompletionRequest request, {
    CancelToken? cancelToken,
  }) {
    //根据stream判断是否需要流类型
    if (request.stream == true) {
      return _deepSeek!
          .createChatCompletionStream(request, cancelToken: cancelToken)
          .map(_toMyChatMessage);
    }
    return _deepSeek!
        .createChatCompletion(request, cancelToken: cancelToken)
        .asStream()
        .map(_toMyChatMessage);
  }

  ///转成MyChatMessage
  static MyChatMessage _toMyChatMessage(ChatCompletionResponse event) {
    MyChatMessage myChatMessage;
    if (event.choices.isEmpty) {
      myChatMessage = MyChatMessage(MyChatMessage.statusGenerate, "", "", srcTarget: event);
    } else {
      ChatChoice chatChoice = event.choices[0];
      if (chatChoice.message != null) {
        myChatMessage = MyChatMessage(MyChatMessage.statusComplete, chatChoice.message?.role ?? "",
            chatChoice.message?.content ?? "",
            srcTarget: event);
      } else {
        myChatMessage = MyChatMessage(
            event.usage != null ? MyChatMessage.statusComplete : MyChatMessage.statusGenerate,
            chatChoice.delta?.role ?? "",
            chatChoice.delta?.content ?? "",
            srcTarget: event);
      }
    }
    return myChatMessage;
  }
}

import '../../../lib/deepseek/models.dart';
import '../entity/MyChatMessage.dart';

class ChatUtils {

  static bool isSystem(ChatMessage chatMessage) {
    return MyChatMessage.messageRoleSystem == chatMessage.role;
  }

  static bool isUser(ChatMessage chatMessage) {
    return MyChatMessage.messageRoleUser == chatMessage.role;
  }

  static bool isAssistant(ChatMessage chatMessage) {
    return MyChatMessage.messageRoleAssistant == chatMessage.role;
  }

}

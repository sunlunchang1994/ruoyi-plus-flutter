import '../../../lib/deepseek/deepseek_api.dart';
import '../../../lib/deepseek/models.dart';

class ConstantDeepSeek {
  static final messageRoleSystem = "system";
  static final messageRoleUser = "user";
  static final messageRoleAssistant = "assistant";

  static bool isSystem(ChatMessage chatMessage) {
    return messageRoleSystem == chatMessage.role;
  }

  static bool isUser(ChatMessage chatMessage) {
    return messageRoleUser == chatMessage.role;
  }

  static bool isAssistant(ChatMessage chatMessage) {
    return messageRoleAssistant == chatMessage.role;
  }

  static final DeepSeekAPI deepSeek = DeepSeekAPI(
    apiKey: 'sk-c78f2b0b2ee24eb5ac9a7a521da45988a',
    // Optional: baseUrl: 'https://api.deepseek.com/v1' (default)
  );
}

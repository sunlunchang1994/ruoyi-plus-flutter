class MyChatMessage {
  static const int statusLoading = 0;
  static const int statusGenerate = 1;
  static const int statusComplete = 2;
  static const int statusError = 3;

  static const messageRoleSystem = "system";
  static const messageRoleUser = "user";
  static const messageRoleAssistant = "assistant";

  int status;
  String role;
  String content;

  Object? srcTarget;

  MyChatMessage(this.status, this.role, this.content, {this.srcTarget});

  bool get isLoading => status == statusLoading;

  bool get isGenerate => status == statusGenerate;

  bool get isComplete => status == statusComplete;

  bool get isError => status == statusError;

  bool get isSystem => role == messageRoleSystem;

  bool get isUser => role == messageRoleUser;

  bool get isAssistant => role == messageRoleAssistant;

  static MyChatMessage createUser(String context) {
    return MyChatMessage(statusComplete, messageRoleUser, context);
  }

  static MyChatMessage createLoading() {
    return MyChatMessage(statusLoading, messageRoleAssistant, "正在思考...");
  }
}

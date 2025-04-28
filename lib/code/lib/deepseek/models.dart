import 'package:json_annotation/json_annotation.dart';

part 'models.g.dart';

/// Represents a request to the chat completion API.
@JsonSerializable(explicitToJson: true)
class ChatCompletionRequest {
  /// The model to use for the chat completion.
  final String model;

  /// The list of messages forming the conversation.
  final List<ChatMessage> messages;

  /// Sampling temperature, a value between 0 and 1 that controls randomness.
  final double? temperature;

  /// The maximum number of tokens to generate.
  @JsonKey(name: 'max_tokens')
  final int? maxTokens;

  /// Nucleus sampling parameter, controlling diversity of responses.
  @JsonKey(name: 'top_p')
  final double? topP;

  /// Penalizes new tokens based on frequency in the input.
  @JsonKey(name: 'frequency_penalty')
  final double? frequencyPenalty;

  /// Penalizes new tokens based on their presence in the input.
  @JsonKey(name: 'presence_penalty')
  final double? presencePenalty;

  /// List of tokens where the API should stop generating further tokens.
  final List<String>? stop;

  /// Whether the response should be streamed.
  final bool? stream;

  /// A unique identifier for the user making the request.
  final String? user;

  /// Constructor for creating a [ChatCompletionRequest] instance.
  ChatCompletionRequest({
    required this.model,
    required this.messages,
    this.temperature,
    this.maxTokens,
    this.topP,
    this.frequencyPenalty,
    this.presencePenalty,
    this.stop,
    this.stream,
    this.user,
  });

  /// Creates a [ChatCompletionRequest] instance from JSON.
  factory ChatCompletionRequest.fromJson(Map<String, dynamic> json) =>
      _$ChatCompletionRequestFromJson(json);

  /// Converts the instance to JSON.
  Map<String, dynamic> toJson() => _$ChatCompletionRequestToJson(this);
}

/// Represents a chat message in the conversation.
@JsonSerializable(explicitToJson: true)
class ChatMessage {
  /// The role of the message sender (e.g., "system", "user", "assistant").
  final String? role;

  /// The content of the message.
  final String content;

  /// Constructor for creating a [ChatMessage] instance.
  ChatMessage({required this.role, required this.content});

  /// Creates a [ChatMessage] instance from JSON.
  factory ChatMessage.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageFromJson(json);

  /// Converts the instance to JSON.
  Map<String, dynamic> toJson() => _$ChatMessageToJson(this);
}

/// Represents a response from the chat completion API.
@JsonSerializable(explicitToJson: true)
class ChatCompletionResponse {
  /// Unique identifier for the response.
  final String id;

  /// Type of response object.
  final String object;

  /// Timestamp of response creation.
  final int created;

  /// The model used for generating the response.
  final String model;

  /// List of choices returned by the model.
  final List<ChatChoice> choices;

  /// Token usage information.
  final Usage? usage;

  /// Constructor for creating a [ChatCompletionResponse] instance.
  ChatCompletionResponse({
    required this.id,
    required this.object,
    required this.created,
    required this.model,
    required this.choices,
    this.usage,
  });

  /// Creates a [ChatCompletionResponse] instance from JSON.
  factory ChatCompletionResponse.fromJson(Map<String, dynamic> json) =>
      _$ChatCompletionResponseFromJson(json);

  /// Converts the instance to JSON.
  Map<String, dynamic> toJson() => _$ChatCompletionResponseToJson(this);
}

/// Represents a choice within a chat completion response.
@JsonSerializable(explicitToJson: true)
class ChatChoice {
  /// Index of the choice in the response.
  final int index;

  /// The message returned by the model.
  final ChatMessage? message;

  /// slc add
  final ChatMessage? delta;

  /// Reason why the generation stopped (if applicable).
  @JsonKey(name: 'finish_reason')
  final String? finishReason;

  /// Constructor for creating a [ChatChoice] instance.
  ChatChoice({
    required this.index,
    required this.message,
    required this.delta,
    this.finishReason,
  });

  /// Creates a [ChatChoice] instance from JSON.
  factory ChatChoice.fromJson(Map<String, dynamic> json) =>
      _$ChatChoiceFromJson(json);

  /// Converts the instance to JSON.
  Map<String, dynamic> toJson() => _$ChatChoiceToJson(this);
}

/// Represents token usage statistics.
@JsonSerializable(explicitToJson: true)
class Usage {
  /// Number of tokens used in the prompt.
  @JsonKey(name: 'prompt_tokens')
  final int promptTokens;

  /// Number of tokens generated in the completion.
  @JsonKey(name: 'completion_tokens')
  final int completionTokens;

  /// Total number of tokens used in the request.
  @JsonKey(name: 'total_tokens')
  final int totalTokens;

  /// Constructor for creating a [Usage] instance.
  Usage({
    required this.promptTokens,
    required this.completionTokens,
    required this.totalTokens,
  });

  /// Creates a [Usage] instance from JSON.
  factory Usage.fromJson(Map<String, dynamic> json) => _$UsageFromJson(json);

  /// Converts the instance to JSON.
  Map<String, dynamic> toJson() => _$UsageToJson(this);
}

/// Represents the response containing a list of available models.
@JsonSerializable(explicitToJson: true)
class ModelsListResponse {
  /// List of available models.
  final List<ModelData> data;

  /// Constructor for creating a [ModelsListResponse] instance.
  ModelsListResponse({required this.data});

  /// Creates a [ModelsListResponse] instance from JSON.
  factory ModelsListResponse.fromJson(Map<String, dynamic> json) =>
      _$ModelsListResponseFromJson(json);

  /// Converts the instance to JSON.
  Map<String, dynamic> toJson() => _$ModelsListResponseToJson(this);
}

/// Represents metadata about a specific model.
@JsonSerializable(explicitToJson: true)
class ModelData {
  /// Unique identifier for the model.
  final String id;

  /// Type of the object (e.g., "model").
  final String object;

  /// Owner of the model.
  @JsonKey(name: 'owned_by')
  final String? ownedBy;

  /// Constructor for creating a [ModelData] instance.
  ModelData({
    required this.id,
    required this.object,
    required this.ownedBy,
  });

  /// Creates a [ModelData] instance from JSON.
  factory ModelData.fromJson(Map<String, dynamic> json) =>
      _$ModelDataFromJson(json);

  /// Converts the instance to JSON.
  Map<String, dynamic> toJson() => _$ModelDataToJson(this);
}

class ChatModel {
  final String? userId;
  final String? userName;

  final String? message;
  final String? time;

  ChatModel({
    this.userId,
    this.userName,
    this.message,
    this.time,
  });

  factory ChatModel.fromRawJson(Map<String, dynamic> jsonData) {
    return ChatModel(
        userId: jsonData['userId'],
        userName: jsonData['userName'],
        message: jsonData['message'],
        time: jsonData['time']);
  }
  Map<String, dynamic> toJson() {
    return {
      "userId": userId,
      "userName": userName,
      "message": message,
      "time": time,
    };
  }
}

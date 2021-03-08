/// Reponse object when call send message api
class SendMessageResult {
  String recipientId;
  String messageId;
  SendMessageResult({this.recipientId, this.messageId});
  SendMessageResult.fromJson(Map<String, dynamic> json) {
    recipientId = json["recipient_id"];
    messageId = json["message_id"];
  }
}

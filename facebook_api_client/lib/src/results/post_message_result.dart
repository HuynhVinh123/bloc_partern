/// Reponse object when call [post]
class PostResult {
  String id;
  String postId;

  PostResult({this.id, this.postId});

  PostResult.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    postId = json["post_id"];
  }
}

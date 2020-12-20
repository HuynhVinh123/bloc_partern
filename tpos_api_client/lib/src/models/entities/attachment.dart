class Attachment {
  Attachment({this.data});
  Attachment.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = Data.fromJson(json['data']);
    }
  }
  Data data;
  Map<String, dynamic> toJson([bool removeIfNull = false]) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['data'] = data;
  }
}

class Data {
  Data({this.imageData});
  Data.fromJson(Map<String, dynamic> json) {
    if (json['image_data'] != null) {
      imageData = ImageData.fromJson(json['image_data']);
    }
  }
  ImageData imageData;
  Map<String, dynamic> toJson([bool removeIfNull = false]) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['image_data'] = data['image_data'] != null ? imageData.toJson() : null;
  }
}

class ImageData {
  ImageData({this.url});
  ImageData.fromJson(Map<String, dynamic> json) {
    url = json['url'];
  }
  String url;
  Map<String, dynamic> toJson([bool removeIfNull = false]) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['url'] = url;
  }
}

class Attachment {
  Attachment({this.data});
  Attachment.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data.add(Data.fromJson(v));
      });
    }
  }
  List<Data> data;
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  Data({this.imageData});
  Data.fromJson(Map<String, dynamic> json) {
    imageData = json['image_data'] != null
        ? ImageData.fromJson(json['image_data'])
        : null;
  }
  ImageData imageData;
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (imageData != null) {
      data['image_data'] = imageData.toJson();
    }
    return data;
  }
}

class ImageData {
  ImageData({this.url});
  ImageData.fromJson(Map<String, dynamic> json) {
    url = json['url'];
  }
  String url;
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['url'] = url;
    return data;
  }
}

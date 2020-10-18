class LiveVideo {
  Status status;
  String description;
  String id;
  String updatedTime;
  String liveStatus;

  LiveVideo(
      {this.status,
      this.description,
      this.id,
      this.updatedTime,
      this.liveStatus});

  LiveVideo.fromJson(Map<String, dynamic> json) {
    status =
        json['status'] != null ? new Status.fromJson(json['status']) : null;
    description = json['description'];
    id = json['id'];
    updatedTime = json['updated_time'];
    liveStatus = json['live_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.status != null) {
      data['status'] = this.status.toJson();
    }
    data['description'] = this.description;
    data['id'] = this.id;
    data['updated_time'] = this.updatedTime;
    data['live_status'] = this.liveStatus;
    return data;
  }
}

class Status {
  String videoStatus;

  Status({this.videoStatus});

  Status.fromJson(Map<String, dynamic> json) {
    videoStatus = json['video_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['video_status'] = this.videoStatus;
    return data;
  }
}

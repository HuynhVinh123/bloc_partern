class FacebookLivestream {
  FacebookLivestream(
      {this.id,
        this.streamSecondaryUrls,
        this.secureStreamSecondaryUrls,
        this.secureStreamUrl,
        this.streamUrl});

  String id;
  String streamUrl;
  String secureStreamUrl;
  List<String> streamSecondaryUrls;
  List<String> secureStreamSecondaryUrls;

  factory FacebookLivestream.fromJson(Map<String, dynamic> data) =>
      FacebookLivestream(
        id: data['id'],
        streamUrl: data['stream_url'],
        secureStreamUrl: data['secure_stream_url'],
      );
}

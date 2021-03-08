import 'package:tpos_api_client/tpos_api_client.dart';

class LiveCampaignState {}

/// State loading khi load data
class LiveCampaignLoading extends LiveCampaignState {}

/// State load more khi load data
class LiveCampaignLoadingMore extends LiveCampaignState {}

/// State được trả về khi load thành công
class LiveCampaignLoadSuccess extends LiveCampaignState {
  LiveCampaignLoadSuccess({this.liveCampaigns});
  final List<LiveCampaign> liveCampaigns;

  @override
  String toString() => liveCampaigns.toString();
}

/// State được trả về khi load thát bại
class LiveCampaignLoadFailure extends LiveCampaignState {
  LiveCampaignLoadFailure({this.title, this.content});

  final String title;
  final String content;
}

/// State dc trả về khi thực hiện 1 thao tác nào đó thành công
class LiveCampaignActionSuccess extends LiveCampaignState {
  LiveCampaignActionSuccess({this.path,this.content,this.title});
  final String path;
  final String title;
  final String content;
}

/// State đc trả về khi thực hiện 1 thao tác thất bại
class LiveCampaignActionFailure extends LiveCampaignState {
  LiveCampaignActionFailure({this.title, this.content});

  final String title;
  final String content;
}

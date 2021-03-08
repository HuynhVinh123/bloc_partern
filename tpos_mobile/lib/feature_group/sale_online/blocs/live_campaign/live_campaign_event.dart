import 'package:tpos_api_client/tpos_api_client.dart';

class LiveCampaignEvent {}

/// Thực hiện load danh sách chiến dịch
class LiveCampaignLoaded extends LiveCampaignEvent {
  LiveCampaignLoaded({this.isActive, this.keyWord, this.skip, this.top});
  final bool isActive;
  final String keyWord;
  final int top;
  final int skip;
}

/// Thực hiện load more danh sách chiến dịch
class LiveCampaignLoadedMore extends LiveCampaignEvent {
  LiveCampaignLoadedMore(
      {this.isActive, this.keyWord, this.skip, this.top, this.liveCampaigns});
  final bool isActive;
  final String keyWord;
  final int top;
  final int skip;
  final List<LiveCampaign> liveCampaigns;
}

/// Thực hiện xóa danh sách chiến dịch
class LiveCampaignDeleted extends LiveCampaignEvent {
  LiveCampaignDeleted({this.id, this.index});
  final String id;
  final int index;
}

/// Load lại dữ liệu sau khi xóa thành công
class LiveCampaignDeleteLocal extends LiveCampaignEvent {
  LiveCampaignDeleteLocal();
}

/// Thực hiện xuất excel chiến dịch
class LiveCampaignExportExcel extends LiveCampaignEvent {
  LiveCampaignExportExcel({this.liveCampaignId, this.liveCampaignName});
  final String liveCampaignId;
  final String liveCampaignName;
}

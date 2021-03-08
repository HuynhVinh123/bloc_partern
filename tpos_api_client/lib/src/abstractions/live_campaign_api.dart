import '../../tpos_api_client.dart';

abstract class LiveCampaignApi {
  /// Lấy danh sách chiến dịch live còn hoạt động
  Future<List<LiveCampaign>> getAvaibleLiveCampaigns(
      {String keyWord, int top, int skip});

  /// Lấy danh sách chiến dịch
  Future<List<LiveCampaign>> getLiveCampaigns(
      {String keyWord, int top, int skip});

  // Xuất file excel chiến dịch live
  Future<String> exportExcelLiveCampaign(
      String campaignId, String campaignName);

  /// Xóa chiến dịch
  Future<void> deleteCampaign(String id);

  /// Get by ID
  Future<LiveCampaign> getDetailLiveCampaigns(String liveCampaignId);

  /// Thêm chiến dịch live mới
  Future<void> addLiveCampaign({LiveCampaign newLiveCampaign});

  /// Sửa chiến dịch live
  Future<void> editLiveCampaign(LiveCampaign editLiveCampaign);

  /// Thay đổi trạng thái cho chiến dịch
  Future<bool> changeLiveCampaignStatus(String liveCampaignId);
}

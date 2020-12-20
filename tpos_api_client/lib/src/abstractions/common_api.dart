import '../../tpos_api_client.dart';

abstract class CommonApi {
  /// Lấy thông tin công ty hiện tại
  Future<GetCompanyCurrentResult> getCompanyCurrent();
  Future<WebUserConfig> getUserConfig();

  /// Lấy danh sách trạng thái khách hàng kèm báo cáo số lượng khách hàng đang có trạng thái dó
  /// https://tmt25.tpos.vn/api/common/getpartnerstatusreport
  Future<PartnerStatusReport> getPartnerStatusReport();

  /// Lấy danh sách trạng thái khách hàng
  /// https://tmt25.tpos.vn/api/common/getpartnerstatus
  Future<List<PartnerStatus>> getPartnerStatus();


  ///Upload image trả về url đã upload
  Future<String> uploadImage(String base64, String name);
}

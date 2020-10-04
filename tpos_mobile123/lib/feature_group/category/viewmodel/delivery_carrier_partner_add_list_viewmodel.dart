import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/services/dialog_service.dart';
import 'package:tpos_mobile/src/tpos_apis/models/delivery_carrier.dart';
import 'package:tpos_mobile/src/tpos_apis/tpos_api.dart';

/// VM. Danh sách các đối tác giao hàng có hỗ trợ
/// Chọn đối tác giao hàng để đăng ký
class DeliveryCarrierPartnerAddListViewModel extends ViewModel {
  var _tposApi = locator<ITposApiService>();
  var _dialog = locator<DialogService>();
  List<DeliveryCarrier> _connectedDeliveryCarriers;
  List<SupportDeliveryCarrierModel> _notConnectDeliveryCarriers;

  String _selectedSupportType;
  String get selectedSupportType => _selectedSupportType;
  set selectedSupportType(String value) {
    _selectedSupportType = value;
  }

  List<DeliveryCarrier> get connectedDeliveryCarriers =>
      _connectedDeliveryCarriers;
  List<SupportDeliveryCarrierModel> get notConnectDeliveryCarriers =>
      _notConnectDeliveryCarriers;

  DeliveryCarrierPartnerAddListViewModel() {
    init();
  }

  /// Khởi tạo khi viewmodel được khởi tạo
  void init() {
    //Create support delivery carrier
    _notConnectDeliveryCarriers = new List<SupportDeliveryCarrierModel>();
//    _notConnectDeliveryCarriers.add(new SupportDeliveryCarrierModel(
//      name: "VNPOST",
//      description: "Bưu điện Việt Nam",
//      code: "VNPost",
//      iconAsset: "images/vnpost_logo.png",
//    ));
    _notConnectDeliveryCarriers.add(new SupportDeliveryCarrierModel(
      name: "My VNPost",
      description: "Bưu điện Việt Nam",
      code: "MyVNPost",
      iconAsset: "images/vnpost_logo.png",
    ));
    _notConnectDeliveryCarriers.add(new SupportDeliveryCarrierModel(
      name: "Viettel Post",
      description: "Viettel post",
      code: "ViettelPost",
      iconAsset: "images/viettelpost_logo.png",
    ));
    _notConnectDeliveryCarriers.add(new SupportDeliveryCarrierModel(
      name: "Giao hàng nhanh",
      description: "Giao hàng nhanh",
      code: "GHN",
      iconAsset: "images/giaohangnhanh_logo.png",
    ));
//    _notConnectDeliveryCarriers.add(new SupportDeliveryCarrierModel(
//      name: "Giao hàng tiết kiệm",
//      description: "GHTK",
//      code: "GHTK",
//      iconAsset: "images/giaohangtietkiem_logo.png",
//    ));

    _notConnectDeliveryCarriers.add(new SupportDeliveryCarrierModel(
      name: "J&T Express",
      description: "Fixed",
      code: "JNT",
      iconAsset: "images/jt_logo.jpg",
    ));
    _notConnectDeliveryCarriers.add(new SupportDeliveryCarrierModel(
      name: "Tín Tốc",
      description: "Tín tốc",
      code: "TinToc",
      iconAsset: "images/tintoc_logo.jpg",
    ));

    _notConnectDeliveryCarriers.add(new SupportDeliveryCarrierModel(
      name: "Super Ship",
      description: "Supership.vn",
      code: "SuperShip",
      iconAsset: "images/supership_logo.png",
    ));

    _notConnectDeliveryCarriers.add(new SupportDeliveryCarrierModel(
      name: "OkieLa",
      description: "Okiela",
      code: "OkieLa",
      iconAsset: "images/okiela_logo.png",
    ));
    _notConnectDeliveryCarriers.add(new SupportDeliveryCarrierModel(
      name: "Giá cố định",
      description: "Fixed",
      code: "fixed",
      iconAsset: "images/fixed_price.jpg",
      type: "other",
    ));
    _notConnectDeliveryCarriers.add(new SupportDeliveryCarrierModel(
      name: "FullTime Ship",
      description: "FullTime Ship",
      code: "FulltimeShip",
      iconAsset: "images/fulltimeship_logo.jpg",
    ));
    _notConnectDeliveryCarriers.add(new SupportDeliveryCarrierModel(
      name: "Best",
      description: "Best",
      code: "BEST",
      iconAsset: "images/bestshipper_logo.png",
    ));
    _notConnectDeliveryCarriers.add(new SupportDeliveryCarrierModel(
      name: "FlashShip",
      description: "FlashShip.com.vn",
      code: "FlashShip",
      iconAsset: "images/flash_ship_logo.jpg",
    ));
    _notConnectDeliveryCarriers.add(new SupportDeliveryCarrierModel(
      name: "DHL Express",
      description: "DHL Express",
      code: "DHL",
      iconAsset: "images/dhl_express_logo.jpg",
    ));
  }

  /// Khởi tạo khi view được khởi tạo
  void initFirst() {}

  /// Khởi tạo dữ liệu ban đầu, khi view được khởi tạo
  Future initData() async {
    try {
      onStateAdd(true);
      _connectedDeliveryCarriers = await _tposApi.getDeliveryCarriers();
      notifyListeners();
      // Map vào

      _notConnectDeliveryCarriers.forEach((notConnect) {
        int count = _connectedDeliveryCarriers
                ?.where((f) => f.deliveryType == notConnect.code)
                ?.length ??
            0;

        notConnect.connectedCount = count;
      });
      notifyListeners();
    } catch (e, s) {
      logger.error("", e, s);
      _dialog.showError(error: e);
    }

    onStateAdd(false);
  }
}

class SupportDeliveryCarrierModel {
  String type;
  String name;
  String code;
  String description;
  String iconAsset;
  bool isConnected;
  int connectedCount = 0;

  SupportDeliveryCarrierModel({
    this.type = "carrier",
    this.name,
    this.code,
    this.description,
    this.iconAsset,
    this.connectedCount = 0,
  });
}

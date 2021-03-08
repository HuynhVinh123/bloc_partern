import 'package:tpos_api_client/tpos_api_client.dart';

class WareHouseStockState {}

/// Loading trong khi đợi load dữ liệu
class WareHouseStockLoading extends WareHouseStockState {}

/// Trả về dữ liệu khi laod thành công
class WareHouseStockLoadSuccess extends WareHouseStockState {
  WareHouseStockLoadSuccess({this.wareHouseStocks});
  final List<WareHouseStock> wareHouseStocks;
}

/// Trả về lỗi khi load thất bại
class WareHouseStockLoadFailure extends WareHouseStockState {
  WareHouseStockLoadFailure({this.title, this.content});
  final String title;
  final String content;
}

class WareHouseStockEvent {}

/// Event lấy danh sách tồn kho
class WareHouseStockLoaded extends WareHouseStockEvent {
  WareHouseStockLoaded({this.keyWord});
  final String keyWord;
}

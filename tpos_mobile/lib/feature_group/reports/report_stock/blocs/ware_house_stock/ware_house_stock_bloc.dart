import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/feature_group/reports/report_stock/blocs/ware_house_stock/ware_house_stock_event.dart';
import 'package:tpos_mobile/feature_group/reports/report_stock/blocs/ware_house_stock/ware_house_stock_state.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

class WareHouseStockBloc
    extends Bloc<WareHouseStockEvent, WareHouseStockState> {
  WareHouseStockBloc({ReportStockApi reportStockApi})
      : super(WareHouseStockLoading()) {
    _apiClient = reportStockApi ?? GetIt.instance<ReportStockApi>();
  }

  ReportStockApi _apiClient;

  @override
  Stream<WareHouseStockState> mapEventToState(
      WareHouseStockEvent event) async* {
    yield WareHouseStockLoading();
    if (event is WareHouseStockLoaded) {
      /// Lấy danh sách tồn kho
      yield* _getWareHouseStock(event);
    }
  }

  Stream<WareHouseStockState> _getWareHouseStock(
      WareHouseStockLoaded event) async* {
    try {
      final List<WareHouseStock> wareHouseStocks =
          await _apiClient.getWarehouseStock(keyWord: event.keyWord);
      yield WareHouseStockLoadSuccess(wareHouseStocks: wareHouseStocks);
    } catch (e) {
      yield WareHouseStockLoadFailure(
          title: S.current.notification, content: e.toString());
    }
  }
}

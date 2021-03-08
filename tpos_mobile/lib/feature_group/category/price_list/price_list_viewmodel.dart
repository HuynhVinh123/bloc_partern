import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:tmt_flutter_viewmodel/tmt_flutter_viewmodel.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/feature_group/pos_order/models/price_list.dart';
import 'package:tpos_mobile/state_management/viewmodel/base_viewmodel.dart';

class PriceListViewModel extends PViewModel {
  PriceListViewModel({PriceListApi priceListApi}) {
    _priceListApi = priceListApi ?? GetIt.I<PriceListApi>();
  }
  final Logger _logger = Logger();
  PriceListApi _priceListApi;

  bool _searchMode = false;

  String get title => _searchMode ? 'Chọn bảng giá' : 'Bảng giá';
  List<ProductPrice> _priceLists;
  List<ProductPrice> get priceLists => _priceLists;
  bool get searchModel => _searchMode;

  @override
  void init({bool searchModel = false}) {
    _searchMode = searchModel;
    initData();
  }

  @override
  Future<PCommandResult> initData() async {
    try {
      setState(PViewModelLoading('Đang tải...'));
      await _fetchPriceList();
      setState(PViewModelLoadSuccess());
      return PCommandResult(true);
    } catch (e, s) {
      _logger.e('', e, s);
      setState(PViewModelLoadFailure(e.toString()));
      return PCommandResult(false);
    }
  }

  /// Xóa bảng giá
  Future<PCommandResult> deletePriceList(PriceList item) async {
    assert(item != null);
    assert(item.id != null);
    try {
      await _priceListApi.delete(item.id);
      return PCommandResult(true);
    } catch (e, s) {
      _logger.e('', e, s);
      return PCommandResult(false);
    }
  }

  Future<void> _fetchPriceList() async {
    final result = await _priceListApi.gets();
    _priceLists = result.value;
  }
}

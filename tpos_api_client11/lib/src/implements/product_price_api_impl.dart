import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:tpos_api_client/src/abstraction.dart';
import 'package:tpos_api_client/src/abstractions/price_list_api.dart';
import 'package:tpos_api_client/src/models/entities/product/product_price_list.dart';
import 'package:tpos_api_client/src/models/results/odata_list_result.dart';

class PriceListApiImpl implements PriceListApi {
  PriceListApiImpl({TPosApi tPosApi}) {
    _tPosApi = tPosApi ?? GetIt.I<TPosApi>();
  }
  final Logger _logger = Logger();
  TPosApi _tPosApi;

  @override
  Future<OdataListResult<ProductPrice>> gets({bool count = true}) async {
    final param = {'format': 'json', "count": count};
    final json =
        await _tPosApi.httpGet('/odata/Product_PriceList', parameters: param);
    return OdataListResult<ProductPrice>.fromJson(json);
  }

  @override
  Future<OdataListResult<ProductPrice>> getPriceListAvailable(
      {DateTime data, String format = 'json', bool count = true}) async {
    final param = {
      "date": data?.toIso8601String() ?? DateTime.now().toIso8601String(),
      "\$format": format,
      "\$count": count,
    };
    final json = await _tPosApi.httpGet(
      '/odata/Product_PriceList/ODataService.GetPriceListAvailable',
      parameters: param,
    );

    return OdataListResult<ProductPrice>.fromJson(json);
  }

  @override
  Future<void> delete(int priceListId) async {
    await _tPosApi.httpDelete('/odata/Product_PriceList($priceListId)');
  }
}

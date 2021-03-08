import 'package:get_it/get_it.dart';
import 'package:tpos_api_client/src/abstraction.dart';
import 'package:tpos_api_client/src/abstractions/fast_sale_order_api.dart';
import 'package:tpos_api_client/src/models/entities/fast_sale_order.dart';
import 'package:tpos_api_client/src/models/requests/get_fast_sale_order_by_id_query.dart';
import 'package:tpos_api_client/src/models/requests/get_fast_sale_order_query.dart';
import 'package:tpos_api_client/src/models/results/odata_list_result.dart';

import '../../tpos_api_client.dart';

class FastSaleOrderApiImpl implements FastSaleOrderApi {
  FastSaleOrderApiImpl({TPosApi apiClient}) {
    _apiClient = apiClient ?? GetIt.I<TPosApi>();
  }
  final String _getPath = "/FastSaleOrder/List";
  final String _getDeliveryInvoicePath = "/FastSaleOrder/DeliveryInvoiceList";
  String _getByIdPath(int id) => "/Odata/FastSaleOrder($id)";
  final String _getDefaultPath = "/odata/FastSaleOrder/ODataService.DefaultGet";
  final String _onChangePartner =
      "/odata/FastSaleOrder/ODataService.OnChangePartner_PriceList";
  final String _insertPath = "/odata/FastSaleOrder";
  String _updatePath(int id) => "/odata/FastSaleOrder($id)";
  final String _printShipPath = "/odata/FastSaleOrder/ODataService.PrintShip";
  final String _getQuickDefaultPath =
      "/odata/SaleOnline_Order/GetDefaultOrderIds";

  final String _insertDefaultPath =
      "/odata/FastSaleOrder/InsertOrderProductDefault";

  TPosApi _apiClient;
  @override
  Future<OdataListResult<FastSaleOrder>> gets(
      GetFastSaleOrderQuery query) async {
    final response = await _apiClient.httpPost(
      _getPath,
      data: query?.toJson(),
    );

    return OdataListResult.fromJson(response);
  }

  @override
  Future<FastSaleOrder> getById(int id,
      {GetFastSaleOrderByIdQuery query}) async {
    query ??= GetFastSaleOrderByIdQuery.allInfo();
    final response = await _apiClient.httpGet(
      _getByIdPath(id),
      parameters: query?.toJson(true),
    );
    return FastSaleOrder.fromJson(response);
  }

  @override
  Future<OdataListResult<FastSaleOrder>> getDeliveryInvoices(
      GetFastSaleOrderQuery query) async {
    final response = await _apiClient.httpPost(
      _getDeliveryInvoicePath,
      data: query?.toJson(),
    );

    return OdataListResult.fromJson(response);
  }

  @override
  Future<FastSaleOrder> getDefault({
    OdataObjectQuery query,
    List<String> saleOrderIds,
    String type = 'invoice',
  }) async {
    query ??= OdataObjectQuery(
      expand:
          'Warehouse,User,PriceList,Company,Journal,PaymentJournal,Partner,Carrier,Tax,SaleOrder',
    );

    final response = await _apiClient.httpPost(_getDefaultPath,
        parameters: query?.toJson(true),
        data: <String, dynamic>{
          "model": {
            "Type": "invoice",
            "SaleOrderIds": saleOrderIds ?? [],
          }
        });

    return FastSaleOrder.fromJson(response);
  }

  @override
  Future<FastSaleOrder> getOnChangePartnerOrPriceList(
      FastSaleOrder order) async {
    final response = await _apiClient.httpPost(
      _onChangePartner,
      parameters: {"expand": 'PartnerShipping,PriceList,Account'},
      data: {
        'model': order.toJson(true),
      },
    );

    return FastSaleOrder.fromJson(response);
  }

  @override
  Future<FastSaleOrder> insert(FastSaleOrder order) async {
    final response = await _apiClient.httpPost(
      _insertPath,
      data: order.toJson(true),
    );

    return FastSaleOrder.fromJson(response);
  }

  @override
  Future<void> update(FastSaleOrder order) async {
    assert(order.id != null && order.id != 0);
    await _apiClient.httpPut(
      _updatePath(order.id),
      data: order.toJson(true),
    );
  }

  @override
  Future<String> printOkialaShip(int invoiceId) async {
    final response = await _apiClient.httpPost(_printShipPath, data: {
      "ids": [
        invoiceId,
      ]
    });

    if (response["data"] != null && response["data"]["orderUrl"] != null) {
      return response["data"]["orderUrl"];
    }
    return "";
  }

  @override
  Future<CreateQuickFastSaleOrderModel> getQuickCreateFastSaleOrderDefault(
      List<String> saleOnlineIds) async {
    assert(saleOnlineIds != null && saleOnlineIds.isNotEmpty);
    final response =
        await _apiClient.httpPost(_getQuickDefaultPath, parameters: {
      '\$expand': 'Lines(\$expand=Partner),Carrier',
    }, data: {
      "ids": saleOnlineIds.toList(),
    });

    return CreateQuickFastSaleOrderModel.fromJson(response);
  }

//POST /odata/FastSaleOrder/ODataService.InsertOrderProductDefault?$expand=DataErrorDefault($expand=Partner) HTTP/1.1
  @override
  Future<InsertOrderProductDefaultResult> createQuickFastSaleOrder(
      CreateQuickFastSaleOrderModel model) async {
    assert(model.lines != null &&
        model.lines.every((element) => element.id == null));
    final response = await _apiClient.httpPost(
      _insertDefaultPath,
      data: {'model': model.toJson(true)},
      parameters: {
        '\$expand': 'DataErrorDefault(\$expand=Partner)',
      },
    );

    final result = InsertOrderProductDefaultResult.fromJson(response);

    //TODO(namnv): Ghi analytic bất kì chỗ nào gọi api này thành công.

    return result;
  }
}

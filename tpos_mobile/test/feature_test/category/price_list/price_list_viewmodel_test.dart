import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/feature_group/category/price_list/price_list_viewmodel.dart';
import 'package:tpos_mobile/state_management/viewmodel/base_viewmodel.dart';

class _MockPriceListApi extends Mock implements PriceListApi {}

void main() {
  final mockPriceListApi = _MockPriceListApi();
  final PriceListViewModel vm =
      PriceListViewModel(priceListApi: mockPriceListApi);
  test('Khởi tạo PriceListViewModel thành công', () async {
    when(mockPriceListApi.gets()).thenAnswer(
      (_) async => Future.value(
        OdataListResult(count: 2, value: [
          ProductPrice(id: 1, name: 'Bảng giá thường'),
          ProductPrice(id: 2, name: 'Bảng giá tết'),
        ]),
      ),
    );

    vm.init();
    final result = await vm.initData();
    expect(result.success, true);
    expect(vm.state.runtimeType, PViewModelLoadSuccess);
    expect(vm.priceLists, isNotNull);
    expect(vm.priceLists.length, 2);
  });

  test(
      'Khởi tạo PriceListViewModel thành công nhưng dữ liệu trả về một danh sách rỗng',
      () async {
    when(mockPriceListApi.gets()).thenAnswer(
      (_) async => Future.value(
        OdataListResult(count: 0, value: []),
      ),
    );

    vm.init();
    final result = await vm.initData();
    expect(result.success, true);
    expect(vm.state.runtimeType, PViewModelLoadSuccess);
    expect(vm.priceLists, isNotNull);
    expect(vm.priceLists.length, 0);
  });

  test("Khởi tạo thất bại do REful api thất bại", () async {
    when(mockPriceListApi.gets()).thenThrow(Exception('Badrequesd api 500'));
    vm.init();
    final result = await vm.initData();
    expect(result.success, false);
    expect(vm.state.runtimeType, PViewModelLoadFailure);
    expect(vm.priceLists, isNull);
  });
}

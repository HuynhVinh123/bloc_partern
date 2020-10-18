import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base_provider.dart';
import 'package:tpos_mobile/locator.dart';

import 'package:tpos_mobile/src/tpos_apis/services/tpos_api_interface.dart';

class SearchProductAttributeViewModel extends ViewModelBase {
  ITposApiService _tposApi;
  SearchProductAttributeViewModel() {
    _tposApi = locator<ITposApiService>();
  }

  List<ProductAttribute> _productAttributes = [];
  List<ProductAttribute> get productAttributes => _productAttributes;
  set productAttributes(List<ProductAttribute> value) {
    _productAttributes = value;
    notifyListeners();
  }

  Future<void> getProductAttributes() async {
    setState(true);
    try {
      var result = await _tposApi.getProductAttributeSearch();
      if (result != null) {
        productAttributes = result;
      }
      setState(false);
    } catch (e, s) {
      setState(false);
    }
  }

  Future<void> getProductAttributeValues() async {
    setState(true);
    try {
      var result = await _tposApi.getProductAttributeValueSearch();
      if (result != null) {
        productAttributes = result;
      }
      setState(false);
    } catch (e, s) {
      setState(false);
    }
  }

  void filterProductAttributeValues(String nameAttribute) {
    List<ProductAttribute> _productAttributess = [];
    for (var i = 0; i < _productAttributes.length; i++) {
      if (_productAttributes[i].attributeName == nameAttribute) {
        _productAttributess.add(_productAttributes[i]);
      }
    }
    _productAttributes = _productAttributess;
    notifyListeners();
  }
}

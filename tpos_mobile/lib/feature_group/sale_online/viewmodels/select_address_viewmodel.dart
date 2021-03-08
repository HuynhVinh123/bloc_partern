/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 4/9/19 9:59 AM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 4/9/19 9:52 AM
 *
 */

import 'dart:async';

import 'package:logging/logging.dart';
import 'package:rxdart/rxdart.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tmt_flutter_untils/sources/string_utils/string_utils.dart';
import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/src/tpos_apis/models/Address.dart';
import 'package:tpos_mobile/src/tpos_apis/services/tpos_api_interface.dart';

class SelectAddressViewModel extends Model implements ViewModelBase {
  SelectAddressViewModel() {
    _tposApi = locator<ITposApiService>();
  }
  //log
  final log = Logger("SelectAddressViewModel");
  ITposApiService _tposApi;

  // city Code
  String cityCode;

  // districtCode
  String districtCode;

  /// isAuto navigate
  /// Cho phép tự động chuyển sang trang chọn cấp thấp hơn khi chọn xong cấp cao hơn

  // bool _isAutoNavigate = false;

  // List<Address>
  List<Address> _address;
  List<Address> get address => _address;
  List<Address> tempAdress;

  set address(List<Address> value) {
    _address = value;
    if (!_addressController.isClosed) {
      _addressController.add(_address);
    }
  }

  final BehaviorSubject<List<Address>> _addressController = BehaviorSubject();
  Stream<List<Address>> get addressStream => _addressController.stream;

  bool _isLoading;
  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    if (!_isLoadingController.isClosed) {
      _isLoadingController.add(value);
    }
  }

  final BehaviorSubject<bool> _isLoadingController = BehaviorSubject();

  //
  Future init() async {
    await loadAddress();
    searchAddress("");
  }

  Future loadAddress() async {
    isLoading = true;
    try {
      // Tải Phường xã
      if (cityCode != null && districtCode != null) {
        final wards = await _tposApi.getWardAddress(districtCode);
        if (wards != null) {
          address = wards
              .map((f) => Address(
                    name: f.name,
                    code: f.code,
                  ))
              .toList();
        }
      }
      // Tải quận huyện
      if (cityCode != null && districtCode == null) {
        final cities = await _tposApi.getDistrictAddress(cityCode);
        if (cities != null) {
          address = cities
              .map((f) => Address(
                    name: f.name,
                    code: f.code,
                  ))
              .toList();
        }
      }

      // Tải tỉnh thành phố
      if (cityCode == null && districtCode == null) {
        final cities = await _tposApi.getCityAddress();
        if (cities != null) {
          address = cities
              .map((f) => Address(
                    name: f.name,
                    code: f.code,
                  ))
              .toList();
        }
      }

      tempAdress = address;
    } catch (ex, stack) {
      log.severe("loadAddress fail", ex, stack);
      _addressController.addError(ex);
    }
    isLoading = false;
  }

  // Tìm kiếm địa chỉ
  Future<List<Address>> searchAddress(String keyword) async {
    if (keyword == null && keyword == "") {
      return address = tempAdress;
    }

    final String key = StringUtils.removeVietnameseMark(keyword ?? "");
    return address = tempAdress
        ?.where((f) => f.name != null
            ? StringUtils.removeVietnameseMark(f.name.toLowerCase())
                .contains(key.toLowerCase())
            : false)
        ?.toList();
  }

  @override
  void dispose() {
    _addressController.close();
    _isLoadingController.close();
  }
}

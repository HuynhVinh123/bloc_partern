import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/resources/app_colors.dart';
import 'package:tpos_mobile/src/tpos_apis/models/CheckAddress.dart';
import 'package:tpos_mobile/src/tpos_apis/tpos_api.dart';
import 'package:tpos_mobile/widgets/ModalWaitingWidget.dart';
import 'package:tpos_mobile/widgets/info_row.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

class CheckAddressPage extends StatefulWidget {
  const CheckAddressPage({this.selectedAddress, this.keyword});
  final CheckAddress selectedAddress;
  final String keyword;

  @override
  _CheckAddressPageState createState() => _CheckAddressPageState();
}

class _CheckAddressPageState extends State<CheckAddressPage> {
  final _vm = CheckAddressViewModel();
  final _keywordController = TextEditingController();
  @override
  void initState() {
    _keywordController.text = widget.keyword;
    _vm.init(selectedCheckAddress: widget.selectedAddress);
    if (widget.keyword != null) {
      _vm.startCheckAddress(widget.keyword);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<CheckAddressViewModel>(
      model: _vm,
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: AppBar(
          // TÌm địa chỉ
          title: Text(S.current.searchAddress),
          actions: <Widget>[
            // LƯU
            FlatButton(
              child: Text(S.current.save.toUpperCase()),
              onPressed: () {
                Navigator.pop(context, _vm._selectedCheckAddress);
              },
              textColor: Colors.white,
            )
          ],
        ),
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    return ModalWaitingWidget(
      isBusyStream: _vm.isBusyController,
      initBusy: false,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // Khung tìm kiếm
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              padding: const EdgeInsets.all(8),
              // ừ khóa
              child: TextField(
                maxLines: null,
                controller: _keywordController,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.all(6),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(width: 0),
                  ),
                  hintText: "${S.current.keyWord}: vd: 54/35 dmc,tsn,tp,hcm",
                  suffix: SizedBox(
                    height: 30,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        FlatButton.icon(
                          icon: const Icon(Icons.search),
                          textColor: Colors.blue,
                          padding: const EdgeInsets.all(0),
                          label: Text(S.current.search),
                          onPressed: () {
                            FocusScope.of(context).requestFocus(FocusNode());
                            _vm.startCheckAddress(
                                _keywordController.text.trim());
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Kết quả  tìm kiếm
            const SizedBox(
              height: 10,
            ),

            Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10),
                    topLeft: Radius.circular(10),
                  ),
                ),
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                child: RichText(
                    text: TextSpan(children: [
                  TextSpan(
                      text: "${S.current.checkAddress_resultSearchAddress}: ",
                      style: const TextStyle(color: Colors.black87)),
                  TextSpan(
                    text: _keywordController.text.trim(),
                    style: const TextStyle(color: Colors.green),
                  )
                ]))),
            const Divider(
              height: 1,
            ),
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                ),
              ),
              child: ScopedModelDescendant<CheckAddressViewModel>(
                builder: (ctx, child, model) {
                  return ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      separatorBuilder: (ctx, index) => const Divider(
                            height: 1,
                          ),
                      itemCount: _vm.checkAddressResults?.length ?? 0,
                      shrinkWrap: true,
                      itemBuilder: (ctx, index) {
                        return _buildResultItem(_vm.checkAddressResults[index]);
                      });
                },
              ),
            ),

            if (_vm.selectedCheckAddress != null) ...[
              const SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: <Widget>[
                    // Tỉnh thành
                    InfoRow(
                      titleString: "${S.current.city}:",
                      contentString: _vm.selectedCheckAddress.cityName ?? "N/A",
                    ),
                    InfoRow(
                      titleString: "${S.current.district}:",
                      contentString:
                          _vm.selectedCheckAddress.districtName ?? "N/A",
                    ),

                    InfoRow(
                      titleString: "${S.current.ward}:",
                      contentString: _vm.selectedCheckAddress.wardName ?? "N/A",
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    RaisedButton.icon(
                      icon: const Icon(Icons.close),
                      color: AppColors.backgroundColor,
                      textColor: Colors.green,
                      label: Text(S.current.close.toUpperCase()),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    RaisedButton.icon(
                      shape: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.green),
                        borderRadius: BorderRadius.circular(3),
                      ),
                      icon: const Icon(Icons.save),
                      textColor: Colors.white,
                      // CHỌN KẾT QUẢ NÀY
                      label: Text(S.current.checkAddress_ChooseResult),
                      onPressed: () {
                        Navigator.pop(context, _vm.selectedCheckAddress);
                      },
                    )
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildResultItem(CheckAddress item) {
    return CheckboxListTile(
      value: _vm.selectedCheckAddress == item,
      title: Text(
        item.address ?? "",
        style: const TextStyle(color: Colors.black54),
      ),
      selected: _vm.selectedCheckAddress == item,
      onChanged: (value) {
        setState(() {
          _vm.selectedCheckAddress = item;
        });

        FocusScope.of(context).requestFocus(FocusNode());
      },
    );
  }
}

class CheckAddressViewModel extends ScopedViewModel {
  CheckAddressViewModel({ITposApiService tposApi}) {
    _tPosApi = tposApi ?? locator<ITposApiService>();
  }

  ITposApiService _tPosApi;

  void init({CheckAddress selectedCheckAddress}) {
    _selectedCheckAddress = selectedCheckAddress;
  }

  List<CheckAddress> _checkAddressResults;
  CheckAddress _selectedCheckAddress;

  List<CheckAddress> get checkAddressResults => _checkAddressResults;
  CheckAddress get selectedCheckAddress => _selectedCheckAddress;

  set selectedCheckAddress(CheckAddress value) {
    _selectedCheckAddress = value;
    notifyListeners();
  }

  /// Bắt đầu kiểm tra địa chỉ
  Future<void> startCheckAddress(String keyword) async {
    setBusy(true);

    try {
      _checkAddressResults = await _tPosApi.checkAddress(keyword);
    } catch (e, s) {
      logger.error("", e, s);
    }
    setBusy(false);
    notifyListeners();
  }
}

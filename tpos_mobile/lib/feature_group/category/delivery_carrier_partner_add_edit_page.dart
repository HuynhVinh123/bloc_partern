import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:scoped_model/scoped_model.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/helper/string_helper.dart';
import 'package:tpos_mobile/app_core/my_widgets/number_input_field.dart';
import 'package:tpos_mobile/app_core/ui_base/ui_base.dart';
import 'package:tpos_mobile/feature_group/category/control_service_page.dart';
import 'package:tpos_mobile/feature_group/category/viewmodel/delivery_carrier_partner_add_edit_viewmodel.dart';
import 'package:tpos_mobile/helpers/tmt.dart';
import 'package:tpos_mobile/src/tpos_apis/models/service_custom.dart';

import 'package:tpos_mobile/src/tpos_apis/tpos_api.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

class DeliveryCarrierPartnerAddEditPage extends StatefulWidget {
  const DeliveryCarrierPartnerAddEditPage(
      {this.deliveryType, this.deliveryName, this.editCarrier});
  final String deliveryType;
  final String deliveryName;
  final DeliveryCarrier editCarrier;

  @override
  _DeliveryCarrierPartnerAddEditPageState createState() =>
      _DeliveryCarrierPartnerAddEditPageState();
}

class _DeliveryCarrierPartnerAddEditPageState
    extends State<DeliveryCarrierPartnerAddEditPage> {
  final _vm = DeliveryCarrierPartnerAddEditViewModel();
  final _nameController = TextEditingController();
  final _senderNameController = TextEditingController();
  final _vnPostClientIdController = TextEditingController();
  final _vnPostPostIdController = TextEditingController();
  final _userNameController = TextEditingController();
  final _passFullController = TextEditingController();
  final _tokenController = TextEditingController();

  final _inputStyle =
      const TextStyle(fontWeight: FontWeight.bold, color: Colors.black54);

  final _headerStyle = const TextStyle(color: Colors.blue);

  @override
  void initState() {
    _vm.init(
        carrier: widget.editCarrier,
        addCarrierType: widget.deliveryType,
        addCarrierName: widget.deliveryName);
    _vm.initData();

    // fill editing controller
    _vm.addListener(() {
      _nameController.text = _vm.carrier.name;
      _senderNameController.text = _vm.carrier?.senderName;
      _vnPostClientIdController.text = _vm.carrier?.vNPostClientId?.toString();
      _vnPostPostIdController.text = _vm.carrier?.extras?.posId?.toString();
      _userNameController.text = _vm.carrier?.viettelPostUserName;
      _passFullController.text = _vm.carrier?.viettelPostPassword;
      _tokenController.text = _vm.carrier?.viettelPostToken;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return UIViewModelBase<DeliveryCarrierPartnerAddEditViewModel>(
      viewModel: _vm,
      child: Scaffold(
        appBar: AppBar(
          title: widget.deliveryType != null
              // Kết nối tới
              // Sửa đối tác
              ? Text(
                  "${S.current.deliveryPartner_ConnectTo} ${widget.deliveryType}")
              : Text(
                  "${S.current.deliveryPartner_EditPartner} ${widget.editCarrier?.name}"),
          actions: <Widget>[
            FlatButton.icon(
                textColor: Colors.white,
                onPressed: () {
                  _vm.save().then((value) {
                    if (value) Navigator.pop(context);
                  });
                },
                icon: const Icon(Icons.save),
                label: Text(S.current.save.toUpperCase()))
          ],
        ),
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: ScopedModelDescendant<DeliveryCarrierPartnerAddEditViewModel>(
        builder: (_, __, ___) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              color: Colors.grey.shade300,
              padding: const EdgeInsets.all(8),
              // hông tin
              child: Text(
                S.current.deliveryPartner_info,
                style: const TextStyle(color: Colors.grey),
              ),
            ),
            //Chung
            Padding(
              padding: const EdgeInsets.all(12),
              child: TextField(
                // Đặt tên đối tác
                decoration: InputDecoration(
                    labelText: "${S.current.deliveryPartner_PartnerName}:",
                    labelStyle: _headerStyle),
                controller: TextEditingController(text: _vm.carrier?.name),
                onChanged: (text) => _vm.carrier?.name = text,
                style: _inputStyle,
              ),
            ),
            // Cho phép sử dụng
            CheckboxListTile(
              title: Text(S.current.deliveryPartner_AllowUse),
              value: _vm.carrier?.active ?? false,
              onChanged: (value) => _vm.isActive = value,
            ),
            // In theo mẫu?
            //In theo mẫu riêng của đối tác (Chỉ áp dụng cho phiên bản Web
            CheckboxListTile(
              title: Text(S.current.printByTemplate),
              subtitle: Text(S.current.deliveryPartner_printByPartnerTemplate),
              value: _vm.carrier?.isPrintCustom ?? false,
              onChanged: (value) => _vm.isPrintCustom = value,
            ),
            // Thông tin kết nối
            Container(
              color: Colors.grey.shade300,
              padding: const EdgeInsets.all(8),
              child: Text(
                S.current.deliveryPartner_ConnectInfo,
                style: const TextStyle(color: Colors.grey),
              ),
            ),
            // Cấu hình kết nối
            _buildConnect(),
            // Cấu hình nâng cao
            Container(
              color: Colors.grey.shade300,
              padding: const EdgeInsets.all(8),
              // Giá trị mặc định
              child: Text(
                S.current.deliveryPartner_DefaultValue,
                style: const TextStyle(color: Colors.grey),
              ),
            ),

            // Cấu hình
            // Phí ship mặc định
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: TextField(
                decoration: InputDecoration(
                  hintText: S.current.deliveryPartner_DefaultShippingFee,
                  labelText: S.current.deliveryPartner_DefaultShippingFee,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  CurrencyInputFormatter(),
                ],
                style: const TextStyle(fontWeight: FontWeight.bold),
                keyboardType: TextInputType.number,
                controller: TextEditingController(
                  text: vietnameseCurrencyFormat(_vm.carrier?.configDefaultFee),
                ),
                onChanged: (text) {
                  final value = App.convertToDouble(text, "vi_VN");
                  _vm.carrier?.configDefaultFee = value;
                },
              ),
            ),
            // Khối lượng mặc định"
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: TextField(
                decoration: InputDecoration(
                    hintText: S.current.deliveryPartner_DefaultWeight,
                    labelText:
                        "${S.current.deliveryPartner_DefaultWeight} (g)"),
                controller: TextEditingController(
                  text: vietnameseCurrencyFormat(
                      _vm.carrier?.configDefaultWeight),
                ),
                inputFormatters: [
                  WhitelistingTextInputFormatter.digitsOnly,
                ],
                style: const TextStyle(fontWeight: FontWeight.bold),
                keyboardType: TextInputType.number,
                onChanged: (text) {
                  final value = int.parse(text);
                  _vm.carrier?.configDefaultWeight = value?.toDouble();
                },
              ),
            ),
            _buillDefaultOption(),
            //LƯU
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RaisedButton(
                child: Text(S.current.save.toUpperCase()),
                onPressed: () {
                  _vm.save().then((value) {
                    if (value) Navigator.pop(context);
                  });
                },
                textColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConnect() {
    switch (_vm.carrierType) {
      case "VNPost":
        return _buildVNPOSTConnectInputPanel();
        break;
      case "MyVNPost":
        return _buildMYVNPOSTConnectInputPanel();
        break;
      case "ViettelPost":
        return _buildVIETTELPOSTConnectInputPanel();
        break;
      case "GHN":
        return _buildGHNConnectInputPanel();
        break;
      case "GHTK":
        return _buildGHTKConnectInputPanel();
        break;
      case "TinToc":
        return _buildTINTOCConnectInputPanel();
        break;
      case "JNT":
        return _buildJNTConnectInputPanel();
        break;
      case "SuperShip":
        return _buildSUPERSHIPConnectInputPanel();
        break;
      case "OkieLa":
        return _buildOKIELAConnectInputPanel();
        break;
      case "fixed":
        return _buildFIXEDConnectInputPanel();
        break;
      case "FulltimeShip":
        return _buildFullTimeShipConnectInputPanel();
        break;
      case "BEST":
        return _buildBESTConnectInputPanel();
        break;
      case "FlashShip":
        return _buildFlashShipConnectInputPanel();
        break;
      case "DHL":
        return _buildDHLExpressConnectInputPanel();
        break;
      default:
        return const SizedBox();
        break;
    }
  }

  Widget _buillDefaultOption() {
    // "0": "Không chọn", "1": "Sáng", "2": "Chiều", "3": "Tối"
    final ships = {
      "0": S.current.deliveryPartner_UnSelect,
      "1": S.current.morning,
      "2": S.current.afternoon,
      "3": S.current.evening,
    };
    switch (_vm.carrierType) {
      case "ViettelPost":
        return Column(
          children: <Widget>[
            CheckboxListTile(
              value: _vm.carrier?.extras?.isDropoff ?? false,
              //Gửi hàng tại điểm
              title: Text(S.current.deliveryPartner_DeliveryAtPosition),
              onChanged: (value) {
                _vm.isDropOff = value;
              },
            ),
          ],
        );
        break;
      case "GHTK":
        return Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(
                height: 10,
              ),
              // Buối láy hàng
              Text(S.current.deliveryPartner_DeliveryTime),
              const Divider(),
              DropdownButton<String>(
                isExpanded: true,
                value: _vm.carrier?.extras?.pickWorkShift,
                onChanged: (value) {
                  _vm.setPickWorkShift(value, ships[value]);
                },
                items: ships.keys
                    .map(
                      (f) => DropdownMenuItem<String>(
                        child: Text(
                          ships[f],
                        ),
                        value: f,
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        );
        break;
      default:
        return const SizedBox();
        break;
    }
  }

  /// Nhập tên người gửi
  Widget _buildSenderNameInput() {
    // Tên người gửi
    return TextField(
      controller: _senderNameController,
      decoration: InputDecoration(
          labelText: "${S.current.deliveryPartner_SenderName}:",
          labelStyle: _headerStyle),
      onChanged: (text) => _vm.carrier?.senderName = text,
      style: _inputStyle,
    );
  }

  Widget _buildVNPOSTConnectInputPanel() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _buildSenderNameInput(),
            TextField(
              controller: _vnPostPostIdController,
              // Mã bưu cục
              decoration: InputDecoration(
                  labelText: "${S.current.deliveryPartner_code}:",
                  labelStyle: _headerStyle),
              onChanged: (text) => _vm.postId = text,
            ),
            // Mã khách hàng
            TextField(
              controller: _vnPostClientIdController,
              decoration: InputDecoration(
                  labelText: "${S.current.customerNumber}:",
                  labelStyle: _headerStyle),
              onChanged: (text) => _vm.carrier?.vNPostClientId = text,
            ),
            // Dịch vụ
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                S.current.deliveryPartner_service,
                style: _headerStyle,
              ),
            ),
            // Chọn dịch vụ"
            DropdownButton<String>(
              isExpanded: true,
              value: _vm.carrier?.vNPostServiceId,
              hint: Text(S.current.deliveryPartner_ChooseService),
              onChanged: (value) {
                setState(() {
                  _vm.carrier.vNPostServiceId = value;
                });
              },
              items: [
                // Không chọn
                DropdownMenuItem<String>(
                  child: Text("- ${S.current.deliveryPartner_UnSelect} -"),
                  value: null,
                ),
                // Nhanh
                DropdownMenuItem<String>(
                  child: Text("${S.current.deliveryPartner_fast} (EMS)"),
                  value: "1",
                ),
                // Thường  Bưu kiện
                DropdownMenuItem<String>(
                  child: Text(
                      "${S.current.deliveryPartner_normal} (${S.current.deliveryPartner_parcel})"),
                  value: "2",
                ),
              ],
            ),
            //Hình thức lấy hàng
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                S.current.deliveryPartner_MethodOfTakingGoods,
                style: _headerStyle,
              ),
            ),
            DropdownButton<String>(
              isExpanded: true,
              value: _vm.carrier?.vNPostPickupType,
              hint: Text(S.current.deliveryPartner_ChooseMethod),
              onChanged: (value) {
                setState(() {
                  _vm.carrier.vNPostPickupType = value;
                });
              },
              items: [
                // Không chọn
                DropdownMenuItem<String>(
                  child: Text("- ${S.current.deliveryPartner_UnSelect} -"),
                  value: null,
                ),
                // Mang hàng đến bưu cục
                DropdownMenuItem<String>(
                  child: Text(
                      "Dropoff (${S.current.deliveryPartner_BringToPostOffice})"),
                  value: "1",
                ),
                // Thu gom hàng
                DropdownMenuItem<String>(
                  child: Text(
                      "Pickup (${S.current.deliveryPartner_CollectGoods})"),
                  value: "2",
                ),
              ],
            ),
            // Đã ký hợp đồng?
            CheckboxListTile(
              title: Text(S.current.deliveryPartner_SignedTheContract),
              value: _vm.carrier?.vNPostIsContracted ?? false,
              onChanged: (value) {},
            ),
          ],
        ),
      ),
    );
  }

  /// Giao diện nhập My VNPost
  Widget _buildMYVNPOSTConnectInputPanel() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _buildSenderNameInput(),
            TextField(
              controller: _vnPostClientIdController,
              //Mã khách hàng
              decoration: InputDecoration(
                  labelText: "${S.current.customerNumber}:",
                  labelStyle: _headerStyle),
              onChanged: (text) => _vm.carrier?.vNPostClientId = text,
            ),
            //Dịch vụ
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                S.current.deliveryPartner_service,
                style: _headerStyle,
              ),
            ),
            DropdownButton<String>(
              isExpanded: true,
              value: _vm.carrier?.viettelPostServiceId,
              hint: Text(S.current.deliveryPartner_ChooseService),
              onChanged: (value) {
                setState(() {
                  _vm.carrier.viettelPostServiceId = value;
                });
              },
              items: [
                //Không chọn
                DropdownMenuItem<String>(
                  child: Text("- ${S.current.deliveryPartner_UnSelect} -"),
                  value: null,
                ),
                // Chuyển phát nhanh
                DropdownMenuItem<String>(
                  child:
                      Text("EMS: ${S.current.deliveryPartner_ExpressDelivery}"),
                  value: "EMS",
                ),
                //Chuyển phát thường"
                DropdownMenuItem<String>(
                  child:
                      Text("BK: ${S.current.deliveryPartner_NormalDelivery}"),
                  value: "BK",
                ),
                //Chuyển phát tiết kiệm
                DropdownMenuItem<String>(
                  child: Text(
                      "ECOD: ${S.current.deliveryPartner_SavingsDelivery}"),
                  value: "ECOD",
                ),
                //Dịch vụ thỏa thuận
                DropdownMenuItem<String>(
                  child: Text(
                      "DONG_GIA: ${S.current.deliveryPartner_ServiceAgreement}"),
                  value: "DONG_GIA",
                ),
              ],
            ),
            //Hình thức lấy hàng
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                S.current.deliveryPartner_MethodOfTakingGoods,
                style: _headerStyle,
              ),
            ),
            // Chọn hình thức lấy hàng
            DropdownButton<String>(
              isExpanded: true,
              value: _vm.carrier?.vNPostPickupType,
              hint: Text(S.current.deliveryPartner_ChooseMethod),
              onChanged: (value) {
                setState(() {
                  _vm.carrier.vNPostPickupType = value;
                });
              },
              items: [
                // Không chọn
                DropdownMenuItem<String>(
                  child: Text("- ${S.current.deliveryPartner_UnSelect} -"),
                  value: null,
                ),
                //Mang hàng đến bưu cục
                DropdownMenuItem<String>(
                  child: Text(
                      "Dropoff (${S.current.deliveryPartner_BringToPostOffice})"),
                  value: "2",
                ),
                // Thu gom hàng
                DropdownMenuItem<String>(
                  child: Text(
                      "Pickup (${S.current.deliveryPartner_CollectGoods})"),
                  value: "1",
                ),
              ],
            ),
            //Kích thước kiện hàng
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text("${S.current.deliveryPartner_size} (cm)",
                  style: _headerStyle),
            ),
            Row(
              children: <Widget>[
                // Chiều dài
                Expanded(
                  child: AppInputNumberField(
                    value: _vm.carrier?.gHNPackageLength?.toDouble(),
                    format: "###,###,###",
                    decoration: InputDecoration(
                      labelText: "${S.current.deliveryPartner_length}:",
                      labelStyle: _headerStyle,
                    ),
                    onValueChanged: (value) {
                      _vm.carrier?.gHNPackageLength = value.toInt();
                    },
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                // Chiều rộng
                Expanded(
                  child: AppInputNumberField(
                    value: _vm.carrier?.gHNPackageWidth?.toDouble(),
                    format: "###,###,###",
                    decoration: InputDecoration(
                        labelText: "${S.current.deliveryPartner_width}:",
                        labelStyle: _headerStyle),
                    onValueChanged: (value) {
                      _vm.carrier?.gHNPackageWidth = value.toInt();
                    },
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                // Chiều cao
                Expanded(
                  child: AppInputNumberField(
                    value: _vm.carrier?.gHNPackageHeight?.toDouble(),
                    format: "###,###,###",
                    decoration: InputDecoration(
                        labelText: "${S.current.deliveryPartner_height}:",
                        labelStyle: _headerStyle),
                    onValueChanged: (value) {
                      print(value);
                      _vm.carrier?.gHNPackageHeight = value.toInt();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVIETTELPOSTConnectInputPanel() {
    const inputStyle =
        TextStyle(color: Colors.black87, fontWeight: FontWeight.bold);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(16),
          child: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                _buildSenderNameInput(),
                // Tải khoản
                TextField(
                  decoration: InputDecoration(
                      labelText: "${S.current.deliveryPartner_UserName}:",
                      labelStyle: _headerStyle),
                  style: inputStyle,
                  controller: TextEditingController(
                      text: _vm.carrier?.viettelPostUserName),
                  onChanged: (text) => _vm.carrier.viettelPostUserName = text,
                ),
                // Mật khẩu
                TextField(
                  decoration: InputDecoration(
                      labelText: "${S.current.deliveryPartner_PassWord}:",
                      labelStyle: _headerStyle),
                  obscureText: true,
                  style: inputStyle,
                  controller: TextEditingController(
                      text: _vm.carrier?.viettelPostPassword),
                  onChanged: (text) => _vm.carrier.viettelPostPassword = text,
                ),
                // Dịch vụ
                Padding(
                  padding: const EdgeInsets.only(left: 0, top: 8),
                  child: Text("${S.current.deliveryPartner_service}:",
                      style: _headerStyle),
                ),
                DropdownButton<String>(
                  style: inputStyle,
                  isExpanded: true,
                  value: _vm.carrier?.viettelPostServiceId,
                  hint: Text(S.current.deliveryPartner_ChooseService),
                  onChanged: (value) {
                    setState(() {
                      _vm.carrier.viettelPostServiceId = value;
                    });
                  },
                  items: [
                    //Không chọn
                    DropdownMenuItem<String>(
                      child: Text("- ${S.current.deliveryPartner_UnSelect} -"),
                      value: "",
                    ),
                    // Giao hàng thu tiền
                    DropdownMenuItem<String>(
                      child: Text(
                          "${S.current.deliveryPartner_CashierDelivery} (SCOD)"),
                      value: "SCOD",
                    ),
                    //Chuyển phát nhanh
                    DropdownMenuItem<String>(
                      child: Text(
                          "${S.current.deliveryPartner_ExpressDelivery} (VCN)"),
                      value: "VCN",
                    ),
                    // Phát trong ngày nội tỉnh
                    DropdownMenuItem<String>(
                      child: Text(
                          "${S.current.deliveryPartner_DeliveryOfTheDay} (PTN)"),
                      value: "PTN",
                    ),
                    // Phát hỏa tốc nội tỉnh
                    DropdownMenuItem<String>(
                      child: Text(
                          "${S.current.deliveryPartner_FastDeliveryOfTheDay} (PHT)"),
                      value: "PHT",
                    ),
                    // Phát hôm sau nội tỉnh
                    DropdownMenuItem<String>(
                      child: Text(
                          "${S.current.deliveryPartner_DeliveryTheNextDay} (PHS)"),
                      value: "PHS",
                    ),
                    // Tiết kiệm
                    DropdownMenuItem<String>(
                      child: Text("${S.current.deliveryPartner_save} (VTK)"),
                      value: "VTK",
                    ),
                    //Dịch vụ nhanh 60h
                    DropdownMenuItem<String>(
                      child: Text(
                          "${S.current.deliveryPartner_FastService60H} (V60)"),
                      value: "V60",
                    ),
                    //Dịch vụ vận tải
                    DropdownMenuItem<String>(
                      child: Text(
                          "${S.current.deliveryPartner_ServiceOfTransportation} (VVT)"),
                      value: "VVT",
                    ),
                    // Nhanh theo hộp
                    DropdownMenuItem<String>(
                      child: Text(
                          "${S.current.deliveryPartner_ExpressDeliveryByBox} (VBS)"),
                      value: "VBS",
                    ),
                    // Tiết kiệm theo hộ
                    DropdownMenuItem<String>(
                      child: Text(
                          "${S.current.deliveryPartner_SavingsByTheBox} (VBE)"),
                      value: "VBE",
                    ),
                  ],
                ),
                //Mã khách hàng
                TextField(
                  decoration: InputDecoration(
                      labelText: "${S.current.customerNumber}:",
                      labelStyle: _headerStyle,
                      hintText: S.current.customerNumber),
                  style: inputStyle,
                  controller: TextEditingController(
                      text: _vm.carrier?.vNPostClientId?.toString()),
                  onChanged: (text) => _vm.carrier.vNPostClientId = text,
                  readOnly: true,
                ),
                // Loại hàng hóa
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(S.current.deliveryPartner_ProductType,
                      style: _headerStyle),
                ),
                //Chọn loại hàng hóa
                DropdownButton<String>(
                  isExpanded: true,
                  value: _vm.carrier?.viettelPostProductType,
                  style: inputStyle,
                  hint: Text(S.current.deliveryPartner_ChooseProductType),
                  onChanged: (value) {
                    setState(() {
                      _vm.carrier.viettelPostProductType = value;
                    });
                  },
                  items: [
                    //  Không chọn
                    DropdownMenuItem<String>(
                      child: Text("- ${S.current.deliveryPartner_UnSelect} -"),
                      value: null,
                    ),
                    // Thư
                    DropdownMenuItem<String>(
                      child: Text(S.current.deliveryPartner_letter),
                      value: "TH",
                    ),
                    //Hàng hóa
                    DropdownMenuItem<String>(
                      child: Text(S.current.deliveryPartner_product),
                      value: "HH",
                    ),
                  ],
                ),
                // Loại vận đơn
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(S.current.deliveryPartner_billOfLadingType,
                      style: _headerStyle),
                ),
                // Chọn loại vận đơn
                DropdownButton<int>(
                  isExpanded: true,
                  value: _vm.carrier?.viettelPostOrderPayment,
                  hint: Text(S.current.deliveryPartner_ChooseBillOfLadingType),
                  style: inputStyle,
                  onChanged: (value) {
                    setState(() {
                      _vm.carrier.viettelPostOrderPayment = value;
                    });
                  },
                  items: [
                    //Không thu tiền
                    DropdownMenuItem<int>(
                      child: Text(S.current.deliveryPartner_NoCharges),
                      value: 1,
                    ),
                    // Thu hộ tiền cước và tiền hàng
                    DropdownMenuItem<int>(
                      child: Text(
                          S.current.deliveryPartner_FareAndMoneyOfTheProduct),
                      value: 2,
                    ),
                    // Thu hộ tiền hàng
                    DropdownMenuItem<int>(
                      child: Text(
                          S.current.deliveryPartner_CollectMoneyOfTheProduct),
                      value: 3,
                    ),
                    // Thu hộ tiền cước
                    DropdownMenuItem<int>(
                      child: Text(S.current.deliveryPartner_CollectFare),
                      value: 4,
                    ),
                  ],
                ),
                TextField(
                  decoration: InputDecoration(
                      labelText: "Token:", labelStyle: _headerStyle),
                  style: inputStyle,
                  controller: TextEditingController(
                      text: _vm.carrier?.viettelPostToken),
                  onChanged: (text) => _vm.carrier.viettelPostToken = text,
                  maxLines: null,
                ),
                // Lấy token
                RaisedButton(
                  child: Text(S.current.getToken),
                  color: Colors.deepPurpleAccent,
                  textColor: Colors.white,
                  onPressed: () {
                    _vm.getViettelPostShipToken();
                  },
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        Divider(
          color: Colors.grey.shade300,
          height: 1,
          thickness: 16,
        ),
        // Dịch vụ tùy chỉnh
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: ExpansionTile(
            title: Text(S.current.deliveryPartner_ServiceOptions),
            initiallyExpanded: true,
            children: <Widget>[
              if (_vm.carrier?.extras?.serviceCustoms?.isEmpty)
                _buildEmpty()
              else
                Container(
                    margin: const EdgeInsets.only(top: 6, bottom: 12),
                    padding: const EdgeInsets.only(
                        left: 12, right: 12, top: 6, bottom: 6),
                    color: Colors.white,
                    child: _buildListItem()),
              _buildItemService(),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildEmpty() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            S.current.deliveryPartner_NoService,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildListItem() {
    return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: _vm.carrier?.extras?.serviceCustoms?.length ?? 0,
        itemBuilder: (BuildContext context, int index) {
          return _showItem(_vm.carrier?.extras?.serviceCustoms[index], index);
        });
  }

// Hiển thị thông tin dịch vụ tùy chỉnh
  Widget _showItem(ServiceCustom item, int index) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ControlServicePage(
              serviceCustom: _vm.carrier?.extras?.serviceCustoms[index],
            ),
          ),
        ).then((value) {
          if (value != null) {
            setState(() {});
          }
        });
      },
      child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          margin: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                      color: _vm.carrier?.extras?.serviceCustoms?.length == 1
                          ? Colors.white
                          : Colors.grey[300]))),
          child: ListTile(
            contentPadding: const EdgeInsets.all(0),
            subtitle: Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 12),
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: item.isDefault == null
                              ? Colors.grey
                              : item.isDefault
                                  ? Colors.green
                                  : Colors.grey)),
                  child: Center(
                    child: item.isDefault == null
                        ? const Icon(
                            Icons.close,
                            size: 20,
                            color: Colors.grey,
                          )
                        : item.isDefault
                            ? const Icon(
                                Icons.check,
                                size: 20,
                                color: Colors.green,
                              )
                            : const Icon(
                                Icons.close,
                                size: 20,
                                color: Colors.grey,
                              ),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.serviceId ?? "",
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[800],
                              fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Flexible(
                            child: Text(item.name ?? "",
                                style: TextStyle(
                                    fontSize: 15, color: Colors.grey[800])),
                          ),
                          // "có" : "Không"
                          Text(
                              " | ${S.current.defaults}: ${item.isDefault ? S.current.yes : S.current.no}",
                              style: TextStyle(
                                  fontSize: 14, color: Colors.grey[700]))
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.delete_forever,
                    size: 30,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    setState(() {
                      _vm.carrier?.extras?.serviceCustoms?.removeAt(index);
                    });
                  },
                )
              ],
            ),
          )),
    );
  }

//Hiển thị danh sách dịch vụ
  Widget _buildItemService() {
    print(_vm.carrier);
    if (_vm.carrier?.extras == null) {
      _vm.carrier?.extras = ShipExtra();
      _vm.carrier?.extras?.serviceCustoms = [];
    }
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 12),
        height: 45,
        decoration: BoxDecoration(
            color: Colors.grey[300], borderRadius: BorderRadius.circular(6)),
        child: FlatButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ControlServicePage(
                    serviceCustoms: _vm.carrier?.extras?.serviceCustoms,
                  ),
                ),
              ).then((value) {
                if (value != null) {
                  setState(() {});
                }
              });
            },
            icon: const Icon(
              Icons.add,
              color: Colors.grey,
            ),
            label: Text(S.current.deliveryPartner_AddService)));
  }

  Widget _buildGHNConnectInputPanel() {
    const inputStyle =
        TextStyle(color: Colors.black87, fontWeight: FontWeight.bold);
    return Container(
      padding: const EdgeInsets.all(16),
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _buildSenderNameInput(),
            //Mã khách hàng
            TextField(
              decoration: InputDecoration(
                  labelText: "${S.current.customerNumber}:",
                  labelStyle: _headerStyle),
              style: inputStyle,
              controller: TextEditingController(text: _vm.carrier?.gHNClientId),
              onChanged: (text) => _vm.carrier.gHNClientId = text,
            ),

            TextField(
              decoration: InputDecoration(
                  labelText: "API Key:", labelStyle: _headerStyle),
              style: inputStyle,
              controller: TextEditingController(text: _vm.carrier?.gHNApiKey),
              onChanged: (text) => _vm.carrier.gHNApiKey = text,
            ),

            // Dịch vụ
            Padding(
              padding: const EdgeInsets.only(left: 0, top: 8),
              child: Text("${S.current.deliveryPartner_service}:",
                  style: _headerStyle),
            ),
            DropdownButton<String>(
              style: inputStyle,
              isExpanded: true,
              value: _vm.carrier?.gHNServiceId,
              hint: Text(S.current.deliveryPartner_ChooseService),
              onChanged: (value) {
                setState(() {
                  _vm.carrier.gHNServiceId = value;
                });
              },
              items: [
                // Không chọn
                DropdownMenuItem<String>(
                  child: Text(S.current.deliveryPartner_UnSelect),
                  value: "",
                ),
                // Gói siêu tốc
                DropdownMenuItem<String>(
                  child: Text(
                      "${S.current.deliveryPartner_SuperSpeedPackage} (Kiện)"),
                  value: "17",
                ),
                // Gói tiết kiệm
                DropdownMenuItem<String>(
                  child:
                      Text("${S.current.deliveryPartner_SavingPackage} (Kiện)"),
                  value: "18",
                ),
                //6 Giờ
                DropdownMenuItem<String>(
                  child: Text(S.current.sixHours),
                  value: "53319",
                ),
                //1 Ngày
                DropdownMenuItem<String>(
                  child: Text(S.current.aDay),
                  value: "53320",
                ),
                //2 ngày
                DropdownMenuItem<String>(
                  child: Text(S.current.twoDay),
                  value: "53321",
                ),
                //3 Ngày
                DropdownMenuItem<String>(
                  child: Text(S.current.threeDay),
                  value: "53322",
                ),
                //4 Ngày
                DropdownMenuItem<String>(
                  child: Text(S.current.fourDay),
                  value: "53323",
                ),
                //4 Ngày
                DropdownMenuItem<String>(
                  child: Text(S.current.fiveDay),
                  value: "53324",
                ),
                const DropdownMenuItem<String>(
                  child: Text("Prime"),
                  value: "53325",
                ),
                DropdownMenuItem<String>(
                  child: Text(S.current.fourHours),
                  value: "53326",
                ),
                // "6 Ngày"
                DropdownMenuItem<String>(
                  child: Text(S.current.sixDay),
                  value: "53327",
                ),
                DropdownMenuItem<String>(
                  child: Text(S.current.sixtyMinutes),
                  value: "53329",
                ),
                DropdownMenuItem<String>(
                  child: Text(S.current.deliveryPartner_SuperSaving),
                  value: "100036",
                ),
              ],
            ),
            // Ghi chú hàng ship
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child:
                  Text(S.current.deliveryPartner_ShipNote, style: _headerStyle),
            ),
            DropdownButton<String>(
              isExpanded: true,
              value: _vm.carrier?.gHNNoteCode,
              style: inputStyle,
              //Chọn ghi chú
              hint: Text(S.current.deliveryPartner_ChooseNote),
              onChanged: (value) {
                setState(() {
                  _vm.carrier.gHNNoteCode = value;
                });
              },
              items: [
                // Cho xem hàng không thử
                DropdownMenuItem<String>(
                  child: Text(S.current.deliveryPartner_OnlyViewProduct),
                  value: "CHOXEMHANGKHONGTHU",
                ),
                //Cho thử hàng
                DropdownMenuItem<String>(
                  child: Text(S.current.deliveryPartner_AllowTryToProduct),
                  value: "CHOTHUHANG",
                ),
                // Không cho xem hàng
                DropdownMenuItem<String>(
                  child: Text(S.current.deliveryPartner_DoNotViewTheProduct),
                  value: "KHONGCHOXEMHANG",
                ),
              ],
            ),

            // Người  trả tiền ship
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(S.current.deliveryPartner_ShipPayer,
                  style: _headerStyle),
            ),
            DropdownButton<int>(
              isExpanded: true,
              value: _vm.carrier?.gHNPaymentTypeId,
              style: inputStyle,
              // Chọn người trả
              hint: Text(S.current.deliveryPartner_ChoosePayer),
              onChanged: (value) {
                setState(() {
                  _vm.carrier.gHNPaymentTypeId = value;
                });
              },
              items: [
                // deliveryPartner_ShopPayment
                DropdownMenuItem<int>(
                  child: Text(S.current.deliveryPartner_ShopPay),
                  value: 1,
                ),
                // "Khách trả"
                DropdownMenuItem<int>(
                  child: Text(S.current.deliveryPartner_CustomerPay),
                  value: 2,
                ),
              ],
            ),
// Kích thước
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text("${S.current.deliveryPartner_size} (cm)",
                  style: _headerStyle),
            ),

            Row(
              children: <Widget>[
                // Chiều dài
                Expanded(
                  child: AppInputNumberField(
                    value: _vm.carrier?.gHNPackageLength?.toDouble(),
                    format: "###,###,###",
                    decoration: InputDecoration(
                        labelText: "${S.current.deliveryPartner_length}:",
                        labelStyle: _headerStyle),
                    onValueChanged: (value) {
                      _vm.carrier?.gHNPackageLength = value.toInt();
                    },
                  ),
                ),
                Expanded(
                  child: AppInputNumberField(
                    value: _vm.carrier?.gHNPackageWidth?.toDouble(),
                    format: "###,###,###",
                    decoration: InputDecoration(
                        labelText: "${S.current.deliveryPartner_width}:",
                        labelStyle: _headerStyle),
                    onValueChanged: (value) {
                      _vm.carrier?.gHNPackageWidth = value.toInt();
                    },
                  ),
                ),
                Expanded(
                  child: AppInputNumberField(
                    value: _vm.carrier?.gHNPackageHeight?.toDouble(),
                    format: "###,###,###",
                    decoration: InputDecoration(
                        labelText: "${S.current.deliveryPartner_width}:",
                        labelStyle: _headerStyle),
                    onValueChanged: (value) {
                      print(value);
                      _vm.carrier?.gHNPackageHeight = value.toInt();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGHTKConnectInputPanel() {
    const inputStyle =
        TextStyle(color: Colors.black87, fontWeight: FontWeight.bold);
    return Container(
      padding: const EdgeInsets.all(16),
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _buildSenderNameInput(),

            //Mã khách hàng
            TextField(
              decoration: InputDecoration(
                  labelText: "${S.current.customerNumber}:",
                  labelStyle: _headerStyle),
              style: inputStyle,
              controller:
                  TextEditingController(text: _vm.carrier?.gHTKClientId),
              onChanged: (text) => _vm.carrier.gHTKClientId = text,
            ),

            TextField(
              decoration: InputDecoration(
                  labelText: "Token:",
                  labelStyle: _headerStyle,
                  suffix: RaisedButton(
                    child: Text(S.current.getToken),
                    onPressed: () {
                      _showGetTokenGHTKDialog();
                    },
                    textColor: Colors.white,
                  )),
              style: inputStyle,
              controller: TextEditingController(text: _vm.carrier?.gHTKToken),
              onChanged: (text) => _vm.carrier.gHTKToken = text,
            ),

            // Dịch vụ
            //Phương thức vận chuyển
            Padding(
              padding: const EdgeInsets.only(left: 0, top: 8),
              child: Text("${S.current.deliveryPartner_ShippingMethod}:",
                  style: _headerStyle),
            ),
            // Chọn dịch vụ
            DropdownButton<int>(
              style: inputStyle,
              isExpanded: true,
              value: _vm.carrier?.configTransportId,
              hint: Text(S.current.deliveryPartner_ChooseService),
              onChanged: (value) {
                setState(() {
                  _vm.carrier.configTransportId = value;
                });
              },
              items: [
                DropdownMenuItem<int>(
                  // "Không chọn
                  child: Text(S.current.deliveryPartner_UnSelect),
                  value: null,
                ),
                //Đường ba
                DropdownMenuItem<int>(
                  child: Text(S.current.deliveryPartner_FlightRoute),
                  value: 1,
                ),
                DropdownMenuItem<int>(
                  child: Text(S.current.deliveryPartner_road),
                  value: 0,
                ),
              ],
            ),
            //Người trả phí shi
            Padding(
              padding: const EdgeInsets.only(left: 0, top: 8),
              child: Text("${S.current.deliveryPartner_ShipPayer}:",
                  style: _headerStyle),
            ),
            DropdownButton<int>(
              style: inputStyle,
              isExpanded: true,
              value: _vm.carrier?.gHNPaymentTypeId,
              hint: Text(S.current.deliveryPartner_ChoosePayer),
              onChanged: (value) {
                setState(() {
                  _vm.carrier.gHNPaymentTypeId = value;
                });
              },
              items: [
                DropdownMenuItem<int>(
                  //Khách trả
                  child: Text(S.current.deliveryPartner_CustomerPay),
                  value: 1,
                ),
                // Shop trả
                DropdownMenuItem<int>(
                  child: Text(S.current.deliveryPartner_ShopPay),
                  value: 2,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTINTOCConnectInputPanel() {
    const inputStyle =
        TextStyle(color: Colors.black87, fontWeight: FontWeight.bold);
    return Container(
      padding: const EdgeInsets.all(16),
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _buildSenderNameInput(),
            // Tài khoản
            TextField(
              decoration: InputDecoration(
                  labelText: "${S.current.deliveryPartner_UserName} (email):",
                  labelStyle: _headerStyle),
              style: inputStyle,
              controller:
                  TextEditingController(text: _vm.carrier?.viettelPostUserName),
              onChanged: (text) => _vm.carrier.viettelPostUserName = text,
            ),
            TextField(
              decoration: InputDecoration(
                  labelText: "API TOKEN:", labelStyle: _headerStyle),
              style: inputStyle,
              controller:
                  TextEditingController(text: _vm.carrier?.viettelPostPassword),
              onChanged: (text) => _vm.carrier.viettelPostPassword = text,
            ),
            TextField(
              decoration: InputDecoration(
                  labelText: "Token:", labelStyle: _headerStyle),
              style: inputStyle,
              controller:
                  TextEditingController(text: _vm.carrier?.viettelPostToken),
              onChanged: (text) => _vm.carrier.viettelPostToken = text,
            ),

            // Người trả phí ship
            Padding(
              padding: const EdgeInsets.only(left: 0, top: 8),
              child: Text("${S.current.deliveryPartner_ShipPayer}:",
                  style: _headerStyle),
            ),
            DropdownButton<int>(
              style: inputStyle,
              isExpanded: true,
              value: _vm.carrier.gHNPaymentTypeId,
              hint: Text(S.current.deliveryPartner_ChooseService),
              onChanged: (value) {
                setState(() {
                  _vm.carrier.gHNPaymentTypeId = value;
                });
              },
              items: [
                // Khách trả
                DropdownMenuItem<int>(
                  child: Text(S.current.deliveryPartner_CustomerPay),
                  value: 0,
                ),
                DropdownMenuItem<int>(
                  child: Text(S.current.deliveryPartner_ShopPay),
                  value: 1,
                ),
              ],
            ),

            //Dịch vụ
            Padding(
              padding: const EdgeInsets.only(left: 0, top: 8),
              child: Text("${S.current.deliveryPartner_service}:",
                  style: _headerStyle),
            ),
            DropdownButton<String>(
              style: inputStyle,
              isExpanded: true,
              value: _vm.carrier.viettelPostServiceId,
              hint: Text(S.current.choose),
              onChanged: (value) {
                setState(
                  () {
                    _vm.carrier.viettelPostServiceId = value;
                  },
                );
              },
              items: [
                // Không chọn
                DropdownMenuItem<String>(
                  child: Text(S.current.deliveryPartner_UnSelect),
                  value: null,
                ),
                // Giao tức thời
                DropdownMenuItem<String>(
                  child: Text(S.current.deliveryPartner_DeliveryImmediately),
                  value: "1351",
                ),
                // Hẹn giờ
                DropdownMenuItem<String>(
                  child: Text(S.current.deliveryPartner_Timer),
                  value: "2082600",
                ),
                // Tiêu chuẩn
                DropdownMenuItem<String>(
                  child: Text(S.current.deliveryPartner_standard),
                  value: "103800",
                ),
                // Siêu tốc
                DropdownMenuItem<String>(
                  child: Text(S.current.deliveryPartner_SuperSpeed),
                  value: "100001",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJNTConnectInputPanel() {
    const inputStyle =
        TextStyle(color: Colors.black87, fontWeight: FontWeight.bold);
    return Container(
      padding: const EdgeInsets.all(16),
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _buildSenderNameInput(),

            //Mã khách hàng
            TextField(
              decoration: InputDecoration(
                  labelText: "${S.current.customerNumber}:",
                  labelStyle: _headerStyle),
              style: inputStyle,
              controller: TextEditingController(text: _vm.carrier?.gHNClientId),
              onChanged: (text) => _vm.carrier.gHNClientId = text,
            ),

            // Hình thức thanh toán
            Padding(
              padding: const EdgeInsets.only(left: 0, top: 8),
              child: Text("${S.current.paymentMethod}:", style: _headerStyle),
            ),
            DropdownButton<int>(
              style: inputStyle,
              isExpanded: true,
              value: _vm.carrier.gHNPaymentTypeId,
              hint: Text(S.current.choosePaymentMethod),
              onChanged: (value) {
                setState(() {
                  _vm.carrier.gHNPaymentTypeId = value;
                });
              },
              items: const [
                DropdownMenuItem<int>(
                  child: Text("PP_PM"),
                  value: 0,
                ),
                DropdownMenuItem<int>(
                  child: Text("PP_CASH"),
                  value: 1,
                ),
                DropdownMenuItem<int>(
                  child: Text("CC_CASH"),
                  value: 2,
                ),
              ],
            ),

            //Hình thức lấy hàn
            Padding(
              padding: const EdgeInsets.only(left: 0, top: 8),
              child: Text("${S.current.deliveryPartner_MethodOfTakingGoods}:",
                  style: _headerStyle),
            ),
            DropdownButton<String>(
              style: inputStyle,
              isExpanded: true,
              value: _vm.carrier.vNPostPickupType,
              hint: Text(S.current.choose),
              onChanged: (value) {
                setState(
                  () {
                    _vm.carrier.vNPostPickupType = value;
                  },
                );
              },
              items: [
                //Không chọn
                DropdownMenuItem<String>(
                  child: Text(S.current.deliveryPartner_UnSelect),
                  value: null,
                ),
                //Mang hàng đến bưu cục
                DropdownMenuItem<String>(
                  child: Text(
                      "Dropoff (${S.current.deliveryPartner_BringToPostOffice})"),
                  value: "6",
                ),
                //hu gom hàng
                DropdownMenuItem<String>(
                  child:
                      Text("Picup (${S.current.deliveryPartner_CollectGoods})"),
                  value: "1",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSUPERSHIPConnectInputPanel() {
    const inputStyle =
        TextStyle(color: Colors.black87, fontWeight: FontWeight.bold);
    return Container(
      padding: const EdgeInsets.all(16),
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _buildSenderNameInput(),
            // /"Mã khách hàng
            TextField(
              decoration: InputDecoration(
                  labelText: "${S.current.customerNumber}:",
                  labelStyle: _headerStyle),
              style: inputStyle,
              controller:
                  TextEditingController(text: _vm.carrier?.superShipClientId),
              onChanged: (text) => _vm.carrier.superShipClientId = text,
            ),
            TextField(
              decoration: InputDecoration(
                  labelText: "Token:", labelStyle: _headerStyle),
              style: inputStyle,
              controller:
                  TextEditingController(text: _vm.carrier?.superShipToken),
              onChanged: (text) => _vm.carrier.superShipToken = text,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOKIELAConnectInputPanel() {
    const inputStyle =
        TextStyle(color: Colors.black87, fontWeight: FontWeight.bold);
    return Container(
      padding: const EdgeInsets.all(16),
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _buildSenderNameInput(),
            // Dịch vụ
            // Người  trả tiền ship
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(S.current.deliveryPartner_ShipPayer,
                  style: _headerStyle),
            ),
            DropdownButton<int>(
              isExpanded: true,
              value: _vm.carrier?.gHNPaymentTypeId,
              style: inputStyle,
              hint: Text(S.current.deliveryPartner_ChoosePayer),
              onChanged: (value) {
                setState(() {
                  _vm.carrier.gHNPaymentTypeId = value;
                });
              },
              items: [
                // Shop trả
                DropdownMenuItem<int>(
                  child: Text(S.current.deliveryPartner_ShopPay),
                  value: 1,
                ),
                // Khách trả
                DropdownMenuItem<int>(
                  child: Text(S.current.deliveryPartner_CustomerPay),
                  value: 2,
                ),
              ],
            ),
            TextField(
              decoration: InputDecoration(
                  labelText: "Token:", labelStyle: _headerStyle),
              style: inputStyle,
              maxLines: null,
              maxLengthEnforced: true,
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.text,
              controller:
                  TextEditingController(text: _vm.carrier?.viettelPostToken),
              onChanged: (text) => _vm.carrier?.viettelPostToken = text,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFIXEDConnectInputPanel() {
    const inputStyle =
        TextStyle(color: Colors.black87, fontWeight: FontWeight.bold);
    return Container(
      padding: const EdgeInsets.all(16),
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _buildSenderNameInput(),
            // /Giá cố định
            AppInputNumberField(
              value: _vm.carrier?.fixedPrice ?? 0,
              onValueChanged: (value) => _vm.carrier?.fixedPrice = value,
              format: "###,###,###.###",
              decoration: InputDecoration(
                  labelText: S.current.reportOrder_fixedPrice,
                  labelStyle: _headerStyle),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFullTimeShipConnectInputPanel() {
    const inputStyle =
        TextStyle(color: Colors.black87, fontWeight: FontWeight.bold);
    return Container(
      padding: const EdgeInsets.all(16),
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _buildSenderNameInput(),
            //Tài khoản
            TextField(
              decoration: InputDecoration(
                  labelText: "${S.current.username} (email):",
                  labelStyle: _headerStyle),
              style: inputStyle,
              controller: _userNameController,
              onChanged: (text) => _vm.carrier.viettelPostUserName = text,
            ),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                  labelText: "${S.current.password}:",
                  labelStyle: _headerStyle),
              style: inputStyle,
              controller: _passFullController,
              onChanged: (text) => _vm.carrier?.viettelPostPassword = text,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                        labelText: "Token:", labelStyle: _headerStyle),
                    style: inputStyle,
                    controller: _tokenController,
                    onChanged: (text) => _vm.carrier?.viettelPostToken = text,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 8),
                  height: 40,
                  decoration: BoxDecoration(
                      color: const Color(0xFF54B86B),
                      borderRadius: BorderRadius.circular(3)),
                  child: FlatButton(
                    onPressed: () {
                      if (_userNameController.text == "" ||
                          _passFullController.text == "") {
                        _vm.showNotify();
                      } else {
                        _vm
                            .getFullTimeShipToken(
                                username: _userNameController.text,
                                password: _passFullController.text)
                            .then((value) {
                          if (value != null && value != "") {
                            setState(() {
                              _tokenController.text = value;
                              _vm.carrier?.viettelPostToken = value;
                            });
                          } else {
                            setState(() {
                              _tokenController.text = "";
                              _vm.carrier?.viettelPostToken = null;
                            });
                          }
                        });
                      }
                    },
                    //"Lấy token"
                    child: Center(
                      child: Text(
                        S.current.getToken,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 12,
            ),
            //Dịch vụ
            Text(
              "${S.current.deliveryPartner_service}:",
              style: _headerStyle.copyWith(fontWeight: FontWeight.bold),
            ),
            _buildServiceFullTimeShip()
          ],
        ),
      ),
    );
  }

  Widget _buildBESTConnectInputPanel() {
    const inputStyle =
        TextStyle(color: Colors.black87, fontWeight: FontWeight.bold);
    return Container(
      padding: const EdgeInsets.all(16),
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _buildSenderNameInput(),
            // Tài khoản
            TextField(
              decoration: InputDecoration(
                  labelText: "${S.current.username} (email):",
                  labelStyle: _headerStyle),
              style: inputStyle,
              controller: _userNameController,
              onChanged: (text) => _vm.carrier.viettelPostUserName = text,
            ),
            //Mật khẩu
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                  labelText: "${S.current.password}:",
                  labelStyle: _headerStyle),
              style: inputStyle,
              controller: _passFullController,
              onChanged: (text) => _vm.carrier?.viettelPostPassword = text,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                        labelText: "Token:", labelStyle: _headerStyle),
                    style: inputStyle,
                    controller: _tokenController,
                    onChanged: (text) => _vm.carrier?.viettelPostToken = text,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 8),
                  height: 40,
                  decoration: BoxDecoration(
                      color: const Color(0xFF54B86B),
                      borderRadius: BorderRadius.circular(3)),
                  child: FlatButton(
                    onPressed: () {
                      if (_userNameController.text == "" ||
                          _passFullController.text == "") {
                        _vm.showNotify();
                      } else {
                        _vm
                            .getBestToken(
                                username: _userNameController.text,
                                password: _passFullController.text)
                            .then((value) {
                          if (value != null && value != "") {
                            setState(() {
                              _tokenController.text = value;
                              _vm.carrier?.viettelPostToken = value;
                            });
                          } else {
                            setState(() {
                              _tokenController.text = "";
                              _vm.carrier?.viettelPostToken = null;
                            });
                          }
                        });
                      }
                    },
                    //"Lấy token
                    child: Center(
                      child: Text(
                        S.current.getToken,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 12,
            ),
            //Dịch vụ:",
            Text(
              "${S.current.deliveryPartner_service}:",
              style: _headerStyle.copyWith(fontWeight: FontWeight.bold),
            ),
            _buildServiceBest()
          ],
        ),
      ),
    );
  }

  Widget _buildFlashShipConnectInputPanel() {
    const inputStyle =
        TextStyle(color: Colors.black87, fontWeight: FontWeight.bold);
    return Container(
      padding: const EdgeInsets.all(16),
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _buildSenderNameInput(),
            //Mã khách hàng
            TextField(
              decoration: InputDecoration(
                labelText: "${S.current.customerNumber}:",
                labelStyle: _headerStyle,
              ),
              style: inputStyle,
              controller: TextEditingController(
                  text: _vm.carrier?.vNPostClientId ?? ""),
              onChanged: (text) => _vm.carrier.viettelPostUserName = text,
              enabled: false,
            ),
            //Tài khoản
            TextField(
              decoration: InputDecoration(
                  labelText: "${S.current.username} (email):",
                  labelStyle: _headerStyle),
              style: inputStyle,
              controller: _userNameController,
              onChanged: (text) => _vm.carrier.viettelPostUserName = text,
            ),
            //Mật khẩu
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                  labelText: "${S.current.password}:",
                  labelStyle: _headerStyle),
              style: inputStyle,
              controller: _passFullController,
              onChanged: (text) => _vm.carrier?.viettelPostPassword = text,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                        labelText: "Token:", labelStyle: _headerStyle),
                    style: inputStyle,
                    controller: _tokenController,
                    onChanged: (text) => _vm.carrier?.viettelPostToken = text,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 8),
                  height: 40,
                  decoration: BoxDecoration(
                      color: const Color(0xFF54B86B),
                      borderRadius: BorderRadius.circular(3)),
                  child: FlatButton(
                    onPressed: () {
                      if (_userNameController.text == "" ||
                          _passFullController.text == "") {
                        _vm.showNotify();
                      } else {
                        _vm
                            .getFlashShipToken(
                                username: _userNameController.text,
                                password: _passFullController.text)
                            .then((value) {
                          if (value != null && value != "") {
                            setState(() {
                              _tokenController.text = value;
                              _vm.carrier?.viettelPostToken = value;
                            });
                          } else {
                            setState(() {
                              _tokenController.text = "";
                              _vm.carrier?.viettelPostToken = null;
                            });
                          }
                        });
                      }
                    },
                    // "Lấy token"
                    child: Center(
                      child: Text(
                        S.current.getToken,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 12,
            ),
            //Hình thức thanh toán
            Text(
              "${S.current.paymentMethod}:",
              style: _headerStyle.copyWith(fontWeight: FontWeight.bold),
            ),
            _buildTypePayment(),
            const SizedBox(
              height: 12,
            ),
            //"Dịch vụ:
            Text(
              "${S.current.deliveryPartner_service}:",
              style: _headerStyle.copyWith(fontWeight: FontWeight.bold),
            ),
            _buildServiceFlashShip()
          ],
        ),
      ),
    );
  }

  Widget _buildDHLExpressConnectInputPanel() {
    print(_vm.carrier?.extras?.pickupAccountId);
    const inputStyle =
        TextStyle(color: Colors.black87, fontWeight: FontWeight.bold);
    return Container(
      padding: const EdgeInsets.all(16),
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _buildSenderNameInput(),
            TextField(
              decoration: InputDecoration(
                labelText: "Pickup account:",
                labelStyle: _headerStyle,
              ),
              style: inputStyle,
              controller: TextEditingController(
                  text: _vm.carrier?.extras?.pickupAccountId ?? ""),
              onChanged: (text) {
                if (_vm.carrier?.extras == null) {
                  _vm.carrier?.extras =
                      ShipExtra(isInsurance: false, isPackageViewable: false);
                  _vm.carrier?.extras?.isDropoff = false;
                }
                _vm.carrier?.extras?.pickupAccountId = text;
              },
            ),
            TextField(
              decoration: InputDecoration(
                  labelText: "Soldto account:", labelStyle: _headerStyle),
              style: inputStyle,
              controller: TextEditingController(
                  text: _vm.carrier?.extras?.soldToAccountId),
              onChanged: (text) {
                if (_vm.carrier?.extras == null) {
                  _vm.carrier?.extras =
                      ShipExtra(isInsurance: false, isPackageViewable: false);
                  _vm.carrier?.extras?.isDropoff = false;
                }
                _vm.carrier?.extras?.soldToAccountId = text;
              },
            ),
            Row(
              children: <Widget>[
                //Chiều dài kiện hàng
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                        suffix: const Text("(cm)"),
                        labelText: "${S.current.deliveryPartner_length} (cm):",
                        labelStyle: _headerStyle),
                    style: inputStyle,
                    controller: TextEditingController(
                        text: vietnameseCurrencyFormat(
                            _vm.carrier?.gHNPackageLength?.toDouble() != 0
                                ? _vm.carrier?.gHNPackageLength?.toDouble()
                                : 10)),
                    onChanged: (text) {
                      if (text != "") {
                        _vm.carrier?.gHNPackageLength =
                            int.parse(text.replaceAll(".", ""));
                      } else {
                        _vm.carrier?.gHNPackageLength = 0;
                      }
                    },
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                      NumberInputFormat.vietnameDong(),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 12,
                ),
                //Chiều rộng kiện hàng
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                        suffix: const Text("(cm)"),
                        labelText: "${S.current.deliveryPartner_width} (cm):",
                        labelStyle: _headerStyle),
                    style: inputStyle,
                    onChanged: (text) {
                      if (text != "") {
                        _vm.carrier?.gHNPackageWidth =
                            int.parse(text.replaceAll(".", ""));
                      } else {
                        _vm.carrier?.gHNPackageWidth = 0;
                      }
                    },
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      WhitelistingTextInputFormatter.digitsOnly,
                      NumberInputFormat.vietnameDong(),
                    ],
                    controller: TextEditingController(
                        text: vietnameseCurrencyFormat(
                            _vm.carrier?.gHNPackageWidth?.toDouble() != 0
                                ? _vm.carrier?.gHNPackageWidth?.toDouble()
                                : 10)),
                  ),
                ),
              ],
            ),
            //Chiều cao kiện hàng
            TextField(
              style: inputStyle,
              decoration: InputDecoration(
                  suffix: const Text("(cm)"),
                  labelText: "${S.current.deliveryPartner_height} (cm):",
                  labelStyle: _headerStyle),
              onChanged: (text) {
                if (text != "") {
                  _vm.carrier?.gHNPackageHeight =
                      int.parse(text.replaceAll(".", ""));
                } else {
                  _vm.carrier?.gHNPackageHeight = 0;
                }
              },
              controller: TextEditingController(
                  text: vietnameseCurrencyFormat(
                      _vm.carrier?.gHNPackageHeight?.toDouble() != 0
                          ? _vm.carrier?.gHNPackageHeight?.toDouble()
                          : 10)),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
                NumberInputFormat.vietnameDong()
              ],
            ),
            const SizedBox(
              height: 12,
            ),
            //Dịch vụ
            Text(
              "${S.current.deliveryPartner_service}:",
              style: _headerStyle.copyWith(fontWeight: FontWeight.bold),
            ),
            _buildServiceDHLExpress(),
          ],
        ),
      ),
    );
  }

  DropdownButton _buildServiceFullTimeShip() => DropdownButton<String>(
          items: [
            // Chọn dịch vụ
            DropdownMenuItem(
              value: "0",
              child: Text(
                S.current.deliveryPartner_ChooseService,
              ),
            ),
            // Giao nhanh"
            DropdownMenuItem(
              value: "1",
              child: Text(
                S.current.deliveryPartner_FastDelivery,
              ),
            ),
          ],
          onChanged: (value) {
            _vm.service = value;
            _vm.carrier?.viettelPostServiceId = value == "0" ? null : value;
          },
          value: "0",
          underline: const SizedBox(),
          isExpanded: true);

  DropdownButton _buildServiceBest() => DropdownButton<String>(
          items: [
            //Chọn dịch vụ
            DropdownMenuItem(
              value: "0",
              child: Text(
                S.current.deliveryPartner_ChooseService,
              ),
            ),
            // Tiêu chuẩn
            DropdownMenuItem(
              value: "12490",
              child: Text(
                "Express: ${S.current.deliveryPartner_standard}",
              ),
            ),
            //Tiết kiệm
            DropdownMenuItem(
              value: "12491",
              child: Text(
                "Eco: ${S.current.deliveryPartner_save}",
              ),
            ),
          ],
          onChanged: (value) {
            _vm.service = value;
            _vm.carrier?.viettelPostServiceId = value == "0" ? null : value;
          },
          value: "0",
          underline: const SizedBox(),
          isExpanded: true);

  DropdownButton _buildServiceDHLExpress() => DropdownButton<String>(
          items: [
            //Chọn dịch vụ
            DropdownMenuItem(
              value: "0",
              child: Text(
                S.current.deliveryPartner_ChooseService,
              ),
            ),
            //Giao hàng tiêu chuẩn
            DropdownMenuItem(
              value: "PDO",
              child: Text(
                "PDO: ${S.current.deliveryPartner_StandardDelivery}",
              ),
            ),
            //Giao hàng trong ngày
            DropdownMenuItem(
              value: "SDP",
              child: Text(
                "SDP: ${S.current.deliveryPartner_DeliveryWithinTheDay}",
              ),
            ),
            // Giao hàng ưu tiên
            DropdownMenuItem(
              value: "PDE",
              child: Text(
                "PDE: ${S.current.deliveryPartner_PriorityDelivery}",
              ),
            ),
          ],
          onChanged: (value) {
            _vm.service = value;
            _vm.carrier?.viettelPostServiceId = value == "0" ? null : value;
          },
          value: _vm.service,
          underline: const SizedBox(),
          isExpanded: true);

  DropdownButton _buildServiceFlashShip() => DropdownButton<String>(
          items: [
            // Chọn dịch vụ"
            DropdownMenuItem(
              value: "0",
              child: Text(
                S.current.deliveryPartner_ChooseService,
              ),
            ),
            const DropdownMenuItem(
              value: "1",
              child: Text(
                "CPN",
              ),
            ),
            DropdownMenuItem(
              value: "2",
              child: Text(
                S.current.deliveryPartner_SuperSpeed,
              ),
            ),
            DropdownMenuItem(
              value: "3",
              child: Text(
                S.current.deliveryPartner_road,
              ),
            ),
          ],
          onChanged: (value) {
            _vm.service = value;
            _vm.carrier?.viettelPostServiceId = value == "0" ? null : value;
          },
          value: _vm.service,
          underline: const SizedBox(),
          isExpanded: true);

  DropdownButton _buildTypePayment() => DropdownButton<String>(
          items: [
            //Chọn hình thức thanh toán
            DropdownMenuItem(
              value: "0",
              child: Text(
                S.current.choosePaymentMethod,
              ),
            ),
            // Người nhận TT ngay
            DropdownMenuItem(
              value: "1",
              child: Text(
                S.current.deliveryPartner_PaymentImmediately,
              ),
            ),
            //Người gửi TT sau
            DropdownMenuItem(
              value: "2",
              child: Text(
                S.current.deliveryPartner_PaymentLater,
              ),
            )
          ],
          onChanged: (value) {
            if (value == '0') {
              _vm.carrier?.extras = null;
              _vm.typePayment = value;
            } else {
              _vm.carrier?.extras ??=
                  ShipExtra(isInsurance: false, isPackageViewable: false);
              _vm.typePayment = value;
              _vm.carrier?.extras?.paymentTypeId = value;
              _vm.carrier?.extras?.isDropoff = false;
            }
          },
          value: _vm.typePayment,
          underline: const SizedBox(),
          isExpanded: true);

  String groupValue = "has";

  void _showGetTokenGHTKDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        // Lấy token
        title: Text('${S.current.getToken} GHTK'),
        content: GetTokenDialog(_vm),
      ),
    );
  }
}

class GetTokenDialog extends StatefulWidget {
  const GetTokenDialog(this.vm);
  final DeliveryCarrierPartnerAddEditViewModel vm;

  @override
  _GetTokenDialogState createState() => _GetTokenDialogState();
}

class _GetTokenDialogState extends State<GetTokenDialog> {
  String groupValue = 'has';
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return UIViewModelBase(
      viewModel: widget.vm,
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              // Đã có TK
              Expanded(
                child: RadioListTile<String>(
                  title: Text(S.current.deliveryPartner_HadAccount),
                  groupValue: groupValue,
                  value: "has",
                  onChanged: (value) {
                    setState(() {
                      groupValue = value;
                    });
                  },
                ),
              ),
              // Chưa có TK
              Expanded(
                child: RadioListTile<String>(
                  title: Text(S.current.deliveryPartner_NoAccountYet),
                  groupValue: groupValue,
                  value: "no",
                  onChanged: (value) {
                    setState(() {
                      groupValue = value;
                    });
                  },
                ),
              ),
            ],
          ),
          if (groupValue == "has") getHasAccount(),
          if (groupValue == "no") getNoAccount(),
        ],
      ),
    );
  }

  Widget getHasAccount() {
    return Column(
      children: <Widget>[
        TextField(
          controller: _usernameController,
          // Tên đăng nhập
          decoration: InputDecoration(
            hintText: S.current.username,
            labelText: S.current.username,
          ),
        ),
        // "Mật khẩu"
        TextField(
          controller: _passwordController,
          decoration: InputDecoration(
            hintText: S.current.password,
            labelText: S.current.password,
          ),
        ),
        RaisedButton(
          child: Text(S.current.confirm.toUpperCase()),
          color: Colors.blue,
          onPressed: () {
            widget.vm
                .getGhtkToken(
                    username: _usernameController.text,
                    password: _passwordController.text)
                .then((value) {
              if (value) Navigator.pop(context);
            });
          },
          textColor: Colors.white,
        )
      ],
    );
  }

  Widget getNoAccount() {
    return const SizedBox();
  }
}

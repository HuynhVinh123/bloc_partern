import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/feature_group/category/partner/partner_status_select_page.dart';
import 'package:tpos_mobile/feature_group/sale_online/ui/check_address_page.dart';
import 'package:tpos_mobile/feature_group/sale_online/ui/sale_online_select_address.dart';
import 'package:tpos_mobile/helpers/app_helper.dart';
import 'package:tpos_mobile/helpers/string_helper.dart';
import 'package:tpos_mobile/helpers/ui_help.dart';
import 'package:tpos_mobile/resources/app_colors.dart';
import 'package:tpos_mobile/src/tpos_apis/models/Address.dart';
import 'package:tpos_mobile/src/tpos_apis/models/CheckAddress.dart';
import 'package:tpos_mobile/state_management/viewmodel/base_viewmodel.dart';
import 'package:tpos_mobile/state_management/viewmodel/viewmodel_provider.dart';
import 'package:tpos_mobile/extensions.dart';
import 'package:tmt_flutter_untils/sources/color_utils/color_extensions.dart';
import 'package:tpos_mobile/widgets/button/bottom_single_button.dart';
import 'package:tpos_mobile/widgets/dialog/alert_type.dart';
import 'package:tpos_mobile/widgets/form_field/input_card_wrapper.dart';
import 'package:tpos_mobile/widgets/form_field/input_checkbox.dart';
import 'package:tpos_mobile/widgets/form_field/input_number_field.dart';
import 'package:tpos_mobile/widgets/form_field/input_select_field.dart';
import 'package:tpos_mobile/widgets/form_field/input_string_field.dart';

import 'viewmodel/partner_add_edit_viewmodel.dart';
import 'package:tmt_flutter_untils/tmt_flutter_extensions.dart';

class PartnerAddEditPage extends StatefulWidget {
  const PartnerAddEditPage(
      {this.closeWhenDone,
      this.partnerId,
      this.onEditPartner,
      this.isCustomer = true,
      this.isSupplier = false});
  final bool closeWhenDone;
  final int partnerId;
  final Function(Partner) onEditPartner;
  final bool isCustomer;
  final bool isSupplier;

  @override
  _PartnerAddEditPageState createState() => _PartnerAddEditPageState();
}

class _PartnerAddEditPageState extends State<PartnerAddEditPage> {
  final GlobalKey<FormState> _key = GlobalKey();
  final PartnerViewModel partnerAddEditViewModel = PartnerViewModel();

  TextEditingController checkAddressController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController refController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController zaloController = TextEditingController();
  TextEditingController facebookController = TextEditingController();
  TextEditingController websiteController = TextEditingController();
  TextEditingController barcodeController = TextEditingController();
  TextEditingController taxCodeController = TextEditingController();

  final discountController = getMoneyController();
  final discountAmountController = getMoneyController();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final FocusNode _maKhachHangFocus = FocusNode();
  final FocusNode _tenKhachHangFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _addressFocus = FocusNode();
  final FocusNode _checkAddressFocus = FocusNode();

  final FocusNode _emailFocus = FocusNode();
  final FocusNode _zaloFocus = FocusNode();
  final FocusNode _facebookFocus = FocusNode();
  final FocusNode _websiteFocus = FocusNode();
  final FocusNode _maSoThueFocus = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  File _image;
  Future getImage(ImageSource source) async {
    try {
      final image =
          await ImagePicker.pickImage(source: source, maxWidth: 400.0);
      setState(() {
        _image = image;
      });
    } catch (e) {
      print(e);
    }
  }

  void _handleSaveAndClose() {
    if (_key.currentState.validate()) {
      _saveData();
      partnerAddEditViewModel.save();
    } else {
      context.showToast(
        type: AlertDialogType.warning,
        title: 'Dữ liệu không hợp lệ',
        message: 'Vui lòng kiểm tra các dữ liệu nhập không hợp lệ',
        paddingBottom: 64,
      );
    }
  }

  /// Phải gọi cái này trước khi lưu dữ liệu không là thiếu dữ liệu
  void _saveData() {
    final model = partnerAddEditViewModel;
    model.name = nameController.text.trim();
    model.setRef(refController.text);
    model.setPhone(phoneController.text);
    model.setAddress(addressController.text);
    model.setEmail(emailController.text);
    model.setZalo(zaloController.text);
    model.setFacebook(facebookController.text);
    model.setWebsite(websiteController.text);
    model.setDiscount(discountController.numberValue);
    model.setDiscountAmount(discountAmountController.numberValue);
  }

  Future<void> _handleChangePartnerStatus(BuildContext context) async {
    final selectStatusPage = PartnerStatusSelectPage(
      selectedStatus: partnerAddEditViewModel.status,
    );

    final PartnerStatus selectedStatus =
        await context.navigateTo(selectStatusPage);
    if (selectedStatus != null) {
      partnerAddEditViewModel.setPartnerStatus(
        status: selectedStatus.value,
        statusText: selectedStatus.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<PartnerViewModel>(
      viewModel: partnerAddEditViewModel,
      busyStateType: PViewModelLoading,
      onStateChanged: (state, vm) {
        if (state is PViewModelLoadSuccess) {
          checkAddressController.text = vm.checkAddress;
          addressController.text = vm.street;
          refController.text = vm.ref;
          nameController.text = vm.name;
          phoneController.text = vm.phone;
          emailController.text = vm.email;
          zaloController.text = vm.zalo;
          facebookController.text = vm.facebook;
          websiteController.text = vm.website;
          barcodeController.text = vm.barcode;
          taxCodeController.text = vm.taxCode;
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: _buildAppbar(context),
        body: _buildBody(),
        backgroundColor: AppColors.backgroundColor,
        bottomNavigationBar: BottomSingleButton(
          title: 'LƯU & ĐÓNG',
          onPressed: () => _handleSaveAndClose(),
        ),
      ),
    );
  }

  /// Build appbar UI
  Widget _buildAppbar(BuildContext context) {
    return AppBar(
      title: widget.partnerId == null
          ? widget.isCustomer
              ? const Text("Thêm khách hàng")
              : widget.isSupplier
                  ? const Text("Thêm nhà cung cấp")
                  : const Text("N/A")
          : const Text("Sửa đối tác"),
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.check),
          onPressed: () async {
            _handleSaveAndClose();
          },
        ),
      ],
    );
  }

  Widget _buildBody() {
    return Consumer<PartnerViewModel>(
      builder: (context, model, widget) {
        return _buildForm(context, model);
      },
    );
  }

  Widget _inputName() => InputStringField(
        controller: nameController,
        hint: 'Nhập tên khách hàng',
        label: 'Tên khách hàng',
        textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        maxLines: 1,
        minLines: 1,
        // textInputType: TextInputType.name,
        textInputAction: TextInputAction.done,
        validator: validateName,
      );
  Widget _buildForm(BuildContext context, PartnerViewModel model) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: 12, right: 12, top: 8),
      child: Form(
        key: _key,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            InputCardWrapper(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Cá nhân - Công ty
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Row(
                      children: <Widget>[
                        Radio(
                          groupValue: model.isPersonal,
                          value: true,
                          onChanged: (newValue) {
                            model.isPersonal = newValue;
                          },
                        ),
                        const Text("Cá nhân"),
                        Radio(
                          groupValue: model.isPersonal,
                          value: false,
                          onChanged: (newValue) {
                            model.isPersonal = newValue;
                          },
                        ),
                        const Text("Công ty"),
                        const SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: InkWell(
                            child: Material(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(3),
                                  side: const BorderSide(
                                      color: Colors.green,
                                      width: 1,
                                      style: BorderStyle.solid)),
                              color: getPartnerStatusColor(model.statusStyle),
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text(
                                  model.statusText ?? "Chưa có trạng thái",
                                  style: TextStyle(
                                    color:
                                        getPartnerStatusColor(model.statusStyle)
                                            .textColor(),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            onTap: () async {
                              _handleChangePartnerStatus(context);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  _inputName(),
                  // Tên khách hàng
                  Row(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        color: Colors.grey.shade200,
                        child: model.imageLink.isUrl()
                            ? Image.network(model.imageLink ?? '')
                            : const SizedBox(),
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            InputCheckbox(
                              value: model.active,
                              title: 'Active',
                              onChanged: (value) {
                                model.isActive = value;
                              },
                            ),
                            InputCheckbox(
                              value: model.isCustomer,
                              title: 'Là khách hàng',
                              onChanged: (value) {
                                model.isCustomer = value;
                              },
                            ),
                            InputCheckbox(
                              value: model.isSupplier,
                              title: 'Là nhà cung cấp',
                              onChanged: (value) {
                                model.isSupplier = value;
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            InputCardWrapper(
              child: Column(
                children: [
                  // Mã số
                  InputStringField(
                    controller: refController,
                    label: 'Mã số',
                    hint: 'Để trống để tự phát sinh',
                  ),
                  InputStringField(
                    controller: phoneController,
                    label: 'Điện thoại',
                    hint: '',
                    validator: validatePhone,
                  ),
                  InputStringField(
                    controller: addressController,
                    label: 'Địa chỉ',
                    hint: '',
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      FlatButton(
                          onPressed: () async {
                            if (await context.showConfirm(
                                content:
                                    'Bạn có muốn cập nhật địa chỉ  "street" từ Phường/Quận/Tỉnh thành')) {
                              model.updateStreetBaseOnAddress();
                              addressController.text = model.street;
                            }
                          },
                          child: const Text("Cập nhật")),
                      FlatButton(
                          onPressed: () {
                            Clipboard.setData(
                              ClipboardData(
                                text: addressController.text.trim(),
                              ),
                            );
                            context.showToast(
                              message: 'Đã lưu dữ liệu trong clipboard',
                              paddingBottom: 65,
                            );
                          },
                          child: const Text("Copy")),
                      FlatButton(
                        onPressed: () async {
                          await context.navigateTo(CheckAddressPage(
                            selectedAddress: CheckAddress(
                              address: model.street,
                            ),
                            keyword: addressController.text.trim(),
                          ));
                        },
                        child: const Text("Kiểm tra"),
                      ),
                    ],
                  ),

                  InputSelectField(
                    title: const Text('Tỉnh thành'),
                    content: Text(model.city?.name ?? 'Chọn tỉnh/thành phố'),
                    onPressed: () async {
                      final Address address =
                          await context.navigateTo(const SelectAddressPage());
                      if (address != null) {
                        model.setCity(CityAddress(
                            code: address.code, name: address.name));
                      }
                    },
                  ),
                  InputSelectField(
                    title: Text('Quận/huyện'),
                    content: Text(model.district?.name ?? 'Chọn quận huyện'),
                    onPressed: () async {
                      final Address address = await context.navigateTo(
                        SelectAddressPage(
                          cityCode: model.city.code,
                        ),
                      );
                      if (address != null) {
                        model.setDistrict(
                          DistrictAddress(
                              code: address.code, name: address.name),
                        );
                      }
                    },
                  ),
                  InputSelectField(
                    title: Text('Phường/xã'),
                    content: Text(model.ward?.name ?? 'Chọn phường xã'),
                    onPressed: () async {
                      final Address address = await context.navigateTo(
                        SelectAddressPage(
                          cityCode: model.city.code,
                          districtCode: model.district.code,
                        ),
                      );
                      if (address != null) {
                        model.setWard(
                          WardAddress(code: address.code, name: address.name),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            InputCardWrapper(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Nhóm khách hàng'),
                  Wrap(
                    children: model.categories
                        .map(
                          (e) => Chip(
                            label: Text(e.name),
                          ),
                        )
                        .toList()
                          ..add(
                            const Chip(
                              label: Text('Thêm..'),
                            ),
                          ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            InputCardWrapper(
              child: ExpansionTile(
                initiallyExpanded: true,
                title: const Text('Thông tin khác (FB, zalo, email...'),
                children: [
                  InputStringField(
                    controller: emailController,
                    label: 'Email: ',
                  ),
                  InputStringField(
                    controller: zaloController,
                    label: 'Zalo: ',
                  ),
                  InputStringField(
                    controller: facebookController,
                    label: 'Facebook: ',
                  ),
                  InputStringField(
                    controller: websiteController,
                    label: 'Website: ',
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            InputCardWrapper(
              child: ExpansionTile(
                initiallyExpanded: true,
                title: const Text('Bán hàng'),
                children: [
                  const Divider(),
                  const InputSelectField(
                    title: Text("Bảng giá"),
                    trailing: Icon(Icons.chevron_right),
                  ),
                  const Divider(),
                  InputNumberField(
                    titleString: 'Chiết khẩu mặc định (%)',
                    controller: discountController,
                  ),
                  const Divider(),
                  InputNumberField(
                    titleString: 'Chiết khấu mặc định (tiền): ',
                    controller: discountAmountController,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

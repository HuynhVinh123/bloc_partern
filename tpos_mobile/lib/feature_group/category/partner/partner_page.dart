import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:tmt_flutter_untils/tmt_flutter_extensions.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app.dart';
import 'package:tpos_mobile/extensions.dart';
import 'package:tpos_mobile/feature_group/category/partner_category/ui/partner_categories_page.dart';
import 'package:tpos_mobile/feature_group/category/price_list/price_list_page.dart';
import 'package:tpos_mobile/feature_group/sale_online/ui/check_address_page.dart';
import 'package:tpos_mobile/feature_group/sale_online/ui/sale_online_select_address.dart';
import 'package:tpos_mobile/helpers/string_helper.dart';
import 'package:tpos_mobile/helpers/ui_help.dart';
import 'package:tpos_mobile/resources/app_colors.dart';
import 'package:tpos_mobile/src/tpos_apis/models/Address.dart';
import 'package:tpos_mobile/src/tpos_apis/models/CheckAddress.dart';
import 'package:tpos_mobile/state_management/viewmodel/base_viewmodel.dart';
import 'package:tpos_mobile/state_management/viewmodel/viewmodel_provider.dart';
import 'package:tpos_mobile/state_management/viewmodel_builder.dart';
import 'package:tpos_mobile/widgets/app_widgets/partner_status_button.dart';
import 'package:tpos_mobile/widgets/button/bottom_single_button.dart';
import 'package:tpos_mobile/widgets/dialog/alert_type.dart';
import 'package:tpos_mobile/widgets/form_field/input_card_wrapper.dart';
import 'package:tpos_mobile/widgets/form_field/input_checkbox.dart';
import 'package:tpos_mobile/widgets/form_field/input_datetime_field.dart';
import 'package:tpos_mobile/widgets/form_field/input_number_field.dart';
import 'package:tpos_mobile/widgets/form_field/input_select_field.dart';
import 'package:tpos_mobile/widgets/form_field/input_string_field.dart';
import 'package:tpos_mobile/widgets/page_state/page_state.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

import 'viewmodel/partner_add_edit_viewmodel.dart';

class PartnerAddEditPage extends StatefulWidget {
  const PartnerAddEditPage(
      {this.closeWhenSaved = false,
      this.partnerId,
      this.onEditPartner,
      this.isCustomer = true,
      this.isSupplier = false,
      this.partner,
      this.onPartnerStatusChanged,
      this.name});

  final bool closeWhenSaved;
  final int partnerId;
  final Function(Partner) onEditPartner;
  final ValueChanged<PartnerStatus> onPartnerStatusChanged;
  final bool isCustomer;
  final bool isSupplier;
  final Partner partner;

  /// Tên sẽ tự điờn khi thêm mới 1 khách hàng theo tên.
  final String name;

  @override
  _PartnerAddEditPageState createState() => _PartnerAddEditPageState();
}

class _PartnerAddEditPageState extends State<PartnerAddEditPage> {
  final GlobalKey<FormState> _key = GlobalKey();
  final PartnerViewModel partnerAddEditViewModel = PartnerViewModel();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  var discountController = getMoneyController();
  var discountAmountController = getMoneyController();

  // final FocusNode _maKhachHangFocus = FocusNode();
  // final FocusNode _tenKhachHangFocus = FocusNode();
  // final FocusNode _phoneFocus = FocusNode();
  // final FocusNode _addressFocus = FocusNode();
  // final FocusNode _checkAddressFocus = FocusNode();

  // final FocusNode _emailFocus = FocusNode();
  // final FocusNode _zaloFocus = FocusNode();
  // final FocusNode _facebookFocus = FocusNode();
  // final FocusNode _websiteFocus = FocusNode();
  // final FocusNode _maSoThueFocus = FocusNode();

  final imagePicker = ImagePicker();
  File _imageFile;

  @override
  void initState() {
    initData();
    super.initState();
  }

  Future initData() async {
    await partnerAddEditViewModel.init(
      id: widget.partnerId,
      isSupplier: widget.isSupplier,
      isCustomer: widget.isCustomer,
      name: widget.name,
      closeWhenSaved: widget.closeWhenSaved,
      onSaved: (partner) {
        if (widget.onEditPartner != null) {
          widget.onEditPartner(partner);
        }
      },
    );
    discountController = getMoneyController(
        initialValue: partnerAddEditViewModel.defaultDiscount);
    discountAmountController = getMoneyController(
        initialValue: partnerAddEditViewModel.defaultDiscountAmount);
  }

  Future getImage(ImageSource source) async {
    try {
      final pickedFile =
          await imagePicker.getImage(source: source, maxWidth: 400.0);
      _imageFile = File(pickedFile.path);
      if (_imageFile != null) {
        final byte = _imageFile.readAsBytesSync();
        partnerAddEditViewModel.setBase64Image(base64Encode(byte));
      }
      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  /// Xử lý khi nhấn nút 'Thêm và đóng'
  Future<void> _handleSaveAndClose() async {
    if (_key.currentState.validate()) {
      final result = await partnerAddEditViewModel.save();
      if (result.success) {
        if (widget.closeWhenSaved == true) {
          Navigator.of(context).pop();
          print("close");
        }
      }
    } else {
      // Dữ liệu không hợp lệ
      App.showToast(
        type: AlertDialogType.warning,
        title: S.current.invalidData,
        message: S.current.pleaseCheckInvalidData,
        paddingBottom: 64,
      );
    }
  }

  /// Xử lý thay đổi hình đại diện khách hàng. Xảy ra khi nhấn vào hình đại diện khách hàng
  void _handleChangeImage(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text("Menu"),
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.camera),
                title: Text(S.current.takeAPicture),
                onTap: () {
                  getImage(ImageSource.camera);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.image),
                title: Text(S.current.fromGallery),
                onTap: () {
                  getImage(ImageSource.gallery);
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  /// Xử lý khi nhấn nút thêm nhóm khách hàng
  Future<void> _handleAddCustomerGroupPressed(BuildContext context) async {
    final selectedPartnerGroup = await context.navigateTo(
      const PartnerCategoriesPage(
        isSearchMode: true,
        isSearch: true,
      ),
    );

    if (selectedPartnerGroup != null) {
      partnerAddEditViewModel.addPartnerCategory(selectedPartnerGroup);
    }
  }

  void _handleDeletePartnerGroupPressed(
      BuildContext context, PartnerCategory item) {
    partnerAddEditViewModel.removePartnerCategory(item);
  }

  Future<void> _handleSelectPriceList(BuildContext context) async {
    final selectedPriceList = await context.navigateTo(const PriceListPage(
      searchMode: true,
    ));

    if (selectedPriceList != null) {
      partnerAddEditViewModel.setPriceList(selectedPriceList);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<PartnerViewModel>(
      viewModel: partnerAddEditViewModel,
      busyStateType: PViewModelLoading,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: _buildAppbar(context),
        body: _buildBody(),
        backgroundColor: AppColors.backgroundColor,
      ),
    );
  }

  /// Build appbar UI
  Widget _buildAppbar(BuildContext context) {
    return AppBar(
      title: _buildAppbarTitle(),
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

  Widget _buildAppbarTitle() {
    return Consumer<PartnerViewModel>(
      builder: (context, model, child) {
        return Text(model.title);
      },
    );
  }

  Widget _buildBody() {
    return PViewModelBuilder<PartnerViewModel>(
      builder: (context, model, state) {
        if (state is PViewModelLoadFailure) {
          return AppPageState.dataError(
            message: state.mesage,
            actions: [
              RaisedButton(
                onPressed: () {
                  model.initData();
                },
                textColor: Colors.white,
                // Thử lại
                child: Text(S.current.retry),
              )
            ],
          );
        } else if (state is PViewModelLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return _buildForm(context, model);
      },
    );
  }

  Widget _inputName(BuildContext context) => InputStringField(
        //controller: nameController,
        hint: S.current.enterNameOfPartner,
        label: S.current.nameOfPartner,
        textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        maxLines: 1,
        minLines: 1,
        textInputType: TextInputType.name,
        textInputAction: TextInputAction.done,
        validator: validateName,
        onChanged: (value) => partnerAddEditViewModel.setName(value),
        initialValue: partnerAddEditViewModel.name,
        key: getFieldKey('name', partnerAddEditViewModel.name),
      );

  Widget _buildForm(BuildContext context, PartnerViewModel model) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
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
                              Text(S.current.personal),
                              Radio(
                                groupValue: model.isPersonal,
                                value: false,
                                onChanged: (newValue) {
                                  model.isPersonal = newValue;
                                },
                              ),
                              Text(S.current.company),
                              const SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                child: PartnerStatusBadge(
                                  partnerId: model.partner?.id,
                                  partner: model.partner,
                                  statusText: model.statusText,
                                  onStatusChanged: (value) async {
                                    partnerAddEditViewModel.setPartnerStatus(
                                      statusText: value.text,
                                    );

                                    widget.onPartnerStatusChanged?.call(value);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),

                        _inputName(context),
                        // Tên khách hàng
                        Row(
                          children: [
                            _PartnerAvatar(
                              avatarLink: model.imageLink,
                              onTap: () => _handleChangeImage(context),
                              imageFile: _imageFile,
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
                                    title: S.current.isCustomer,
                                    onChanged: (value) {
                                      model.isCustomer = value;
                                    },
                                  ),
                                  InputCheckbox(
                                    value: model.isSupplier,
                                    title: S.current.isSupplier,
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
                          //controller: refController,
                          initialValue: model.ref,
                          key: getFieldKey('ref', partnerAddEditViewModel.ref),
                          label: S.current.partnerCode,
                          hint: S.current.leaveBlankToAutoGeneration,
                          onChanged: (value) => model.setRef(value),
                        ),
                        InputStringField(
                          //controller: phoneController,
                          initialValue: model.phone,
                          key: getFieldKey(
                              'phone', partnerAddEditViewModel.phone),
                          label: S.current.phone,
                          hint: '',
                          // validator: (value) => validatePhone(value),
                          onChanged: (value) => model.setPhone(value),
                        ),
                        // Chờn sinh nhật khách hàng
                        InputDateField(
                          key: getFieldKey(
                              'birthday', model.birthDay?.toString()),
                          initialValue:
                              model.birthDay?.toLocal() ?? DateTime.now(),
                          firstDate: DateTime(1900, 1, 1),
                          lastDate: DateTime.now().add(
                            const Duration(days: 1),
                          ),
                          hint: S.current.chooseBirthday,
                          label: S.current.birthday,
                          format: 'dd/MM/yyyy',
                          onChanged: (value) {
                            model.setBirthday(value);
                          },
                        ),

                        InputStringField(
                          //controller: addressController,
                          initialValue: model.street,
                          key: getFieldKey(
                              'street', partnerAddEditViewModel.street),
                          label: S.current.address,
                          hint: '',
                          onChanged: (value) => model.setAddress(value),
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            FlatButton(
                              onPressed: () async {
                                final bool confirm = await context.showConfirm(
                                    content:
                                        S.current.partner_notifyUpdateFromCity);

                                if (confirm.getValue()) {
                                  model.updateStreetBaseOnAddress();
                                }
                              },
                              child: Text(S.current.update),
                              textColor: AppColors.link,
                            ),
                            FlatButton(
                              onPressed: () {
                                Clipboard.setData(
                                  ClipboardData(
                                    text: model.street.trim(),
                                  ),
                                );
                                context.showToast(
                                  message: '${S.current.dataSavedIn} clipboard',
                                  paddingBottom: 65,
                                );
                              },
                              child: Text(S.current.copy),
                              textColor: AppColors.link,
                            ),
                            FlatButton(
                              onPressed: () async {
                                final selectCheckedAddress =
                                    await context.navigateTo(CheckAddressPage(
                                  selectedAddress: CheckAddress(
                                    address: model.street,
                                  ),
                                  keyword: model.street,
                                ));

                                if (selectCheckedAddress != null) {
                                  model.setCheckAddress(selectCheckedAddress);
                                }
                              },
                              child: Text(S.current.check),
                              textColor: AppColors.link,
                            ),
                          ],
                        ),

                        InputSelectField(
                          title: Text(S.current.city),
                          content:
                              Text(model.city?.name ?? S.current.selectCity),
                          onPressed: () async {
                            final Address address = await context
                                .navigateTo(const SelectAddressPage());
                            if (address != null) {
                              model.setCity(CityAddress(
                                  code: address.code, name: address.name));
                            }
                          },
                        ),
                        InputSelectField(
                          title: Text(S.current.district),
                          content: Text(
                              model.district?.name ?? S.current.selectDistrict),
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
                          title: Text(S.current.ward),
                          content:
                              Text(model.ward?.name ?? S.current.selectWard),
                          onPressed: () async {
                            final Address address = await context.navigateTo(
                              SelectAddressPage(
                                cityCode: model.city.code,
                                districtCode: model.district.code,
                              ),
                            );
                            if (address != null) {
                              model.setWard(
                                WardAddress(
                                    code: address.code, name: address.name),
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
                        Text(S.current.customerGroups),
                        Wrap(spacing: 8, runSpacing: 0, children: [
                          ...model.categories
                              .map(
                                (e) => Chip(
                                  label: Text(e.name),
                                  onDeleted: () =>
                                      _handleDeletePartnerGroupPressed(
                                          context, e),
                                ),
                              )
                              .toList(),
                          ActionChip(
                            label: Text('${S.current.add}..'),
                            onPressed: () =>
                                _handleAddCustomerGroupPressed(context),
                          ),
                        ]),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  InputCardWrapper(
                    child: ExpansionTile(
                      initiallyExpanded: true,
                      title: Text(S.current.partnerInfo_otherInfo),
                      children: [
                        InputStringField(
                          // controller: emailController,
                          initialValue: model.email,
                          key: getFieldKey(
                              'email', partnerAddEditViewModel.email),
                          label: 'Email: ',
                          onChanged: (value) => model.setEmail(value),
                        ),
                        InputStringField(
                          //controller: zaloController,
                          initialValue: model.zalo,
                          key:
                              getFieldKey('zalo', partnerAddEditViewModel.zalo),
                          label: 'Zalo: ',
                          onChanged: (value) => model.setZalo(value),
                        ),
                        InputStringField(
                          //controller: facebookController,
                          initialValue: model.facebook,
                          key: getFieldKey(
                              'facebook', partnerAddEditViewModel.facebook),
                          label: 'Facebook: ',
                          onChanged: (value) => model.setFacebook(value),
                        ),
                        InputStringField(
                          //controller: websiteController,
                          initialValue: model.website,
                          key: getFieldKey(
                              'website', partnerAddEditViewModel.website),
                          label: 'Website: ',
                          onChanged: (value) => model.setWebsite(value),
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
                      title: Text(S.current.reportOrder_Sell),
                      children: [
                        const Divider(),
                        InputSelectField(
                          title: Text(S.current.priceList),
                          content: Text(model.priceList?.name ??
                              S.current.selectPriceList),
                          trailing: const Icon(Icons.chevron_right),
                          onPressed: () => _handleSelectPriceList(context),
                        ),
                        const Divider(),
                        InputNumberField(
                          titleString: '${S.current.defaultDiscount} (%)',
                          // initialValue: model.defaultDiscount,
                          controller: discountController,
                          onNumberChanged: (value) =>
                              model.setDiscount(discountController.numberValue),
                          validator: (value) => validateNumberRange(
                              discountController.numberValue, 0, 100.0),
                        ),
                        const Divider(),
                        InputNumberField(
                          titleString: S.current.defaultAmountDiscount,
                          // initialValue: model.defaultDiscountAmount,
                          controller: discountAmountController,
                          onNumberChanged: (value) =>
                              model.setDiscountAmount(value),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          width: double.infinity,
          child: BottomSingleButton(
            title: S.current.saveAndClose.toUpperCase(),
            onPressed: () => _handleSaveAndClose(),
            hideOnKeyboard: true,
          ),
        ),
      ],
    );
  }
}

/// UI Hình đại diện khách hàng. Nếu khách hàng chưa có avatar hoặc image không hợp lệ thì hiện nút thêm
class _PartnerAvatar extends StatelessWidget {
  const _PartnerAvatar({Key key, this.avatarLink, this.onTap, this.imageFile})
      : super(key: key);
  final String avatarLink;
  final File imageFile;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        width: 100,
        height: 100,
        color: Colors.grey.shade200,
        child: Builder(
          builder: (context) {
            if (imageFile != null) {
              return _buildHasImageFromSelect(context, imageFile);
            }
            if (avatarLink != null && avatarLink.isUrl()) {
              return _buildHasImage(context, avatarLink);
            }
            return _buildNoImage();
          },
        ),
      ),
      onTap: onTap,
    );
  }

  Widget _buildNoImage() {
    return const Center(
      child: Icon(
        Icons.add_circle,
        color: Colors.green,
      ),
    );
  }

  Widget _buildHasImage(BuildContext context, String imageLink) {
    return Image.network(imageLink);
  }

  Widget _buildHasImageFromSelect(BuildContext context, File image) {
    return Image.file(image);
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tpos_api_client/tpos_api_client.dart';

import 'package:tpos_mobile/feature_group/sale_online/ui/check_address_page.dart';
import 'package:tpos_mobile/feature_group/sale_online/ui/partner_category_page.dart';
import 'package:tpos_mobile/feature_group/sale_online/ui/sale_online_select_address.dart';
import 'package:tpos_mobile/feature_group/sale_online/ui/sale_online_select_partner_status_dialog_page.dart';
import 'package:tpos_mobile/feature_group/sale_online/viewmodels/partner_add_edit_viewmodel.dart';
import 'package:tpos_mobile/helpers/helpers.dart';
import 'package:tpos_mobile/resources/app_colors.dart';
import 'package:tpos_mobile/src/tpos_apis/models/Address.dart';

import 'package:tpos_mobile/widgets/custom_widget.dart';

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
  _PartnerAddEditPageState createState() =>
      _PartnerAddEditPageState(closeWhenDone: closeWhenDone);
}

class _PartnerAddEditPageState extends State<PartnerAddEditPage> {
  _PartnerAddEditPageState({this.closeWhenDone = false});
  bool closeWhenDone;

  final GlobalKey<FormState> _key = GlobalKey();
  bool _validate = false;
  final PartnerAddEditViewModel viewModel = PartnerAddEditViewModel();

  TextEditingController checkAddressController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController maKhachHangController = TextEditingController();
  TextEditingController tenKhachHangController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController zaloController = TextEditingController();
  TextEditingController facebookController = TextEditingController();
  TextEditingController websiteController = TextEditingController();
  TextEditingController maVachController = TextEditingController();
  TextEditingController maSoThueController = TextEditingController();

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
    viewModel.partner.id = widget.partnerId;
    viewModel.init(
        isSupplier: widget.isSupplier, isCustomer: widget.isCustomer);
    // Parner changed
    viewModel.partnerStream.listen(
      (partner) {
        if (viewModel.partner != null) {
          if (viewModel.partner.street != null)
            addressController.text = viewModel.partner.street;
          if (viewModel.partner.ref != null)
            maKhachHangController.text = viewModel.partner.ref;
          tenKhachHangController.text = viewModel.partner.name;
          phoneController.text = viewModel.partner.phone;
          maSoThueController.text = viewModel.partner.taxCode;
          maVachController.text = viewModel.partner.barcode;
          emailController.text = viewModel.partner.email;
          zaloController.text = viewModel.partner.zalo;
          facebookController.text = viewModel.partner.facebook;
          websiteController.text = viewModel.partner.website;
        }
      },
    );

    viewModel.eventController.listen((event) {
      if (event.eventName == "GO_BACK") {
        Navigator.pop(context);
      }
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    viewModel.notifyPropertyChangedController.listen((name) {
      setState(() {});
    });

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

  @override
  Widget build(BuildContext context) {
    return ViewBaseWidget(
      isBusyStream: viewModel.isBusyController,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
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
                save();
                if (tenKhachHangController.text != "") {
                  viewModel.partner.barcode = maVachController.text.trim();
                  final result = await viewModel.save(_image);

                  if (widget.onEditPartner != null && result == true) {
                    widget.onEditPartner(viewModel.partner);
                  }
                  if (closeWhenDone == true && result == true) {
                    Navigator.pop(context, viewModel.partner);
                  }
                }
              },
            ),
          ],
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context)?.requestFocus(FocusNode());
          },
          child: Container(
            color: Colors.grey.shade200,
            child: Column(children: <Widget>[
              Expanded(child: _showBody()),
              // Button
            ]),
          ),
        ),
        bottomNavigationBar: Padding(
          padding:
              const EdgeInsets.only(left: 20, top: 6, bottom: 12, right: 20),
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                  padding: const EdgeInsets.all(12),
                  color: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                  child: const Text(
                    "LƯU",
                  ),
                  onPressed: () async {
                    save();
                    if (tenKhachHangController.text != "") {
                      viewModel.partner.barcode = maVachController.text.trim();
                      await viewModel.save(_image);
                      if (widget.onEditPartner != null)
                        widget.onEditPartner(viewModel.partner);
                      if (closeWhenDone == true) {
                        Navigator.pop(context, viewModel.partner);
                      }
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _showBody() {
    final List<Widget> chils = <Widget>[];

    if (true) {
      chils.add(const Text("dieksjdf"));
      chils.add(const Text("dieksjdf"));
      chils.add(const Text("dieksjdf"));
    }
    return StreamBuilder<Partner>(
        stream: viewModel.partnerStream,
        initialData: viewModel.partner,
        builder: (context, snapshot) {
          return SingleChildScrollView(
            padding: EdgeInsets.only(left: 12, right: 12, top: 8),
            child: Form(
              key: _key,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Row(
                      children: <Widget>[
                        Radio(
                          groupValue: viewModel.radioValue,
                          value: 0,
                          onChanged: (newValue) {
                            setState(() {
                              viewModel.handleRadioValueChanged(newValue);
                            });
                          },
                        ),
                        const Text("Cá nhân"),
                        Radio(
                          groupValue: viewModel.radioValue,
                          value: 1,
                          onChanged: (newValue) {
                            setState(() {
                              viewModel.handleRadioValueChanged(newValue);
                            });
                          },
                        ),
                        const Text("Công ty"),
                        const SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: GestureDetector(
                            child: Material(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(3),
                                  side: BorderSide(
                                      color: Colors.green,
                                      width: 1,
                                      style: BorderStyle.solid)),
                              color: getTextColorFromParterStatus(
                                  snapshot.data?.status)[0],
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text(
                                  viewModel.partner?.statusText ??
                                      "Chưa có trạng thái",
                                  style: TextStyle(
                                      color: getTextColorFromParterStatus(
                                          snapshot.data?.status)[1]),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            onTap: () async {
                              if (widget.partnerId != null) {
                                final PartnerStatus selectStatus =
                                    await showDialog(
                                        context: context,
                                        builder: (ctx) {
                                          return AlertDialog(
                                            content:
                                                SaleOnlineSelectPartnerStatusDialogPage(),
                                          );
                                        });

                                if (selectStatus != null) {
                                  viewModel.updateParterStatus(
                                      selectStatus.value, selectStatus.text);
                                }
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.only(
                      left: 12,
                      right: 12,
                      top: 12,
                    ),
                    child: TextFormField(
                      controller: tenKhachHangController,
                      onEditingComplete: () {
                        _tenKhachHangFocus.unfocus();
                        FocusScope.of(context).requestFocus(_phoneFocus);
                      },
                      focusNode: _tenKhachHangFocus,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(0),
                        labelText: 'Tên khách hàng',
                      ),
                      validator: validateName,
                      style: const TextStyle(
                          fontSize: 20, color: AppColors.brand2),
                    ),
                  ),
                  // Thông tin khách h
                  Container(
                    color: Colors.white,
                    child: ExpansionTile(
                      initiallyExpanded: true,
                      title: const Text("Thông tin khách hàng"),
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 10, right: 5),
                          child: Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: Container(
                                      height: 120,
                                      child: Builder(builder: (context) {
                                        if (_image != null) {
                                          return Stack(
                                            alignment: Alignment.topRight,
                                            children: <Widget>[
                                              Image.file(_image),
                                              _buildImageSelect(),
                                            ],
                                          );
                                        }
                                        if (snapshot.data?.imageUrl != null &&
                                            snapshot.data?.imageUrl != "") {
                                          return Stack(
                                            alignment: Alignment.topRight,
                                            children: <Widget>[
                                              Image.network(
                                                snapshot.data?.imageUrl,
                                                height: 120,
                                                width: 120,
                                              ),
                                              _buildImageSelect(),
                                            ],
                                          );
                                        }
                                        return Padding(
                                          padding: const EdgeInsets.all(3),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                              color: Colors.green,
                                            )),
                                            height: 120,
                                            width: 120,
                                            child: IconButton(
                                              color: Colors.green,
                                              icon: Icon(Icons.add),
                                              onPressed: () async {
                                                showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return SimpleDialog(
                                                        title:
                                                            const Text("Menu"),
                                                        children: <Widget>[
                                                          ListTile(
                                                            leading: Icon(
                                                                Icons.camera),
                                                            title: const Text(
                                                                "Chọn từ máy ảnh"),
                                                            onTap: () {
                                                              getImage(
                                                                  ImageSource
                                                                      .camera);
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                          ),
                                                          ListTile(
                                                            leading: Icon(
                                                                Icons.image),
                                                            title: const Text(
                                                                "Chọn từ thư viện"),
                                                            onTap: () {
                                                              getImage(
                                                                  ImageSource
                                                                      .gallery);
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                          ),
                                                        ],
                                                      );
                                                    });
                                              },
                                            ),
                                          ),
                                        );
                                      }),
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: <Widget>[
                                        // Mã khách hàng
                                        TextFormField(
                                          onEditingComplete: () {
                                            _maKhachHangFocus.unfocus();
                                            FocusScope.of(context).requestFocus(
                                                _tenKhachHangFocus);
                                          },
                                          controller: maKhachHangController,
                                          focusNode: _maKhachHangFocus,
                                          textInputAction: TextInputAction.next,
                                          decoration: const InputDecoration(
                                              border: InputBorder.none,
                                              contentPadding: EdgeInsets.all(0),
                                              labelText: 'Mã khách hàng',
                                              hintText:
                                                  'Bỏ trống để tự sinh mã khách hàng'),
                                        ),

                                        const Divider(),
                                        // Điện thoại
                                        TextFormField(
                                          controller: phoneController,
                                          onEditingComplete: () {
                                            _phoneFocus.unfocus();
                                            FocusScope.of(context)
                                                .requestFocus(_addressFocus);
                                          },
                                          focusNode: _phoneFocus,
                                          keyboardType: TextInputType.number,
                                          onFieldSubmitted: (term) {},
                                          textInputAction: TextInputAction.next,
                                          decoration: const InputDecoration(
                                            border: InputBorder.none,
                                            contentPadding: EdgeInsets.all(0),
                                            labelText: 'Điện thoại',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const Divider(),
                              Row(
                                children: <Widget>[
                                  Chip(
                                    backgroundColor:
                                        Colors.greenAccent.shade100,
                                    label: Text(
                                      "Nợ hiện tại: ${vietnameseCurrencyFormat(snapshot.data?.credit) ?? 0}",
                                      style:
                                          const TextStyle(color: Colors.black),
                                    ),
                                  ),
                                  Expanded(
                                    child: CheckboxListTile(
                                      controlAffinity:
                                          ListTileControlAffinity.leading,
                                      value: viewModel.isActive,
                                      title: const Text('Active'),
                                      onChanged: (bool value) {
                                        viewModel.isCheckActive(value);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              const Divider(),
                              // Địa chỉ
                              TextField(
                                maxLines: null,
                                onEditingComplete: () {
                                  _addressFocus.unfocus();
                                  FocusScope.of(context)
                                      .requestFocus(_checkAddressFocus);
                                },
                                focusNode: _addressFocus,
                                controller: addressController,
                                onChanged: (value) {
                                  viewModel.partner.street = value;
                                },
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.all(0),
                                  icon: Icon(Icons.location_on),
                                  labelText: 'Địa chỉ',
                                  counter: SizedBox(
                                    height: 30,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        FlatButton(
                                          padding: const EdgeInsets.all(0),
                                          child: const Text("Copy"),
                                          textColor: Colors.blue,
                                          onPressed: () {
                                            Clipboard.setData(ClipboardData(
                                                text: addressController.text
                                                    .trim()));
                                            Scaffold.of(context).showSnackBar(
                                                SnackBar(
                                                    content: Text(
                                                        "Đã copy ${addressController.text.trim()} vào clipboard")));
                                          },
                                        ),
                                        FlatButton(
                                          textColor: Colors.blue,
                                          padding: const EdgeInsets.all(0),
                                          child: const Text("Kiểm tra"),
                                          onPressed: () async {
                                            final result = await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    CheckAddressPage(
                                                  keyword: addressController
                                                      .text
                                                      .trim(),
                                                ),
                                              ),
                                            );
//
                                            if (result != null) {
                                              viewModel
                                                  .selectCheckAddressCommand(
                                                      result);
                                            }

                                            FocusScope.of(context)
                                                .requestFocus(FocusNode());
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0, right: 15),
                          child: Column(
                            children: <Widget>[
                              // Check địa chỉ
//
                              const Divider(
                                height: 1,
                              ),
                              //Chọn tỉnh/thành phố
                              ListTile(
                                contentPadding: const EdgeInsets.all(0),
                                leading: const Padding(
                                  padding: EdgeInsets.only(top: 3),
                                  child: Text(
                                    "Tỉnh thành",
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ),
                                title: Text(
                                  snapshot.data?.city?.name ??
                                      "Chọn tỉnh/thành phố",
                                  textAlign: TextAlign.right,
                                ),
                                trailing: const Icon(Icons.chevron_right),
                                onTap: () async {
                                  final Address selectAddress =
                                      await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (ctx) {
                                        return const SelectAddressPage(
                                          cityCode: null,
                                          districtCode: null,
                                        );
                                      },
                                    ),
                                  );
                                  viewModel.partnerCity = selectAddress;
                                },
                              ),
                              //Chọn quận/huyện
                              ListTile(
                                contentPadding: const EdgeInsets.all(0),
                                leading: const Padding(
                                  padding: EdgeInsets.only(top: 3),
                                  child: Text(
                                    "Quận/Huyện",
                                    style: TextStyle(fontSize: 15),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                title: Text(
                                  snapshot.data?.district?.name ??
                                      "Chọn quận/huyện",
                                  textAlign: TextAlign.right,
                                ),
                                trailing: const Icon(Icons.chevron_right),
                                onTap: () async {
                                  if (snapshot.data?.city == null) {
                                    return;
                                  }
                                  final Address selectAddress =
                                      await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (ctx) {
                                        return SelectAddressPage(
                                          cityCode:
                                              viewModel.partner.city?.code,
                                          districtCode: null,
                                        );
                                      },
                                    ),
                                  );

                                  viewModel.partnerDistrict = selectAddress;
                                },
                              ),
                              //Chọn phường/xã
                              ListTile(
                                contentPadding: const EdgeInsets.all(0),
                                leading: const Padding(
                                  padding: EdgeInsets.only(top: 3),
                                  child: Text(
                                    "Phường/Xã",
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ),
                                title: Text(
                                  snapshot.data?.ward?.name ?? "Chọn phường/xã",
                                  style: const TextStyle(),
                                  textAlign: TextAlign.right,
                                ),
                                trailing: const Icon(Icons.chevron_right),
                                onTap: () async {
                                  if (snapshot.data?.district == null) {
                                    return;
                                  }
                                  final Address selectAddress =
                                      await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (ctx) {
                                        return SelectAddressPage(
                                          cityCode:
                                              viewModel.partner.city?.code,
                                          districtCode:
                                              viewModel.partner.district?.code,
                                        );
                                      },
                                    ),
                                  );

                                  viewModel.partnerWard = selectAddress;
                                },
                              ),
                              const Divider(
                                height: 1,
                              ),
                              // Danh sách địa chỉ lựa chọn
                            ],
                          ),
                        ),
                        ListTile(
                          title: const Text("Nhóm khách hàng"),
                          subtitle: Column(
                            children: <Widget>[
                              _showChip(context),
                            ],
                          ),
                          trailing: const Icon(Icons.keyboard_arrow_right),
                          onTap: () async {
                            final PartnerCategory result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return PartnerCategoryPage(
                                    partnerCategories:
                                        viewModel.partnerCategories,
                                  );
                                },
                              ),
                            );
                            if (result != null) {
                              if (!viewModel.partnerCategories
                                  .any((f) => f.id == result.id))
                                viewModel.selectPartnerCategoryCommand(result);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  // Thông tin chi tiết
                  Container(
                    color: Colors.white,
                    child: ExpansionTile(
                      title: const ListTile(
                        contentPadding: const EdgeInsets.all(0),
                        title: Text(
                          "Thông tin bổ sung (ĐT, mail, zalo, fb..)",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      initiallyExpanded: false,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0, right: 15),
                          child: Column(
                            children: <Widget>[
                              TextFormField(
                                onEditingComplete: () {
                                  _emailFocus.unfocus();
                                  FocusScope.of(context)
                                      .requestFocus(_zaloFocus);
                                },
                                focusNode: _emailFocus,
                                controller: emailController,
                                textInputAction: TextInputAction.next,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.all(0),
                                  icon: Icon(Icons.email),
                                  labelText: 'Email',
                                ),
                              ),
                              const Divider(),
                              TextFormField(
                                onEditingComplete: () {
                                  _zaloFocus.unfocus();
                                  FocusScope.of(context)
                                      .requestFocus(_facebookFocus);
                                },
                                controller: zaloController,
                                focusNode: _zaloFocus,
                                textInputAction: TextInputAction.next,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.all(0),
                                  icon: Icon(Icons.account_box),
                                  labelText: 'Zalo',
                                ),
                              ),
                              const Divider(),
                              TextFormField(
                                onEditingComplete: () {
                                  _facebookFocus.unfocus();
                                  FocusScope.of(context)
                                      .requestFocus(_websiteFocus);
                                },
                                focusNode: _facebookFocus,
                                controller: facebookController,
                                textInputAction: TextInputAction.next,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.all(0),
                                  icon: Icon(Icons.face),
                                  labelText: 'Facebook',
                                ),
                              ),
                              const Divider(),
                              TextFormField(
                                onEditingComplete: () {
                                  _websiteFocus.unfocus();
                                  FocusScope.of(context)
                                      .requestFocus(_maSoThueFocus);
                                },
                                focusNode: _websiteFocus,
                                controller: websiteController,
                                textInputAction: TextInputAction.next,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.all(0),
                                  icon: Icon(Icons.cloud),
                                  labelText: 'Website',
                                ),
                              ),
                              const Divider(),
                              if (viewModel.radioValue == 0)
                                const SizedBox()
                              else
                                TextFormField(
                                  onEditingComplete: () {
                                    _maSoThueFocus.unfocus();
                                  },
                                  focusNode: _maSoThueFocus,
                                  controller: maSoThueController,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.all(0),
                                    icon: Icon(Icons.insert_invitation),
                                    labelText: 'Mã số thuế',
                                  ),
                                ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    color: Colors.white,
                    child: ExpansionTile(
                      title: const ListTile(
                        contentPadding: const EdgeInsets.all(0),
                        title: Text(
                          "Bán hàng",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      initiallyExpanded: true,
                      children: <Widget>[
                        CheckboxListTile(
                          value: viewModel.isCustomer,
                          title: const Text('Là khách hàng'),
                          onChanged: (bool value) {
                            viewModel.isCheckCustomer(value);
                          },
                        ),
                        //TODO Chọn bảng giá
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 15.0, right: 15.0),
                          child: Column(
                            children: <Widget>[
//                              DropdownButtonHideUnderline(
//                                child: DropdownButton<ProductPrice>(
//                                  isExpanded: true,
//                                  hint: Text("Chọn bảng giá"),
//                                  value: viewModel.selectedProductPrice,
//                                  onChanged: (ProductPrice newValue) async {
//                                    setState(() {
//                                      viewModel.selectedProductPrice = newValue;
//                                    });
//                                  },
//                                  items: viewModel.productPrices?.map(
//                                    (ProductPrice productPrice) {
//                                      return  DropdownMenuItem<ProductPrice>(
//                                        value: productPrice,
//                                        child:  Text(
//                                          "${productPrice.name ?? ""}",
//                                        ),
//                                      );
//                                    },
//                                  )?.toList(),
//                                ),
//                              ),
                              if (viewModel.accountPayments == null ||
                                  viewModel.accountPayments.isEmpty)
                                const SizedBox()
                              else
                                DropdownButtonHideUnderline(
                                  child: DropdownButton<AccountPaymentTerm>(
                                    isExpanded: true,
                                    hint: const Text(
                                        "Điều khoản khách hàng thanh toán"),
                                    value: viewModel.selectedAccountPayment,
                                    onChanged:
                                        (AccountPaymentTerm newValue) async {
                                      setState(() {
                                        viewModel.selectedAccountPayment =
                                            newValue;
                                      });
                                    },
                                    items: viewModel.accountPayments.map(
                                        (AccountPaymentTerm accountPayment) {
                                      return DropdownMenuItem<
                                          AccountPaymentTerm>(
                                        value: accountPayment,
                                        child: Text(
                                          accountPayment.name ?? "",
                                        ),
                                      );
                                    })?.toList(),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    color: Colors.white,
                    child: ExpansionTile(
                      title: const ListTile(
                        contentPadding: const EdgeInsets.all(0),
                        title: Text(
                          "Mua hàng",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      initiallyExpanded: true,
                      children: <Widget>[
                        CheckboxListTile(
                          value: viewModel.isProvider,
                          title: const Text('Là nhà cung cấp'),
                          onChanged: (bool value) {
                            viewModel.isCheckProvider(value);
                          },
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 15.0, right: 15.0),
                          child: viewModel.accountPayments == null
                              ? const SizedBox()
                              : DropdownButtonHideUnderline(
                                  child: DropdownButton<AccountPaymentTerm>(
                                    isExpanded: true,
                                    hint: const Text(
                                        "Điều khoản thanh toán nhà cung cấp"),
                                    value: viewModel.selectedSupplierPayment,
                                    onChanged:
                                        (AccountPaymentTerm newValue) async {
                                      setState(() {
                                        viewModel.selectedSupplierPayment =
                                            newValue;
                                      });
                                    },
                                    items: viewModel.accountPayments.map(
                                        (AccountPaymentTerm accountPayment) {
                                      return DropdownMenuItem<
                                          AccountPaymentTerm>(
                                        value: accountPayment,
                                        child: Text(
                                          accountPayment.name ?? "",
                                        ),
                                      );
                                    })?.toList(),
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    color: Colors.white,
                    child: ExpansionTile(
                      title: const ListTile(
                        contentPadding: EdgeInsets.all(0),
                        title: Text(
                          "Điểm bán hàng",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      initiallyExpanded: false,
                      children: <Widget>[
                        // Mã vạch
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0, right: 15),
                          child: TextFormField(
                            controller: maVachController,
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(0),
                              icon: Icon(Icons.code),
                              labelText: 'Mã vạch',
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget _buildImageSelect() {
    return GestureDetector(
      onTap: () {
        viewModel.partner.imageUrl = null;
        _image = null;
      },
      child: const Icon(
        Icons.close,
        color: Colors.redAccent,
      ),
    );
  }

  Widget _showChip(BuildContext context) {
    return StreamBuilder<List<PartnerCategory>>(
        stream: viewModel.partnerCategoriesStream,
        initialData: viewModel.partnerCategories,
        builder: (ctx, snapshot) {
          return Wrap(
            spacing: 1.0,
            runSpacing: 0,
            runAlignment: WrapAlignment.start,
            children: List<Widget>.generate(viewModel.partnerCategories?.length,
                (index) {
              return Chip(
                backgroundColor: Colors.greenAccent.shade100,
                onDeleted: () {
                  viewModel.removePartnerCategoryCommand(
                      viewModel.partnerCategories[index]);
                },
                label: Text(viewModel.partnerCategories[index]?.name ?? ''),
              );
            }),
          );
        });
  }

  String validateName(String value) {
    if (value.isEmpty) {
      return "Tên khách hàng không được bỏ trống";
    }
    return null;
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

  void save() {
    viewModel.partner ??= Partner();
    viewModel.partner.ref = maKhachHangController.text.trim();
    viewModel.partner.name = tenKhachHangController.text;
    viewModel.partner.phone = phoneController.text.trim();
    viewModel.partner.street = addressController.text.trim();
    viewModel.partner.zalo = zaloController.text.trim();
    viewModel.partner.facebook = facebookController.text.trim();
    viewModel.partner.email = emailController.text.trim();
    viewModel.partner.website = websiteController.text.trim();
    viewModel.partner.barcode = maVachController.text.trim();
    viewModel.partner.taxCode = maSoThueController.text.trim();
    _sendToServer();
  }

  void _sendToServer() {
    if (_key.currentState.validate()) {
      // No any error in validation
      _key.currentState.save();
    } else {
      // validation error
      setState(() {
        _validate = true;
      });
    }
  }
}

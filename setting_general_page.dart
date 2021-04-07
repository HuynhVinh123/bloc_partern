import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tdental_api_client/models/entities/res_config_setting.dart';
import 'package:tdentalmobile/pages/categories/bloc/set_config/set_config_bloc.dart';
import 'package:tdentalmobile/pages/categories/ui/config/setting_general_bloc.dart';
import 'package:tdentalmobile/pages/categories/ui/config/setting_general_event.dart';
import 'package:tdentalmobile/pages/categories/ui/config/setting_general_state.dart';
import 'package:tdentalmobile/pages/categories/ui/overview/dialog_service_info_app.dart';
import 'package:tdentalmobile/services/dialog_service/dialog_service.dart';
import 'package:tdentalmobile/widgets/core_widgets/app_button.dart';
import 'package:tdentalmobile/widgets/core_widgets/loading_page.dart';

import '../../../../locator.dart';
import '../../../../theme.dart';

class SettingGeneralPage extends StatefulWidget {
  @override
  _SettingGeneralPageState createState() => _SettingGeneralPageState();
}

class _SettingGeneralPageState extends State<SettingGeneralPage> {
  final TextEditingController _amountController =
      TextEditingController(text: '0');
  final FocusNode _focusNode = FocusNode();
  final SettingGeneralBloc _bloc = SettingGeneralBloc();
  ResConfigSetting resConfigSetting = ResConfigSetting();
  final DialogServiceInfoApp _dialogApp = DialogServiceInfoApp();
  final DialogService _dialogService = locator<DialogService>();

  List<Map<String, dynamic>> _titles = <Map<String, dynamic>>[
    <String, dynamic>{
      'key': false,
      'value': 'Coupon & khuyến mãi',
      'nameKey': 'groupSaleCouponPromotion'
    },
    <String, dynamic>{
      'key': false,
      'value': 'Thẻ dịch vụ',
      'nameKey': 'groupServiceCard'
    },
    <String, dynamic>{
      'key': false,
      'value': 'Chăm sóc tự động',
      'nameKey': 'groupTCare'
    },
    <String, dynamic>{
      'key': false,
      'value': 'Thẻ thành viên',
      'nameKey': 'groupLoyaltyCard'
    },
    <String, dynamic>{
      'key': false,
      'value': 'Đơn vị tính',
      'nameKey': 'groupUoM'
    },
    <String, dynamic>{
      'key': false,
      'value': 'Bán thuốc',
      'nameKey': 'groupMedicine'
    },
    <String, dynamic>{
      'key': false,
      'value': 'Khảo sát đánh giá ',
      'nameKey': 'groupSurvey'
    },
    <String, dynamic>{
      'key': false,
      'value': 'Đa chi nhánh',
      'nameKey': 'groupMultiCompany'
    }
  ];

  final List<String> _subTitle = const <String>[
    'Quản lý chương trình coupon & khuyến mãi',
    'Quản lý thẻ dịch vụ',
    'Tạo kịch bản chăm sóc khách hàng',
    'Quản lý thẻ thành viên, áp dụng bảng giá thành viên',
    'Hàng hóa có thể nhập xuất nhiều đơn vị tính',
    'Quản lý đơn thuốc và hóa đơn thuốc',
    'Quản lý và cấu hình khảo sát đánh giá',
    'Quản lý đa chi nhánh'
  ];

  List<Map<String, dynamic>> _checkCompanies = <Map<String, dynamic>>[
    {
      'key': false,
      'value': 'Dùng chung danh sách đối tác',
      'nameKey': 'companySharePartner'
    },
    {
      'key': false,
      'value': 'Dùng chung danh sách sản phẩm',
      'nameKey': 'companyShareProduct'
    },
    {
      'key': false,
      'value': 'Giá bán sản phẩm riêng cho từng chi nhánh',
      'nameKey': 'productListpriceRestrictCompany'
    }
  ];

  @override
  void initState() {
    super.initState();
    _bloc.add(
        SettingGeneralLoaded(titles: _titles, checkCompanies: _checkCompanies));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SettingGeneralBloc>(
      create: (BuildContext context) => _bloc,
      child: BlocConsumer<SettingGeneralBloc, SettingGeneralState>(
          listener: (BuildContext context, SettingGeneralState state) {
            if(state is SettingGeneralInsertFailure){
              _dialogApp.showDefaultApp(
                  context: context,
                  title: state.title,
                  content: state.content,
                  logo: 'images/ic_action_error.svg',
                  actions: AppButton(
                    border: Border.all(color: const Color(0xFFEEEEEE)),
                    background: Colors.white,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Đóng',
                      style: TextStyle(
                        color: Color(0xFF858585),
                        fontSize: 15,
                      ),
                    ),
                  ));
            }else if(state is SettingGeneralInsertSuccess){
              Navigator.pop(context);
              _dialogService.showToastOnTop(
                  type: AlertDialogType.info,
                  icon:
                  const Icon(Icons.cancel, color: Colors.white, size: 24),
                  message: 'Cập nhật thành công!',
                  title: 'Thông báo',
                  backgroundColor: AppColors.doneStateColor,
                  context: context);
            }else if(state is SettingGeneralLoadError){
              _dialogApp.showDefaultApp(
                  context: context,
                  title: state.title,
                  content: state.content,
                  logo: 'images/ic_action_error.svg',
                  actions: AppButton(
                    border: Border.all(color: const Color(0xFFEEEEEE)),
                    background: Colors.white,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Đóng',
                      style: TextStyle(
                        color: Color(0xFF858585),
                        fontSize: 15,
                      ),
                    ),
                  ));
            }
          },
          builder: (BuildContext context, SettingGeneralState state) {
            return Stack(
              children: <Widget>[
                Scaffold(
                  backgroundColor: Colors.white,
                  appBar: _buildAppBar() as PreferredSizeWidget?,
                  body: BlocBuilder<SettingGeneralBloc, SettingGeneralState>(
                      builder:
                          (BuildContext context, SettingGeneralState state) {
                    if (state is SettingGeneralSuccess) {
                      _titles = state.titles;
                      _checkCompanies = state.checkCompanies;
                      resConfigSetting = state.resConfigSetting;
                      return _buildBody();
                    }
                    return _buildBody();
                  }),
                ),
                if (state is SettingGeneralLoading) const LoadingPage()
              ],
            );
          }),
    );
  }

  Widget _buildAppBar() => AppBar(
        elevation: 3,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            color: Color(0xff303030),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Center(
          child: Text('Cấu hình',
              style: TextStyle(color: Color(0xff303030)),
              textAlign: TextAlign.center),
        ),
        actions: <Widget>[
          InkWell(
            onTap: () {
              _bloc.add(SettingGeneralInserted(
                  titles: _titles,
                  checkCompanies: _checkCompanies,
                  resConfigSetting: resConfigSetting,
                  amount:double.parse(_amountController.text.trim())
              ));
            },
            child: const Center(
              child: Padding(
                padding: EdgeInsets.only(right: 12),
                child: Text(
                  'Áp dụng',
                  style: TextStyle(
                      color: Color(0xff1A6DE3),
                      fontWeight: FontWeight.w600,
                      fontSize: 16),
                ),
              ),
            ),
          )
        ],
      );

  Widget _buildBody() => ListView.separated(
      itemBuilder: (BuildContext context, int index) => index == 3
          ? _InputEmployee(
              title: _titles[index],
              content: _subTitle[index],
              controller: _amountController,
              focusNode: _focusNode,
              onPressed: (dynamic value) {
                setState(() {
                  _titles[index]['key'] = value;
                });
              },
              onCountChanged: (bool isIncrement) {
                if (isIncrement) {
                  setState(() {
                    _amountController.text =
                        (int.parse(_amountController.text) + 1).toString();
                  });
                } else {
                  setState(() {
                    _amountController.text =
                        (int.parse(_amountController.text) > 0
                                ? int.parse(_amountController.text) - 1
                                : 0)
                            .toString();
                  });
                }
              },
            )
          : index == _titles.length - 1
              ? _Companies(
                  title: _titles[index],
                  content: _subTitle[index],
                  checkCompanies: _checkCompanies,
                  onPressed: (dynamic value) {
                    setState(() {
                      _titles[index]['key'] = value;
                    });
                  },
                  onChangeCompany: (dynamic value, dynamic position) {
                    setState(() {
                      _checkCompanies[position]['key'] = value;
                      if(position == 1 && !value){
                        _checkCompanies[position+1]['key'] = false;
                      }
                    });
                  })
              : _ItemConfig(
                  title: _titles[index],
                  content: _subTitle[index],
                  onPressed: (dynamic value) {
                    setState(() {
                      _titles[index]['key'] = value;
                    });
                  }),
      separatorBuilder: (BuildContext context, int index) =>
          const Divider(height: 8),
      itemCount: _titles.length);
}

class _Companies extends StatelessWidget {
  const _Companies(
      {required this.title,
      required this.content,
      required this.onPressed,
      required this.checkCompanies,
      required this.onChangeCompany});

  final Map<String, dynamic> title;
  final String content;
  final List<Map<String, dynamic>> checkCompanies;
  final Function onPressed;
  final Function onChangeCompany;

  @override
  Widget build(BuildContext context) {
    return ListTile(
        onTap: () {
          onPressed(!title['key']);
        },
        contentPadding: const EdgeInsets.all(0),
        title: Row(
          children: <Widget>[
            Checkbox(
              value: title['key'],
              onChanged: (bool? value) {
                onPressed(!title['key']);
              },
            ),
            Expanded(child: Text(title['value'])),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 48, right: 12),
                child: Text(content),
              ),
              Visibility(
                visible: title['key'],
                child: Padding(
                  padding: const EdgeInsets.only(left: 36, right: 12),
                  child: ListTile(
                    onTap: () {
                      onChangeCompany(!checkCompanies[0]['key'], 0);
                    },
                    contentPadding: const EdgeInsets.all(0),
                    title: Row(
                      children: <Widget>[
                        Checkbox(
                          value: checkCompanies[0]['key'],
                          onChanged: (bool? value) {
                            onChangeCompany(!checkCompanies[0]['key'], 0);
                          },
                        ),
                        Expanded(child: Text(checkCompanies[0]['value']))
                      ],
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: title['key'],
                child: Padding(
                  padding: const EdgeInsets.only(left: 36, right: 12),
                  child: ListTile(
                    onTap: () {
                      onChangeCompany(!checkCompanies[1]['key'], 1);
                    },
                    contentPadding: const EdgeInsets.all(0),
                    title: Row(
                      children: <Widget>[
                        Checkbox(
                          value: checkCompanies[1]['key'],
                          onChanged: (bool? value) {
                            onChangeCompany(!checkCompanies[1]['key'], 1);
                          },
                        ),
                        Expanded(child: Text(checkCompanies[1]['value']))
                      ],
                    ),
                    subtitle: Visibility(
                      visible: checkCompanies[1]['key'],
                      child: Padding(
                        padding: const EdgeInsets.only(left: 36, right: 12),
                        child: ListTile(
                          onTap: () {
                            onChangeCompany(!checkCompanies[2]['key'], 2);
                          },
                          contentPadding: const EdgeInsets.all(0),
                          title: Row(
                            children: <Widget>[
                              Checkbox(
                                value: checkCompanies[2]['key'],
                                onChanged: (bool? value) {
                                  onChangeCompany(!checkCompanies[2]['key'], 2);
                                },
                              ),
                              Expanded(child: Text(checkCompanies[2]['value']))
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}

class _ItemConfig extends StatelessWidget {
  const _ItemConfig(
      {required this.title, required this.content, required this.onPressed});

  final Map<String, dynamic> title;
  final String content;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return ListTile(
        onTap: () {
          onPressed(!title['key']);
        },
        contentPadding: const EdgeInsets.all(0),
        title: Row(
          children: <Widget>[
            Checkbox(
              value: title['key'],
              onChanged: (bool? value) {
                onPressed(!title['key']);
              },
            ),
            Expanded(child: Text(title['value'])),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(left: 48),
          child: Text(content),
        ));
  }
}

class _InputEmployee extends StatelessWidget {
  const _InputEmployee(
      {required this.title,
      required this.content,
      required this.controller,
      required this.focusNode,
      required this.onPressed,
      required this.onCountChanged});

  final Map<String, dynamic> title;
  final String content;
  final TextEditingController controller;
  final FocusNode focusNode;
  final Function onPressed;
  final Function(bool) onCountChanged;

  @override
  Widget build(BuildContext context) {
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        controller.selection =
            TextSelection(baseOffset: 0, extentOffset: controller.text.length);
      }
    });

    return ListTile(
        onTap: () {
          onPressed(!title['key']);
        },
        contentPadding: const EdgeInsets.all(0),
        title: Row(
          children: <Widget>[
            Checkbox(
              value: title['key'],
              onChanged: (bool? value) {
                onPressed(!title['key']);
              },
            ),
            Expanded(child: Text(title['value'])),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(left: 48),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(content),
              const Text('Số tiền trên 1 điểm:'),
              Container(
                margin: const EdgeInsets.only(top: 12, right: 12),
                height: 40,
                child: Row(
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        FocusScope.of(context).unfocus();
                        onCountChanged(false);
                      },
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8),
                                bottomLeft: Radius.circular(8)),
                            color: Color(0xffEDF4FF)),
                        child: const Icon(
                          Icons.remove,
                          color: Color(0xff1a6de3),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                          width: double.infinity,
                          height: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8)),
                          child: Center(
                            child: TextField(
                              focusNode: focusNode,
                              textAlign: TextAlign.center,
                              controller: controller,
                              decoration:
                                  const InputDecoration.collapsed(hintText: ''),
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9]')),
                              ],
                            ),
                          )),
                    ),
                    InkWell(
                      onTap: () {
                        FocusScope.of(context).unfocus();
                        onCountChanged(true);
                      },
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(8),
                                bottomRight: Radius.circular(8)),
                            color: Color(0xffEDF4FF)),
                        child: const Icon(
                          Icons.add_sharp,
                          color: Color(0xff1a6de3),
                        ),
                      ),
                    ),
                  ],
                ),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: const Color(0xffEDF4FF),
                    border: Border.all(color: const Color(0xffEDF4FF))),
              ),
              const SizedBox(
                width: 12,
              )
            ],
          ),
        ));
  }
}

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tpos_mobile/app_core/ui_base/ui_base.dart';
import 'package:tpos_mobile/helpers/string_helper.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/services/analytics_service.dart';
import 'package:tpos_mobile/src/tpos_apis/models/tpos_city.dart';
import 'package:tpos_mobile/application/register_confirm_phone_page.dart';
import 'package:tpos_mobile/application/viewmodel/register_viewmodel.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final vm = RegisterViewModel();
  var _formKey = GlobalKey<FormState>();
  var _scaffoldKey = GlobalKey<ScaffoldState>();

  var _shopUrlController = new TextEditingController();
  Future _onSubmit(BuildContext context) async {
    vm.resetServerValidate();
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      bool result = await vm.submitRegister();
      if (result) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RegisterConfirmPage(
              vm: vm,
            ),
          ),
        );
      }
    } else {
      _scaffoldKey.currentState?.showSnackBar(
        SnackBar(
          content: Text("Vui lòng điền đúng các trường còn thiếu"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void initState() {
    vm.initData();
    _shopUrlController.addListener(() {
      if (mounted) setState(() {});
    });

    vm.eventController.listen((event) {
      if (event.eventName == "RegisterError") {
        // Validate lại
        _formKey.currentState.validate();
      } else if (event.eventName == RegisterViewModel.REGISTER_COMPLETE_EVENT) {
        // Xác thực số điện thoại

      }
    });

    // log server event
    locator<AnalyticsService>().logOpenRegisterPage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: ScopedModel<RegisterViewModel>(
        model: vm,
        child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: Text("Đăng ký"),
          ),
          body: _buildBody(),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Liên hệ 0908 075455 hoặc 1900 2852 để được hỗ trợ khi gặp sự cố đăng kí, để nhận tư vấn thêm hoặc đăng ký hỗ trợ trực tiếp.",
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.lightGreen),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return UIViewModelBase(
      viewModel: vm,
      child: ScopedModelDescendant<RegisterViewModel>(
        builder: (context, child, model) {
          return SingleChildScrollView(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(
                  height: 30,
                ),
                if (!vm.isShowRegisterForm) _buildLoginFacebook(),
                if (vm.isShowRegisterForm) _buildForm(),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Email, số điện thoại
  Widget _buildLoginFacebook() {
    return Container(
      margin: EdgeInsets.only(top: 50),
      child: Column(
        children: <Widget>[
          Text(
            "Đăng ký dùng thử TPOS",
            style: TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "Rất nhiều chủ shop online đã sử dụng và có phản hồi tốt",
            style: TextStyle(fontSize: 14, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 40),
          if (!vm.isLoginFacebook) ...[
            Text("ĐĂNG KÝ BẰNG TÀI KHOẢN FACEBOOK CỦA BẠN"),
            const SizedBox(height: 50),
            Container(
              width: double.infinity,
              child: RaisedButton.icon(
                label: Text("ĐĂNG KÝ BẰNG FACEBOOK"),
                color: Colors.indigo,
                textColor: Colors.white,
                icon: Icon(FontAwesomeIcons.facebookF),
                onPressed: () {
                  vm.loginFacebook();
                },
              ),
            ),
          ],
          SizedBox(
            height: 30,
          ),
          if (vm.isLoginFacebook)
            Text("Xin chào ${vm.facebookUser?.name}. Xin chờ một chút"),
          if (vm.isLoginFacebook) CircularProgressIndicator(),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            "Nhập thông tin cửa hàng sau đó nhấn tiếp tục",
            style: TextStyle(color: Colors.indigo),
          ),
          RegisterFormField(
            initValue: vm.name,
            label: "Tên Shop (*)",
            hint: "VD: Shop giày Moon",
            onSubmit: (value) => vm.name = value,
          ),
          RegisterFormField(
            label: "Địa chỉ email (*)",
            hint: "Vd: shopmoon@gmail.com",
            validator: validateEmail,
            onSubmit: (value) => vm.email = value,
            initValue: vm.email,
          ),
          RegisterFormField(
            label: "Số điện thoại (*)",
            hint: "Số điện thoại",
            validator: vm.validatePhone,
            onSubmit: (value) => vm.phone = value,
          ),
          TextFormField(
            controller: _shopUrlController,
            decoration: InputDecoration(
                errorText: vm.shopUrlValidate,
                hintText: "Vd: moonshop",
                labelText: "Địa chỉ gian hàng trên TPOS.VN (*)"),
            onFieldSubmitted: (value) => vm.shopUrl = value,
            validator: vm.validateShopUrl,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RichText(
              text: TextSpan(
                text: "https://",
                style: TextStyle(color: Colors.black),
                children: [
                  TextSpan(
                    text:
                        "${vm.shopUrl == null || vm.shopUrl == "" ? "dia_chi_gian_hang" : "${vm.shopUrl}"}",
                    style: TextStyle(
                        color: Colors.green, fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: ".tpos.vn"),
                ],
              ),
              textAlign: TextAlign.left,
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Bạn ở tỉnh/ thành phố nào?",
              style: TextStyle(fontSize: 17),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      vm.selectedCity?.label ?? "Vui lòng chọn",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Icon(Icons.arrow_drop_down)
                ],
              ),
              onTap: () {
                _showCitySearch();
              },
            ),
          ),
          Text(
            "${vm.cityCodeValidate ?? ""}",
            style: TextStyle(color: Colors.red),
          ),
          Divider(
            height: 2,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8, top: 2),
            child: TextField(
              decoration: InputDecoration(labelText: "Ghi chú thêm"),
              onChanged: (text) {
                vm.note = text;
              },
              maxLines: null,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          RaisedButton(
            color: Colors.blue,
            child: Text("TIẾP TỤC"),
            textColor: Colors.white,
            onPressed: () {
              _onSubmit(context);
              //_formKey.currentState.save();
              // vm.loginWithPhone();

//              Navigator.push(
//                  context,
//                  MaterialPageRoute(
//                      builder: (context) => RegisterConfirmPage(
//                            vm: vm,
//                          )));
            },
          )
        ],
      ),
    );
  }

  Widget _buildSuccess() {
    return Container(
      child: Column(
        children: const <Widget>[
          Text('Đăng ký thành công'),
        ],
      ),
    );
  }

  void _showCitySearch() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Container(
          width: 200,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(hintText: "Tìm kiếm"),
                onChanged: (text) {
                  vm.searchCity(text);
                },
              ),
              Expanded(
                child: StreamBuilder<List<TPosCity>>(
                    stream: vm.cityStream,
                    builder: (context, snapshot) {
                      return ListView.separated(
                          itemBuilder: (context, index) => ListTile(
                                title: Text("${vm.viewCities[index].label}"),
                                onTap: () {
                                  vm.selectedCity = vm.viewCities[index];
                                  Navigator.pop(context);
                                },
                              ),
                          separatorBuilder: (context, index) => Divider(
                                height: 1,
                              ),
                          itemCount: vm.viewCities?.length ?? 0);
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class RegisterFormField extends StatelessWidget {
  final String label;
  final String hint;
  final FormFieldValidator<String> validator;
  final FormFieldSetter<String> onSubmit;
  final VoidCallback onEditingComplete;
  final String initValue;
  RegisterFormField(
      {this.label = "",
      this.hint = "",
      this.validator,
      this.onSubmit,
      this.onEditingComplete,
      this.initValue});
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initValue,
      decoration: InputDecoration(hintText: hint, labelText: label),
      autovalidate: false,
      onSaved: onSubmit,
      validator: validator,
      onEditingComplete: onEditingComplete,
      style: TextStyle(fontWeight: FontWeight.bold),
    );
  }
}

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:tpos_mobile/app_core/ui_base/ui_base.dart';

import 'package:tpos_mobile/application/viewmodel/register_viewmodel.dart';

class RegisterConfirmPage extends StatefulWidget {
  final RegisterViewModel vm;
  RegisterConfirmPage({this.vm});
  @override
  _RegisterConfirmPageState createState() => _RegisterConfirmPageState();
}

class _RegisterConfirmPageState extends State<RegisterConfirmPage> {
  final _verifyCodeController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return UIViewModelBase<RegisterViewModel>(
      viewModel: widget.vm,
      child: WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            leading: SizedBox(),
            title: Text("Xác thực số điện thoại"),
          ),
          body: _buildBody(),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Container(
      padding: EdgeInsets.all(25),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Vui lòng nhập mã xác nhận được gửi tới số ${widget.vm?.phone}",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 17),
            ),
          ),
          TextField(
            controller: _verifyCodeController,
            decoration: InputDecoration(hintText: "vd:123433"),
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.blue, fontSize: 20),
            keyboardType: TextInputType.number,
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              RaisedButton(
                child: Text("XÁC NHẬN"),
                onPressed: () async {
                  var confirmResult = await widget.vm.confirmPhone(
                    verifyCode: _verifyCodeController.text.trim(),
                  );
                  if (confirmResult == true) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RegisterConfirmNotify(widget.vm),
                      ),
                    );
                  }
                },
                textColor: Colors.white,
              ),
              const SizedBox(
                width: 10,
              ),
              RaisedButton(
                child: Text("GỬI LẠI MÃ"),
                color: Colors.redAccent,
                onPressed: () async {
                  widget.vm.resendCode();
                },
                textColor: Colors.white,
              ),
              const SizedBox(
                width: 10,
              ),
              RaisedButton(
                child: Text("ĐÓNG"),
                color: Colors.redAccent,
                onPressed: () async {
                  Navigator.pop(context);
                },
                textColor: Colors.white,
              )
            ],
          ),
        ],
      ),
    );
  }
}

class RegisterConfirmNotify extends StatelessWidget {
  final RegisterViewModel vm;
  RegisterConfirmNotify(this.vm);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(""),
              AutoSizeText(
                "Cảm ơn bạn đã đăng ký sử dụng TPOS, tài khoản dùng thử sẽ được khởi tạo và gửi cho bạn qua email hoặc sms sớm nhất có thể",
                minFontSize: 20,
                maxFontSize: 27,
              ),
              SizedBox(
                height: 20,
              ),
              RaisedButton.icon(
                icon: Icon(Icons.arrow_back),
                label: Text("Quay lại đăng nhập"),
                onPressed: () {
                  Navigator.popUntil(
                      context, (Route<dynamic> route) => route.isFirst);
                },
                textColor: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:tpos_mobile/app_core/ui_base/view_base.dart';
import 'package:tpos_mobile/feature_group/pos_order/viewmodels/dialog_update_info_viewmodel.dart';
import 'package:tpos_mobile/locator.dart';

class DialogUpdateInfoPage extends StatefulWidget {
  @override
  _DialogUpdateInfoPageState createState() => _DialogUpdateInfoPageState();
}

class _DialogUpdateInfoPageState extends State<DialogUpdateInfoPage> {
  final DialogUpdateInfoViewModel _vm = locator<DialogUpdateInfoViewModel>();

  @override
  Widget build(BuildContext context) {
    return ViewBase<DialogUpdateInfoViewModel>(
        model: _vm,
        builder: (context, model, _) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                    "Bạn có muốn cập nhật lại dữ liệu? (Danh sách sản phẩm, khách hàng và cấu hình phiên bán sẽ được cập nhật lại.)"),
              ),
              const SizedBox(
                height: 28,
              ),
              Row(
                children: <Widget>[
                  const SizedBox(
                    width: 10,
                  ),
                  Checkbox(
                    value: _vm.isNoQuestion,
                    onChanged: (value) async {
                      _vm.isNoQuestion = value;
                    },
                  ),
                  InkWell(
                    onTap: () {
                      _vm.isNoQuestion = !_vm.isNoQuestion;
                    },
                    child: const Text(
                      "Không hỏi lại lần sau",
                      style: TextStyle(fontSize: 14),
                    ),
                  )
                ],
              )
            ],
          );
        });
  }
}

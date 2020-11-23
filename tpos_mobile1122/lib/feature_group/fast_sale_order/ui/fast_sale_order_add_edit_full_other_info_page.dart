import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base.dart';
import 'package:tpos_mobile/feature_group/fast_sale_order/viewmodels/fast_sale_order_add_edit_full_viewmodel.dart';

class FastSaleOrderAddEditFullOtherInfoPage extends StatefulWidget {
  const FastSaleOrderAddEditFullOtherInfoPage({this.editVm});
  final FastSaleOrderAddEditFullViewModel editVm;

  @override
  _FastSaleOrderAddEditFullOtherInfoPageState createState() =>
      _FastSaleOrderAddEditFullOtherInfoPageState();
}

class _FastSaleOrderAddEditFullOtherInfoPageState
    extends State<FastSaleOrderAddEditFullOtherInfoPage> {
  final _vm = FastSaleOrderAddEditFullOtherInfoViewModel();
  final _noteTextController = TextEditingController();

  @override
  void initState() {
    _vm.init(editVm: widget.editVm);
    _noteTextController.text = widget.editVm.note;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<FastSaleOrderAddEditFullOtherInfoViewModel>(
      model: _vm,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Thông tin khác"),
        ),
        body: _buildBody(),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.only(left: 12, right: 12, bottom: 12),
          child: RaisedButton.icon(
            icon: Icon(Icons.keyboard_return),
            label: const Text("QUAY LẠI ĐƠN HÀNG"),
            onPressed: () {
              Navigator.pop(context);
            },
            color: Theme.of(context).primaryColor,
            textColor: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return ScopedModelDescendant<FastSaleOrderAddEditFullOtherInfoViewModel>(
      builder: (context, child, model) {
        return GestureDetector(
          onTap: () {
            FocusScope.of(context)?.requestFocus(FocusNode());
          },
          child: Container(
            color: Colors.grey.shade300,
            child: ListView(
              children: <Widget>[
                // Người bán
                Container(
                  color: Colors.white,
                  child: ListTile(
                    leading: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(
                          Icons.people,
                          color: Theme.of(context).iconTheme.color,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Text(
                          "Người bán",
                        )
                      ],
                    ),
                    title: ScopedModelDescendant<
                        FastSaleOrderAddEditFullOtherInfoViewModel>(
                      builder: (ctx, child, model) {
                        return Text(
                          widget.editVm.user?.name ?? "Chọn người bán",
                          textAlign: TextAlign.right,
                          style: Theme.of(context).textTheme.subtitle,
                        );
                      },
                    ),
                    trailing: Icon(Icons.chevron_right),
                    onTap: () async {},
                  ),
                ),

                // Ngày hóa đơn

                const SizedBox(
                  height: 1,
                ),
                Container(
                  color: Colors.white,
                  child: ListTile(
                    contentPadding: const EdgeInsets.only(
                      right: 0,
                      left: 16,
                    ),
                    leading: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(
                          Icons.date_range,
                          color: Theme.of(context).iconTheme.color,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Text(
                          "Ngày hóa đơn:",
                        )
                      ],
                    ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          DateFormat("dd/MM/yyyy HH:mm")
                              .format(model.invoiceDate.toLocal()),
                          style: const TextStyle(fontSize: 15),
                        ),
                        IconButton(
                          onPressed: () async {
                            final selectedDate = await showDatePicker(
                              context: context,
                              initialDate: widget.editVm.order.dateInvoice,
                              firstDate: DateTime.now()
                                  .add(const Duration(days: -365)),
                              lastDate: DateTime.now().add(
                                const Duration(days: 1),
                              ),
                            );

                            if (selectedDate != null) {
                              _vm.setInvoiceDate(selectedDate, false);
                            }
                          },
                          icon: Icon(Icons.date_range),
                        ),
                        IconButton(
                          onPressed: () async {
                            final selectedTime = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay(
                                    hour: DateTime.now().hour,
                                    minute: DateTime.now().minute));

                            if (selectedTime != null) {
                              model.setInvoiceTime(selectedTime);
                            }
                          },
                          icon: Icon(Icons.access_time),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(
                  height: 1,
                ),

                Container(
                  padding: const EdgeInsets.only(
                      left: 17, right: 8, top: 5, bottom: 10),
                  color: Colors.white,
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Icon(Icons.note),
                          const SizedBox(
                            width: 10,
                          ),
                          const Text("Ghi chú đơn hàng"),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextField(
                        controller: _noteTextController,
                        maxLines: null,
                        onChanged: (text) {
                          widget.editVm.note = text;
                        },
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              gapPadding: 10,
                              borderSide: BorderSide(
                                  width: 1,
                                  color: Colors.grey,
                                  style: BorderStyle.solid),
                            ),
                            hintText: "Để lại ghi chú"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class FastSaleOrderAddEditFullOtherInfoViewModel extends ViewModel {
  FastSaleOrderAddEditFullOtherInfoViewModel(
      {FastSaleOrderAddEditFullViewModel editVm}) {
    _editVm = editVm;
  }
  FastSaleOrderAddEditFullViewModel _editVm;

  void init({FastSaleOrderAddEditFullViewModel editVm}) {
    _editVm = editVm;
  }

  DateTime get invoiceDate => _editVm.order.dateInvoice;

  void setInvoiceDate(DateTime value, bool isHour) {
    final temp = _editVm.order.dateInvoice;

    _editVm.order.dateInvoice = DateTime(
        value.year,
        value.month,
        value.day,
        temp.hour,
        temp.minute,
        temp.second,
        temp.millisecond,
        temp.microsecond);

    notifyListeners();
  }

  void setInvoiceTime(TimeOfDay value) {
    final temp = _editVm.order.dateInvoice;
    _editVm.order.dateInvoice =
        DateTime(temp.year, temp.month, temp.day, value.hour, value.minute);
    notifyListeners();
  }
}
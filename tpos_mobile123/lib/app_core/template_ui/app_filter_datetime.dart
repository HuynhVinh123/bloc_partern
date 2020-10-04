import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tpos_mobile/app_core/helper/app_filter_helper.dart';
import 'package:tpos_mobile/app_core/template_models/app_filter_date_model.dart';

import 'app_filter_expansion_tile.dart';

/// Widget dùng cho AppFilterDrawer bên phải chọn từ ngày- đến ngày
/// Có nút chọn nhanh khoảng thời gian cần lọc
class AppFilterDateTime extends StatefulWidget {
  final Key key;
  final DateTime fromDate;
  final DateTime toDate;
  final AppFilterDateModel initDateRange;
  final ValueChanged<bool> onSelectChange;
  final ValueChanged<DateTime> onFromDateChanged;
  final ValueChanged<DateTime> onToDateChanged;
  final ValueChanged<AppFilterDateModel> dateRangeChanged;
  final isSelected;
  final List<AppFilterDateModel> dateRange;
  AppFilterDateTime(
      {this.key,
      this.fromDate,
      this.toDate,
      this.onSelectChange,
      this.onFromDateChanged,
      this.onToDateChanged,
      this.dateRange,
      this.initDateRange,
      this.dateRangeChanged,
      this.isSelected = false})
      : super(key: key);

  @override
  _AppFilterDateTimeState createState() => _AppFilterDateTimeState();
}

class _AppFilterDateTimeState extends State<AppFilterDateTime> {
  bool isEnableCustomDate = false;
  AppFilterDateModel _selectedDateFilter;
  @override
  void initState() {
    _selectedDateFilter = widget.initDateRange;
    isEnableCustomDate = widget.initDateRange?.name == "Tùy chỉnh";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var dateRanges = widget.dateRange ?? getFilterDateTemplateSimple();
    return Container(
      child: AppFilterExpansionTile(
        initiallyExpanded: widget.isSelected,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: widget.isSelected
              ? Icon(Icons.check_box)
              : Icon(Icons.check_box_outline_blank),
        ),
        title: Text(
          "Theo thời gian",
        ),
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 8, right: 8),
            width: double.infinity,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: PopupMenuButton(
                      child: Row(children: <Widget>[
                        Expanded(
                          child: Text(
                            "${_selectedDateFilter?.name ?? "Chọn khoảng thời gian"}",
                            style: const TextStyle(color: Colors.green),
                          ),
                        ),
                        Icon(Icons.arrow_drop_down),
                      ]),
                      itemBuilder: (context) => (dateRanges)
                          .map(
                            (f) => PopupMenuItem<AppFilterDateModel>(
                              child: Text("${f.name}"),
                              value: f,
                            ),
                          )
                          .toList(),
                      onSelected: (AppFilterDateModel value) {
                        setState(() {
                          _selectedDateFilter = value;
                          widget.onFromDateChanged(value.fromDate);
                          widget.onToDateChanged(value.toDate);
                          widget.dateRangeChanged(value);

                          if (value.name == "Tùy chỉnh") {
                            isEnableCustomDate = true;
                          } else {
                            isEnableCustomDate = false;
                          }
                        });
                      }),
                ),
                Material(
                  color: Colors.grey.shade200,
                  child: InkWell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Thêm"),
                    ),
                  ),
                ),
              ],
            ),
          ),
          ConstrainedBox(
            constraints: BoxConstraints(minWidth: 150),
            child: Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: Row(
                children: <Widget>[
                  Text("Từ ngày "),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlineButton(
                      child: Text(
                        "${widget.fromDate != null ? DateFormat("dd/MM/yyyy").format(widget.fromDate) : ""}",
                      ),
                      onPressed: isEnableCustomDate
                          ? () async {
                              var selectedDate = await showDatePicker(
                                context: context,
                                initialDate: widget.fromDate ?? DateTime.now(),
                                firstDate:
                                    DateTime.now().add(Duration(days: -2000)),
                                lastDate: DateTime.now().add(
                                  Duration(days: 100),
                                ),
                              );

                              if (selectedDate != null) {
                                var newFromDate = new DateTime(
                                    selectedDate.year,
                                    selectedDate.month,
                                    selectedDate.day,
                                    widget.fromDate.hour,
                                    widget.fromDate.minute,
                                    widget.fromDate.second,
                                    widget.fromDate.millisecond,
                                    widget.fromDate.microsecond);

                                widget.onFromDateChanged(newFromDate);
                              }
                            }
                          : null,
                    ),
                  ),
                  OutlineButton(
                    child: Text(
                      "${DateFormat("HH:mm").format(widget.fromDate)}",
                    ),
                    onPressed: !isEnableCustomDate
                        ? null
                        : () async {
                            var selectedTime = await showTimePicker(
                              context: context,
                              initialTime:
                                  TimeOfDay.fromDateTime(widget.fromDate),
                            );

                            if (selectedTime != null) {
                              var oldDatetime = widget.fromDate;
                              var newFromDate = new DateTime(
                                oldDatetime.year,
                                oldDatetime.month,
                                oldDatetime.day,
                                selectedTime.hour,
                                selectedTime.minute,
                                0,
                              );

                              widget.onFromDateChanged(newFromDate);
                            }
                          },
                  ),
                ],
              ),
            ),
          ),
          ConstrainedBox(
            constraints: BoxConstraints(minWidth: 150),
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8),
              child: Row(
                children: <Widget>[
                  Text("Tới ngày"),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlineButton(
                      child: Text(
                        "${widget.toDate != null ? DateFormat("dd/MM/yyyy").format(widget.toDate) : ""}",
                      ),
                      onPressed: isEnableCustomDate
                          ? () async {
                              var selectedDate = await showDatePicker(
                                context: context,
                                initialDate: widget.toDate ?? DateTime.now(),
                                firstDate:
                                    DateTime.now().add(Duration(days: -2000)),
                                lastDate: DateTime.now().add(
                                  Duration(days: 100),
                                ),
                              );

                              if (selectedDate != null) {
                                setState(() {
                                  var newToDate = new DateTime(
                                      selectedDate.year,
                                      selectedDate.month,
                                      selectedDate.day,
                                      widget.toDate.hour,
                                      widget.toDate.minute,
                                      widget.toDate.second,
                                      widget.toDate.millisecond,
                                      widget.toDate.microsecond);
                                  widget.onToDateChanged(newToDate);
                                });
                              }
                            }
                          : null,
                    ),
                  ),
                  OutlineButton(
                    child: Text("${DateFormat("HH:mm").format(widget.toDate)}"),
                    onPressed: !isEnableCustomDate
                        ? null
                        : () async {
                            var selectedTime = await showTimePicker(
                              context: context,
                              initialTime:
                                  TimeOfDay.fromDateTime(widget.toDate),
                            );

                            if (selectedTime != null) {
                              var oldDatetime = widget.toDate;
                              var newFromDate = new DateTime(
                                oldDatetime.year,
                                oldDatetime.month,
                                oldDatetime.day,
                                selectedTime.hour,
                                selectedTime.minute,
                                0,
                              );

                              widget.onToDateChanged(newFromDate);
                            }
                          },
                  ),
                ],
              ),
            ),
          ),
        ],
        onExpansionChanged: (value) {
          if (widget.onSelectChange != null) this.widget.onSelectChange(value);
        },
      ),
    );
  }
}

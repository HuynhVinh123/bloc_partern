import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tpos_mobile/app_core/helper/app_filter_helper.dart';
import 'package:tpos_mobile/app_core/template_models/app_filter_date_model.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'app_filter_expansion_tile.dart';

/// Widget dùng cho AppFilterDrawer bên phải chọn từ ngày- đến ngày
/// Có nút chọn nhanh khoảng thời gian cần lọc
class AppFilterDateTime extends StatefulWidget {
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
          padding: const EdgeInsets.only(left: 10),
          child: widget.isSelected
              ? const Icon(Icons.check_box)
              : const Icon(Icons.check_box_outline_blank),
        ),
        title: Text(S.current.filter_filterByDatetime),
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(left: 8, right: 8),
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
                        const Icon(Icons.arrow_drop_down),
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

                          if (value.name == S.current.custom) {
                            isEnableCustomDate = true;
                          } else {
                            isEnableCustomDate = false;
                          }
                        });
                      }),
                ),
                // Material(
                //   color: Colors.grey.shade200,
                //   child: const InkWell(
                //     child: Padding(
                //       padding: const EdgeInsets.all(8.0),
                //       child: Text("Thêm"),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 150),
            child: Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: Row(
                children: <Widget>[
                  Expanded(
                      flex: 1,
                      child: AutoSizeText(
                        "${S.current.fromDate} ",
                        minFontSize: 11,
                        maxLines: 1,
                        maxFontSize: 15,
                      )),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 3,
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
                                final newFromDate = DateTime(
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
                              final oldDatetime = widget.fromDate;
                              var newFromDate = DateTime(
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
            constraints: const BoxConstraints(minWidth: 150),
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8),
              child: Row(
                children: <Widget>[
                  // ignore: unnecessary_string_interpolations
                  Expanded(
                      flex: 1,
                      child: AutoSizeText(
                        "${S.current.toDate}",
                        minFontSize: 11,
                        maxLines: 1,
                        maxFontSize: 15,
                      )),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 3,
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
                                  var newToDate = DateTime(
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
                              final oldDatetime = widget.toDate;
                              final newFromDate = DateTime(
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
          if (widget.onSelectChange != null) {
            widget.onSelectChange(value);
          }
        },
      ),
    );
  }
}

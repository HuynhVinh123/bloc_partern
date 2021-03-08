import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tmt_flutter_untils/tmt_flutter_extensions.dart';
import 'package:tpos_mobile/app_core/helper/app_filter_helper.dart';
import 'package:tpos_mobile/app_core/template_models/app_filter_date_model.dart';
import 'package:tpos_mobile/extensions.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

import 'app_filter_expansion_tile.dart';

/// Widget dùng cho AppFilterDrawer bên phải chọn từ ngày- đến ngày
/// Có nút chọn nhanh khoảng thời gian cần lọc
class AppFilterDateTime extends StatefulWidget {
  const AppFilterDateTime(
      {Key key,
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
  final DateTime fromDate;
  final DateTime toDate;
  final AppFilterDateModel initDateRange;
  final ValueChanged<bool> onSelectChange;
  final ValueChanged<DateTime> onFromDateChanged;
  final ValueChanged<DateTime> onToDateChanged;
  final ValueChanged<AppFilterDateModel> dateRangeChanged;
  final bool isSelected;
  final List<AppFilterDateModel> dateRange;

  @override
  _AppFilterDateTimeState createState() => _AppFilterDateTimeState();
}

class _AppFilterDateTimeState extends State<AppFilterDateTime> {
  bool isEnableCustomDate = false;
  AppFilterDateModel _selectedDateFilter;
  DateTime _toDate;
  DateTime _fromDate;
  @override
  void initState() {
    _toDate = widget.toDate;
    _fromDate = widget.fromDate;
    _selectedDateFilter = widget.initDateRange;
    isEnableCustomDate = widget.initDateRange?.name == "Tùy chỉnh" ||
        widget.initDateRange?.name == "Option";
    super.initState();
  }

  bool validate(BuildContext context, DateTime fromDate, DateTime toDate) {
    if (fromDate.isAfter(toDate)) {
      context.showDefaultDialog(
        title: S.current.invalidData,
        content: S.current.invalidDateRangeMessage,
      );
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    final dateRanges = widget.dateRange ?? getFilterDateTemplateSimple();
    return Container(
      child: AppFilterExpansionTile(
        initiallyExpanded: widget.isSelected,
        leading: widget.isSelected
            ? const Icon(Icons.check_box)
            : const Icon(Icons.check_box_outline_blank),
        title: Text(S.current.filter_filterByDatetime),
        children: <Widget>[
          Container(
            width: double.infinity,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: PopupMenuButton(
                      child: Row(children: <Widget>[
                        Expanded(
                          child: Text(
                            _selectedDateFilter?.name ??
                                "Chọn khoảng thời gian",
                            style: const TextStyle(color: Colors.green),
                          ),
                        ),
                        const Icon(Icons.arrow_drop_down),
                      ]),
                      itemBuilder: (context) => dateRanges
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
              ],
            ),
          ),
          // Từ ngày
          Row(
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Text(
                  "${S.current.fromDate} ",
                  maxLines: 1,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 7,
                child: OutlineButton(
                  child: Text(
                    widget.fromDate != null
                        ? DateFormat("dd/MM/yyyy").format(widget.fromDate)
                        : "",
                  ),
                  onPressed: isEnableCustomDate
                      ? () async {
                          final selectedDate = await showDatePicker(
                            context: context,
                            initialDate: widget.fromDate ?? DateTime.now(),
                            firstDate:
                                DateTime.now().add(const Duration(days: -2000)),
                            lastDate: DateTime.now().add(
                              const Duration(days: 100),
                            ),
                          );

                          if (selectedDate != null) {
                            _fromDate = _fromDate.changeDate(selectedDate);

                            if (validate(context, _fromDate, _toDate)) {
                              widget.onFromDateChanged(_fromDate);
                            } else {
                              setState(() {
                                _fromDate = widget.fromDate;
                              });
                            }
                          }
                        }
                      : null,
                ),
              ),
              OutlineButton(
                  padding: const EdgeInsets.all(0),
                  child: Text(
                    // ignore: unnecessary_string_interpolations
                    "${DateFormat("HH:mm").format(widget.fromDate)}",
                  ),
                  onPressed: !isEnableCustomDate
                      ? null
                      : () async {
                          final selectedTime = await showTimePicker(
                            context: context,
                            initialTime:
                                TimeOfDay.fromDateTime(widget.fromDate),
                          );

                          _fromDate = _fromDate.changeTime(selectedTime);

                          if (selectedTime != null) {
                            _fromDate = _fromDate.changeTime(selectedTime);

                            if (validate(context, _fromDate, _toDate)) {
                              widget.onFromDateChanged(_fromDate);
                            } else {
                              setState(() {
                                _fromDate = widget.fromDate;
                              });
                            }
                          }
                        }),
            ],
          ),
          // Đến ngày
          Row(
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Text(
                  S.current.toDate,
                  maxLines: 1,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 7,
                child: OutlineButton(
                  child: Text(
                    widget.toDate != null
                        ? DateFormat("dd/MM/yyyy").format(widget.toDate)
                        : "",
                  ),
                  onPressed: isEnableCustomDate
                      ? () async {
                          final selectedDate = await showDatePicker(
                            context: context,
                            initialDate: widget.toDate ?? DateTime.now(),
                            firstDate:
                                DateTime.now().add(const Duration(days: -2000)),
                            lastDate: DateTime.now().add(
                              const Duration(days: 100),
                            ),
                          );

                          if (selectedDate != null) {
                            _toDate = _toDate.changeDate(selectedDate);

                            if (validate(context, _fromDate, _toDate)) {
                              widget.onToDateChanged(_toDate);
                            } else {
                              setState(() {
                                _toDate = widget.toDate;
                              });
                            }
                          }
                        }
                      : null,
                ),
              ),
              OutlineButton(
                padding: const EdgeInsets.all(0),
                child: Text("${DateFormat("HH:mm").format(widget.toDate)}"),
                onPressed: !isEnableCustomDate
                    ? null
                    : () async {
                        final selectedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.fromDateTime(widget.toDate),
                        );

                        if (selectedTime != null) {
                          _toDate = _toDate.changeTime(selectedTime);

                          if (validate(context, _fromDate, _toDate)) {
                            widget.onToDateChanged(_toDate);
                          } else {
                            setState(() {
                              _toDate = widget.toDate;
                            });
                          }
                        }
                      },
              ),
            ],
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

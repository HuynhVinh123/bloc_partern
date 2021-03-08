import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

DateTime convertDateTime(String timeString) {
  if (timeString != null) {
    final String unixTimeStr =
        RegExp(r"(?<=Date\()\d+").stringMatch(timeString);

    if (unixTimeStr != null && unixTimeStr.isNotEmpty) {
      final int unixTime = int.parse(unixTimeStr);
      return DateTime.fromMillisecondsSinceEpoch(unixTime);
    } else {
      if (timeString != null) {
        return DateTime.parse(timeString).toLocal();
      }
    }
  }
  return null;
}

String getDate(DateTime dateTime) =>
    dateTime != null ? DateFormat("dd/MM/yyyy").format(dateTime) : null;

String getTime(DateTime dateTime) => DateFormat("HH:mm").format(dateTime);

double convertDouble(dynamic number) {
  if (number is int) {
    return double.parse(number.toString());
  } else if (number is String) {
    return double.parse(number);
  } else if (number is double) {
    return number;
  }
  return null;
}

int convertInt(dynamic number) {
  if (number is int) {
    return number;
  } else if (number is String) {
    return double.parse(number).toInt();
  } else if (number is double) {
    return number.toInt();
  }
  return null;
}

String getStateVietnamese(String state) {
  switch (state) {
    case "open":
      {
        /// Đã xác nhận
        return S.current.confirm;
      }
    case "paid":
      {
        ///Đã thanh toán
        return S.current.paid;
      }
    case "cancel":
      {
        /// Đã hủy
        return S.current.canceled;
      }
    case "draft":
      {
        /// Nháp
        return S.current.draft;
      }
  }
  return "";
}

Color getStateColor(String state) {
  switch (state) {
    case "open":
      {
        return Colors.blue;
      }
    case "paid":
      {
        return Colors.green;
      }
    case "cancel":
      {
        return Colors.red;
      }
  }
  return Colors.grey;
}

///sort:  DateInvoice,AmountTotal,Number
String getSortVietnamese(String sortField) {
  switch (sortField) {
    case "DateInvoice":
      {
        // Ngày lập
        return S.current.fastPurchase_dateCreated;
      }
    case "AmountTotal":
      {
        // Tổng tiền
        return S.current.fastPurchase_totalAmount;
      }
    case "Number":
      {
        // Mã hóa đơn
        return S.current.invoiceCode;
      }
  }
  return "null";
}

String dateTimeOffset(DateTime text) {
  return text != null
      ? "${DateFormat("yyyy-MM-ddTHH:mm:ss.SSSSSSS'+07:00'").format(text)}"
      : null;
}

/// 14/2/2018
DateTime getDateTime2(String date) {
  final List<String> listTime = date.split("/").toList();
  final int day = int.parse(listTime[0]);
  final int month = int.parse(listTime[1]);
  final int year = int.parse(listTime[2]);
  return DateTime(year, month, day);
}

String convertTime(dynamic date) {
  if (date != null) {
    String time = "";
    DateTime datetime;
    if (date is String) {
      datetime = DateTime.parse(date);
    } else if (date is DateTime) {
      datetime = date;
    }
    final DateTime currentTime = DateTime.now();
    if (datetime.difference(currentTime).inDays.abs() > 30) {
      time =
          "${(datetime.difference(currentTime).inDays.abs() / 30).round()} tháng trước";
    } else if (datetime.difference(currentTime).inDays.abs() > 0) {
      time = "${datetime.difference(currentTime).inDays.abs()} ngày trước";
    } else if (datetime.difference(currentTime).inHours.abs() > 0) {
      time = "${datetime.difference(currentTime).inHours.abs()} giờ trước";
    } else if (datetime.difference(currentTime).inMinutes.abs() > 0) {
      time = "${datetime.difference(currentTime).inMinutes.abs()} phút trước";
    } else if (datetime.difference(currentTime).inSeconds.abs() > 0) {
      time = "${datetime.difference(currentTime).inSeconds.abs()} giây trước";
    } else {
      time = "";
    }
    return time;
  }

  return "";
}

String convertErrorToString(dynamic e) {
  if (e is SocketException) {
    return "Không thể kết nối đến internet";
  } else {
    return "Đã xãy ra lỗi, vui lòng thử lại";
  }
}

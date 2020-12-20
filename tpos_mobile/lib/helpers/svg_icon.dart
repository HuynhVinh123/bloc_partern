import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgIcon extends StatelessWidget {
  const SvgIcon(this.path, {this.size, this.color}) : assert(path != null);

  static const menuCloseOrder = "assets/icon/close-order.svg";

  static const menuOrder = "assets/icon/pre-order-multicolor-blue.svg";
  static const menuTag = "assets/icon/tag-green.svg";

  static const menuSetting = "assets/icon/menu_icon_setting.svg";

  static const revenue = "assets/icon/ic_revenue.svg";
  static const count = "assets/icon/ic_count.svg";
  static const noConnect = "assets/icon/icon_no_connect.svg";
  static const homeNavigation = 'assets/icon/bottom_navigation_icon_home.svg';
  static const reportNavigation =
      'assets/icon/bottom_navigation_icon_report.svg';
  static const notificationNavigation =
      'assets/icon/bottom_navigation_notification.svg';
  static const barcode = "images/barcode_scan.svg";
  static const saveMoney = "assets/icon/ic_save_money.svg";
  static const invoice = "assets/icon/ic_invoice.svg";
  static const card = "assets/icon/card.svg";
  static const money = "assets/icon/money.svg";
  static const state = "assets/icon/ic_state.svg";
  static const stateDraft = "assets/icon/ic_state_draft.svg";
  static const paymentBackGroundMoney = "assets/icon/background_money.svg";
  static const cart = "assets/icon/ic_cart.svg";
  static const tag = "assets/icon/ic_tag.svg";
  static const liveStream = "assets/icon/livestream-multicolor.svg";
  static const emptyCustomer = 'assets/svg/empty-customer.svg';
  static const ring = "assets/icon/ic_ring.svg";
  static const calender = 'assets/icon/calendar_icon.svg';
  static const cardCustomer = 'assets/icon/card_customer.svg';
  static const liveStreamSession = 'assets/svg/livestream-session-blank.svg';
  static const chart = 'assets/images/chart.svg';
  static const commentLiveStream = 'assets/images/Live stream.svg';
  static const warning = "assets/icon/ic_product_warning.svg";
  static const productWarning = "assets/icon/ic_product_warning_green.svg";
  static const camera = 'assets/icon/camera.svg';
  static const message = 'assets/icon/ic_message.svg';
  static const share = 'assets/icon/ic_share.svg';
  static const order = 'assets/icon/ic_order.svg';
  static const deliveryTruck = "images/delivery-truck.svg";
  static const callBack = 'assets/icon/call_black.svg';
  static const fbBlack = 'assets/icon/facebook_black.svg';
  static const printAppbar = 'assets/icon/print_appbar.svg';
  static const bag = "assets/icon/ic_bag.svg";
  static const luckyWheel = "assets/game/icon/lucky_wheel_icon.svg";
  static const close = "assets/icon/close.svg";
  static const refresh = 'assets/icon/refresh.svg';
  static const win = 'assets/icon/win.svg';
  static const person = 'assets/icon/person.svg';
  static const gameShare = 'assets/icon/share.svg';
  static const comment = 'assets/icon/comment.svg';
  static const gameWheelArrow = "assets/icon/game_wheel_arrow.svg";
  static const gameRotateScreen = "assets/icon/rotate_screen.svg";
  static const instruction = 'assets/icon/instruction.svg';
  static const dialogMainPage = "assets/icon/icon_dialog_main_page.svg";
  static const wifiConnection = "assets/icon/wifi_connection.svg";
  static const callPerson = "assets/icon/call_person.svg";
  static const emptyData = "images/empty_data.svg";
  static const iconZalo = "assets/icon/ic_zalo.svg";
  static const deposit = "assets/icon/ic_deposit.svg";

  final String path;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      path,
      color: color,
      width: size,
      height: size,
      alignment: Alignment.center,
    );
  }
}

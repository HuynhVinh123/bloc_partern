import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tpos_mobile/app_core/helper/string_helper.dart';

class ReportDeliveryFastSaleOrderPage extends StatefulWidget {
  @override
  _ReportDeliveryFastSaleOrderPageState createState() => _ReportDeliveryFastSaleOrderPageState();
}

class _ReportDeliveryFastSaleOrderPageState extends State<ReportDeliveryFastSaleOrderPage>  with TickerProviderStateMixin {
  TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEBEDEF),
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Material(
              color: Colors.white,
              child: TabBar(
                  controller: _tabController,
                  indicatorColor: const Color(0xFF28A745),
                  labelColor: const Color(0xFF28A745),
                  unselectedLabelColor: Colors.black54,
                  tabs: const <Widget>[
                    Tab(
                      text: 'Tổng quan',
                    ),
                    Tab(
                      text: 'Khách hàng',
                    ),
                    Tab(
                      text: 'Nhân viên',
                    ),
                  ]),
            ),
            _buildGeneral(),
            _buildListInvoice()
          ],
        ),
      ),
    );
  }

  Widget _buildGeneral() {
    return Stack(
      children: <Widget>[
        Container(
          padding:
          const EdgeInsets.only(left: 12, right: 12, bottom: 12, top: 24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          margin: const EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ItemReportDeliveryGeneral(
                color: const Color(0xFF7AC461),
                icon: SvgPicture.asset(
                  "assets/icon/ic_invoice.svg",
                  alignment: Alignment.center,
                ),
                title: "Tiền thu hộ",
                amount: "53.981.967",
                amountPosOrder:0,
                amountFastSaleOrder:0,
                isOverView: false,
                textColor: const Color(0xFF7AC461),
              ),
              const ItemReportDeliveryGeneralDot(
                color: Color(0xff28A745),
                title: "Đã thanh toán",
                amount: "0",
              totalInvoice: 1,
              ),
              const ItemReportDeliveryGeneralDot(
                color: Color(0xff2395FF),
                title: "Đang giao",
                amount: "0",
                totalInvoice: 1,
              ),
              const ItemReportDeliveryGeneralDot(
                color: Color(0xffF3A72E),
                title: "Trả hàng",
                amount: "0",
                totalInvoice: 1,
              ),
              const ItemReportDeliveryGeneralDot(
                color: Color(0xffEB3B5B),
                title: "Đối soát không thành công",
                amount: "0",
                totalInvoice: 1,
              ),
              ItemReportDeliveryGeneral(
                color: const Color(0xFF4EAAFF),
                icon: SvgPicture.asset(
                  "assets/icon/ic_invoice.svg",
                  alignment: Alignment.center,
                ),
                title: "Tổng tiền cọc",
                amount: "53.981.967",
                amountPosOrder:0,
                amountFastSaleOrder:0,
                isOverView: false,
                textColor: const Color(0xFF4EAAFF),
              ),
            ],
          ),
        ),
        Positioned(
          top: 2,
          left: 0,
          right: 0,
          child:Center(
              child: InkWell(
                onTap: () {
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                      color: const Color(0xFfEBEDEF),
                      borderRadius: BorderRadius.circular(12)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const<Widget>[
                      Icon(Icons.date_range,
                          size: 17, color: Color(0xFF6B7280)),
                      SizedBox(
                        width: 6,
                      ),
                      Text(
                         "Thời gian",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Color(0xFF6B7280)),
                      ),
                      Icon(Icons.arrow_drop_down,
                          color: Color(0xFF6B7280))
                    ],
                  ),
                ),
              ))
        )
      ],
    );
  }

  Widget _buildListInvoice() {
    return InkWell(
      onTap: () {},
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12),
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(8)),
        child: Row(
          children: <Widget>[
            const Expanded(
                child: Text(
                  "Danh sách hóa đơn giao hàng",
                  style: TextStyle(color: Color(0xFF2C333A), fontSize: 16),
                )),
            Container(
              margin: const EdgeInsets.only(right: 6),
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: const Color(0xFF28A745)),
              child: Center(
                child: Text(
                   "0",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Color(0xFF929DAA),
            ),
          ],
        ),
      ),
    );
  }


}

class ItemReportDeliveryGeneral extends StatelessWidget {
  const ItemReportDeliveryGeneral(
      {this.color,
        this.icon,
        this.title,
        this.amount,
        this.isOverView = true,
        this.amountPosOrder,
        this.amountFastSaleOrder,
        this.textColor});

  final Color color;
  final Color textColor;
  final Widget icon;
  final String title;
  final String amount;
  final bool isOverView;
  final double amountPosOrder;
  final double amountFastSaleOrder;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(right: 10,top: 8),
          width: 48,
          height: 48,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12), color: color),
          child: Center(
            child: icon,
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(
                height: 10,
              ),
              Container(
                  child: Text(
                    title,
                    style: const TextStyle(color: Color(0xFF6B7280)),
                  )),
              const SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      amount,
                      style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: textColor),
                    ),
                  ),const Text("10 hóa đơn",style: TextStyle(color: Color(0xFF929DAA)),)
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              const Divider(
                color: Color(0xFFE9EDF2),
                height: 4,
              ),

            ],
          ),
        ),
      ],
    );
  }
}

class ItemReportDeliveryGeneralDot extends StatelessWidget {
  const ItemReportDeliveryGeneralDot(
      {this.color,
        this.title,
        this.amount,this.totalInvoice});

  final Color color;
  final String title;
  final String amount;
  final int totalInvoice;

  @override
  Widget build(BuildContext context) {
    return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  const SizedBox(width: 44),
                  Container(
                    margin: const EdgeInsets.only(right: 8),
                    decoration:  BoxDecoration(
                        shape: BoxShape.circle,
                        color: color
                    ),
                    width: 8,
                    height: 8,),
                  Container(
                      child: Text(
                        title,
                        style: const TextStyle(color: Color(0xFF6B7280)),
                      )),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  const SizedBox(width: 60),
                  Expanded(
                    child: Text(
                      amount,
                      style: const TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2C333A)),
                    ),
                  ),const Text("10 hóa đơn",style: TextStyle(color: Color(0xFF929DAA)),)
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 60),
                child: const Divider(
                  color: Color(0xFFE9EDF2),
                  height: 4,
                ),
              ),

            ],
          )
;
  }
}
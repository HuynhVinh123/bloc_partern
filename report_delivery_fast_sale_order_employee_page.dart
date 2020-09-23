import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tpos_mobile/app_core/helper/string_helper.dart';

class ReportDeliveryFastSaleOrderEmployeePage extends StatefulWidget {
  @override
  _ReportDeliveryFastSaleOrderEmployeePageState createState() =>
      _ReportDeliveryFastSaleOrderEmployeePageState();
}

class _ReportDeliveryFastSaleOrderEmployeePageState
    extends State<ReportDeliveryFastSaleOrderEmployeePage> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Column(
          children: <Widget>[
            _buildFilter(),
            Expanded(child: _buildBody()),
          ],
        ),
      ],
    );
  }

  Widget _buildBody() {
    return ListView.builder(
        padding: const EdgeInsets.only(top: 6),
        itemCount: 2,
        itemBuilder: (context, index) => _buildItem());
  }

  Widget _buildItem() {
    return InkWell(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4),
        margin: const EdgeInsets.only(right: 12, left: 12, bottom: 10),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(6)),
        child: ListTile(
          title: Row(
            children: <Widget>[
              const Expanded(
                child: Text(
                  "[KH12345] Nguyen Binh",
                  style: const TextStyle(
                      color: Color(0xFF28A745),
                      fontSize: 16,
                      fontWeight: FontWeight.w700),
                ),
              ),
              Text(
                vietnameseCurrencyFormat(1325000),
                style: const TextStyle(color: Color(0xFFF25D27)),
              )
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(
                height: 8,
              ),
              Row(
                children: <Widget>[
                  SvgPicture.asset(
                    "assets/icon/ic_revenue.svg",
                    alignment: Alignment.center,
                  ),
                  const SizedBox(
                    width: 6,
                  ),
                  const Flexible(
                    child: Text(
                      "2",
                      style: TextStyle(color: Color(0xFF2C333A)),
                    ),
                  ),
                  const Text("  |  "),
                  SvgPicture.asset(
                    "assets/icon/ic_count.svg",
                    alignment: Alignment.center,
                  ),
                  const SizedBox(
                    width: 6,
                  ),
                  const Flexible(
                    child: Text(
                      "14.000",
                      style: TextStyle(color: Color(0xFF2C333A)),
                    ),
                  ),
                  const Text("  |  "),
                  Icon(
                    FontAwesomeIcons.truck,
                    color: const Color(0xFF929daa),
                    size: 13,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Flexible(
                    child: Text(vietnameseCurrencyFormat(24000),
                        style: const TextStyle(color: Color(0xFF2C333A))),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilter() {
    return InkWell(
      onTap: () {
//        scaffoldKey.currentState.openEndDrawer();
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12),
        height: 40,
        child: Row(
          children: <Widget>[
            Icon(Icons.date_range, size: 18, color: const Color(0xFF6B7280)),
            const SizedBox(
              width: 6,
            ),
            const Text(
              "Thời gian",
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFF6B7280)),
            ),
            const SizedBox(
              width: 6,
            ),
            Icon(Icons.arrow_drop_down, color: const Color(0xFF6B7280))
          ],
        ),
      ),
    );
  }
}

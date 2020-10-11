import 'package:flutter/material.dart';
import 'package:tpos_mobile/feature_group/pos_order/models/partners.dart';
import 'package:tpos_mobile/feature_group/pos_order/ui/pos_partner_add_edit_page.dart';

import 'package:tpos_mobile/widgets/info_row.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

class PosPartnerInfoPage extends StatefulWidget {
  const PosPartnerInfoPage(this.partner);
  final Partners partner;

  @override
  _PosPartnerInfoPageState createState() => _PosPartnerInfoPageState();
}

class _PosPartnerInfoPageState extends State<PosPartnerInfoPage> {
  TextStyle detailFontStyle;
  TextStyle titleFontStyle;

  @override
  Widget build(BuildContext context) {
    titleFontStyle = const TextStyle(color: Colors.green);
    detailFontStyle = const TextStyle(color: Colors.green);
    return Scaffold(
      appBar: AppBar(
        title: Text(S.current.posOfSale_partnerInfo),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        PosPartnerAddEditPage(widget.partner)),
              );
            },
          )
        ],
      ),
      body: _buildPartnerInfo(),
    );
  }

  Widget _buildPartnerInfo() {
    const dividerMin = Divider(
      height: 2,
    );
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(
            height: 6,
          ),
          Text(
            widget.partner?.name ?? "",
            style: detailFontStyle.copyWith(
                fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(
            height: 15.0,
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey[400],
                        offset: const Offset(0, 3),
                        blurRadius: 3)
                  ]),
              child: ListView(
                padding: const EdgeInsets.all(10.0),
                children: <Widget>[
                  /// Mã vạch
                  InfoRow(
                    contentTextStyle: titleFontStyle,
                    titleString: "${S.current.posOfSale_barCode}: ",
                    content: Text(widget.partner?.barcode ?? "N/A",
                        textAlign: TextAlign.right, style: detailFontStyle),
                  ),
                  dividerMin,
                  InfoRow(
                    contentTextStyle: titleFontStyle,

                    /// Mã số thuế
                    titleString: "${S.current.posOfSale_taxCode}:",
                    content: Text(widget.partner?.taxCode ?? "",
                        textAlign: TextAlign.right, style: detailFontStyle),
                  ),
                  dividerMin,

                  /// SĐT
                  InfoRow(
                    contentTextStyle: titleFontStyle,
                    titleString: "${S.current.phone}:",
                    content: Text(widget.partner?.phone ?? "",
                        textAlign: TextAlign.right, style: detailFontStyle),
                  ),
                  dividerMin,
                  InfoRow(
                    contentTextStyle: titleFontStyle,
                    titleString: "Email:",
                    content: Text(widget.partner?.email ?? "",
                        textAlign: TextAlign.right, style: detailFontStyle),
                  ),
                  dividerMin,
                  InfoRow(
                    contentTextStyle: titleFontStyle,
                    titleString: "${S.current.posOfSale_address}:",
                    content: Text(widget.partner?.street ?? "",
                        textAlign: TextAlign.right, style: detailFontStyle),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

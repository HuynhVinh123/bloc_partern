import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/helper/string_helper.dart';
import 'package:tpos_mobile/feature_group/conversation/bloc/conversation_product_template_bloc.dart';
import 'package:tpos_mobile/feature_group/conversation/page/product_template_uomline_page.dart';

class ConversationProductEditPage extends StatefulWidget {
  const ConversationProductEditPage({this.partnerId, this.crmTeam});
  final int partnerId;
  final CRMTeam crmTeam;
  @override
  _ConversationProductEditPageState createState() =>
      _ConversationProductEditPageState();
}

class _ConversationProductEditPageState
    extends State<ConversationProductEditPage> {
  ConversationProductTemplateUomBloc conversationProductTemplateUomBloc =
      ConversationProductTemplateUomBloc();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    conversationProductTemplateUomBloc.add(ConversationSaleOnlineOrderLoaded(
        partnerId: widget.partnerId, id: widget.crmTeam.id.toString()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF008E30),
        // ignore: unnecessary_string_interpolations
        title: const Text(
          'Sản phẩm',
          style: TextStyle(fontSize: 21),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProductTemplateUomlinePage()));
            },
            icon: const Icon(
              Icons.add,
              size: 34,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: BlocProvider.value(
        value: conversationProductTemplateUomBloc,
        child: BlocBuilder<ConversationProductTemplateUomBloc,
            ConversationProductTemplateUomState>(
          builder: (context, state) {
            if (state is ConversationSaleOnlineOrderLoad) {
              return ListView.builder(
                  itemCount: state?.saleOnlineOrder?.details?.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(
                          left: 10, right: 10, top: 5, bottom: 5),
                      child: _buildItemList(
                          state?.saleOnlineOrder?.details[index]),
                    );
                  });
            }
            return Container();
          },
        ),
      ),
    );
  }

  Widget _buildItemList(SaleOnlineOrderDetail product) {
    return Container(
      decoration: const BoxDecoration(
          border: Border(
              bottom: BorderSide(
                  width: 1.0, color: Color.fromARGB(255, 242, 244, 247)))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 0, bottom: 10, left: 16),
            child: Container(
              width: 70,
              height: 70,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              child: Positioned(
                top: 13,
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      color: const Color(0xffF8F9FB),
                      border: Border.all(
                        color: const Color(0xffF8F9FB),
                      )),
                  child: SvgPicture.asset('assets/icon/empty-image-product.svg',
                      width: 50, height: 50, fit: BoxFit.cover),
                ),
              ),
            ),
          ),
          // const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 13),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                product.productName ?? '',
                                textAlign: TextAlign.left,
                                style: const TextStyle(
                                    color: Color(0xFF2C333A),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                        Builder(
                          builder: (BuildContext context) {
                            return Row(
                              children: [
                                Expanded(
                                  child: RichText(
                                    text: TextSpan(
                                      style: DefaultTextStyle.of(context).style,
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: product.uomName ?? '',
                                          style: const TextStyle(
                                              color: Color.fromARGB(
                                                  255, 146, 157, 170),
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        const TextSpan(
                                          text: ' - ',
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 146, 157, 170),
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        TextSpan(
                                          text: vietnameseCurrencyFormat(
                                              product.price),
                                          style: const TextStyle(
                                              color: Color.fromARGB(
                                                  255, 146, 157, 170),
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
              ),
            ),
          ),

          const SizedBox(width: 16),
        ],
      ),
    );
  }
}

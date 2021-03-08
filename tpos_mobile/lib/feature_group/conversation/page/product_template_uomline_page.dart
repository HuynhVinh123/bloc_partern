import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/feature_group/conversation/bloc/conversation_product_template_bloc.dart';
import 'package:tpos_mobile/widgets/loading_indicator.dart';
import 'package:tpos_mobile_localization/generated/l10n.dart';

class ProductTemplateUomlinePage extends StatefulWidget {
  @override
  _ProductTemplateUomlinePageState createState() =>
      _ProductTemplateUomlinePageState();
}

class _ProductTemplateUomlinePageState
    extends State<ProductTemplateUomlinePage> {
  ConversationProductTemplateUomBloc conversationProductTemplateUomBloc =
      ConversationProductTemplateUomBloc();
  final RefreshController _refreshSaleOrderController =
      RefreshController(initialRefresh: false);
  final TextEditingController _keywordController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  int skip = 0;
  bool isSelected = false;
  List<Product> productOrders = <Product>[];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    conversationProductTemplateUomBloc.add(ConversationProductTemplateUomLoaded(
        getListQuery: OdataGetListQuery(
      top: 20,
      version: -1,
      orderBy: 'Name asc',
      skip: 0,
      count: true,
    )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: BackButton(
            color: const Color(0xFFA7B2BF),
            onPressed: () {
              Navigator.pop(context);
            }),
        backgroundColor: Colors.white,
        title: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF8F9FB),
            borderRadius: BorderRadius.circular(17),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Icon(Icons.search, color: Color(0xFF5A6271)),
                Expanded(
                  child: Center(
                    child: Container(
                        height: 35,
                        margin: const EdgeInsets.only(left: 4),
                        child: Center(
                          child: TextField(
                            controller: _keywordController,
                            focusNode: _focusNode,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 14),
                            decoration: const InputDecoration(
                                contentPadding: EdgeInsets.all(0),
                                isDense: true,
                                hintText: 'Tìm kiếm sản phẩm',
                                hintStyle: TextStyle(color: Color(0xFF929DAA)),
                                border: InputBorder.none),
                            onChanged: (value) {},
                          ),
                        )),
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
              ],
            ),
          ),
        ),
        actions: const [
          Icon(
            Icons.add,
            color: Colors.green,
          ),
          SizedBox(
            width: 16,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocProvider.value(
              value: conversationProductTemplateUomBloc,
              child: _buildList(),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
            child: FlatButton(
                height: 48,
                minWidth: double.infinity,
                color: const Color(0xFF28A745),
                onPressed: () {
                  Navigator.pop(context, productOrders);
                },
                child: const Text(
                  'Thêm vào',
                  style: TextStyle(color: Colors.white),
                )),
          ),
        ],
      ),
    );
  }

  Widget _buildList() {
    return BlocConsumer(
        cubit: conversationProductTemplateUomBloc,
        listener: (context, state) {},
        builder: (context, state) {
          if (state is ConversationProductTemplateUomLoading) {
            _refreshSaleOrderController.loadComplete();
            return SmartRefresher(
              controller: _refreshSaleOrderController,
              enablePullDown: false,
              enablePullUp: true,
              header: CustomHeader(
                builder: (BuildContext context, RefreshStatus mode) {
                  Widget body;
                  if (mode == RefreshStatus.idle) {
                    body = const Text(
                      'Kéo xuống để lấy dữ liệu',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black12,
                      ),
                    );
                  } else if (mode == RefreshStatus.canRefresh) {
                    body = const Text(
                      'Thả ra để lấy lại dữ liệu',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black12,
                      ),
                    );
                  }
                  return Container(
                    height: 50,
                    child: Center(child: body),
                  );
                },
              ),
              onLoading: () async {
                skip += 20;
                conversationProductTemplateUomBloc
                    .add(ConversationProductTemplateUomLoadedMore(
                        getListQuery: OdataGetListQuery(
                  top: 20,
                  version: -1,
                  orderBy: 'Name asc',
                  skip: skip,
                  count: true,
                )));
              },
              footer: CustomFooter(
                builder: (BuildContext context, LoadStatus mode) {
                  Widget body;
                  if (mode == LoadStatus.idle) {
                    body = const Text(
                      'Kéo lên để lấy thêm dữ liệu',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black12,
                      ),
                    );
                  } else if (mode == LoadStatus.loading) {
                    body = const LoadingIndicator();
                  } else if (mode == LoadStatus.canLoading) {
                    body = const Text(
                      'Thả ra để lấy lại dữ liệu',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black12,
                      ),
                    );
                  } else {
                    body = const Text(
                      'Không còn dữ liệu',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black12,
                      ),
                    );
                  }
                  return Container(
                    height: 50,
                    child: Center(child: body),
                  );
                },
              ),
              child: ListView.builder(
                  itemCount: state?.products?.value?.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(
                          left: 10, right: 10, top: 5, bottom: 5),
                      child: _buildItemList(
                          state?.products?.value[index], isSelected),
                    );
                  }),
            );
          }
          return Container();
        });
  }

  Widget _buildItemList(Product product, bool isSelected) {
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
              child: Stack(
                children: [
                  Positioned(
                    top: 13,
                    child: product.imageUrl != null && product.imageUrl != ''
                        ? CachedNetworkImage(
                            width: 50,
                            height: 50,
                            imageUrl: product.imageUrl,
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) =>
                                    CircularProgressIndicator(
                                        value: downloadProgress.progress),
                            fit: BoxFit.cover,
                            imageBuilder: (BuildContext context,
                                ImageProvider imageProvider) {
                              return Container(
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),
                                  border: Border.all(
                                    color: Colors.grey.withAlpha(100),
                                  ),
                                  image: DecorationImage(
                                      image: imageProvider, fit: BoxFit.cover),
                                ),
                              );
                            },
                            errorWidget: (context, url, error) => Container(
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),
                                  color: const Color(0xffF8F9FB),
                                  border: Border.all(
                                    color: const Color(0xffF8F9FB),
                                  )),
                              child: SvgPicture.asset(
                                  'assets/icon/empty-image-product.svg',
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover),
                            ),
                          )
                        : Container(
                            decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                color: const Color(0xffF8F9FB),
                                border: Border.all(
                                  color: const Color(0xffF8F9FB),
                                )),
                            child: SvgPicture.asset(
                                'assets/icon/empty-image-product.svg',
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover),
                          ),
                  ),
                  StatefulBuilder(
                    builder: (BuildContext context,
                        void Function(void Function()) setState1) {
                      return Positioned(
                        right: 0,
                        top: 0,
                        child: ClipOval(
                          child: Container(
                            height: 40,
                            width: 40,
                            child: Material(
                              color: Colors.transparent,
                              child: IconButton(
                                iconSize: 25,
                                icon: isSelected
                                    ? Container(
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: isSelected
                                                ? const Color.fromARGB(
                                                    255, 40, 167, 69)
                                                : Colors.white,
                                            border: Border.all(
                                                color: isSelected
                                                    ? Colors.transparent
                                                    : Colors.grey)),
                                        child: const Icon(
                                          Icons.check,
                                          size: 20.0,
                                          color: Colors.white,
                                        ),
                                      )
                                    : Container(
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: isSelected
                                                ? const Color.fromARGB(
                                                    255, 40, 167, 69)
                                                : Colors.white,
                                            border: Border.all(
                                                color: isSelected
                                                    ? Colors.transparent
                                                    : Colors.grey)),
                                      ),
                                onPressed: () {
                                  setState1(() {
                                    isSelected = !isSelected;
                                    if (isSelected) {
                                      productOrders.add(product);
                                    } else {
                                      productOrders.remove(product);
                                    }
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  )
                ],
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
                                product.name ?? '',
                                textAlign: TextAlign.left,
                                style: const TextStyle(
                                    color: Color.fromARGB(255, 44, 51, 58),
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
                                          text: product.uOMName ?? '',
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
                                          text:
                                              S.of(context).realQuantity + ': ',
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

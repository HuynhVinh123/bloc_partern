import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/feature_group/category/product_attribute/bloc/product_attribute_line/product_attribute_line_bloc.dart';
import 'package:tpos_mobile/feature_group/category/product_attribute/bloc/product_attribute_line/product_attribute_line_event.dart';
import 'package:tpos_mobile/feature_group/category/product_attribute/bloc/product_attribute_line/product_attribute_line_state.dart';
import 'package:tpos_mobile/feature_group/category/product_attribute/ui/attribute_value/product_attribute_view_page.dart';
import 'package:tpos_mobile/feature_group/category/product_attribute/ui/product_attribute_add_edit_page.dart';
import 'package:tpos_mobile/feature_group/category/product_attribute/ui/product_attribute_line_action_page.dart';
import 'package:tpos_mobile/widgets/bloc_widget/base_bloc_listener_ui.dart';
import 'package:tpos_mobile/widgets/button/app_button.dart';
import 'package:tpos_mobile/widgets/custom_expand_tile.dart';
import 'package:tpos_mobile/widgets/load_status.dart';
import 'package:tpos_mobile/widgets/search_app_bar.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

///Nếu [productTemplate] khác [null] thì danh sách sẽ hiện các biến thể thuộc sản phẩm này
///không thể thêm mới và sửa
///Nếu [productTemplate] bằng [null] thì danh sách sẽ hiện thị tất cả biến thể, có thể thêm mới và sửa
///Nếu [isSearch] nhấn vào các item sẽ trả về đổi tượng cho màn hình trước
class ProductAttributeLinePage extends StatefulWidget {
  const ProductAttributeLinePage({Key key, this.productTemplate, this.isSearch = false}) : super(key: key);

  @override
  _ProductAttributeLinePageState createState() => _ProductAttributeLinePageState();
  final ProductTemplate productTemplate;
  final bool isSearch;
}

class _ProductAttributeLinePageState extends State<ProductAttributeLinePage> {
  ProductAttributeLineBloc _productAttributeLineBloc;
  String _keyword = '';

  @override
  void initState() {
    super.initState();
    _productAttributeLineBloc = ProductAttributeLineBloc();
    _productAttributeLineBloc.add(ProductAttributeLineStarted(productTemplate: widget.productTemplate));
  }

  @override
  void dispose() {
    _productAttributeLineBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  Widget _buildAppBar() {
    return PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: SearchAppBar(
          title: S.of(context).attributeValue,
          text: _keyword,
          onKeyWordChanged: (String keyword) {
            if (_keyword != keyword) {
              _keyword = keyword;
              _productAttributeLineBloc.add(ProductAttributeLineSearched(keyword: keyword));
            }
          },
          actions: widget.productTemplate == null
              ? [
                  ClipOval(
                    child: Container(
                      height: 50,
                      width: 50,
                      child: Material(
                        color: Colors.transparent,
                        child: IconButton(
                          iconSize: 30,
                          icon: const Icon(
                            Icons.folder_open_rounded,
                            color: Colors.white,
                          ),
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return const ProductAttributeLineActionPage();
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  ClipOval(
                    child: Container(
                      height: 50,
                      width: 50,
                      child: Material(
                        color: Colors.transparent,
                        child: IconButton(
                          iconSize: 30,
                          icon: const Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                          onPressed: () async {
                            final ProductAttribute productAttributeLine = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return const ProductAttributeAddEditPage();
                                },
                              ),
                            );

                            if (productAttributeLine != null) {
                              setState(() {
                                _keyword = '';
                              });
                              _productAttributeLineBloc.add(ProductAttributeLineRefreshed());
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ]
              : null,
        ));
  }

  Widget _buildBody() {
    return BaseBlocListenerUi<ProductAttributeLineBloc, ProductAttributeLineState>(
      bloc: _productAttributeLineBloc,
      loadingState: ProductAttributeLineLoading,
      busyState: ProductAttributeLineBusy,
      errorState: ProductAttributeLineLoadFailure,
      errorBuilder: (BuildContext context, ProductAttributeLineState state) {
        String error = S.of(context).canNotGetDataFromServer;
        if (state is ProductAttributeLineLoadFailure) {
          error = state.error ?? S.of(context).canNotGetDataFromServer;
        }

        return SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 50 * (MediaQuery.of(context).size.height / 700)),
              LoadStatusWidget(
                statusName: S.of(context).loadDataError,
                content: error,
                statusIcon: SvgPicture.asset('assets/icon/error.svg', width: 170, height: 130),
                action: AppButton(
                  onPressed: () {
                    _productAttributeLineBloc.add(ProductAttributeLineStarted(productTemplate: widget.productTemplate));
                  },
                  width: 180,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 40, 167, 69),
                    borderRadius: BorderRadius.all(Radius.circular(24)),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          FontAwesomeIcons.sync,
                          color: Colors.white,
                          size: 23,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          S.of(context).refreshPage,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
      builder: (BuildContext context, ProductAttributeLineState state) {
        return state.productAttributes.isEmpty ? _buildEmptyList() : _buildAttributes(state.productAttributes);
      },
    );
  }

  Widget _buildAttributes(List<ProductAttribute> attributes) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: ListView.separated(
        itemCount: attributes.length,
        itemBuilder: (BuildContext context, int index) {
          return _buildAttributeItem(attributes[index]);
        },
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(height: 0);
        },
      ),
    );
  }

  ///Xây dựng giao diện trống
  Widget _buildEmptyList() {
    return _keyword != ''
        ? SingleChildScrollView(
            child: Column(
            children: [
              SizedBox(height: 50 * (MediaQuery.of(context).size.height / 700)),
              LoadStatusWidget(
                statusName: S.of(context).noData,
                content:S.of(context).searchNotFoundWithKeywordParam(_keyword, S.of(context).attributeValues),
                statusIcon: SvgPicture.asset('assets/icon/no-result.svg', width: 170, height: 130),
              ),
            ],
          ))
        : SingleChildScrollView(
            child: Column(
            children: [
              SizedBox(height: 50 * (MediaQuery.of(context).size.height / 700)),
              LoadStatusWidget.empty(
                statusName: S.of(context).noData,
                content: S.of(context).emptyNotificationParam(S.of(context).attributeValue),
                action: AppButton(
                  onPressed: () async {
                    final ProductAttribute productAttributeLine = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return const ProductAttributeAddEditPage();
                        },
                      ),
                    );

                    if (productAttributeLine != null) {
                      setState(() {
                        _keyword = '';
                      });
                      _productAttributeLineBloc.add(ProductAttributeLineRefreshed());
                    }
                  },
                  width: 250,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 40, 167, 69),
                    borderRadius: BorderRadius.all(Radius.circular(24)),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:  [
                        const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 23,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          S.of(context).addNewParam(S.of(context).attributeValue.toLowerCase()),
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ));
  }

  ///Xây dựng giao diện giá trị thuộc tính
  Widget _buildProductAttributeLine(ProductAttribute attribute) {
    return Column(
      children: <Widget>[
        Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: ListTile(
                onTap: () {
                  if (widget.isSearch) {
                    // Navigator.pop(context, attribute);
                  }
                },
                contentPadding: const EdgeInsets.all(5),
                title: Text(attribute.name ?? '', textAlign: TextAlign.start),
                leading: CircleAvatar(
                  backgroundColor: const Color(0xffE9F6EC),
                  child: Text(
                    attribute != null && attribute.name != '' ? attribute.name.substring(0, 1) : '',
                    style: const TextStyle(color: Color(0xff28A745)),
                  ),
                ),
              ),
            ),
            if (attribute.attributeValues.isNotEmpty)
              Positioned(
                bottom: 10,
                left: 40,
                child: CircleAvatar(
                  maxRadius: 8,
                  backgroundColor: const Color(0xff28A745),
                  child: Text(
                    attribute.attributeValues.length.toString(),
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              )
          ],
        ),
        const Divider(height: 2.0),
      ],
    );
  }

  ///Xây dựng giao diện danh sách thuộc tính
  Widget _buildAttributeValues(ProductAttribute attribute) {
    return Column(
        children: attribute.attributeValues
            .map((ProductAttributeValue productAttributeValue) => Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 40),
                      child: ListTile(
                        onTap: () async {
                          if (widget.isSearch) {
                            Navigator.pop(context, productAttributeValue);
                          } else {
                            final bool change = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return ProductAttributeViewPage(productAttribute: productAttributeValue);
                                },
                              ),
                            );

                            if (change) {
                              _productAttributeLineBloc
                                  .add(ProductAttributeLineStarted(productTemplate: widget.productTemplate));
                            }
                          }
                        },
                        contentPadding: const EdgeInsets.all(5),
                        title: Text(productAttributeValue.nameGet ?? '', textAlign: TextAlign.start),
                        leading: CircleAvatar(
                          backgroundColor: const Color(0xffE9F6EC),
                          child: Text(
                            attribute != null && attribute.name != '' ? attribute.name.substring(0, 1) : '',
                            style: const TextStyle(color: Color(0xff28A745)),
                          ),
                        ),
                      ),
                    ),
                    const Divider(height: 2.0),
                  ],
                ))
            .toList());
  }

  Widget _buildAttributeItem(ProductAttribute productAttributeLine) {
    return productAttributeLine.attributeValues.isEmpty
        ? _buildProductAttributeLine(productAttributeLine)
        : _buildExpanse(
            header: _buildProductAttributeLine(productAttributeLine),
            body: _buildAttributeValues(productAttributeLine),
          );
  }

  ///Xây dựng giao diện mở rộng khi nhấn vào sẽ mở ra
  /// [header] là phần đầu
  /// [body] là phần thân
  /// [expanse] có mở ra lúc khởi tạo hay k và sau đó k thể cập nhật chỉ mở rông được bằng cách nhấn
  Widget _buildExpanse({Widget header, Widget body, bool expanse = false}) {
    return Padding(
      padding: const EdgeInsets.only(top: 0, bottom: 0),
      child: CustomExpandTitle(
        expanseWhenClick: true,
        update: false,
        expanse: expanse,
        iconSpace: 10,
        header: header,
        iconBuilder: (BuildContext context, bool expanse) {
          return RotatedBox(
            quarterTurns: expanse ? 2 : 0,
            child: const Icon(
              Icons.keyboard_arrow_down,
              color: Color.fromARGB(255, 167, 178, 191),
            ),
          );
        },
        body: body,
      ),
    );
  }
}

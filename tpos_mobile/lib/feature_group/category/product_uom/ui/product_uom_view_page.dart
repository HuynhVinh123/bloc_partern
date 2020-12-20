import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app.dart';
import 'package:tpos_mobile/feature_group/category/product_uom/bloc/add_edit/product_uom_add_edit_bloc.dart';
import 'package:tpos_mobile/feature_group/category/product_uom/bloc/add_edit/product_uom_add_edit_event.dart';
import 'package:tpos_mobile/feature_group/category/product_uom/bloc/add_edit/product_uom_add_edit_state.dart';
import 'package:tpos_mobile/feature_group/category/product_uom/ui/product_uom_add_edit_page.dart';
import 'package:tpos_mobile/widgets/bloc_widget/base_bloc_listener_ui.dart';
import 'package:tpos_mobile/widgets/button/app_button.dart';
import 'package:tpos_mobile/widgets/dialog/alert_type.dart';
import 'package:tpos_mobile/widgets/load_status.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

///Màn hình xem chi tiết đơn vị tính
class ProductUomViewPage extends StatefulWidget {
  const ProductUomViewPage({Key key, this.productUom}) : super(key: key);

  @override
  _ProductUomViewPageState createState() => _ProductUomViewPageState();

  final ProductUOM productUom;
}

class _ProductUomViewPageState extends State<ProductUomViewPage> {
  bool _change = false;
  ProductUomAddEditBloc _productUomAddEditBloc;
  ProductUOM _productUom;

  @override
  void initState() {
    _productUomAddEditBloc = ProductUomAddEditBloc();
    _productUomAddEditBloc.add(ProductUomAddEditStarted(productUom: widget.productUom));
    super.initState();
  }

  @override
  void dispose() {
    _productUomAddEditBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_change) {
          Navigator.of(context).pop(_productUom);
        } else {
          Navigator.of(context).pop();
        }
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: _buildAppBar(),
        body: _buildBody(),
      ),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      title:  Text(
        S.of(context).unit,
        style: const TextStyle(color: Colors.white, fontSize: 21),
      ),
      leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            if (_change) {
              Navigator.of(context).pop(_productUom);
            } else {
              Navigator.of(context).pop();
            }
          }),
      actions: [
        IconButton(
            icon: const Icon(Icons.edit_rounded, color: Colors.white),
            onPressed: () async {
              final ProductUOM productUom = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return ProductUomAddEditPage(
                      productUom: widget.productUom,
                    );
                  },
                ),
              );

              if (productUom != null) {
                _change = true;
                _productUomAddEditBloc.add(ProductUomAddEditUpdateLocal(productUom: productUom));
              }
            }),
        IconButton(icon: const Icon(Icons.more_vert, color: Colors.white), onPressed: () async {}),
      ],
    );
  }

  Widget _buildBody() {
    return BaseBlocListenerUi<ProductUomAddEditBloc, ProductUomAddEditState>(
      bloc: _productUomAddEditBloc,
      loadingState: ProductUomAddEditLoading,
      busyState: ProductUomAddEditBusy,
      errorState: ProductUomAddEditLoadFailure,
      buildWhen: (ProductUomAddEditState last, ProductUomAddEditState current) {
        return current is! ProductUomAddEditSaveError || current is! ProductUomAddEditDeleteError;
      },
      listener: (BuildContext context, ProductUomAddEditState state) {
        if (state is ProductUomAddEditDeleteError) {
          App.showDefaultDialog(title: S.of(context).error, context: context, type: AlertDialogType.error, content: state.error);
        } else if (state is ProductUomAddEditDeleteSuccess) {
          Navigator.of(context).pop(_productUomAddEditBloc);
        }
      },
      errorBuilder: (BuildContext context, ProductUomAddEditState state) {
        String error = S.of(context).canNotGetDataFromServer;
        if (state is ProductUomAddEditLoadFailure) {
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
                    _productUomAddEditBloc.add(ProductUomAddEditStarted(productUom: widget.productUom));
                  },
                  width: 180,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 40, 167, 69),
                    borderRadius: BorderRadius.all(Radius.circular(24)),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:  [
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
      builder: (BuildContext context, ProductUomAddEditState state) {
        if (state is ProductUomAddEditLoadSuccess) {
          _productUom = state.productUom;
        }

        return SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(_productUom),
              Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: _buildFieldRow(title: S.of(context).unitCategory, value: _productUom.categoryName ?? '')),
              Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: _buildFieldRow(title: S.of(context).type, value: _productUom.showUOMType ?? '')),
              Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: _buildFieldRow(
                      title: S.of(context).factor, value: _productUom.showFactor != null ? _productUom.showFactor.toStringAsFixed(2) : '')),
              if (_productUom.uOMType != 'reference')
                Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    child: _buildFieldRow(
                        title: S.of(context).rounding,
                        value: _productUom.rounding != null ? _productUom.rounding.toStringAsFixed(2) : '')),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: _buildActive(),
              )
            ],
          ),
        );
      },
    );
  }

  ///Xây dựng tên của nhóm sản phẩm đứng đầu
  Widget _buildHeader(ProductUOM productUom) {
    return Container(
      color: const Color(0xffF8F9FB),
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 Text(S.of(context).unit.toUpperCase(), style:const  TextStyle(color: Color(0xff929DAA), fontSize: 15)),
                Text(productUom.name, style: const TextStyle(color: Color(0xff2C333A), fontSize: 21)),
              ],
            ),
          ),
          const SizedBox(width: 10),
          SvgPicture.asset('assets/icon/product_uom.svg'),
        ],
      ),
    );
  }

  ///Xây dựng giao diện hiện thị trường dữ liệu theo dạng hàng
  Widget _buildFieldRow({String title, String value}) {
    return Container(
      width: double.infinity,
      child: Column(
        children: [
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(child: Text(title, style: const TextStyle(color: Color(0xff2C333A), fontSize: 17))),
              Flexible(
                  child: Padding(
                padding: const EdgeInsets.only(right: 15),
                child: Text(value, style: const TextStyle(color: Color(0xff6B7280), fontSize: 17)),
              )),
            ],
          ),
          const SizedBox(height: 10),
          Container(color: Colors.grey.shade200, height: 1, width: double.infinity),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  ///Xây dựng giao diện hiệu lực
  Widget _buildActive() {
    return Row(
      children: [
        if (_productUom.active)
          const Icon(
            FontAwesomeIcons.checkCircle,
            color: Color(0xff28A745),
            size: 16,
          )
        else
          const Icon(
            Icons.cancel_outlined,
            color: Color(0xffEB3B5B),
            size: 16,
          ),
        const SizedBox(width: 8),
        if (_productUom.active)
           Text(S.of(context).valid, style:const  TextStyle(color: Color(0xff2C333A), fontSize: 17))
        else
          Text(S.of(context).invalid, style: const TextStyle(color: Color(0xffEB3B5B), fontSize: 17)),
      ],
    );
  }
}

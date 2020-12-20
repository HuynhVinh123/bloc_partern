import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/feature_group/category/origin_country/ui/origin_country_page.dart';
import 'package:tpos_mobile/feature_group/category/partner_ext/ui/partner_ext_page.dart';
import 'package:tpos_mobile/feature_group/category/product_template/ui/add_edit/product_template_description_page.dart';
import 'package:tpos_mobile/widgets/button/app_button.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

///Xây dựng giao diện nhập thêm thông tin cho sản phẩm của tab [GeneralInfoTab]
class AnotherProductInfoPage extends StatefulWidget {
  const AnotherProductInfoPage({Key key, this.productTemplate}) : super(key: key);

  @override
  _AnotherProductInfoPageState createState() => _AnotherProductInfoPageState();

  final ProductTemplate productTemplate;
}

class _AnotherProductInfoPageState extends State<AnotherProductInfoPage> {
  ProductTemplate _productTemplate;

  final TextEditingController _descriptionController = TextEditingController(text: '');
  final TextEditingController _elementController = TextEditingController(text: '');
  final TextEditingController _specificationsController = TextEditingController(text: '');
  final TextEditingController _infoWarningController = TextEditingController(text: '');

  int _yearOfManufacture = 0;
  PartnerExt _producer;
  PartnerExt _importer;
  PartnerExt _distributor;
  OriginCountry _originCountry;

  @override
  void initState() {
    super.initState();
    _productTemplate = widget.productTemplate;
    _producer = _productTemplate.producer;
    _importer = _productTemplate.importer;
    _distributor = _productTemplate.distributor;
    _yearOfManufacture = _productTemplate.yearOfManufacture;
    _originCountry = _productTemplate.originCountry;
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _specificationsController.dispose();
    _elementController.dispose();
    _infoWarningController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffEBEDEF),
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      title: Text(S.of(context).otherInformation, style: const TextStyle(color: Colors.white, fontSize: 21)),
      actions: <Widget>[
        IconButton(
            icon: const Icon(Icons.check, color: Colors.white, size: 30),
            onPressed: () {
              _productTemplate.description = _descriptionController.text;
              _productTemplate.yearOfManufacture = _yearOfManufacture;
              _productTemplate.element = _elementController.text;
              _productTemplate.specifications = _specificationsController.text;
              _productTemplate.infoWarning = _infoWarningController.text;
              _productTemplate.producer = _producer;
              _productTemplate.importer = _importer;
              _productTemplate.distributor = _distributor;

              _productTemplate.originCountry = _originCountry;
              Navigator.of(context).pop(_productTemplate);
            }),
      ],
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            _buildDescription(),
            const SizedBox(height: 10),
            _buildNavigateGroup(),
            const SizedBox(height: 10),
            _buildInputs(),
            const SizedBox(height: 10),
            _buildProductDescription(),
            const SizedBox(height: 70),
          ],
        ),
      ),
    );
  }

  ///Xây dựng giao diện nhập mô tả
  Widget _buildDescription() {
    return _buildGroup(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(S.of(context).descriptionInPos.toUpperCase(), style: const TextStyle(color: Color(0xff28A745))),
        _buildTextField(
          hint: S.of(context).enterParam(S.of(context).description.toLowerCase()),
          controller: _descriptionController,
          onTextChanged: (String text) {},
        ),
      ],
    ));
  }

  ///Xâu dựng giao diện chọn 'Nhà sản xuất','Nhà nhập khẩu','Nhà phân phối', 'Xuất xứ'
  Widget _buildNavigateGroup() {
    return _buildGroup(
        child: Column(
      children: [
        StatefulBuilder(
          builder: (BuildContext context, void Function(void Function()) setState) {
            return _buildNavigate(
                title: S.of(context).producer,
                note: _producer != null
                    ? _producer.name
                    : S.of(context).selectParam(S.of(context).producer.toLowerCase()),
                noteStyle: _producer != null ? const TextStyle(color: Color(0xff2C333A), fontSize: 15) : null,
                onTap: () async {
                  final PartnerExt result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return PartnerExtPage(
                          title: S.of(context).selectParam(S.of(context).producer.toLowerCase()),
                        );
                      },
                    ),
                  );
                  if (result != null) {
                    _producer = result;
                    setState(() {});
                  }
                });
          },
        ),
        const SizedBox(height: 10),
        Container(color: Colors.grey.shade200, height: 1, width: double.infinity),
        const SizedBox(height: 10),
        StatefulBuilder(
          builder: (BuildContext context, void Function(void Function()) setState) {
            return _buildNavigate(
                title: S.of(context).importer,
                note: _importer != null
                    ? _importer.name
                    : S.of(context).selectParam(S.of(context).importer.toLowerCase()),
                noteStyle: _importer != null ? const TextStyle(color: Color(0xff2C333A), fontSize: 15) : null,
                onTap: () async {
                  final PartnerExt result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return PartnerExtPage(
                          title: S.of(context).selectParam(S.of(context).importer.toLowerCase()),
                        );
                      },
                    ),
                  );
                  if (result != null) {
                    _importer = result;
                    setState(() {});
                  }
                });
          },
        ),
        const SizedBox(height: 10),
        Container(color: Colors.grey.shade200, height: 1, width: double.infinity),
        const SizedBox(height: 10),
        StatefulBuilder(
          builder: (BuildContext context, void Function(void Function()) setState) {
            return _buildNavigate(
                title: S.of(context).distributor,
                note: _distributor != null
                    ? _distributor.name
                    : S.of(context).selectParam(S.of(context).distributor.toLowerCase()),
                noteStyle: _distributor != null ? const TextStyle(color: Color(0xff2C333A), fontSize: 15) : null,
                onTap: () async {
                  final PartnerExt result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return PartnerExtPage(
                            title: S.of(context).selectParam(S.of(context).distributor.toLowerCase()));
                      },
                    ),
                  );
                  if (result != null) {
                    _distributor = result;
                    setState(() {});
                  }
                });
          },
        ),
        const SizedBox(height: 10),
        Container(color: Colors.grey.shade200, height: 1, width: double.infinity),
        const SizedBox(height: 10),
        StatefulBuilder(
          builder: (BuildContext context, void Function(void Function()) setState) {
            return _buildNavigate(
                title: S.of(context).origin,
                note: _originCountry != null ? _originCountry.name : S.of(context).selectParam(S.of(context).origin.toLowerCase()),
                noteStyle: _originCountry != null ? const TextStyle(color: Color(0xff2C333A), fontSize: 15) : null,
                onTap: () async {
                  final OriginCountry result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const OriginCountryPage();
                      },
                    ),
                  );
                  if (result != null) {
                    _originCountry = result;
                    setState(() {});
                  }
                });
          },
        ),
        const SizedBox(height: 10),
        Container(color: Colors.grey.shade200, height: 1, width: double.infinity),
        const SizedBox(height: 14),
        _buildCalendar()
      ],
    ));
  }

  ///Xây dựng giao diện nhập thông tin thành phần, thông số kỷ thuât, thông tin cảnh báo
  Widget _buildInputs() {
    return _buildGroup(
        child: Column(
      children: [
        _buildTextField(
          controller: _elementController,
          hint: S.of(context).element,
          onTextChanged: (String text) {},
        ),
        _buildTextField(
          controller: _specificationsController,
          hint: S.of(context).technicalSpecifications,
          onTextChanged: (String text) {},
        ),
        _buildTextField(
          controller: _infoWarningController,
          hint: S.of(context).warningInformation,
          onTextChanged: (String text) {},
        ),
      ],
    ));
  }

  ///Xây dựng giao diện nhập mô tả sản phẩm
  Widget _buildProductDescription() {
    return _buildGroup(child: StatefulBuilder(
      builder: (BuildContext context, void Function(void Function()) setState) {
        return InkWell(
          onTap: () async {
            final String value = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductTemplateDescriptionPage(
                  description: _productTemplate.description,
                ),
              ),
            );
            if (value != null) {
              _productTemplate.description = value;
            }
          },
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(S.of(context).productDescription,
                        style: const TextStyle(color: Color(0xff2C333A), fontSize: 17)),
                    const SizedBox(height: 7),
                    if (_productTemplate.description != null && _productTemplate.description != '')
                      Html(data: _productTemplate.description)
                    else
                      Text(S.of(context).enterParam(S.of(context).productDescription.toLowerCase()),
                          style: const TextStyle(color: Color(0xff929DAA), fontSize: 15)),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 15, color: Color(0xff929DAA)),
              const SizedBox(width: 10),
            ],
          ),
        );
      },
    ));
  }

  ///Xây dựng giao diện chọn ngày
  Widget _buildCalendar() {
    return StatefulBuilder(
      builder: (BuildContext context, void Function(void Function()) setState) {
        return InkWell(
          onTap: () async {
            final int result = await showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return YearPicker(
                    initValue: _yearOfManufacture == 0 ? DateTime.now().year : _yearOfManufacture,
                    onValueChanged: (int value) {
                      if (value != null) {
                        _yearOfManufacture = value;
                        setState(() {});
                      }
                    },
                  );
                });
            if (result != null) {
              _yearOfManufacture = result;
              setState(() {});
            }
          },
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(S.of(context).productionYear, style: const TextStyle(color: Color(0xff929DAA), fontSize: 17)),
                  Row(
                    children: [
                      Text(_yearOfManufacture.toString(),
                          style: const TextStyle(color: Color(0xff2C333A), fontSize: 17)),
                      const SizedBox(width: 10),
                      const Padding(
                          padding: EdgeInsets.only(right: 10),
                          child: Icon(
                            FontAwesomeIcons.calendarAlt,
                            color: Color(0xff858F9B),
                            size: 20,
                          )),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Container(color: Colors.grey.shade200, height: 1, width: double.infinity),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  ///Xây dựng giao diện nhóm các widget với nền trắng bo tròn 4 cạnh
  Widget _buildGroup(
      {Widget child, EdgeInsets padding = const EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 20)}) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        color: Colors.white,
      ),
      padding: padding,
      child: child,
    );
  }

  ///Xây dựng giao diện nhập liệu
  Widget _buildTextField(
      {TextEditingController controller,
      FocusNode focusNode,
      String hint,
      Function(String) onTextChanged,
      EdgeInsets contentPadding = const EdgeInsets.only(right: 10),
      bool error = false}) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      maxLines: 1,
      onChanged: onTextChanged,
      style: const TextStyle(color: Color(0xff2C333A), fontSize: 17),
      decoration: InputDecoration(
        contentPadding: contentPadding,
        enabledBorder: error
            ? const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
              )
            : UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xff929DAA), fontSize: 17),
        focusedBorder: error
            ? const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
              )
            : const UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xff28A745)),
              ),
      ),
    );
  }

  ///Xây dựng giao diện navigate đến màn hình khác để chọn
  Widget _buildNavigate(
      {@required String title, @required String note, @required Function() onTap, TextStyle noteStyle}) {
    assert(title != null);
    assert(note != null);
    assert(onTap != null);
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Color(0xff2C333A), fontSize: 17)),
                const SizedBox(height: 7),
                Text(note, style: noteStyle ?? const TextStyle(color: Color(0xff929DAA), fontSize: 15)),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 15, color: Color(0xff929DAA)),
          const SizedBox(width: 10),
        ],
      ),
    );
  }
}

///Giao diện chọn năm
class YearPicker extends StatefulWidget {
  const YearPicker({Key key, this.initValue = 1800, this.onValueChanged}) : super(key: key);

  @override
  _YearPickerState createState() => _YearPickerState();
  final int initValue;
  final Function(int) onValueChanged;
}

class _YearPickerState extends State<YearPicker> {
  final FixedExtentScrollController _fixedExtentScrollController = FixedExtentScrollController();

  int _current;

  @override
  void initState() {
    _current = widget.initValue;
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _fixedExtentScrollController.jumpToItem(widget.initValue - 1800));
    super.initState();
  }

  @override
  void dispose() {
    _fixedExtentScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
          child: Row(
            children: [
              Flexible(
                child: AppButton(
                  background: const Color(0xff28A745),
                  child:  Text(
                    S.of(context).cancel,
                    style: const TextStyle(color: Colors.white, fontSize: 17),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              const SizedBox(width: 50),
              Flexible(
                child: AppButton(
                  background: const Color(0xff28A745),
                  child:  Text(
                    S.of(context).select,
                    style: const TextStyle(color: Colors.white, fontSize: 17),
                  ),
                  onPressed: () {
                    Navigator.pop(context, _current);
                  },
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: CupertinoPicker(
            scrollController: _fixedExtentScrollController,
            backgroundColor: Colors.white,
            onSelectedItemChanged: (int value) {
              _current = 1800 + value;
            },
            itemExtent: 32.0,
            children: List.generate(300, (index) => 1800 + index).map((e) => Text(e.toString())).toList(),
          ),
        ),
      ],
    );
  }
}

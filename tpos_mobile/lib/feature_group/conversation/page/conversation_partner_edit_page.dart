import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/feature_group/conversation/bloc/conversation_partner_edit_bloc.dart';
import 'package:tpos_mobile/feature_group/conversation/bloc/conversation_partner_status.dart';
import 'package:tpos_mobile/feature_group/sale_online/ui/sale_online_select_address.dart';
import 'package:tpos_mobile/src/tpos_apis/models/Address.dart';
import 'package:tpos_mobile/widgets/button/app_button.dart';
import 'package:tpos_mobile/widgets/load_status.dart';
import 'package:tpos_mobile/widgets/loading_indicator.dart';
import 'package:tpos_mobile_localization/generated/l10n.dart';

class ConversationPartnerEditPage extends StatefulWidget {
  const ConversationPartnerEditPage({this.conversation, this.crmTeam});
  final Conversation conversation;
  final CRMTeam crmTeam;
  @override
  _ConversationPartnerEditPageState createState() =>
      _ConversationPartnerEditPageState();
}

///Drawer hội thoại
class _ConversationPartnerEditPageState
    extends State<ConversationPartnerEditPage> {
  ConversationPartnerEditBloc conversationPartnerEditBloc =
      ConversationPartnerEditBloc();
  ConversationPartnerStatusBloc conversationPartnerStatusBloc =
      ConversationPartnerStatusBloc();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  Address selectCity;
  Address selectDistrict;
  Address selectWard;
  String statusCustomer = 'Bình thường';
  PartnerStatus partnerStatus;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Thông tin khách hàng'),
        actions: const [
          IconButton(
            icon: Icon(
              Icons.check,
              color: Colors.white,
            ),
          )
        ],
      ),
      body: MultiBlocProvider(
        providers: [
          BlocProvider<ConversationPartnerEditBloc>(
            create: (context) => conversationPartnerEditBloc,
          ),
          BlocProvider<ConversationPartnerStatusBloc>(
            create: (context) => conversationPartnerStatusBloc,
          ),
        ],
        child: BlocConsumer(
          cubit: conversationPartnerEditBloc,
          listener: (BuildContext context, state) {
            if (state is ConversationPartnerEditLoad) {
              nameController.text = state.partner.name;
              phoneController.text = state.partner.phone;
              emailController.text = state.partner.email;
              noteController.text = state.partner.comment;
              statusCustomer = state.partner.statusText;
              selectCity = Address(
                  name: state?.partner?.city?.name,
                  code: state?.partner?.city?.code);
              selectDistrict = Address(
                  name: state?.partner?.district?.name,
                  code: state?.partner?.district?.code);
              selectWard = Address(
                  name: state?.partner?.ward?.name,
                  code: state?.partner?.ward?.code);

              addressController.text = state.partner.street;
            } else if (state is ConversationPartnerEditSuccess) {
              Navigator.pop(context, state.partner);
            }
          },
          builder: (BuildContext context, state) {
            if (state is ConversationPartnerEditLoad) {
              return _buildList(context, state);
            }
            return Container();
          },
        ),
      ),
    );
  }

  void _buildBottomSheetPartnerStatus(BuildContext context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        backgroundColor: Colors.white,
        builder: (ctx) {
          return SafeArea(
            child: Container(
              constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height - 100),
              child: Column(
                children: [
                  Stack(
                    children: [
                      const ListTile(
                        title: Center(
                          child: Text(
                            'Chọn trạng thái',
                            style: TextStyle(
                                color: Color(
                                  0xFF2C333A,
                                ),
                                fontSize: 20,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, top: 7),
                        child: IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  ),
                  BlocBuilder(
                    cubit: conversationPartnerStatusBloc,
                    builder: (BuildContext context, state) {
                      if (state is ConversationPartnerStatusLoading) {
                        return Expanded(
                          child: ListView.builder(
                            padding: const EdgeInsets.only(
                                top: 24, bottom: 20, right: 16, left: 16),
                            shrinkWrap: true,
                            itemCount: state?.listPartnerStatus?.length,
                            itemBuilder: (context, index) => Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    partnerStatus =
                                        state?.listPartnerStatus[index];
                                    statusCustomer = partnerStatus.text;
                                  });
                                  Navigator.pop(context);
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(state?.listPartnerStatus[index].text ??
                                        ''),
                                    if (statusCustomer ==
                                        state?.listPartnerStatus[index].text)
                                      const Icon(
                                        Icons.check_circle,
                                        color: Color(0xFF28A745),
                                      )
                                    else
                                      const Icon(
                                        Icons.check_circle,
                                        color: Color(0xFFDFE5E9),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      } else if (state is ConversationPartnerStatusFailure) {
                        return Column(
                          children: [
                            SizedBox(
                                height: 50 *
                                    (MediaQuery.of(context).size.height / 700)),
                            LoadStatusWidget(
                              statusName: S.of(context).loadDataError,
                              content: state.error,
                              statusIcon: SvgPicture.asset(
                                  'assets/icon/error.svg',
                                  width: 170,
                                  height: 130),
                              action: AppButton(
                                onPressed: () {
                                  conversationPartnerStatusBloc
                                      .add(ConversationPartnerStatusLoaded());
                                },
                                width: 180,
                                decoration: const BoxDecoration(
                                  color: Color.fromARGB(255, 40, 167, 69),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(24)),
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
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      } else if (state is ConversationPartnerStatusWating) {
                        return const LoadingIndicator();
                      }
                      return Container();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget _buildList(BuildContext context, ConversationPartnerEditState state) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Column(
              children: [
                Container(
                  height: 121,
                  width: 121,
                  margin: const EdgeInsets.only(top: 26),
                  child: CircleAvatar(
                    radius: 30.0,
                    backgroundImage: NetworkImage(
                      'https://graph.facebook.com/${widget.conversation?.psid}/picture?access_token=${widget.crmTeam?.facebookPageToken}',
                    ),
                    backgroundColor: Colors.transparent,
                  ),
                ),
                InkWell(
                  onTap: () {
                    _buildBottomSheetPartnerStatus(context);
                    conversationPartnerStatusBloc
                        .add(ConversationPartnerStatusLoaded());
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 55, left: 55, top: 21),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.0),
                      color: const Color(0xFFFBF9FB),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 5, bottom: 5),
                      child: Center(
                        child: RichText(
                            text: TextSpan(children: [
                          const TextSpan(
                              text: 'Trạng thái:',
                              style: TextStyle(
                                  fontSize: 17.0, color: Color(0xFF6B7280))),
                          TextSpan(
                              text: statusCustomer,
                              style: const TextStyle(
                                  fontSize: 17.0, color: Color(0xFF28A745))),
                          const TextSpan(
                              text: ' | ',
                              style: TextStyle(
                                  fontSize: 17.0, color: Color(0xFF6B7280))),
                          const TextSpan(
                              text: 'KH00042',
                              style: TextStyle(
                                  fontSize: 17.0, color: Color(0xFF2395FF))),
                        ])),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          _buildInputText(context,
              textEditingController: nameController,
              title: 'Tên khách hàng',
              content: 'Nhập tên'),
          _buildInputText(context,
              textEditingController: phoneController,
              title: 'Điện thoại',
              content: 'Nhập số điện thoại',
              textInputType: TextInputType.phone),
          _buildInputText(context,
              textEditingController: emailController,
              title: 'Email',
              content: 'Nhập email',
              textInputType: TextInputType.emailAddress),
          _buildInputText(context,
              textEditingController: noteController,
              title: 'Ghi chú ',
              content: 'Nhập ghi chú'),
          _buildInputText(context,
              textEditingController: addressController,
              title: 'Địa chỉ',
              content: 'Nhập địa chỉ'),
          Padding(
            padding: const EdgeInsets.only(left: 8, top: 10),
            child: Column(
              children: <Widget>[
                // Tỉnh thành
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, top: 10, right: 10),
                  child: GestureDetector(
                    onTap: () async {
                      final Address city = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (ctx) => const SelectAddressPage(
                            cityCode: null,
                            districtCode: null,
                          ),
                        ),
                      );
                      setState(() {
                        selectCity = city;
                        selectDistrict = null;
                        selectWard = null;
                      });
                    },
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            selectCity?.name ??
                                S.current.saleOnline_ChooseProvinceCity,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                        const Icon(Icons.keyboard_arrow_right),
                      ],
                    ),
                  ),
                ),
                const Divider(),
                //Quận huyện
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, top: 10, right: 10),
                  child: GestureDetector(
                    onTap: () async {
                      if (selectCity == null) return;
                      final Address newSelectDistrict = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (ctx) => SelectAddressPage(
                                    cityCode: selectCity.code,
                                    districtCode: null,
                                  )));
                      setState(() {
                        selectDistrict = newSelectDistrict;
                        selectWard = null;
                      });
                    },
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            selectDistrict?.name ??
                                S.current.saleOnline_ChooseDistrict,
                            style: const TextStyle(
                                fontSize: 16, color: Colors.black),
                          ),
                        ),
                        const Icon(Icons.keyboard_arrow_right),
                      ],
                    ),
                  ),
                ),
                const Divider(),
                // Phường
                Padding(
                  padding: const EdgeInsets.only(
                      left: 8.0, top: 10, right: 10, bottom: 10),
                  child: GestureDetector(
                    onTap: () async {
                      if (selectDistrict == null) return;
                      final Address newSelectWard = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (ctx) => SelectAddressPage(
                            cityCode: selectCity.code,
                            districtCode: selectDistrict.code,
                          ),
                        ),
                      );
                      setState(() {
                        selectWard = newSelectWard;
                      });
                    },
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            selectWard?.name ?? S.current.saleOnline_ChooseWard,
                            style: const TextStyle(
                                fontSize: 16, color: Colors.black),
                          ),
                        ),
                        const Icon(Icons.keyboard_arrow_right),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          Container(
            padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
            child: FlatButton(
                height: 48,
                minWidth: double.infinity,
                color: const Color(0xFF28A745),
                onPressed: () {
                  conversationPartnerEditBloc
                      .add(ConversationPartnerEditUpdated(
                          partner: Partner(
                            city: CityAddress(
                                code: selectCity?.code, name: selectCity?.name),
                            ward: WardAddress(
                                code: selectWard?.code, name: selectWard?.name),
                            district: DistrictAddress(
                                code: selectDistrict?.code,
                                name: selectDistrict?.name),
                            comment: noteController.text,
                            id: widget?.conversation?.partnerId,
                            name: nameController.text,
                            phone: phoneController.text,
                            email: emailController.text,
                            status: statusCustomer,
                            street: addressController.text,
                          ),
                          crmTeamId: widget?.crmTeam?.id));
                },
                child: const Text(
                  'Lưu',
                  style: TextStyle(color: Colors.white),
                )),
          ),
        ],
      ),
    );
  }

  Widget _buildInputText(BuildContext context,
      {TextEditingController textEditingController,
      String title,
      String content,
      TextInputType textInputType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      child: TextField(
        keyboardType: textInputType,
        controller: textEditingController,
        decoration: InputDecoration(
          hintText: content,
          labelText: title,
          hintStyle: const TextStyle(fontSize: 17),
          labelStyle: const TextStyle(color: Color(0xFF929DAA), fontSize: 15),
          suffixIcon: title == 'Địa chỉ'
              ? Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: SvgPicture.asset(
                    'assets/icon/gg_map.svg',
                  ),
                )
              : null,
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    conversationPartnerEditBloc.add(ConversationPartnerEditLoaded(
        partnerId: widget.conversation.partnerId));
    conversationPartnerStatusBloc.add(ConversationPartnerStatusLoaded());
  }
}

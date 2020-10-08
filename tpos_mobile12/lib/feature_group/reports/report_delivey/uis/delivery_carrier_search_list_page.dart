import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tpos_mobile/feature_group/reports/report_delivey/blocs/delivery_carrier_search/delivery_carrier_search_bloc.dart';
import 'package:tpos_mobile/feature_group/reports/report_delivey/blocs/delivery_carrier_search/delivery_carrier_search_event.dart';
import 'package:tpos_mobile/feature_group/reports/report_delivey/blocs/delivery_carrier_search/delivery_carrier_search_state.dart';
import 'package:tpos_mobile/feature_group/reports/report_order/ui/empty_data_page.dart';
import 'package:tpos_mobile/helpers/messenger_helper.dart';
import 'package:tpos_mobile/src/tpos_apis/models/delivery_carrier.dart';
import 'package:tpos_mobile/widgets/bloc_widget/bloc_loading_screen.dart';
import 'package:tpos_mobile/widgets/bloc_widget/bloc_ui_provider.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

class DeliveryCarrierSearchListPage extends StatefulWidget {
  @override
  _DeliveryCarrierSearchListPageState createState() =>
      _DeliveryCarrierSearchListPageState();
}

class _DeliveryCarrierSearchListPageState
    extends State<DeliveryCarrierSearchListPage> {
  final _bloc = DeliveryCarrierSearchBloc();

  @override
  void initState() {
    super.initState();
    _bloc.add(DeliveryCarrierSearchLoaded());
  }

  @override
  Widget build(BuildContext context) {
    return BlocUiProvider<DeliveryCarrierSearchBloc>(
      bloc: _bloc,
      listen: (state) {
        if (state is DeliveryCarrierSearchLoadFailure) {
          showError(
              title: state.title, message: state.content, context: context);
        }
      },
      child: Scaffold(
          appBar: AppBar(
            /// Danh sách đối tác giao hàng
            title:  Text(S.current.reportOrder_partners),
          ),
          body: _buildBody()),
    );
  }

  Widget _buildBody() {
    return BlocLoadingScreen<DeliveryCarrierSearchBloc>(
        busyStates: const [DeliveryCarrierSearchLoading],
        child:
            BlocBuilder<DeliveryCarrierSearchBloc, DeliveryCarrierSearchState>(
                builder: (context, state) =>
                    state is DeliveryCarrierSearchLoadSuccess
                        ? _buildListItem(state)
                        : Container()));
  }

  Widget _buildListItem(DeliveryCarrierSearchLoadSuccess state) {
    return state.deliveryCarriers.isEmpty ? EmptyDataPage() : ListView.separated(
        itemBuilder: (context, index) =>
            _buildItem(state.deliveryCarriers[index]),
        separatorBuilder: (context, index) => const Divider(),
        itemCount: state.deliveryCarriers.length);
  }

  Widget _buildItem(DeliveryCarrier item) {
    return InkWell(
      onTap: () {
        Navigator.pop(context, item);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Text(item.name ?? ""),
      ),
    );
  }
}

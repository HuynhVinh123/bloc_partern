import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmt_flutter_untils/tmt_flutter_utils.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/extensions.dart';
import 'package:tpos_mobile/feature_group/category/partner/partner_status_select_page.dart';
import 'package:tpos_mobile/helpers/app_helper.dart';
import 'package:tpos_mobile/widgets/app_widgets/partner_status_badge_bloc.dart';

class PartnerStatusBadge extends StatefulWidget {
  /// Khởi tạo một UI biểu diễn trạng thái của nhà cung cấp/khách hàng
  /// Màu của trạng thái sẽ được lấy từ bộ nhớ _cacheService.
  const PartnerStatusBadge(
      {Key key,
      @required this.statusText,
      this.onStatusChanged,
      this.changeServer = true,
      @required this.partnerId,
      this.partner})
      : super(key: key);

  /// Trạng thái của khách hàng/ nhà cung cấp
  final String statusText;

  /// Callback nói rằng trạng thái của khách hàng đã bị thay đổi. Nếu [onStatusChanged] không bị null. thì nút này sẽ nhấn được và mở ra một giao diện để chọn  trạng thái.
  final ValueChanged<PartnerStatus> onStatusChanged;

  /// Khi chọn trạng thái khác thì thay đổi luôn ở máy chủ qua API. Khi thay đổi thành công thì mới gọi sự kiện [onStatusChange]
  final bool changeServer;

  /// Id của [Partner]
  final int partnerId;

  /// Đối tượng [partner] sau khi trạng thái thay đổi. trạng thái mới sẽ được cập nhật cho [partner] này.
  final Partner partner;

  @override
  _PartnerStatusBadgeState createState() => _PartnerStatusBadgeState();
}

class _PartnerStatusBadgeState extends State<PartnerStatusBadge>
    with AutomaticKeepAliveClientMixin {
  Future<void> _handleButtonPressed(BuildContext context) async {
    final PartnerStatus status = await context.navigateTo(
      PartnerStatusSelectPage(
        selectedStatus: widget.statusText,
      ),
    );

    if (widget.changeServer) {
      context.read<PartnerStatusBadgeBloc>().add(PartnerStatusBadgePressed(
            status: status,
            partnerId: widget.partnerId,
            partner: widget.partner,
          ));
    } else {
      widget.onStatusChanged?.call(status);
    }
  }

  final _bloc = PartnerStatusBadgeBloc();
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final Color backgroundColor =
        getPartnerStatusColorFromStatusText(widget.statusText);
    final Color textColor = backgroundColor.textColor();

    return BlocProvider<PartnerStatusBadgeBloc>(
      create: (context) => _bloc,
      child: Builder(
        builder: (context) => ElevatedButton(
          onPressed: () {
            if (widget.onStatusChanged != null) {
              _handleButtonPressed(context);
            }
          },
          child: BlocConsumer<PartnerStatusBadgeBloc, PartnerStatusBadgeState>(
            listener: (context, state) {
              if (state is PartnerStatusBadgeChangeSuccess) {
                widget.onStatusChanged?.call(state.status);
              }
            },
            builder: (context, state) {
              if (state is PartnerStatusBadgeChangeing) {
                return const SizedBox(
                  child: CircularProgressIndicator(),
                  width: 20,
                  height: 20,
                );
              }

              return Text(
                widget.statusText ?? '',
                style: TextStyle(color: textColor),
              );
            },
          ),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(backgroundColor),
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tpos_mobile/widgets/button/app_button.dart';
import 'package:tpos_mobile/widgets/loading_indicator.dart';
import 'package:tpos_mobile/widgets/page_state/page_state.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

/// Một vài tính năng được tính hợp và sẵn sàng để sử dụng nhanh
class BaseBlocListenerUiCustom<T extends Bloc<dynamic, TState>, TState>
    extends StatefulWidget {
  const BaseBlocListenerUiCustom(
      {Key key,
      this.bloc,
      this.busyState,
      this.loadingState,
      this.listener,
      @required this.builder,
      this.errorState,
      this.reload,
      this.loadingWidget,
      this.initState,
      this.buildWhen,
      this.errorBuilder,
      this.errorStates,
      this.reloadWithState})
      : super(key: key);
  final T bloc;

  /// Trạng thái bận
  /// Nếu trạng thái của bloc hiện tại khớp với [busyState] thì một lớp phủ [Loading]
  /// sẽ được bật lên nhằm thông báo cho người dùng biết là không thể thao tác gì thêm trong thời gian này
  final dynamic busyState;

  /// Trạng thái mới khởi tạo dữ liệu
  /// Nếu trạng thái của bloc hiện tại khớp với [loadingState] thì giao diện chờ tải sẽ hiện lên thay thế giao diện chính
  final dynamic loadingState;

  ///Danh sachs trạng thái khi lấy dữ liệu thất bại từ server
  /// Nếu trạng thái của bloc hiện tại khớp với phần tử trong [errorStates] thì giao diện chờ tải sẽ hiện lên thay thế giao diện chính
  final List<dynamic> errorStates;

  /// Trạng thái khi lấy dữ liệu thất bại từ server
  /// Nếu trạng thái của bloc hiện tại khớp với [errorState] thì giao diện chờ tải sẽ hiện lên thay thế giao diện chính
  @Deprecated('Sử dụng [errorStates] thay vì [errorState]')
  final dynamic errorState;

  ///Trạng thái khởi tạo của bloc
  final dynamic initState;

  ///Hàm lấy lại dữ liệu chung
  final Function() reload;

  ///Hàm lấy lại dữ liệu dựa trên state, sử dụng nếu tao dừng [errorStates]
  final Function(TState state) reloadWithState;

  final Widget loadingWidget;

  final Widget Function(BuildContext context, TState state) errorBuilder;

  final Function(TState last, TState current) buildWhen;

  ///Dùng cho những ui cần sử dụng tới listener
  final Function(BuildContext context, TState state) listener;
  final Widget Function(BuildContext context, TState state) builder;

  @override
  _BaseBlocListenerUiCustomState<T, TState> createState() =>
      _BaseBlocListenerUiCustomState<T, TState>();
}

class _BaseBlocListenerUiCustomState<T extends Bloc<dynamic, TState>, TState>
    extends State<BaseBlocListenerUiCustom<T, TState>> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<T, TState>(
      cubit: widget.bloc ?? BlocProvider.of<T>(context),
      listener: (BuildContext context, TState state) {
        widget.listener?.call(context, state);
      },
      buildWhen: (TState last, TState current) {
        return widget.buildWhen != null
            ? widget.buildWhen(last, current)
            : true;
      },
      builder: (BuildContext context, TState state) {
        bool findErrorState = false;
        if (widget.errorStates != null) {
          findErrorState =
              widget.errorStates.any((dynamic s) => s == state.runtimeType);
        }
        return ((state.runtimeType != widget.errorState) && !findErrorState)
            ? Stack(
                children: <Widget>[
                  if (state.runtimeType != widget.loadingState)
                    widget.builder(context, state)
                  else
                    const SizedBox(),
                  if (widget.busyState != null &&
                      state.runtimeType == widget.busyState)
                    Container(
                      color: Colors.grey.shade200.withOpacity(0.2),
                      child: const Center(
                        child: LoadingIndicator(),
                      ),
                    )
                  else if (state.runtimeType == widget.loadingState)
                    widget.loadingWidget ??
                        Container(
                          color: Colors.grey.shade200.withOpacity(0.2),
                          child: const Center(
                            child: LoadingIndicator(),
                          ),
                        )
                  else
                    const SizedBox(),
                ],
              )
            : widget.errorBuilder != null
                ? widget.errorBuilder(context, state)
                : AppPageState(
                    icon: SvgPicture.asset('assets/icon/error.svg'),
                    title: S.of(context).loadDataError,
                    message: S.of(context).canNotGetDataFromServer,
                    actions: [
                      AppButton(
                        onPressed: () {
                          widget.reload?.call();
                        },
                        width: null,
                        decoration: const BoxDecoration(
                          color: Color(0xFF28A745),
                          borderRadius: BorderRadius.all(Radius.circular(24)),
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(
                                width: 16,
                              ),
                              const Icon(
                                FontAwesomeIcons.sync,
                                color: Colors.white,
                                size: 18,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                S.of(context).refreshPage,
                                style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white),
                              ),
                              const SizedBox(
                                width: 16,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
      },
    );
  }
}

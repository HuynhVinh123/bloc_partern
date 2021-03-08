import 'package:tpos_mobile/feature_group/sale_online/blocs/report_product_bloc.dart';

class ReportProductState {}

class ReportProductLoading extends ReportProductState {}

class ReportProductSuccess extends ReportProductState {
  ReportProductSuccess({this.reportProducts});
  List<ReportProduct> reportProducts;
}

class ReportProductFailure extends ReportProductState {
  ReportProductFailure({this.title, this.content});
  final String title;
  final String content;
}

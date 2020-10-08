import 'package:tpos_mobile/src/tpos_apis/services/object_apis/product_template_api.dart';
import 'package:tpos_mobile/src/tpos_apis/services/tpos_api_interface.dart';
import 'package:tpos_mobile/src/tpos_apis/tpos_api.dart';

ITposApiService getTposApi() {
  DateTime d1 = new DateTime(2019, 09, 01);
  DateTime d2 = DateTime.now();

  var d = d2.difference(d1);
  print(d);

  return new TposApiService(
      shopUrl: "https://tmt25.tpos.vn",
      accessToken:
          "pOpU13v72lSosIQUnDATypymZcQMmPu3TC5c6UaNvzpqk_kFr6k8vojrPM0kJIOi3DoikRXLn87Tvhk-baloZecl2CvaOrY7WT6ievZkt_hy2PuwKeIgDiSgqWmtNHyoOVMaSuD9LbM7dNzziosiIfMv-CorMYGE5leBlZhmrt1lz3wG332FTsmH4efl_CvVDTAg0kNQFR_b1bZqeeQFt8ichKoJwgE6x7yL6H6_2AO-Bdi_-pnDI2e3r1QpB4BMOgK1fXv-2t_tQe8IB6w5tLaBG0zrimVEuoWNqu3Jklmyzhuc50QSjgd4KGZ9MJAAGmr9ED7fhzKHImpz3IxZFFjlqJGlZZrtRZytj2yfIFgtn8UcGWbFB0sMqyjDRiPg5CmJvVu6SboJcLPxj6bxcEY6TVUXgJxJr-wpfZmTDXGwVJPJ_Jfp0WnNzJ4ufMBVVs356fo0-SxLIkSTXyIE0w");
}

ITposApiService tposApi = getTposApi();

import 'package:test/test.dart';
import 'package:tpos_mobile/feature_group/sale_online/models/tpos_service/odata_filter.dart';

void main() {
  OdataFilter filter = new OdataFilter(
    logic: "and",
    filters: [
      new OdataFilter(
        logic: "or",
        filters: [
          new OdataFilterItem(field: "State", operator: "eq", value: "draft"),
          new OdataFilterItem(field: "State", operator: "eq", value: "open"),
        ],
      ),
      new OdataFilterItem(
          field: "DateInvoice",
          operator: "gte",
          value: DateTime.parse("2019-04-01T00:00:00")),
      new OdataFilterItem(
          field: "DateInvoice",
          operator: "lte",
          value: DateTime.parse("2019-04-23T23:59:59")),
    ],
  );

  test(
    "test to json",
    () {
      var jsonMap = filter.toJson();
      var resultTrue = {
        "logic": "and",
        "filters": [
          {
            "logic": "or",
            "filters": [
              {"field": "State", "operator": "eq", "value": "draft"},
              {"field": "State", "operator": "eq", "value": "open"}
            ]
          },
          {
            "field": "DateInvoice",
            "operator": "gte",
            "value": "2019-04-01T00:00:00"
          },
          {
            "field": "DateInvoice",
            "operator": "lte",
            "value": "2019-04-23T23:59:59"
          }
        ]
      };

      expect(jsonMap, equals(resultTrue));
    },
  );

  test("test filter item to url encode", () {
    OdataFilterItem item =
        new OdataFilterItem(field: "StatusStr", operator: "eq", value: "Draft");
    String urlEncode = item.toUrlEncode();
    expect(urlEncode, "StatusStr eq 'Draft'");
  });

  test("test filter to url encode", () {
    var urlEncode = filter.toUrlEncode();

    String resultTrue =
        "((State eq 'draft' or State eq 'open') and DateInvoice gte 2019-04-01T00:00:00 and DateInvoice lte 2019-04-23T23:59:59)";

    expect(urlEncode, resultTrue);
  });
}

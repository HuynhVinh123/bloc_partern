class GetPartnerExtForSearchQuery {
  GetPartnerExtForSearchQuery({this.format = 'json', String filter, this.keyword, this.count = true}) {
    this.filter = filter ??
        "(contains(NameNoSign,'$keyword')+or+contains(Code,%$keyword')+or+contains(Phone,'$keyword'))";
  }

  final String format;
  String filter;
  final String keyword;
  final bool count;

  Map<String, dynamic> toJson([bool removeIfNull = false]) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['\$format'] = format;
    data['\$filter'] = filter;
    data['\$count'] = count;
    if (removeIfNull) {
      data.removeWhere((key, value) => value == null);
    }
    return data;
  }
}

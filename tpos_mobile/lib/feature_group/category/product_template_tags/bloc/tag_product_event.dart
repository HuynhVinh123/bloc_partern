import 'package:tpos_api_client/tpos_api_client.dart';

abstract class TagProductEvent {}

class TagProductStarted extends TagProductEvent {
  TagProductStarted({this.tags});

  final List<Tag> tags;
}

class TagProductAdded extends TagProductEvent {
  TagProductAdded({this.tag});

  final Tag tag;
}

class TagProductSearched extends TagProductEvent {
  TagProductSearched({this.keyword});

  final String keyword;
}

import 'package:flutter/material.dart';
import 'package:tpos_api_client/tpos_api_client.dart';

class TagEvent {}

class TagLoaded extends TagEvent {}

class TagDeleted extends TagEvent {
  TagDeleted({this.id});
  final String id;
}

class TagUpdated extends TagEvent {
  TagUpdated({this.tag});
  final TagTPage tag;
}

class TagUpdatedStatus extends TagEvent {
  TagUpdatedStatus({this.tagId});
  final String tagId;
}

class TagAdded extends TagEvent {
  TagAdded({this.tag});
  final TagTPage tag;
}

class ColorStateChanged extends TagEvent {
  ColorStateChanged({this.color});
  final Color color;
}

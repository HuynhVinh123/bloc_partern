import 'package:tpos_api_client/tpos_api_client.dart';

abstract class TagProductState {
  TagProductState({this.tags});

  final List<Tag> tags;
}

class TagProductLoading extends TagProductState {
  TagProductLoading({List<Tag> tags}) : super(tags: tags);
}

class TagProductBusy extends TagProductState {
  TagProductBusy({List<Tag> tags}) : super(tags: tags);
}

class TagProductLoadSuccess extends TagProductState {
  TagProductLoadSuccess({List<Tag> tags}) : super(tags: tags);
}

class TagProductAddTagSuccess extends TagProductLoadSuccess {
  TagProductAddTagSuccess({List<Tag> tags}) : super(tags: tags);
}

class TagProductLoadFailure extends TagProductState {
  TagProductLoadFailure({List<Tag> tags, this.error}) : super(tags: tags);
  final String error;
}

class TagProductAddTagFailure extends TagProductState {
  TagProductAddTagFailure({List<Tag> tags, this.error}) : super(tags: tags);
  final String error;
}

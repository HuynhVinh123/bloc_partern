class WebUserConfig {
  WebUserConfig.fromJson(Map<String, dynamic> json) {
    routes = (json["routes"] as List)
        ?.map((f) => WebUserConfigRoute.fromJson(f))
        ?.toList();

    if (json["functions"] != null) {
      functions = (json["functions"] as List).cast<String>();
    }

    if (json['fields'] != null) {
      fields = (json["fields"] as List).cast<String>();
    }
  }
  List<WebUserConfigRoute> routes;
  List<String> functions;
  List<String> fields;
}

class WebUserConfigRoute {
  WebUserConfigRoute({this.name, this.route});
  WebUserConfigRoute.fromJson(Map<String, dynamic> json) {
    name = json['name'];
//    if (json['functions'] != null) {
//      functions = new List<Null>();
//      json['functions'].forEach((v) {
//        functions.add(new Null.fromJson(v));
//      });
//    }
    route = json['route'] != null
        ? WebUserConfigRouteInfo.fromJson(json['route'])
        : null;
  }
  String name;
  WebUserConfigRouteInfo route;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
//    if (this.functions != null) {
//      data['functions'] = this.functions.map((v) => v.toJson()).toList();
//    }
    if (route != null) {
      data['route'] = route.toJson();
    }
    return data;
  }
}

class WebUserConfigRouteInfo {
  WebUserConfigRouteInfo(
      {this.abstract,
      this.url,
      this.template,
      this.templateUrl,
      this.controller,
      this.controllerAs,
      this.component,
      this.data,
      this.params,
      this.breadcrumb,
      this.resolve});
  WebUserConfigRouteInfo.fromJson(Map<String, dynamic> json) {
    abstract = json['abstract'];
    url = json['url'];
    template = json['template'];
    templateUrl = json['templateUrl'];
    controller = json['controller'];
    controllerAs = json['controllerAs'];
    component = json['component'];
    data = json['data'];
    params = json['params'];
    breadcrumb = json['breadcrumb'];
    resolve = json['resolve'];
  }
  bool abstract;
  String url;
  String template;
  String templateUrl;
  String controller;
  String controllerAs;
  String component;
  dynamic data;
  dynamic params;
  dynamic breadcrumb;
  dynamic resolve;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['abstract'] = abstract;
    data['url'] = url;
    data['template'] = template;
    data['templateUrl'] = templateUrl;
    data['controller'] = controller;
    data['controllerAs'] = controllerAs;
    data['component'] = component;
    data['data'] = data;
    data['params'] = params;
    data['breadcrumb'] = breadcrumb;
    data['resolve'] = resolve;
    return data;
  }
}

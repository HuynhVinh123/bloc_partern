class WebUserConfig {
  List<WebUserConfigRoute> routes;
  List<String> functions;
  List<String> fields;
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
}

class WebUserConfigRoute {
  String name;
  WebUserConfigRouteInfo route;

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
        ? new WebUserConfigRouteInfo.fromJson(json['route'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
//    if (this.functions != null) {
//      data['functions'] = this.functions.map((v) => v.toJson()).toList();
//    }
    if (this.route != null) {
      data['route'] = this.route.toJson();
    }
    return data;
  }
}

class WebUserConfigRouteInfo {
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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['abstract'] = this.abstract;
    data['url'] = this.url;
    data['template'] = this.template;
    data['templateUrl'] = this.templateUrl;
    data['controller'] = this.controller;
    data['controllerAs'] = this.controllerAs;
    data['component'] = this.component;
    data['data'] = this.data;
    data['params'] = this.params;
    data['breadcrumb'] = this.breadcrumb;
    data['resolve'] = this.resolve;
    return data;
  }
}

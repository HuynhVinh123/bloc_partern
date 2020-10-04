/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 4/9/19 9:59 AM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 4/9/19 9:52 AM
 *
 */

library tmt_flutter_locator;

import 'package:flutter/foundation.dart';
import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base.dart';

typedef FactoryFunc<T> = T Function();

/// Very simple and easy to use service locator
/// You register your object creation or an instance of an object with [registerFactory], [registerSingleton] or [registerLazySingleton]
/// And retrieve the desired object using [get]
class TmtFlutterLocator {
  final _factories = new Map<Type, _ServiceFactory<dynamic>>();
  final _factoriesByName = Map<String, _ServiceFactory<dynamic>>();
  TmtFlutterLocator._();
  static TmtFlutterLocator _instance;

  static TmtFlutterLocator get instance {
    if (_instance == null) {
      _instance = TmtFlutterLocator._();
    }
    return _instance;
  }

  static TmtFlutterLocator get I => instance;

  /// You should prefer to use the `instance()` method to access an instance of [GetIt].
  /// If you really, REALLY need more than one [GetIt] instance please set allowMultipleInstances
  /// to true to signal you know what you are doing :-).
  factory TmtFlutterLocator.asNewInstance() {
    assert(allowMultipleInstances,
        'You should prefer to use the `instance()` method to access an instance of GetIt. If you really need more than one GetIt instance please set allowMultipleInstances to true.');
    return TmtFlutterLocator._();
  }

  /// By default it's not allowed to register a type a second time.
  /// If you really need to you can disable the asserts by setting[allowReassignment]= true
  bool allowReassignment = false;

  /// By default it's not allowed to create more than one [GetIt] instance.
  /// If you really need to you can disable the asserts by setting[allowReassignment]= true
  static bool allowMultipleInstances = false;

  /// retrives or creates an instance of a registered type [T] depending on the registration function used for this type.
  T get<T>([String instanceName]) {
    assert(!(!(const Object() is! T) && instanceName == null),
        'You have to provide either a type or a name. Did you accidentally do  `var sl=GetIt.instance();` instead of var sl=GetIt.instance;');

    _ServiceFactory<T> object;
    if (instanceName == null) {
      object = _factories[T];
    } else {
      object = _factoriesByName[instanceName];
    }
    if (object == null) {
      if (instanceName == null) {
        throw Exception(
            "Object of type ${T.toString()} is not registered inside GetIt");
      } else {
        throw Exception(
            "Object with name $instanceName is not registered inside GetIt");
      }
    }
    return object.getObject();
  }

  T call<T>([String instanceName]) {
    return get<T>(instanceName);
  }

  /// registers a type so that a new instance will be created on each call of [get] on that type
  /// [T] type to register
  /// [fun] factory funtion for this type
  void registerFactory<T>(FactoryFunc<T> func, [String instanceName]) {
    _register<T>(
        type: _ServiceFactoryType.alwaysNew,
        instanceName: instanceName,
        factoryFunc: func);
  }

  /// registers a type as Singleton by passing a factory function that will be called on the first call of [get] on that type
  /// [T] type to register
  /// [fun] factory funtion for this type
  void registerLazySingleton<T>(FactoryFunc<T> func, [String instanceName]) {
    _register<T>(
        type: _ServiceFactoryType.lazy,
        instanceName: instanceName,
        factoryFunc: func);
  }

  /// registers a type as Singleton by passing an instance that will be returned on each call of [get] on that type
  /// [T] type to register
  /// [fun] factory funtion for this type
  void registerSingleton<T>(T instance, [String instanceName]) {
    _register<T>(
        type: _ServiceFactoryType.constant,
        instanceName: instanceName,
        instance: instance);
  }

  void _register<T>(
      {@required _ServiceFactoryType type,
      FactoryFunc factoryFunc,
      T instance,
      @required String instanceName}) {
    assert(allowReassignment || !_factories.containsKey(T),
        "Type ${T.toString()} is already registered");
    assert(
      instanceName != null ||
          (allowReassignment || !_factoriesByName.containsKey(instanceName)),
      "An object of name $instanceName is already registered",
    );

    var serviceFactory = _ServiceFactory<T>(type,
        creationFunction: factoryFunc, instance: instance);
    if (instanceName == null) {
      _factories[T] = serviceFactory;
    } else {
      _factoriesByName[instanceName] = serviceFactory;
    }
  }

  /// Clears all registered types. Handy when writing unit tests
  void reset() {
    _factories.clear();
    _factoriesByName.clear();
  }

  void resetViewModel<T extends ViewModel>() {
    var instance = _factories[T];
    if (instance != null) {
      (instance.instance as ViewModel).dispose();
      instance?.cleanInstance();
    }
  }
}

enum _ServiceFactoryType { alwaysNew, constant, lazy }

class _ServiceFactory<T> {
  _ServiceFactoryType type;
  FactoryFunc creationFunction;
  Object instance;

  _ServiceFactory(this.type, {this.creationFunction, this.instance});

  T getObject() {
    try {
      switch (type) {
        case _ServiceFactoryType.alwaysNew:
          return creationFunction() as T;
          break;
        case _ServiceFactoryType.constant:
          return instance as T;
          break;
        case _ServiceFactoryType.lazy:
          if (instance == null) {
            instance = creationFunction();
          }
          return instance as T;
          break;
      }
    } catch (e, s) {
      print("Error while creating ${T.toString()}");
      print('Stack trace:\n $s');
      rethrow;
    }
    return null; // should never get here but to make the analyzer happy
  }

  void cleanInstance() {
    instance = null;
  }
}

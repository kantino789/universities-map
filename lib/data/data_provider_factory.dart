import 'package:universities_map/config.dart';
import 'package:universities_map/data/data_provider_interface.dart';
import 'package:universities_map/data/debug_data_provider.dart';
import 'package:universities_map/data/provider_factory_stub.dart'
    if (dart.library.io) 'package:universities_map/data/provider_factory_native.dart'
    as platform;

Future<IDataProvider> createDataProvider(Config config) {
  if (config == Config.debug) {
    return Future.value(DebugDataProvider());
  }
  return platform.createReleaseProvider();
}
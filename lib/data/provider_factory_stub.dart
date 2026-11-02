import 'package:universities_map/data/data_provider_interface.dart';
import 'package:universities_map/data/debug_data_provider.dart';

Future<IDataProvider> createReleaseProvider() async => DebugDataProvider();
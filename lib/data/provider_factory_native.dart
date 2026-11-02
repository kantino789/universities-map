import 'package:universities_map/data/data_provider.dart';
import 'package:universities_map/data/data_provider_interface.dart';

Future<IDataProvider> createReleaseProvider() => DataProvider.open();
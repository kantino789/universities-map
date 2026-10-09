import 'package:flutter/material.dart';
import 'package:property_change_notifier/property_change_notifier.dart';
import 'package:universities_map/view/pages/main_page.dart';
import 'package:universities_map/model/editor.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final editor = Editor();
  await editor.loadPois();
  runApp(MyApp(editor: editor));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.editor});

  final Editor editor;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StringPropertyChangeProvider<Editor>(
      value: editor,
      child: MaterialApp(
        title: 'Universities Map',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
        home: const MainPage(),
      ),
    );
  }
}

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'viewmodel/setting_view_model.dart';
import 'package:provider/provider.dart';
import 'viewmodel/task_view_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import '/home.dart';
import 'UI/mytheme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.windows ||
          defaultTargetPlatform == TargetPlatform.macOS ||
          defaultTargetPlatform == TargetPlatform.linux)) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;

    final database = openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      join(await getDatabasesPath(), 'tasks_database.db'),

      onCreate: (db, version) {
        // Run the CREATE TABLE statement on the database.
        return db.execute(
          'CREATE TABLE task (id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, description TEXT, tags TEXT, nbhours INTEGER, difficulty INTEGER, color TEXT)',
        );
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    );

    // Get a reference to the database.
    final db = await database;

    runApp(MyTD4(db)); // runApp
  }
}

class MyTD4 extends StatelessWidget {
  final Database database;
  const MyTD4(this.database, {super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => SettingViewModel(),
        ), //getSettings est appelee dans le constructeur
        ChangeNotifierProvider(create: (_) => TaskViewModel(database)),
      ],
      child: Consumer<SettingViewModel>(
        builder: (context, SettingViewModel notifier, child) {
          return MaterialApp(
            theme: notifier.isDark ? MyTheme.dark() : MyTheme.light(),
            title: 'TD4',
            home: Home(),
          );
        },
      ),
    );
  }
}

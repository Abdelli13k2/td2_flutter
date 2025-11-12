import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:td2_app/models/viewmodel.dart';
import 'package:td2_app/viewmodel/setting_view_model.dart';
import 'UI/mytheme.dart';
import '/home.dart';

void main() {
  runApp(MyTD2App());
}

class MyTD2App extends StatelessWidget {
  const MyTD2App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<SettingViewModel>(
          create: (_) {
            SettingViewModel settingsViewModel = SettingViewModel();
            //getSettings() est déjà appelé dans le constructeur
            return settingsViewModel;
          },
        ),
        ChangeNotifierProvider(
          create: (_) {
            TaskViewModel taskViewModel = TaskViewModel();
            taskViewModel.generateTask();
            return taskViewModel;
          },
        ),
      ],
      child: Consumer(
        builder: (context, SettingViewModel notifier, child) {
          return MaterialApp(
            theme: notifier.isDark ? MyTheme.dark() : MyTheme.light(),
            title: "TD2",
            home: Home(),
          );
        },
      ),
    );
  }
}

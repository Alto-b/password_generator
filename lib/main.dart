import 'package:flutter/cupertino.dart';
import 'package:upgrader/upgrader.dart';

import 'imports.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // return MaterialApp(
    //   debugShowCheckedModeBanner: false,
    //   title: 'SecurePass',
    //   theme: ThemeData(
    //     colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
    //     useMaterial3: true,
    //   ),
    //   home: HomePage()
    // );
    return PlatformProvider(
      builder: (context) => PlatformTheme(
        builder:(context) =>  PlatformApp(
          debugShowCheckedModeBanner: false,
          localizationsDelegates: <LocalizationsDelegate<dynamic>>[
            DefaultMaterialLocalizations.delegate,
            DefaultWidgetsLocalizations.delegate,
            DefaultCupertinoLocalizations.delegate
          ],
          title: "SecurePass",
          home: UpgradeAlert(
            child: HomePage(),
            barrierDismissible: true,
            showReleaseNotes: true,
            ),
        ), ),);
  }
}

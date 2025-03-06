import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:ifms/api/ApiProvider.dart';
import 'package:ifms/screens/farmers/MLLoginScreen.dart';
import 'package:ifms/screens/MLSplashScreen.dart';
import 'package:ifms/store/AppStore.dart';
import 'package:ifms/utils/AppTheme.dart';
import 'package:ifms/utils/MLDataProvider.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart'; // Importing provider package
import 'package:permission_handler/permission_handler.dart'; // Import permission handler

AppStore appStore = AppStore();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Request permissions here

  await initialize(aLocaleLanguageList: languageList());

  appStore.toggleDarkMode(value: getBoolAsync('isDarkModeOnPref'));

  runApp(const MyApp());
}

// Function to request necessary permissions

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Add any other providers that you need here
        ChangeNotifierProvider(
          create: (context) => FarmersProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => FarmerViewProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => NotificationsProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => RecentInspectionsProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ChecklistProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => CropsProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ChecklistProvider(),
        ),
      ],
      child: Observer(
        builder: (_) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: '${'farmexceed'}${!isMobile ? ' ${platformName()}' : ''}',
          home: MLSplashScreen(),
          theme: !appStore.isDarkModeOn
              ? AppThemeData.lightTheme
              : AppThemeData.darkTheme,
          navigatorKey: navigatorKey,
          scrollBehavior: SBehavior(),
          supportedLocales: LanguageDataModel.languageLocales(),
          localeResolutionCallback: (locale, supportedLocales) => locale,
        ),
      ),
    );
  }
}

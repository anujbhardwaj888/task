import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// ignore: depend_on_referenced_packages

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:hastar/config/g_storage.dart';
import 'package:hastar/config/theme/g_colors.dart';
import 'package:hastar/config/theme/g_theme.dart';
import 'package:tekki_web_solution_assignment/firebase_options.dart';
import 'package:tekki_web_solution_assignment/providers/getx_bindings.dart';
import 'package:tekki_web_solution_assignment/routes/routes.dart';
import 'package:permission_handler/permission_handler.dart';

late GAppTheme gTheme;

GStorage gStorage = GStorage();

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage event) async {
  // ignore: avoid_print
  print(
      " on kill     event :$event  data:  ${event.data}  title : ${event.notification?.title}  body :  ${event.notification?.body}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  var fcmToken = await FirebaseMessaging.instance.getToken();

  debugPrint('-----fcmToken-->$fcmToken');

  await Permission.notification.isDenied.then((value) async {
    if (value) {
      await Permission.notification.request().then((value) async {
        if (value.isGranted) {
          FirebaseMessaging.instance.getInitialMessage().then((event) async {
            debugPrint(
                " on init     event :$event  data:  ${event?.data}  title : ${event?.notification?.title}  body :  ${event?.notification?.body}");
          });

          FirebaseMessaging.onMessage.listen((event) async {
            // FlutterBackgroundService().invoke("setAsForeground");
            debugPrint(
                "  app forground       event :$event  data:  ${event.data}  title : ${event.notification?.title}  body :  ${event.notification?.body}");
          });

          FirebaseMessaging.onBackgroundMessage(
              _firebaseMessagingBackgroundHandler);
        }
      });
    }
  });

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await gStorage.init();

  runApp(const MyApp());

  gTheme = GAppTheme.init(
    lPrimaryColor: GColors().hexToColor("#248F98"),
    dPrimaryColor: Colors.black,
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  // This widget is the root of your application.
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: ScreenUtil.defaultSize,
        builder: (context, child) {
          return GetMaterialApp(
            themeMode: ThemeMode.system,
            debugShowCheckedModeBanner: false,
            getPages: Routes().getPages(),
            initialRoute: Routes.initialRoute,
            initialBinding: GetXBindings(),
            darkTheme: gTheme.lightTheme,
            theme: gTheme.lightTheme,
          );
        });
  }
}
// TODO GHOST #

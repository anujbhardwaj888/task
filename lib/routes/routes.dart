import 'package:get/get.dart';
import 'package:tekki_web_solution_assignment/chatScreen/chat_screen.dart';
import 'package:tekki_web_solution_assignment/views/sign_in_screen.dart';
import 'package:tekki_web_solution_assignment/views/splash_screen.dart';

class Routes {
  //  * Variables * //
  static const String initialRoute = '/';
  static const String chatScreenRoute = '/chatScreen';
  static const String signScreenRoute = '/signScreenRoute';

  /// * Constructors * ///
  Routes();

  //  * Functions * //
  List<GetPage<dynamic>>? getPages() {
    return [
      GetPage(name: initialRoute, page: () => const SplashScreen()),
      GetPage(name: chatScreenRoute, page: () => const ChatScreen()),
      GetPage(name: signScreenRoute, page: () => const SignInScreen()),
    ];
  }
}

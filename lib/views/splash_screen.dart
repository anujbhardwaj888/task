//  * Flutter Imports * //
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:hastar/haster.dart';
import 'package:tekki_web_solution_assignment/routes/routes.dart';

//  * Third Party Imports * //

//  * Custom Imports * //

class SplashScreen extends StatefulWidget {
  //  * Parameters * //

  //  * Constructor * //
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  //  * Variables * //

  //  * Functions * //
  void navigateTo() async {
    Get.offNamedUntil(Routes.signScreenRoute, (route) => false);
  }
  //  * Overrides * //

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 2)).then((value) => navigateTo());
    super.initState();
  }

  //  * Build * //
  @override
  Widget build(BuildContext context) {
    return GBlank(
      removeAppBar: true,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GSpace.s15,
          Center(
            child: Image.network(
              'https://media.licdn.com/dms/image/v2/C560BAQGy7ZweUiO3xA/company-logo_200_200/company-logo_200_200/0/1630628470928/tekki_web_solutions_pvt_ltd_logo?e=2147483647&v=beta&t=DfmgNYaRvGFFYWy-82U23Cev63rpNXyq-2q99qr6xgU',
              height: GResponsive().hX(0.45),
              width: GResponsive().hX(0.45),
            ),
          ),
          Text(
            "Tekki Web Solutions",
            style:
                context.style.t24.bold.colored(Theme.of(context).primaryColor),
          ),
          Text(
            "Flutter Assignment",
            style: context.style.t14.bold,
          )
        ].separateBy(GSpace.s2),
      ),
    );
  }

  //....
  ///
  /// ** Custom Widgets **
  ///
  //....
}

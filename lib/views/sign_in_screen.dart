//  * Flutter Imports * //
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hastar/haster.dart';
import 'package:tekki_web_solution_assignment/routes/routes.dart';
import 'package:tekki_web_solution_assignment/service/auth_service.dart';

//  * Third Party Imports * //

//  * Custom Imports * //

class SignInScreen extends StatefulWidget {
  //  * Parameters * //

  //  * Constructor * //
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  //  * Variables * //
  final AuthService _authService = AuthService();
  //  * Functions * //

  //  * Overrides * //

  //  * Build * //
  @override
  Widget build(BuildContext context) {
    return GBlank(
      removeAppBar: true,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              'https://media.licdn.com/dms/image/v2/C560BAQGy7ZweUiO3xA/company-logo_200_200/company-logo_200_200/0/1630628470928/tekki_web_solutions_pvt_ltd_logo?e=2147483647&v=beta&t=DfmgNYaRvGFFYWy-82U23Cev63rpNXyq-2q99qr6xgU',
              height: GResponsive().hX(0.40),
              width: GResponsive().hX(0.45),
            ),
            GButtonWithFrontIcon(
              borderColor: Theme.of(context).primaryColor,
              buttonColor: Theme.of(context).scaffoldBackgroundColor,
              textColor: Theme.of(context).primaryColor,
              icon: const Icon(FontAwesomeIcons.google),
              text: "   Continue with Google",
              onTap: () async {
                final user = await _authService.signInWithGoogle();

                if (user != null) {
                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Welcome ${user.displayName}")));
                  Get.offNamedUntil(
                    Routes.chatScreenRoute, (route) => false,
                    // arguments: {"data": user}
                  );
                }
              },
              radius: 8,
            ),
            GSpace.s10,
          ].separateBy(GSpace.s10),
        ),
      ),
    );
  }

  //....
  ///
  /// ** Custom Widgets **
  ///
  //....
}

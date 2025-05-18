import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rateit/helpers/colors.dart';
import 'package:rateit/helpers/widgets.dart';
import 'package:rateit/services/api.service.dart';
import 'package:rateit/views/auth/auth_cubit.dart';
import 'package:rateit/views/login/login_page.dart';
import 'package:rateit/views/temp.dart';
import 'package:sizer/sizer.dart';

import 'helpers/router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); //is required in Flutter v1.9.4+ before using any plugins if the code is executed before runApp.
  await ApiService.init();
  runApp(
      BlocProvider(
        create: (context) => AuthCubit()..checkAuthentication(),
        child: RateItApp()
      )
  );
}

class RateItApp extends StatelessWidget {
  const RateItApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: ColorsPalette.flirtatious,
          scaffoldBackgroundColor: ColorsPalette.white,
          textTheme: GoogleFonts.playpenSansTextTheme(Theme.of(context).textTheme),
          colorScheme: ColorScheme.fromSwatch().copyWith(
              secondary: ColorsPalette.turquoiseTopaz,
              outline: ColorsPalette.boyzone
          ),
        ),
        home: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state){
            if(state is Uninitialized) {return Scaffold(
              body: Container(
                alignment: Alignment.center,
                child: loadingWidget(ColorsPalette.boyzone),
              ),
            );}
            if (state is Unauthenticated) return LoginPage();
            if (state is Authenticated) return Temp();
            return SizedBox(height:0);
          }            
        ),
        //home: const LoginPage(),
        onGenerateRoute: RouteGenerator.generateRoute,
      );
    });
  }
}
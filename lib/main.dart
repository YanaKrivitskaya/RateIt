
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rateit/helpers/colors.dart';
import 'package:rateit/helpers/widgets.dart';
import 'package:rateit/services/api.service.dart';
import 'package:rateit/views/auth/cubit/auth_cubit.dart';
import 'package:rateit/views/auth/login/login.page.dart';
import 'package:rateit/views/home/home.page.dart';
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

final globalScaffoldMessenger = GlobalKey<ScaffoldMessengerState>();

class RateItApp extends StatelessWidget {
  const RateItApp({super.key});


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    /*SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top]);*/
    return Sizer(builder: (context, orientation, deviceType) {
      return MaterialApp(
        scaffoldMessengerKey: globalScaffoldMessenger,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: ColorsPalette.flirtatious,
          scaffoldBackgroundColor: ColorsPalette.white,
          textTheme: GoogleFonts.playpenSansTextTheme(Theme.of(context).textTheme).apply(
            fontSizeFactor: 1.1,
            fontSizeDelta: 2.0
          ),
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
            if (state is Authenticated) return HomePage();
            return SizedBox(height:0);
          }            
        ),
        onGenerateRoute: RouteGenerator.generateRoute,
      );
    });
  }
}
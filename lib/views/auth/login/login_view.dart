import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rateit/helpers/colors.dart';
import 'package:rateit/helpers/styles.dart';
import 'package:rateit/views/auth/login/cubit/login_cubit.dart';

import '../../../helpers/route_constants.dart';
import '../../../helpers/widgets.dart';
import '../../../main.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    //_loginSignupBloc = BlocProvider.of<LoginSignupBloc>(context);
    //_errorMessage = "";
  }

  @override
  void dispose(){
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state){
        if(state is LoginStateError){
          var duration = Duration(days: 1);
          globalScaffoldMessenger.currentState!
            ..hideCurrentSnackBar()
            ..showSnackBar(customSnackBar(SnackBarState.error, state.error, duration));
        }
        if(state is LoginStateLoading){
          var duration = Duration(days: 1);
          globalScaffoldMessenger.currentState!
            ..hideCurrentSnackBar()
            ..showSnackBar(customSnackBar(SnackBarState.loading, null, duration));
        }
        if(state is LoginStateSuccess){
          globalScaffoldMessenger.currentState!
            .hideCurrentSnackBar();
          Navigator.pushNamed(context, otpVerificationRoute, arguments: state.email);
        }
      },
      child: BlocBuilder<LoginCubit, LoginState>(
          builder: (context, state) {
            return SingleChildScrollView(
                child: Column(
                    children: [
                      SizedBox(height: sizerHeight),
                      _header(),
                      SizedBox(height: sizerHeight),
                      SizedBox(
                          width: fullWidth < 600 ? width80 : 600,
                          child: Column(
                              children: [
                                Text("Email", style: appTextStyle(color: ColorsPalette.boyzone, fontSize: headerFontSize)),
                                _emailTextField(_emailController, state),
                              ])),
                      SizedBox(height: formPaddingHeight),
                      _submitButton(context, _emailController.text)
                    ]));
          })
    );
  }
  Widget _header() => Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text("Rate it!", style: headerTextStyle(color: ColorsPalette.algalFuel, fontSize: 60.0)),
      ]);

  Widget _emailTextField(TextEditingController emailController, LoginState state) => TextFormField(
      decoration: const InputDecoration(
          label: Center(
            child: Text ("username@company.com"),
          ),
          floatingLabelBehavior: FloatingLabelBehavior.never,
          alignLabelWithHint: true
      ),
      textAlign: TextAlign.center,
      keyboardType: TextInputType.emailAddress,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: emailController
  );

  Widget _submitButton(BuildContext context, String email) => TextButton(
      style: ButtonStyle(
          fixedSize: WidgetStateProperty.all<Size>(const Size.fromWidth(120.0)),
          backgroundColor: WidgetStateProperty.all<Color>(ColorsPalette.algalFuel),
          foregroundColor: WidgetStateProperty.all<Color>(ColorsPalette.white)
      ),
      onPressed: () {
        context.read<LoginCubit>().sendOtpToEmail(_emailController.text);
      },
      child: const Text("Submit")
  );

}







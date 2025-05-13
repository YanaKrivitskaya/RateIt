import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rateit/helpers/colors.dart';
import 'package:rateit/helpers/styles.dart';
import 'package:rateit/views/login/cubit/login_cubit.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose(){
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(fullWidth);
    return Scaffold(
      body: BlocBuilder<LoginCubit, LoginState>(
        builder: (context, state) {
          return Column(
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
                  ],
                )
              ),
              SizedBox(height: formPaddingHeight),
              _submitButton(context)
            ],
          );
        },
      ),
    );
  }
}

Widget _header() => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Text("Rate It!", style: headerTextStyle(color: ColorsPalette.algalFuel, fontSize: 60.0)),
    ],
  );

Widget _emailTextField(TextEditingController emailController, LoginState state) => new TextFormField(
    decoration: const InputDecoration(
      //labelText: 'Email',
        hintText: "username@company.com"
    ),
    textAlign: TextAlign.center,
    keyboardType: TextInputType.emailAddress,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    validator: (_) {
      //return (state is LoginStateEdit && !state.isEmailValid) ? 'Invalid Email' : null;
    },
    controller: emailController
);

Widget _submitButton(BuildContext context) => TextButton(
    style: ButtonStyle(
        fixedSize: WidgetStateProperty.all<Size>(const Size.fromWidth(120.0)),
        backgroundColor: WidgetStateProperty.all<Color>(ColorsPalette.algalFuel),
        foregroundColor: WidgetStateProperty.all<Color>(ColorsPalette.white)
    ),
    onPressed: () {
      /*Navigator.pushNamed(context, newGameRoute).then((value) {
        context.read<HomeCubit>().getCurrentGame();
      });*/
    },
    child: const Text("Submit")
);



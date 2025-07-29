import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';
import 'package:otp_timer_button/otp_timer_button.dart';
import 'package:rateit/helpers/colors.dart';
import 'package:rateit/helpers/styles.dart';
import 'package:rateit/views/auth/cubit/auth_cubit.dart';

import 'package:rateit/helpers/widgets.dart';
import 'package:rateit/main.dart';
import 'cubit/otp_cubit.dart';

class OtpVerificationView extends StatefulWidget {
  final String email;
  OtpVerificationView(this.email);

  @override
  _OtpVerificationViewState createState() => _OtpVerificationViewState();
}

class _OtpVerificationViewState extends State<OtpVerificationView> {
  final pinController = TextEditingController();
  final focusNode = FocusNode();

  OtpTimerButtonController otpController = OtpTimerButtonController();

  // declare as global
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    pinController.addListener(_onPinChanged);
  }

  @override
  void dispose(){
    pinController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 60,
      height: 64,
      textStyle: appTextStyle(fontSize: 20, color: ColorsPalette.black),
      decoration: BoxDecoration(
        color: ColorsPalette.lynxWhite,
        borderRadius: BorderRadius.circular(24),
      ),
    );

    final cursor = Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: 21,
        height: 1,
        margin: EdgeInsets.only(bottom: sizerHeightsm),
        decoration: BoxDecoration(
          color: Color.fromRGBO(137, 146, 160, 1),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );

    return Scaffold(
      key: _scaffoldKey,
      body: BlocListener<OtpCubit, OtpState>(
        listener: (context, state){
          if(state is OtpInitial){
            globalScaffoldMessenger.currentState!
              .hideCurrentSnackBar();
            pinController.text = '';
          }
          if(state is OtpStateError){
            pinController.text = '';
            var duration = Duration(days: 1);
            globalScaffoldMessenger.currentState!
              ..hideCurrentSnackBar()
              ..showSnackBar(customSnackBar(SnackBarState.error, state.error, duration));
          }
          if(state is OtpStateLoading){
            var duration = Duration(days: 1);
            globalScaffoldMessenger.currentState!
              ..hideCurrentSnackBar()
              ..showSnackBar(customSnackBar(SnackBarState.loading, null, duration));
          }
          if(state is OtpStateSuccess){
            ScaffoldMessenger.of(context).removeCurrentSnackBar();
            context.read<AuthCubit>().login(state.user);
            Navigator.pop(context);
          }
        },
        child: BlocBuilder<OtpCubit, OtpState>(
          builder: (context, state){
            return Center(
                child: SingleChildScrollView(
                  child: Container(
                    margin: EdgeInsets.all(viewPadding),
                    child: Column(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(top: formTopPadding, left: viewPadding, right: viewPadding, bottom: viewPadding),
                          height: scrollViewHeightLg,
                          child: _pinForm(pinController, defaultPinTheme, cursor, widget.email, otpController),
                        )
                      ],
                    ),
                  ),
                )
            );
          }
      ),
      )
    );
  }

  Widget _pinForm(TextEditingController pinController, PinTheme defaultTheme,
      Widget cursor, String email, OtpTimerButtonController otpController) => Container(
    child: Column(children: [
      Column(mainAxisSize: MainAxisSize.min, children: [
        Text("Verification",
            style: appTextStyle(fontSize: headerFontSize, weight: FontWeight.w700, color: ColorsPalette.boyzone)),
        SizedBox(height: sizerHeightlg),
        Text(
          'Enter the code sent to the email',
          style: appTextStyle(color: ColorsPalette.black),
        ),
        Text(
          email,
          style: appTextStyle(color: ColorsPalette.boyzone),
        ),
        SizedBox(height: sizerHeightlg),
        InkWell(
          child: Text("Wrong email?", style: appTextStyle(
              fontSize: fontSize,
              color: ColorsPalette.black,
              decoration: TextDecoration.underline
          )),
          onTap: () => Navigator.pop(context),
        ),
        SizedBox(height: formBottomPadding)
      ]),
      SizedBox(height: sizerHeightsm),
      Pinput(
        length: 4,
        controller: pinController,
        focusNode: focusNode,
        defaultPinTheme: defaultTheme,
        focusedPinTheme: defaultTheme.copyWith(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.05999999865889549),
                offset: Offset(0, 3),
                blurRadius: 16,
              )
            ],
          ),
        ),
        showCursor: true,
        cursor: cursor,
      ),
      SizedBox(height: formBottomPadding),
      Text(
        'Didn’t receive a code?',
        style: appTextStyle(
          fontSize: fontSize,
          color: ColorsPalette.boyzone,
      )),
      OtpTimerButton(
        controller: otpController,
        onPressed: () {
          otpController.startTimer();
          context.read<OtpCubit>().resendOtp(widget.email);
        },
        text: Text('Resend', style: appTextStyle(color: ColorsPalette.lynxWhite)),
        duration: 60,
        backgroundColor: ColorsPalette.boyzone,
      ),
    ],)
  );

  void _onPinChanged() {
    var pin = pinController.text;
    if(pin.length == 4){
      context.read<OtpCubit>().verifyOtp(pin, widget.email);
    }
  }
}

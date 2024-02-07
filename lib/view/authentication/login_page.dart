import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:testapp_1/bloc/auth_bloc/auth_bloc.dart';
import 'package:testapp_1/view/authentication/signup_page.dart';
import '../../helpers/factory.dart';
import '../../helpers/spacer.dart';
import '../home/home_page.dart';

class LoginPage extends StatefulWidget {
  static const String route = "/login";
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        bottom: false,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              right: 0,
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Image.asset(
                  "assets/images/splash_bg.gif",
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(30),
                        child: Text(
                          "Login to Dashboard account",
                          style: GoogleFonts.roboto().copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 34,
                          ),
                        ),
                      ),
                      vSpacing(40),
                      const _LoginPageBuilder(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoginPageBuilder extends StatefulWidget {
  const _LoginPageBuilder({super.key});

  @override
  State<_LoginPageBuilder> createState() => _LoginPageBuilderState();
}

class _LoginPageBuilderState extends State<_LoginPageBuilder> {
  bool passwordVisibility = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey();
  AuthBloc authBloc = AuthBloc();

  // late AuthenticationBloc bloc;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc,AuthStates>(
      bloc: authBloc,
      listener: (context, state) {
        if(state is AuthInProgress) {
          showDialog(context: context,
            barrierDismissible: false,
            builder: (context) => const AlertDialog(
            content: SizedBox(
              height: 100,
              child:
                Center(child: CircularProgressIndicator(),),

            ),
          ),);
        } else if (state is AuthFailed) {
          Navigator.of(context).pop();
          showDialog(context: context, builder: (context) => AlertDialog(
            content: Text(state.errorMessage),
          ),);

        } else if(state is AuthSuccessful) {
          Navigator.of(context).pop();
          Navigator.of(context).pushNamed(HomePageScreen.route);

        }
      },
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Column(
          children: [
            Container(
              // margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.3),
              height: MediaQuery.of(context).size.height * 0.7,
              padding: const EdgeInsets.only(
                top: 32,
                left: 32,
                right: 32,
              ),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    offset: Offset(0, 4),
                    blurRadius: 20,
                    spreadRadius: 10,
                  ),
                ],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                color: Colors.white.withOpacity(0.92),
              ),
              child: SingleChildScrollView(
                child: SizedBox(
                  height: 540,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Login",
                        style: GoogleFonts.roboto().copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: 36,
                        ),
                      ),
                      vSpacing(25),
                      Row(
                        children: [
                          Text(
                            "Don't have an account?",
                            style: GoogleFonts.roboto(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pushNamed(SignupScreen.route);
                            },
                            child: Text(
                              " Sign up here!",
                              style: GoogleFonts.roboto(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      vSpacing(20),
                      _authFields()
                      // vSpacing(56),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _authFields() {
    return Form(
      key: formKey,
      child: Column(
        children: [
          TextFormField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            cursorColor: Theme.of(context).primaryColor,
            validator: (v){
              if(!validateEmailAddress(emailController.text) && emailController.text.isNotEmpty){
                return "Enter a valid email address";
              }else if(emailController.text.isEmpty){
                return "Enter your email address";
              }
            },
            decoration: InputDecoration(
              prefixIconConstraints:
                  const BoxConstraints(minHeight: 0, minWidth: 30, maxHeight: 5),
              isDense: true,
              prefix: const Padding(
                padding: EdgeInsets.all(8.0),
                child: FaIcon(
                  Icons.mail_outline,
                  size: 18,
                ),
              ),
              alignLabelWithHint: true,
              labelText: "Email",
              labelStyle: GoogleFonts.roboto(
                color: Colors.black,
              ),
              floatingLabelAlignment: FloatingLabelAlignment.start,
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).primaryColor),
              ),
            ),
          ),
          vSpacing(10),
          TextFormField(
            controller: passwordController,
            cursorColor: Theme.of(context).primaryColor,
            keyboardType: TextInputType.text,
            obscureText: !passwordVisibility,
            validator: (v){
              if(passwordController.text.length < 8 && passwordController.text.isNotEmpty){
                return "Please enter 8 digit password";
              }else if(passwordController.text.isEmpty){
                return "Please enter your password";
              }
            },
            decoration: InputDecoration(
              prefix: const Padding(
                padding: EdgeInsets.all(8.0),
                child: FaIcon(
                  Icons.lock,
                  size: 18,
                ),
              ),
              suffix: InkWell(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    !passwordVisibility ? Icons.visibility_off : Icons.visibility,
                    size: 18,
                  ),
                ),
                onTap: () {
                  setState(() {
                    passwordVisibility = !passwordVisibility;
                  });
                },
              ),
              suffixIconColor: Colors.black,
              isDense: true,
              alignLabelWithHint: true,
              labelText: "Password",
              labelStyle: GoogleFonts.roboto(
                color: Colors.black,
              ),
              floatingLabelAlignment: FloatingLabelAlignment.start,
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).primaryColor),
              ),
            ),
          ),
          vSpacing(40),
          ElevatedButton(
            onPressed: () async {
              if(formKey.currentState?.validate() == true) {
                authBloc.add(LoginPressed(email: emailController.text, password: passwordController.text));

              }

            },
            child: Text(
              "LOGIN",
              style: ProjectProperty.fontFactory.robotoStyle.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          )
        ],
      ),
    );
  }

  bool validateEmailAddress(String value){
    const emailRegex = r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";

    if(RegExp(emailRegex).hasMatch(value)){
      return true;
    }else {
      return false;
    }
  }
}

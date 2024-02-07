import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:testapp_1/bloc/auth_bloc/auth_bloc.dart';
import 'package:testapp_1/view/home/home_page.dart';

import '../../helpers/factory.dart';
import '../../helpers/spacer.dart';

class SignupScreen extends StatefulWidget {
  static const String route = "/signup";
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  AuthBloc authBloc = AuthBloc();
  GlobalKey<FormState> formKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc,AuthStates>(
      bloc: authBloc,
      listener: (context,state){
        if(state is AuthInProgress){
          showDialog(context: context,
            barrierDismissible: false,
            builder: (context) => const AlertDialog(
              content: SizedBox(
                height: 100,
                child:
                Center(child: CircularProgressIndicator(),),

              ),
            ),);
        }else if (state is AuthFailed) {
          Navigator.of(context).pop();
          showDialog(context: context, builder: (context) => AlertDialog(
            content: Text(state.errorMessage),
          ),);

        }else{
          Navigator.pop(context);
          Navigator.of(context).pushNamed(HomePageScreen.route);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          elevation: 0,
          title: Text(
            "Sign up",
            style: ProjectProperty.fontFactory.robotoStyle.copyWith(
              fontWeight: FontWeight.w500,
              fontSize: 24,
            ),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Container(
                padding: const EdgeInsets.all(28),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      getCompulsoryHeading("Please fill all the mandatory details"),
                      vSpacing(35),
                      getCompulsoryHeading("Email", size: 14),
                      vSpacing(15),
                      CustomTextField(
                        controller: emailController,
                        validator: (v){
                          if(!validateEmailAddress(emailController.text) && emailController.text.isNotEmpty){
                            return "Enter a valid email address";
                          }else if(emailController.text.isEmpty){
                            return "Enter your email address";
                          }
                        },
                        hintText: "Enter Email ID",
                        iconWidgetUrl: "assets/images/mail.svg",
                      ),
                      vSpacing(35),
                      getCompulsoryHeading("Password", size: 14),
                      vSpacing(15),
                      CustomTextField(
                        controller: passwordController,
                        validator: (v){
                          if(passwordController.text.length < 8 && passwordController.text.isNotEmpty){
                            return "Please enter 8 digit password";
                          }else if(passwordController.text.isEmpty){
                            return "Please enter your password";
                          }
                        },
                        hintText: "Enter Password",
                        iconWidgetUrl: "assets/images/phone.svg",
                      ),
                      vSpacing(35),
                      vSpacing(40),
                      ElevatedButton(
                        onPressed: () {
                          if(formKey.currentState?.validate() == true) {
                            authBloc.add(SignUpPressed(email: emailController.text, password: passwordController.text));

                          }
                        },
                        child: Text(
                          "Sign Up",
                          style: ProjectProperty.fontFactory.robotoStyle.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                            color: Colors.white
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
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


  Widget getCompulsoryHeading(String text, {double size = 16}) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: [
          TextSpan(
            text: text,
            style: ProjectProperty.fontFactory.robotoStyle.copyWith(
              fontWeight: FontWeight.w400,
              fontSize: size,
              color: Colors.black,
            ),
          ),
          TextSpan(
            text: "  *",
            style: ProjectProperty.fontFactory.robotoStyle.copyWith(
              fontWeight: FontWeight.w800,
              fontSize: 16,
              color: ProjectProperty.colorFactory.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final String? iconWidgetUrl;
  final String hintText;
  final String? Function(String? v) validator;
  final TextEditingController controller;
  const CustomTextField({
    required this.hintText,
    this.iconWidgetUrl, required
    this.validator,
    super.key, required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (iconWidgetUrl != null)
          SizedBox(
            height: 16,
            width: 16,
            child: SvgPicture.asset(iconWidgetUrl!),
          ),
        hSpacing(10),
        Expanded(
          child: TextFormField(
            cursorColor: Theme.of(context).primaryColor,
            validator: validator,
            controller: controller,
            decoration: InputDecoration(
              prefixIconConstraints: const BoxConstraints(
                  minHeight: 0, minWidth: 30, maxHeight: 5),
              isDense: true,
              alignLabelWithHint: true,
              hintText: hintText,
              labelStyle: ProjectProperty.fontFactory.robotoStyle,
              floatingLabelAlignment: FloatingLabelAlignment.start,
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

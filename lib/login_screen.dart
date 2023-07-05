import 'package:flutter/material.dart';
import 'package:sizer_pro/sizer.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  // For Validating Forms
  final formkey = GlobalKey<FormState>();

  // For Checkbox control
  bool checkboxvalue = false;

  // Controllers for TextFields
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();

  final Decoration bgDecoration = BoxDecoration(
    border: Border.all(
      color: Colors.blue[200]!,
      width: 1.w,
    ),
    image: const DecorationImage(
        image: AssetImage(
          "img/back.jpg",
        ),
        fit: BoxFit.cover),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
          child: Container(
        width: SizerUtil.width,
        decoration: bgDecoration,
        child: Column(
          children: [
            SizedBox(
              height: 3.h,
            ),
            logoContainer(),
            SizedBox(
              height: 3.h,
            ),
            Form(
              key: formkey,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 1.h,
                  vertical: 5.w,
                ),
                margin: EdgeInsets.symmetric(
                  horizontal: 5.w,
                ),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.70),
                    borderRadius: BorderRadius.circular(5.sp)),
                child: Column(
                  children: [
                    usernameField(),
                    SizedBox(
                      height: 3.h,
                    ),
                    passwordField(),
                    SizedBox(
                      height: 1.2.h,
                    ),
                    showPasswordRow(),
                    loginButton(context),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        forgetPasswordButton(),
                        TextButton(
                          onPressed: () {
                            print("Don't have an account pressed");
                          },
                          child: Text("Don't have an account?",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11.sp,
                              )),
                        )
                      ],
                    ),
                    registerButton(),
                  ],
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }

  ElevatedButton registerButton() {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.pink,
        elevation: 0,
        fixedSize: Size(40.w, 4.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.sp),
        ),
      ),
      child: Text(
        "Register Now",
        style: TextStyle(
          fontSize: 12.sp,
          color: Colors.white,
        ),
      ),
    );
  }

  TextButton forgetPasswordButton() {
    return TextButton(
      onPressed: () {
        print('Forgot Password Pressed');
      },
      child: Text(
        "Forgot Password",
        style: TextStyle(
            color: Colors.blue, fontSize: 11.sp, fontWeight: FontWeight.bold),
      ),
    );
  }

  ElevatedButton loginButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () => onLoginPressed(context),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        fixedSize: Size(40.w, 4.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.sp),
        ),
      ),
      child: Text(
        "Login",
        style: TextStyle(
          fontSize: 12.sp,
          color: Colors.white,
        ),
      ),
    );
  }

  void onLoginPressed(BuildContext context) {
    if (formkey.currentState!.validate()) {
      print("Validated");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.black,
          content: Text(
            'Login In Successful',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.pink,
              fontSize: 15.sp,
            ),
          ),
          duration: const Duration(seconds: 2),
          action: SnackBarAction(
            label: 'Okay',
            onPressed: () {},
          ),
        ),
      );
    }
  }

  Row showPasswordRow() {
    return Row(
      children: [
        SizedBox(
          width: 15.w,
        ),
        Checkbox(
          value: checkboxvalue,
          focusColor: Colors.pink,
          hoverColor: Colors.pink,
          fillColor: MaterialStateColor.resolveWith(
            (states) {
              if (states.contains(MaterialState.selected)) {
                return Colors.pink; // the color when checkbox is selected;
              }
              return Colors.white; //the color when checkbox is unselected;
            },
          ),
          onChanged: (value) {
            setState(() {
              checkboxvalue = value!;
            });
          },
          checkColor: Colors.white,
        ),
        Text(
          "Show Password",
          style: TextStyle(
            color: Colors.pink,
            fontWeight: FontWeight.bold,
            fontSize: 13.sp,
          ),
        ),
      ],
    );
  }

  Container passwordField() {
    return Container(
      height: 5.h,
      padding: EdgeInsets.symmetric(
        horizontal: 20.sp,
      ),
      child: TextFormField(
        controller: _password,
        validator: (value) {
          if (value!.isEmpty) {
            return "Please Enter your Password";
          }
          // else if (value.length >= 10) {
          //   return "Password too Long";
          // }
          else if (value.length <= 5) {
            return "Password too short";
          }
          return null;
        },
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 15.sp,
          height: 2.2,
        ),
        obscureText: !checkboxvalue,
        decoration: InputDecoration(
          icon: Icon(
            Icons.lock,
            size: 21.sp,
            color: Colors.white,
          ),
          hintText: " Password",
          hintStyle: TextStyle(
            color: Colors.white,
            fontSize: 15.sp,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white, width: 1),
            borderRadius: BorderRadius.circular(18.sp),
          ),
        ),
      ),
    );
  }

  Container usernameField() {
    return Container(
      height: 5.h,
      padding: EdgeInsets.symmetric(
        horizontal: 20.sp,
      ),
      child: TextFormField(
        controller: _username,
        validator: (value) {
          if (value!.isEmpty) {
            return "Please Enter your Username";
          }
          // else if (value.length >= 10) {
          //   return "Name too Long";
          // }
          else if (value.length <= 5) {
            return "Name too short";
          }
          return null;
        },
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 15.sp,
          height: 2.2,
        ),
        decoration: InputDecoration(
          icon: Icon(
            Icons.person,
            size: 21.sp,
            color: Colors.white,
          ),
          hintText: " Enter Username",
          hintStyle: TextStyle(
            color: Colors.white,
            fontSize: 15.sp,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white, width: 1),
            borderRadius: BorderRadius.circular(18.sp),
          ),
        ),
      ),
    );
  }

  Container logoContainer() {
    return Container(
      width: 50.w,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.sp),
          border: Border.all(
            color: Colors.blue,
            width: 2,
          )),
      child: const Image(
        image: AssetImage("img/logo.png"),
        fit: BoxFit.cover,
      ),
    );
  }
}

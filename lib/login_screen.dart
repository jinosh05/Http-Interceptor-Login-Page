import 'package:flutter/material.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:login_page/api_client.dart';
import 'package:login_page/common.dart';
import 'package:sizer_pro/sizer.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  LoginRepository repository = LoginRepository(
    InterceptedClient.build(
      interceptors: [
        LoginInterceptor(),
        LoggerInterceptor(),
      ],
      retryPolicy: ExpiredTokenRetryPolicy(),
    ),
  );

  @override
  void dispose() {
    repository.client.close();
    super.dispose();
  }

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
                      height: 1.h,
                    ),
                    showPasswordRow(),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "Forgot Password",
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: 8.f,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    loginButton(context),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                      child: Text(
                        "Don't have an account?",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10.f,
                        ),
                      ),
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
          fixedSize: Size(40.w, 18.f),
          shape: const StadiumBorder()),
      child: Text(
        "Register Now",
        style: TextStyle(
          fontSize: 10.f,
          color: Colors.white,
        ),
      ),
    );
  }

  ElevatedButton loginButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () => onLoginPressed(context),
      style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(
            vertical: 3.f,
            horizontal: 10.w,
          ),
          backgroundColor: Colors.blue,
          shape: const StadiumBorder()),
      child: Text(
        "Login",
        style: TextStyle(
          fontSize: 10.f,
          color: Colors.white,
        ),
      ),
    );
  }

  void onLoginPressed(BuildContext context) async {
    if (formkey.currentState!.validate()) {
      debugPrint("Validated");
      var response = await repository.login(
        username: _username.text,
        password: _password.text,
      );
      if (response['status'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.black,
            content: Text(
              'Login In Successful',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.pink,
                fontSize: 10.f,
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
  }

  Row showPasswordRow() {
    return Row(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(10.f, 0, 5.sp, 0),
          child: Checkbox(
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
        ),
        Text(
          "Show Password",
          style: TextStyle(
            color: Colors.purple,
            fontSize: 8.f,
          ),
        ),
      ],
    );
  }

  Padding passwordField() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.f),
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
          fontSize: 10.f,
        ),
        obscureText: !checkboxvalue,
        decoration: InputDecoration(
          icon: Icon(
            Icons.lock,
            size: 15.sp,
            color: Colors.white,
          ),
          isDense: true,
          hintText: " Password",
          hintStyle: TextStyle(
            color: Colors.white,
            fontSize: 10.f,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white, width: 1),
            borderRadius: BorderRadius.circular(18.sp),
          ),
        ),
      ),
    );
  }

  Padding usernameField() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 10.f,
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
          fontSize: 10.f,
        ),
        decoration: InputDecoration(
          icon: Icon(
            Icons.person,
            size: 15.f,
            color: Colors.white,
          ),
          isDense: true,
          hintText: " Enter Username",
          hintStyle: TextStyle(
            color: Colors.white,
            fontSize: 10.f,
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

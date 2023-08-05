import 'package:sizer/sizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_dumy/utils/colors.dart';
import 'package:instagram_dumy/widgets/widgets.dart';
import 'package:instagram_dumy/screens/signup_screen.dart';
import 'package:instagram_dumy/services/auth_services.dart';
import 'package:instagram_dumy/screens/main_user_screen.dart';
import 'package:instagram_dumy/services/shared_preference.dart';

class Loginscreen extends StatefulWidget {
  const Loginscreen({super.key});

  @override
  State<Loginscreen> createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {
  late final TextEditingController emailcontroller = TextEditingController();
  late final TextEditingController passwordcontroller = TextEditingController();
  final ValueNotifier<bool> toggle = ValueNotifier<bool>(true);
  final formkey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailcontroller.dispose();
    passwordcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final inputbortder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(5),
    );
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        // Body
        body: SafeArea(
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 25.sp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Expanded(child: SizedBox()),

                // Instagram-Logo
                SvgPicture.asset(
                  "assets/images/logo_name.svg",
                  // ignore: deprecated_member_use
                  color: primaryColor,
                  height: 60.sp,
                ),
                SizedBox(height: 40.sp),

                // Form fields
                Form(
                  key: formkey,
                  child: Column(
                    children: [
                      TextFormField(
                        autofocus: false,
                        controller: emailcontroller,
                        decoration: InputDecoration(
                          hintText: "Email",
                          border: inputbortder,
                          focusedErrorBorder: inputbortder,
                          enabledBorder: inputbortder,
                          filled: true,
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          return RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                          ).hasMatch(value!)
                              ? null
                              : "Please enter correct email";
                        },
                      ),

                      // Password field
                      SizedBox(height: 10.sp),
                      ValueListenableBuilder(
                        valueListenable: toggle,
                        builder: (context, value, child) {
                          return Column(
                            children: [
                              TextFormField(
                                controller: passwordcontroller,
                                obscureText: toggle.value,
                                obscuringCharacter: "*",
                                decoration: InputDecoration(
                                  hintText: "Password",
                                  border: inputbortder,
                                  focusedErrorBorder: inputbortder,
                                  enabledBorder: inputbortder,
                                  filled: true,
                                  suffix: GestureDetector(
                                    onTap: () {
                                      toggle.value = !toggle.value;
                                    },
                                    child: Icon(
                                      toggle.value
                                          ? Icons.visibility_sharp
                                          : Icons.visibility_off,
                                    ),
                                  ),
                                ),
                                keyboardType: TextInputType.visiblePassword,
                                validator: (value) {
                                  return value!.length < 6
                                      ? "Password must have atlesat 6 character"
                                      : null;
                                },
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),

                // Login button
                SizedBox(height: 10.sp),
                InkWell(
                  // Calling login function
                  onTap: () => login(
                    emailcontroller.text.toString().trim(),
                    passwordcontroller.text.toString().trim(),
                    context,
                  ),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 10.sp),
                    decoration: BoxDecoration(
                      color: blueColor,
                      borderRadius: BorderRadius.circular(5.sp),
                    ),
                    child: Center(
                      child: Text("Login", style: TextStyle(fontSize: 12.sp)),
                    ),
                  ),
                ),

                // Sign-up page
                SizedBox(height: 10.sp),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account? ",
                      style: TextStyle(fontWeight: FontWeight.w300),
                    ),
                    GestureDetector(
                      onTap: () {
                        nextpage(context, const Signupscreen());
                      },
                      child: const Text(
                        "Sign-up",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const Expanded(child: SizedBox()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void login(String uemail, String upassword, context) async {
    // validating all fields
    if (formkey.currentState!.validate()) {
      activityloaderdialouge(context);

      // Using authservice for login
      Authservices authservice = Authservices();
      bool login = await authservice.signiuserwithemailandpassword(
        uemail,
        upassword,
        context,
      );
      if (login == true) {
        // Saving data throw sharedpreference
        await Sharedprefference.saveuselogein(true);
        await Sharedprefference.saveuseremail(uemail);

        // Printing user data
        if (kDebugMode) {
          print(uemail);
          print(upassword);
        }

        // Next page replacement
        nextpagereplacement(context, const MainUserScreen());
      }
    }
  }
}

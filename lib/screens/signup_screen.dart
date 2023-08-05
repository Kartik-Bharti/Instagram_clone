import 'package:sizer/sizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_dumy/utils/colors.dart';
import 'package:instagram_dumy/widgets/widgets.dart';
import 'package:instagram_dumy/utils/image_picker.dart';
import 'package:instagram_dumy/services/auth_services.dart';
import 'package:instagram_dumy/screens/main_user_screen.dart';
import 'package:instagram_dumy/services/shared_preference.dart';

class Signupscreen extends StatefulWidget {
  const Signupscreen({super.key});

  @override
  State<Signupscreen> createState() => _SigninscreenState();
}

class _SigninscreenState extends State<Signupscreen> {
  Uint8List? pickedimage;
  final formkey = GlobalKey<FormState>();
  final ValueNotifier<bool> toggle1 = ValueNotifier<bool>(true);
  final ValueNotifier<bool> toggle2 = ValueNotifier<bool>(true);
  final TextEditingController emailcontroller = TextEditingController();
  final TextEditingController usernamecontroller = TextEditingController();
  final TextEditingController passwordcontroller = TextEditingController();
  final TextEditingController confirmpcontroller = TextEditingController();
  final inputbortder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(5.sp),
  );

  void imagepicker() async {
    Uint8List? image = await pickimage(ImageSource.gallery, 1);
    if (image != null) {
      setState(() {
        pickedimage = image;
        if (kDebugMode) print(image);
      });
    }
  }

  @override
  void dispose() {
    emailcontroller.dispose();
    passwordcontroller.dispose();
    confirmpcontroller.dispose();
    usernamecontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        // Body
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(
              decelerationRate: ScrollDecelerationRate.fast,
            ),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.only(
                top: 35.sp,
                left: 25.sp,
                right: 25.sp,
                bottom: 60.sp,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Image
                  SvgPicture.asset(
                    "assets/images/logo_name.svg",
                    // ignore: deprecated_member_use
                    color: primaryColor,
                    height: 60.sp,
                  ),

                  // Stack
                  SizedBox(height: 10.sp),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      pickedimage != null
                          ? CircleAvatar(
                              radius: 50.sp,
                              backgroundImage: MemoryImage(pickedimage!),
                            )
                          : CircleAvatar(
                              radius: 50.sp,
                              backgroundImage: const AssetImage(
                                "assets/images/profile.png",
                              ),
                              backgroundColor: Colors.grey,
                            ),
                      Positioned(
                        bottom: 6.sp,
                        right: 0.sp,
                        child: InkWell(
                          onTap: () => imagepicker(),
                          child: Icon(Icons.add_a_photo_outlined, size: 18.sp),
                        ),
                      ),
                    ],
                  ),

                  // Textinput-fields
                  Form(
                    key: formkey,
                    child: Column(
                      children: [
                        // Name controller
                        SizedBox(height: 35.sp),
                        TextFormField(
                          controller: usernamecontroller,
                          decoration: InputDecoration(
                            hintText: "Full Name",
                            border: inputbortder,
                            enabledBorder: inputbortder,
                            focusedErrorBorder: inputbortder,
                            filled: true,
                          ),
                          keyboardType: TextInputType.name,
                          validator: (value) =>
                              usernamecontroller.text.isNotEmpty
                                  ? null
                                  : "Please Enter your Name",
                        ),

                        // Email controller
                        SizedBox(height: 10.sp),
                        TextFormField(
                          controller: emailcontroller,
                          decoration: InputDecoration(
                            hintText: "Email",
                            border: inputbortder,
                            focusedErrorBorder: inputbortder,
                            enabledBorder: inputbortder,
                            filled: true,
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) => RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                          ).hasMatch(emailcontroller.text.toString())
                              ? null
                              : "Please enter a valid Email",
                        ),

                        // Password controller
                        SizedBox(height: 10.sp),
                        ValueListenableBuilder(
                          valueListenable: toggle1,
                          builder: (context, value, child) {
                            return TextFormField(
                              controller: passwordcontroller,
                              obscureText: toggle1.value,
                              obscuringCharacter: "*",
                              decoration: InputDecoration(
                                hintText: "Password",
                                border: inputbortder,
                                enabledBorder: inputbortder,
                                focusedErrorBorder: inputbortder,
                                filled: true,
                                suffix: GestureDetector(
                                  onTap: () {
                                    toggle1.value = !toggle1.value;
                                  },
                                  child: Icon(
                                    toggle1.value
                                        ? Icons.visibility_sharp
                                        : Icons.visibility_off,
                                  ),
                                ),
                              ),
                              keyboardType: TextInputType.visiblePassword,
                              validator: (value) {
                                if (value!.length < 6) {
                                  return "Password must have atlesat 6 character";
                                }
                                return null;
                              },
                            );
                          },
                        ),

                        // Confirm password controller
                        SizedBox(height: 10.sp),
                        ValueListenableBuilder(
                          valueListenable: toggle2,
                          builder: (context, value, child) {
                            return TextFormField(
                              controller: confirmpcontroller,
                              obscureText: toggle2.value,
                              obscuringCharacter: "*",
                              decoration: InputDecoration(
                                hintText: "Confirm Password",
                                border: inputbortder,
                                focusedErrorBorder: inputbortder,
                                enabledBorder: inputbortder,
                                filled: true,
                                suffix: GestureDetector(
                                  onTap: () => toggle2.value = !toggle2.value,
                                  child: Icon(
                                    toggle2.value
                                        ? Icons.visibility_sharp
                                        : Icons.visibility_off,
                                  ),
                                ),
                              ),
                              keyboardType: TextInputType.visiblePassword,
                              validator: (value) {
                                if (passwordcontroller.text !=
                                        confirmpcontroller.text ||
                                    confirmpcontroller.text == "") {
                                  return "Password dosen't match";
                                }
                                return null;
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 10.sp),
                  InkWell(
                    onTap: () => signup(
                      context,
                      usernamecontroller.text.toString().trim(),
                      emailcontroller.text.toString().trim(),
                      passwordcontroller.text.toString().trim(),
                      pickedimage,
                    ),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 10.sp),
                      decoration: BoxDecoration(
                        color: blueColor,
                        borderRadius: BorderRadius.circular(5.sp),
                      ),
                      child: Center(
                        child: Text(
                          "Sign-up",
                          style: TextStyle(fontSize: 12.sp),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 10.sp),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Already have a account? ",
                        style: TextStyle(fontWeight: FontWeight.w300),
                      ),
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        child: const Text(
                          "Login",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void signup(
    context,
    String uname,
    String uemail,
    String upassword,
    Uint8List? pickedimage,
  ) async {
    // validating all fields
    if (formkey.currentState!.validate()) {
      activityloaderdialouge(context);

      // Using authservices
      Authservices authservices = Authservices();
      bool signuped = await authservices.registeruserwithemailandpassword(
        uname,
        uemail,
        upassword,
        pickedimage,
        context,
      );

      if (signuped == true) {
        // Saving data throw sharedpreference
        await Sharedprefference.saveuselogein(true);
        await Sharedprefference.saveusername(uname);
        await Sharedprefference.saveuseremail(uemail);

        // Printing user data
        if (kDebugMode) {
          print(uemail);
          print(uname);
          print(upassword);
        }

        // Next page replacement
        nextpagereplacement(context, const MainUserScreen());
      }
    }
  }
}

import 'package:uuid/uuid.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_dumy/utils/colors.dart';
import 'package:instagram_dumy/widgets/widgets.dart';
import 'package:instagram_dumy/models/user_model.dart';
import 'package:instagram_dumy/models/posts_model.dart';
import 'package:instagram_dumy/utils/image_picker.dart';
import 'package:instagram_dumy/services/cloud_storage.dart';
import 'package:instagram_dumy/services/database_services.dart';

class Addpostscreen extends StatefulWidget {
  final Usermodel usermodel;
  const Addpostscreen({super.key, required this.usermodel});

  @override
  State<Addpostscreen> createState() => _ApppostsccreenState();
}

class _ApppostsccreenState extends State<Addpostscreen> {
  Uint8List? pickedfile;
  bool isloading = false;
  final TextEditingController captioncontroller = TextEditingController();
  final String useraccountimage =
      "https://t3.ftcdn.net/jpg/00/64/67/80/360_F_64678017_zUpiZFjj04cnLri7oADnyMH0XBYyQghG.jpg";

  @override
  void dispose() {
    super.dispose();
    captioncontroller.dispose();
  }

  void clearimage() {
    setState(() => pickedfile = null);
  }

  Future<void> selectimage(context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          elevation: 10,
          title: const Text("Creat a post"),
          children: [
            SimpleDialogOption(
              padding: const EdgeInsets.all(25),
              onPressed: () async {
                Navigator.of(context).pop();
                Uint8List? file = await pickimage(ImageSource.camera, 1.2);
                setState(() => pickedfile = file);
              },
              child: const Text("Take a photo"),
            ),
            SimpleDialogOption(
              padding: const EdgeInsets.all(25),
              onPressed: () async {
                Navigator.of(context).pop();
                Uint8List? file = await pickimage(ImageSource.gallery, 1.2);
                setState(() => pickedfile = file);
              },
              child: const Text("Choose from gallery"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        child: Scaffold(
          // Appbar
          appBar: pickedfile != null
              ? AppBar(
                  title: const Text("Post to"),
                  elevation: 0,
                  backgroundColor: mobileBackgroundColor,
                  leading: InkWell(
                    onTap: () => clearimage(),
                    child: const Icon(Icons.arrow_back),
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () async => await addpostoninstagram(
                        context,
                        widget.usermodel.name,
                        captioncontroller.text.toString().trim(),
                        pickedfile!,
                      ),
                      child: const Text(
                        "Post",
                        style: TextStyle(
                          color: Colors.blueAccent,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    SizedBox(width: 4.sp)
                  ],
                )
              : null,

          // Body
          body: pickedfile != null
              ? SingleChildScrollView(
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(bottom: 10.sp, left: 5, right: 5),
                    child: Column(
                      children: [
                        // Loading indicator
                        isloading
                            ? const LinearProgressIndicator(minHeight: 4)
                            : const SizedBox(),

                        // Image-post
                        AspectRatio(
                          aspectRatio: 1 / 1.2,
                          child: Image(image: MemoryImage(pickedfile!)),
                        ),
                        SizedBox(height: 10.sp),

                        // Caption
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            CircleAvatar(
                              radius: 18.sp,
                              backgroundImage: NetworkImage(
                                widget.usermodel.profilepick != ""
                                    ? widget.usermodel.profilepick
                                    : useraccountimage,
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.8,
                              child: TextFormField(
                                controller: captioncontroller,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Write a caption...",
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              : Center(
                  child: IconButton(
                    onPressed: () => selectimage(context),
                    icon: const Icon(Icons.upload),
                  ),
                ),
        ),
      ),
    );
  }

  Future<void> addpostoninstagram(
    context,
    String uname,
    String description,
    Uint8List file,
  ) async {
    try {
      setState(() => isloading = true);

      // Generating a unique ID for each post
      final String uuid = const Uuid().v1();

      // uploading Post to Cloud Storage
      final String uploadedpick =
          await CloudStoragemethods().addposttocloudstorage(file, uuid);

      // Saving data to postmodel
      final Postmodel postmodel = Postmodel(
        username: uname,
        description: description,
        profilepick: widget.usermodel.profilepick,
        uploadedpost: uploadedpick,
        date: DateTime.now(),
        uid: FirebaseAuth.instance.currentUser!.uid,
        postId: "${FirebaseAuth.instance.currentUser!.uid}_$uuid",
        likes: [],
        uuid: uuid,
      );

      // Saving post data to Database
      await Databaseservice().saveuserpostdata(uuid, postmodel);

      setState(() {
        captioncontroller.clear();
        isloading = false;
      });

      clearimage();

      // Show Image uploaded Sucessfully message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Image uploaded sucessfully"),
          duration: Duration(seconds: 3),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      showsnackbar(context, Colors.red, e);
      if (kDebugMode) print(e.toString());
    }
  }
}

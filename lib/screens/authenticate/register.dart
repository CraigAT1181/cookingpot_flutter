import 'package:agrarian_flutter/shared/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:agrarian_flutter/services/auth.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class Register extends StatefulWidget {
  const Register({super.key, required this.toggleView});

  final Function toggleView;

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  String userName = '';
  String email = '';
  String town = '';
  String allotment = '';
  String plot = '';
  String password = '';
  File? profilePic;

  String error = '';

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() => profilePic = File(pickedFile.path));
    }
  }

  Future handleRegistration() async {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      try {
        final String profilePicPath = profilePic?.path ?? 'assets/no_image.jpg';

        final register = await _auth.registerUser(
            userName, email, profilePicPath, town, allotment, plot, password);

        if (register != null) {
          await _auth.userLogin(email, password);
        }
      } catch (e) {
        setState(() {
          // error = e.toString();
          error =
              "Oops, something went wrong! Please check your details and try again.";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.green[800],
          foregroundColor: Colors.white,
          elevation: 0.0,
          title: const Text('Welcome Aboard!'),
          actions: <Widget>[
            const Icon(Icons.person),
            TextButton(
                onPressed: () => widget.toggleView(),
                style: TextButton.styleFrom(foregroundColor: Colors.white),
                child: const Text('Sign In')),
          ],
        ),
        body: SingleChildScrollView(
            child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      const SizedBox(height: 20.0),
                      TextFormField(
                        decoration: const InputDecoration(hintText: 'Username'),
                        validator: (value) => value == null || value.isEmpty
                            ? 'Please enter a username.'
                            : null,
                        onChanged: (val) => setState(() => userName = val),
                      ),
                      const SizedBox(height: 20.0),
                      TextFormField(
                        decoration: const InputDecoration(hintText: 'Email'),
                        validator: (value) => value == null || value.isEmpty
                            ? 'Please enter an email address.'
                            : value.contains('@')
                                ? null
                                : 'Please use a valid email address',
                        onChanged: (val) => setState(() => email = val),
                      ),
                      const SizedBox(height: 20.0),
                      TextFormField(
                        decoration: const InputDecoration(hintText: 'Town'),
                        validator: (value) => value == null || value.isEmpty
                            ? 'Please enter your town.'
                            : null,
                        onChanged: (val) => setState(() => town = val),
                      ),
                      const SizedBox(height: 20.0),
                      TextFormField(
                        decoration:
                            const InputDecoration(hintText: 'Allotment'),
                        validator: (value) => value == null || value.isEmpty
                            ? 'Please enter your allotment.'
                            : null,
                        onChanged: (val) => setState(() => allotment = val),
                      ),
                      const SizedBox(height: 20.0),
                      TextFormField(
                        decoration: const InputDecoration(hintText: 'Plot'),
                        validator: (value) => value == null || value.isEmpty
                            ? 'Please enter your plot.'
                            : null,
                        onChanged: (val) => setState(() => plot = val),
                      ),
                      const SizedBox(height: 20.0),
                      TextFormField(
                        decoration: const InputDecoration(hintText: 'Password'),
                        validator: (value) => value == null || value.length < 6
                            ? 'Please ensure password is at least 6 characters long.'
                            : null,
                        obscureText: true,
                        onChanged: (val) => setState(() => password = val),
                      ),
                      const SizedBox(height: 20.0),
                      GestureDetector(
                        onTap: profilePic == null
                            ? _pickImage
                            : () {
                                // Optional: show a dialog to confirm removal
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Remove Profile Picture'),
                                    content: const Text(
                                        'Are you sure you want to remove the profile picture?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(
                                              context); // Close dialog
                                        },
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          setState(() {
                                            profilePic = null; // Clear the file
                                          });
                                          Navigator.pop(
                                              context); // Close dialog
                                        },
                                        child: const Text('Remove'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // The circular avatar
                            Material(
                              elevation: 5,
                              shape: const CircleBorder(),
                              child: CircleAvatar(
                                radius: 40,
                                backgroundColor: Colors.grey[200],
                                backgroundImage: profilePic != null
                                    ? FileImage(profilePic!)
                                    : null,
                                child: profilePic == null
                                    ? Icon(
                                        Icons.add_a_photo,
                                        size: 40,
                                        color: Colors.green[800],
                                      )
                                    : null,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      PrimaryButton(
                          onPressed: handleRegistration, text: 'Register'),
                      const SizedBox(
                        height: 12.0,
                      ),
                      Text(
                        error,
                        style: const TextStyle(color: Colors.red),
                      )
                    ],
                  ),
                ))));
  }
}

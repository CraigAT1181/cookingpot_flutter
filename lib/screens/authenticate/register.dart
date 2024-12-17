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

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() => profilePic = File(pickedFile.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.brown[100],
        appBar: AppBar(
          backgroundColor: Colors.brown[200],
          elevation: 0.0,
          title: const Text('Welcome Aboard!'),
          actions: <Widget>[
            TextButton(
                onPressed: () => widget.toggleView(),
                style: TextButton.styleFrom(foregroundColor: Colors.brown[800]),
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
                            : null,
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
                        onTap: _pickImage,
                        child: CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.white,
                          backgroundImage: profilePic != null
                              ? FileImage(profilePic!)
                              : null,
                          child: profilePic == null
                              ? Icon(
                                  Icons.add_a_photo,
                                  size: 40,
                                  color: Colors.brown[800],
                                )
                              : null,
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.brown[400],
                        ),
                        onPressed: () async {
                          if (_formKey.currentState != null &&
                              _formKey.currentState!.validate()) {
                            if (profilePic == null) {
                              print("No profile picture selected.");
                              return;
                            }
                            await _auth.registerUser(
                                userName,
                                email,
                                profilePic!.path,
                                town,
                                allotment,
                                plot,
                                password);
                          }
                        },
                        child: const Text(
                          'Register',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ))));
  }
}

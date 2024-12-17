import 'package:agrarian_flutter/services/supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:agrarian_flutter/models/user.dart' as custom_user;
import 'dart:io';
import 'package:path/path.dart' as path;

class AuthService {
  final supabase = SupabaseService().supabase;

  custom_user.User? user(userDetails) {
    return userDetails != null
        ? custom_user.User(
            userId: userDetails['user_id'],
            authId: userDetails['auth_user_id'],
            userName: userDetails['user_name'],
            email: userDetails['email'],
            profilePic: userDetails['profile_pic'],
            town: userDetails['towns']['town_name'],
            allotment: userDetails['allotments']['allotment_name'],
            plot: userDetails['plot'])
        : null;
  }

  Stream<custom_user.User?> get authStateChanges {
    return supabase.auth.onAuthStateChange.asyncMap((event) async {
      final session = event.session;
      print('onAuthChange: $event');
      final userId = session?.user.id;
      print('userId: $userId');

      if (session != null) {
        final userId = session.user.id;

        final userDetails = await supabase
            .from("users")
            .select("*, towns(town_name), allotments(allotment_name)")
            .eq("auth_user_id", userId)
            .maybeSingle();

        return user(userDetails);
      } else {
        return null;
      }
    });
  }

  Future<String> storeImage(
      String imagePath, String bucket, String userId) async {
    try {
      // Create a File object from the provided imagePath
      final file = File(imagePath);

      // Extract the original file name from the imagePath
      final String originalName = path.basename(imagePath);

      // Generate a unique file name (optional)
      final String fileName =
          '$userId/${DateTime.now().millisecondsSinceEpoch}_$originalName';

      // Upload the file to Supabase storage
      final String uploadedFilePath = await supabase.storage
          .from(bucket)
          .upload(
            fileName, // Path in the storage bucket
            file, // File to upload
            fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
          );

      // Return the full URL to the uploaded file
      final String publicUrl =
          supabase.storage.from(bucket).getPublicUrl(uploadedFilePath);
      return publicUrl;
    } catch (e) {
      // Handle errors gracefully
      print('Error uploading image: $e');
      throw Exception('Error storing image on Supabase: $e');
    }
  }

  // Pass in image file and obtain URL of stored profile-pic

  Future<custom_user.User?> registerUser(
      String userName,
      String email,
      String profilePicPath,
      String town,
      String allotment,
      String plot,
      String password) async {
    try {
      final authResponse = await supabase.auth.signUp(
        email: email,
        password: password,
      );

      final supabaseUser = authResponse.user;

      if (supabaseUser == null) {
        throw Exception('User registration failed.');
      }

      final userTownResponse = await supabase
          .from('towns')
          .select('town_id')
          .eq('town_name', town)
          .maybeSingle(); // Use maybeSingle() to directly get a single object or null.

      if (userTownResponse == null || userTownResponse['town_id'] == null) {
        throw Exception('Invalid town name provided.');
      }

      final userAllotmentResponse = await supabase
          .from('allotments')
          .select('allotment_id')
          .eq('allotment_name', allotment)
          .maybeSingle(); // Use maybeSingle() to directly get a single object or null.

      if (userAllotmentResponse == null ||
          userAllotmentResponse['allotment_id'] == null) {
        throw Exception('Invalid allotment name provided.');
      }

      final userTownId = userTownResponse['town_id'] as String;
      final userAllotmentId = userAllotmentResponse['allotment_id'] as String;

      final userId = supabaseUser.id;

      final profilePicUrl =
          await storeImage(profilePicPath, "profile-pictures", userId);

      final newUserResponse = await supabase
          .from('users')
          .insert({
            'auth_user_id': userId,
            'user_name': userName,
            'email': email,
            'profile_pic': profilePicUrl,
            'town_id': userTownId,
            'allotment_id': userAllotmentId,
            'plot': plot,
          })
          .select()
          .maybeSingle();

      if (newUserResponse == null) {
        throw Exception('Failed to create user in the database.');
      }

      return custom_user.User(
        userId: newUserResponse['user_id'],
        authId: userId,
        userName: userName,
        email: email,
        profilePic: profilePicUrl,
        town: town,
        allotment: allotment,
        plot: plot,
      );
    } catch (e) {
      throw Exception('Error adding new user: $e');
    }
  }

  Future<custom_user.User?> userLogin(String email, String password) async {
    try {
      final loginResponse = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      final supabaseUser = loginResponse.user;

      if (supabaseUser == null) {
        throw Exception('Login failed. User not found.');
      }

      final userDetails = await supabase
          .from("users")
          .select("*, towns(town_name), allotments(allotment_name) ")
          .eq("auth_user_id", supabaseUser.id)
          .maybeSingle();

      if (userDetails == null) return null;

      return user(userDetails);
    } catch (e) {
      throw Exception('An error occurred: $e');
    }
  }

  Future signOut() async {
    try {
      await supabase.auth.signOut();
    } catch (e) {
      print('Error signing out: $e');
      return null;
    }
  }
}

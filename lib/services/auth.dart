import 'package:agrarian_flutter/services/supabase.dart';
import 'package:agrarian_flutter/models/user.dart';

class AuthService {
  final supabase = SupabaseService().supabase;

  User? user(userDetails) {
    return userDetails != null
        ? User(
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

  Future userLogin(String email, String password) async {
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
}

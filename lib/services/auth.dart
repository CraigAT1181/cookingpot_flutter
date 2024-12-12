import 'package:agrarian_flutter/services/supabase.dart';

class AuthService {
  final supabase = SupabaseService().supabase;

  Future userLogin(String email, String password) async {
    try {
      final loginResponse = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      print(loginResponse.toString());

      final user = loginResponse.user;

      if (user == null) throw Exception('Login failed. User not found.');

      final userDetails = await supabase
          .from("users")
          .select("*, towns(town_name), allotments(allotment_name) ")
          .eq("auth_user_id", user.id)
          .single();

      return userDetails;
    } catch (e) {
      // throw Exception('An error occurred: $e');
      print('Error signing in: $e');
      return null;
    }
  }
}

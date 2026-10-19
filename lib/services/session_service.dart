import 'package:shared_preferences/shared_preferences.dart';

class SessionService {
  //Simpan Session
  //Static: Untuk Mengakses Method Dari Luar
  static Future<void> login(
    String username,
    String password,
    String email,
    String fullName,
  ) async {
    //Manggil SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    //Mengatur User Sudah Login
    await prefs.setBool('isLogin', true);
    //Jika User Sudah Login Akan Ke Home
    //Jika User Belum Login Akan Ke Login
    await prefs.setString('userName', username);
    await prefs.setString('userPassword', password);
    await prefs.setString('userEmail', email);
    await prefs.setString('userFullName', fullName);
  }

  //Cek Sudah Login
  static Future<bool> isLogin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLogin') ?? false;
  }

  //Ambil Username
  static Future<String> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userName') ?? '';
  }

  //Logout
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLogin');
    await prefs.remove('userName');
    await prefs.remove('userPassword');
    await prefs.remove('userEmail');
    await prefs.remove('userFullName');
  }
}

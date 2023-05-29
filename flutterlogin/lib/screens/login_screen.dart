import 'package:flutter/material.dart';

bool isStrongPassword(String password) {
  // Memeriksa panjang password
  if (password.length < 6) {
    return false;
  }

  // Memeriksa apakah terdapat huruf kapital, angka, dan karakter khusus
  bool hasUppercase = false;
  bool hasNumber = false;
  bool hasSpecialChar = false;

  for (int i = 0; i < password.length; i++) {
    var char = password[i];

    if (char == char.toUpperCase() && char != char.toLowerCase()) {
      hasUppercase = true;
    } else if (int.tryParse(char) != null) {
      hasNumber = true;
    } else if (!char.trim().isEmpty) {
      hasSpecialChar = true;
    }
  }

  return hasUppercase && hasNumber && hasSpecialChar;
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  void _login() {
    String password = _passwordController.text;

    if (isStrongPassword(password)) {
      // Lakukan proses login jika password kuat
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Password Sesuai'),
          content: Text('Password sudah memenuhi kriteria.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
      // TODO: Implement login logic
    } else {
      // Tampilkan pesan error jika password tidak memenuhi ketentuan
      List<String> errorMessages = [];

      if (password.length < 6) {
        errorMessages.add('- Minimal 6 karakter');
      }

      if (!password.contains(RegExp(r'[A-Z]'))) {
        errorMessages.add('- Minimal 1 huruf kapital');
      }

      if (!password.contains(RegExp(r'[0-9]'))) {
        errorMessages.add('- Minimal 1 angka');
      }

      if (!password.contains(RegExp(r'[!@#$%^&*()\-=_+{}\[\]|;:",.<>/?]'))) {
        errorMessages.add('- Minimal 1 karakter khusus');
      }

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Password Error'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: errorMessages
                .map(
                  (error) => Text(error),
                )
                .toList(),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
              ),
            ),
            TextFormField(
              controller: _passwordController,
              obscureText: !_isPasswordVisible,
              decoration: InputDecoration(
                labelText: 'Password',
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: _togglePasswordVisibility,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: _login,
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}

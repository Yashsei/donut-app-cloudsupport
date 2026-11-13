import 'package:donut_app/screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool _obscureText = true;
  final _userFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _confirmFocusNode = FocusNode();
  final _mailFocusNode = FocusNode();

  final _userController = TextEditingController();
  final _passController = TextEditingController();
  final _mailController = TextEditingController();
  final _confirmController = TextEditingController();

  String? passError;
  String? userError;
  String? nameError;
  String? mailError;
  String? confirmError;

  @override
  void dispose() {
    _userController.dispose();
    _mailController.dispose();
    _passController.dispose();
    _confirmController.dispose();
    _userFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmFocusNode.dispose();
    _mailFocusNode.dispose();
    super.dispose();
  }

  bool isValidUser(String user) {
    final re = RegExp(r'^[A-Za-z]{4,}$');
    return re.hasMatch(user);
  }

  bool isValidPassword(String pass) {
    final re = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^A-Za-z0-9]).{8,}$',
    );
    return re.hasMatch(pass);
  }

  bool isValidMail(mail) {
    final re = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    return re.hasMatch(mail);
  }

  Future<void> _onRegister() async {
    final user = _userController.text.trim();
    final pass = _passController.text.trim();
    final confirm = _confirmController.text.trim();
    final mail = _mailController.text.trim();

    final uError = isValidUser(user) ? null : 'Usuario Invalido';
    final pError = isValidPassword(pass) ? null : 'Contraseña Invalida';
    final mError = isValidMail(mail) ? null : 'Correo Invalido';
    final cError = confirm == pass ? null : 'Las contraseñas no coinciden';
    setState(() {
      userError = uError;
      passError = pError;
      mailError = mError;
      confirmError = cError;
    });
    if (uError != null ||
        mError != null ||
        pError != null ||
        confirmError != null) {
      return;
    }

    try {
      final res = await Supabase.instance.client.auth.signUp(
        email: mail,
        password: pass,
        data: {'username': user},
      );

      if (!mounted) return;

      if (res.user?.identities?.isEmpty ?? false) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Este correo ya está registrado')),
        );
        return;
      }

      if (res.session != null) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const HomePage()),
          (route) => false,
        );
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Cuenta creada')));
        Navigator.pop(context);
      }
    } on AuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: const Text(
          'Register',
          style: TextStyle(fontSize: 28, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsetsGeometry.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 25),
              Padding(padding: EdgeInsetsGeometry.all(20)),
              TextField(
                controller: _userController,
                focusNode: _userFocusNode,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  errorText: userError,
                  labelText: 'Usuario',
                  labelStyle: const TextStyle(color: Colors.white),
                  prefixIcon: const Icon(Icons.person_outline_sharp),
                ),
              ),
              const SizedBox(height: 25),
              TextField(
                controller: _mailController,
                focusNode: _mailFocusNode,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  errorText: mailError,
                  labelText: 'Correo electronico',
                  labelStyle: const TextStyle(color: Colors.white),
                  prefixIcon: const Icon(Icons.email_outlined),
                ),
              ),
              const SizedBox(height: 25),
              TextField(
                controller: _passController,
                focusNode: _passwordFocusNode,
                obscureText: _obscureText,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  errorText: passError,
                  labelText: 'Password',
                  labelStyle: const TextStyle(color: Colors.white),
                  prefixIcon: const Icon(Icons.lock_clock_outlined),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                    icon: Icon(
                      _obscureText
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 25),
              TextField(
                controller: _confirmController,
                focusNode: _confirmFocusNode,
                obscureText: _obscureText,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  errorText: confirmError,
                  labelText: 'Confirm Password',
                  labelStyle: const TextStyle(color: Colors.white),
                  prefixIcon: const Icon(Icons.lock_clock_outlined),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                    icon: Icon(
                      _obscureText
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _onRegister,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurpleAccent,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 48,
                        vertical: 16,
                      ),
                    ),
                    child: Text(
                      'Crear cuenta',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

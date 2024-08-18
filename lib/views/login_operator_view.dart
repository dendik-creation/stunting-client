import 'package:client/controllers/operator_login_controller.dart';
import 'package:client/utils/theme.dart';
import 'package:flutter/material.dart';

class LoginOperatorView extends StatefulWidget {
  const LoginOperatorView({super.key});

  @override
  State<LoginOperatorView> createState() => _LoginOperatorViewState();
}

class _LoginOperatorViewState extends State<LoginOperatorView> {
  final _formKey = GlobalKey<FormState>();
  final _controller = OperatorLoginController();
  bool _onSubmitting = false;

  void _loginCheck() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _onSubmitting = true;
      });
      await _controller.login(context);
      setState(() {
        _onSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.person_4_rounded,
                  size: 82.0, color: AppColors.green[500]),
              const SizedBox(height: 15),
              const Text(
                'Login',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                'Akses aplikasi sebagai operator',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildTextField(
                        "Username", Icons.person, TextInputType.text, (value) {
                      _controller.handleChange(value!, 'username');
                    }),
                    const SizedBox(height: 15),
                    _buildTextField(
                        "Password", Icons.key_rounded, TextInputType.text,
                        (value) {
                      _controller.handleChange(value!, 'password');
                    }, isPasswordType: true),
                    const SizedBox(height: 30),
                    SizedBox(
                      height: 60,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _onSubmitting ? null : _loginCheck,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF12d516),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: _onSubmitting
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'Login',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, IconData icon, TextInputType type,
      FormFieldSetter<String> onSaved,
      {int maxLength = 100, bool isPasswordType = false}) {
    return TextFormField(
      obscureText: isPasswordType,
      keyboardType: type,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontSize: 14.0),
        suffixIcon: Icon(
          icon,
          color: const Color(0xFF08b10b),
        ),
        fillColor: Colors.white,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF12d516), width: 2.0),
        ),
      ),
      onSaved: onSaved,
      maxLength: maxLength == 16 ? maxLength : null,
      validator: (value) => value == "" ? 'Wajib terisi' : null,
    );
  }
}

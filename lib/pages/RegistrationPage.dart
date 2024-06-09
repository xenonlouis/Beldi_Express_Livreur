import 'package:flutter/material.dart';

import '../services/FirebaseServices.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController regController = TextEditingController();
  final FirebaseServices _firebaseServices = FirebaseServices();
  final List<String> regions = ['reg1', 'reg2', 'reg3'];

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    // You can add more sophisticated email validation here if needed
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    // You can add more password validation rules here if needed
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value != passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registration'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                  ),
                  validator: _validateEmail,
                ),
                TextFormField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                  ),
                  obscureText: true,
                  validator: _validatePassword,
                ),
                TextFormField(
                  controller: confirmPasswordController,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                  ),
                  obscureText: true,
                  validator: _validateConfirmPassword,
                ),
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                  ),
                ),
                TextFormField(
                  controller: phoneNumberController,
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                  ),
                ),
                DropdownButtonFormField<String>(
              value: regions.first, // Initially selected region
              items: regions.map((region) {
                return DropdownMenuItem<String>(
                  value: region,
                  child: Text(region),
                );
              }).toList(),
              onChanged: ( value) {
                // Update the selected region
                regController.text = value!;
              },
              onSaved: (value) {
                    regController.text = value!;
                 },
              decoration: const InputDecoration(
                labelText: 'Region',
              ),
            ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      try {
                        await _firebaseServices.registerWithEmailAndPassword(
                          emailController.text,
                          passwordController.text,
                          nameController.text,
                          phoneNumberController.text,
                          regController.text
                        );
                        Navigator.pop(context);
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(e.toString()),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)
                          ),
                        ));
                      }
                    }
                  },
                  child: Text('Register'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

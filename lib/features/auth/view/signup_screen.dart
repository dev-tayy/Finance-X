import 'package:finance_x/components/custom_button.dart';
import 'package:finance_x/components/custom_textfield.dart';
import 'package:finance_x/components/snackbar.dart';
import 'package:finance_x/core/services/navigation/navigation_service.dart';
import 'package:finance_x/features/auth/view/login_screen.dart';
import 'package:finance_x/features/auth/viewmodel/auth_provider.dart';
import 'package:finance_x/utils/constants.dart';
import 'package:finance_x/utils/validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SignUpScreen extends HookConsumerWidget {
  static const String id = 'signup_screen';
  SignUpScreen({Key? key}) : super(key: key);
  final GlobalKey<FormState> _key = GlobalKey();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _fullNameController = useTextEditingController();
    final _emailController = useTextEditingController();
    final _passwordController = useTextEditingController();
    final _retypePasswordController = useTextEditingController();
    final _phoneNumberController = useTextEditingController();
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        color: AppColors.white,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(
                left: 16.0, right: 16.0, top: 50.0, bottom: 25.0),
            child: Form(
              key: _key,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () => NavigationService.goBack(),
                    child: const Icon(Icons.close),
                  ),
                  const SizedBox(height: 70),
                  const Text(
                    'Create Account',
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Open a Finance-X account with a few details.',
                    style: TextStyle(
                      fontSize: 15,
                      color: AppColors.textColor,
                    ),
                  ),
                  const SizedBox(height: 40),
                  const Text(
                    'Full name',
                    style: TextStyle(
                      fontSize: 15,
                      color: AppColors.textColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    hintText: 'Enter your full name',
                    keyboardType: TextInputType.name,
                    textCapitalization: TextCapitalization.sentences,
                    validator: (value) => Validator.validateName(value ?? ""),
                    controller: _fullNameController,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Email',
                    style: TextStyle(
                      fontSize: 15,
                      color: AppColors.textColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    hintText: 'Enter your email',
                    keyboardType: TextInputType.emailAddress,
                    textCapitalization: TextCapitalization.none,
                    validator: (value) => Validator.validateEmail(value ?? ""),
                    controller: _emailController,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Phone number',
                    style: TextStyle(
                      fontSize: 15,
                      color: AppColors.textColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    hintText: '0801 234 5678',
                    maxLength: 11,
                    keyboardType: TextInputType.number,
                    textCapitalization: TextCapitalization.none,
                    controller: _phoneNumberController,
                    validator: (value) =>
                        Validator.validatePhoneNumber(value ?? ""),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Password',
                    style: TextStyle(
                      fontSize: 15,
                      color: AppColors.textColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    hintText: '******',
                    obscureText: true,
                    maxLength: 6,
                    keyboardType: TextInputType.number,
                    textCapitalization: TextCapitalization.none,
                    controller: _passwordController,
                    validator: (value) =>
                        Validator.validatePassword(value ?? ""),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Retype password',
                    style: TextStyle(
                      fontSize: 15,
                      color: AppColors.textColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    hintText: '******',
                    obscureText: true,
                    maxLength: 6,
                    keyboardType: TextInputType.number,
                    textCapitalization: TextCapitalization.none,
                    controller: _retypePasswordController,
                    validator: (value) =>
                        Validator.validatePassword(value ?? ""),
                  ),
                  const SizedBox(height: 20),
                  CustomButton(
                    label: 'CREATE YOUR ACCOUNT',
                    color: AppColors.black,
                    onPressed: () {
                      if (_key.currentState!.validate()) {
                        if (_passwordController.text ==
                            _retypePasswordController.text) {
                          ref.read(authNotifierProvider.notifier).register(
                                context: context,
                                email: _emailController.text.trim(),
                                fullName: _fullNameController.text.trim(),
                                password: _passwordController.text,
                                phoneNumber: _phoneNumberController.text,
                              );
                        } else {
                          return FXSnackbar.showErrorSnackBar(context,
                              message: 'Password does not match',
                              snackBarBehavior: SnackBarBehavior.fixed,
                              milliseconds: 350);
                        }
                      } else {
                        return;
                      }
                    },
                    size: size,
                    textColor: AppColors.white,
                    borderSide: BorderSide.none,
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      NavigationService.navigateTo(LoginScreen.id);
                    },
                    child: RichText(
                      textScaleFactor: 0.8,
                      text: const TextSpan(
                        text: "Do you already have a Finance-X acccount? ",
                        style: TextStyle(
                          color: AppColors.textColor,
                          fontFamily: 'Karla',
                          fontSize: 15,
                        ),
                        children: [
                          TextSpan(
                            text: 'Sign in here',
                            style: TextStyle(
                              color: AppColors.primaryColor,
                              fontSize: 15,
                              fontFamily: 'Karla',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

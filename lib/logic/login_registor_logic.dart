import 'package:flutter/material.dart';
import 'package:my_food_reviews/models/user_model.dart';
import 'package:my_food_reviews/services/database_service.dart';

import '../helper/validators.dart';
import '../services/authentication_service.dart';

class LoginRegisterInfo {
  LoginRegisterInfo(
      {required this.buttonLoginRegisterEnabled,
      required this.showLoginRegisterError,
      required this.loginRegisterErrorMessage});

  bool buttonLoginRegisterEnabled;
  bool showLoginRegisterError;
  String loginRegisterErrorMessage;
}

class LoginRegisterLogic extends ChangeNotifier {
  bool _isEmailOk = false;
  bool _isPasswordOk = false;
  bool _isPasswordConfirmOk = false;
  final LoginRegisterInfo _loginRegisterInfo = LoginRegisterInfo(
      buttonLoginRegisterEnabled: false,
      showLoginRegisterError: false,
      loginRegisterErrorMessage: '');

  LoginRegisterInfo get loginRegisterInfo {
    return _loginRegisterInfo;
  }

  // User Forgot Password Page
  void checkLoginEmail({required String email}) {
    _loginRegisterInfo.showLoginRegisterError = false;
    _isEmailOk = Validators.email(email: email) ? true : false;
    _loginRegisterInfo.buttonLoginRegisterEnabled = _isEmailOk ? true : false;
    notifyListeners();
  }

  void checkLoginEmailAndPassword(
      {required String email, required String password}) {
    _loginRegisterInfo.showLoginRegisterError = false;
    _isEmailOk = Validators.email(email: email) ? true : false;
    _isPasswordOk = Validators.password(password: password) ? true : false;
    _loginRegisterInfo.buttonLoginRegisterEnabled =
        _isEmailOk && _isPasswordOk ? true : false;
    notifyListeners();
  }
  void checkRegisterEmailAndPasswordAndConfirm(
      {required String email,
      required String password,
      required String passwordConfirm}) {
    _loginRegisterInfo.showLoginRegisterError = false;
    _isEmailOk = Validators.email(email: email) ? true : false;
    _isPasswordOk = Validators.password(password: password) ? true : false;
    _isPasswordConfirmOk =
        Validators.password(password: passwordConfirm) ? true : false;
    bool isPasswordConfirmedOk = password == passwordConfirm ? true : false;
    _loginRegisterInfo.buttonLoginRegisterEnabled = _isEmailOk &&
            _isPasswordOk &&
            _isPasswordConfirmOk &&
            isPasswordConfirmedOk
        ? true
        : false;
    notifyListeners();
  }

  void showLoginErrorWithMessage({required String message}) {
    _loginRegisterInfo.showLoginRegisterError = true;
    _loginRegisterInfo.loginRegisterErrorMessage = message;
    notifyListeners();
  }
void login({required String email, required String password}) {
    if (loginRegisterInfo.buttonLoginRegisterEnabled) {
      AuthenticationService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    }
}

void register({required String email, required String password}){
  AuthenticationService.createUserWithEmailAndPassword(
    email: email, password: password)
    .then((uid){
      UserModel userModel = UserModel.initializeNewUserWithDefaultValues(
        uid: uid!,
        email: email,
        providerId: 'password',
        );
        DatabaseService.addUser(userModel)
        .then((value) => debugPrint('Sucess: $value'))
        .onError((error, stackTrace) => showLoginErrorWithMessage(message: '$error'));
    }
    ).onError((error, stackTrace) {showLoginErrorWithMessage(message: '$error');});
}
}
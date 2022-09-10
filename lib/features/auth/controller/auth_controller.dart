// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:wpclonemn/models/user_model.dart';

import '../repository/auth_repository.dart';

final authControllerProvider = Provider((ref) {
  final authRespository = ref.watch(authRespositoryProvider);
  return AuthController(authRespository: authRespository, ref: ref);
});

final userDataAuthProvider = FutureProvider((ref) {
  final authController = ref.watch(authControllerProvider);
  return authController.getUserData();
});

class AuthController {
  final AuthRespository authRespository;
  final ProviderRef ref;

  AuthController({
    required this.authRespository,
    required this.ref,
  });

  Future<UserModel?> getUserData() async {
    UserModel? user = await authRespository.getCurrentUserData();
    return user;
  }

  void signInWithPhone(BuildContext context, String phoneNumber) {
    authRespository.signInWithPhone(context, phoneNumber);
  }

  void verifyOTP(BuildContext context, String verificationId, String userOTP) {
    authRespository.verifyOTP(
      context: context,
      verificationId: verificationId,
      userOTP: userOTP,
    );
  }

  void saveUserDataToFirebase(
      BuildContext context, String name, File? profilePic) {
    authRespository.saveUserDataToFirebase(
      name: name,
      profilePic: profilePic,
      ref: ref,
      context: context,
    );
  }

  Stream<UserModel> userDataById(String userId) {
    return authRespository.userData(userId);
  }

  void setUserState(bool isOnline) {
    authRespository.setUserState(isOnline);
  }
}

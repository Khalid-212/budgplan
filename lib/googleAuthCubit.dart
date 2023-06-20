import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'googleAuthState.dart';

class GoogleAuthCubit extends Cubit<GoogleAuthState> {
  GoogleAuthCubit() : super(GoogleAuthInitialState());
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final _auth = FirebaseAuth.instance;

  void login() async {
    emit(GoogleAuthLoadingState());
    try {
      final userAccount = await _googleSignIn.signIn();
      if (userAccount == null) {
        emit(GoogleAuthFailedState('Failed to login'));
        return;
      }
      final googleAuth = await userAccount.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);

      emit(GoogleAuthSuccessState(userCredential.user!));
    } catch (e) {
      emit(GoogleAuthFailedState('Failed to login'));
    }
  }
}

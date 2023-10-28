import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bbuddy_app/features/auth_firebase/blocs/bloc.dart';
import 'package:bbuddy_app/features/auth_firebase/loading/loading_screen.dart';
import 'package:bbuddy_app/features/auth_firebase/dialogs/dialog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

void doLogout(BuildContext context) async {
  context.read<AppBloc>().add(const AppEventLogOut());
}

void loadingAndDisplayAuthError(BuildContext context, AppState appState) {
  if (appState.isLoading) {
    LoadingScreen.instance().show(
      context: context,
      text: 'Loading...',
    );
  } else {
    LoadingScreen.instance().hide();
  }

  final authError = appState.authError;
  if (authError != null) {
    showAuthError(
      authError: authError,
      context: context,
    );
  }
}

void hideLoading(BuildContext context, AppState appState) {
  if (!appState.isLoading) {
    LoadingScreen.instance().hide();
  }
}

Future<String?> getIdToken() async {
  String? token = await FirebaseAuth.instance.currentUser?.getIdToken();
  return token;
}


Future<bool> isFirstUser(UserCredential userCredential) async {
  final user = FirebaseAuth.instance.currentUser;
  final userRef = FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid);
  DocumentSnapshot userDoc = await userRef.get();

  // If the user is not authenticated, consider it their first time.
  if (!userDoc.exists) { 
      print('first user from google or apple');
      return true;
  } else {
    Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
    bool? firstUser = userData['firstUser'] as bool?;

    if (firstUser == true) {
      print('first user from register');
      return true;
    } else {
      print('not first user');
      return false;
    }
  }
}

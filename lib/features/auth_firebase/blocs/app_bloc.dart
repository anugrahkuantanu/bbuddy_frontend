import 'package:bbuddy_app/agreement_screen.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:bbuddy_app/core/core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:bbuddy_app/features/auth_firebase/errors/auth_error.dart';
import 'package:bbuddy_app/features/auth_firebase/blocs/bloc.dart';
import 'package:bbuddy_app/di/di.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc()
      : super(const AppStateLoggedOut(
          isLoading: false,
        )) {
    on<AppEventInitialize>(_initialize);
    on<AppEventGoToRegistration>(_goToRegistration);
    on<AppEventLogIn>(_logIn);
    on<AppEventGoogleLogin>(_googleLogin);
    on<AppEventAppleLogin>(_appleLogin);
    on<AppEventGoToLogin>(_goToLogin);
    on<AppEventRegister>(_register);
    on<AppEventLogOut>(_logOut);
    on<AppEventDeleteAccount>(_deleteAccount);
    on<AppEventForgotPassword>(_forgotPassword); 
  }

  void _goToRegistration(
      AppEventGoToRegistration event, Emitter<AppState> emit) {
    emit(const AppStateIsInRegistrationView(
      isLoading: false,
    ));
  }

  Future<void> _logIn(AppEventLogIn event, Emitter<AppState> emit) async {
    emit(const AppStateLoggedOut(
      isLoading: true,
    ));

    try {
      final userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
      final user = userCredential.user!;



      final http = locator.get<Http>();
      String? token = await FirebaseAuth.instance.currentUser?.getIdToken();
      http.addHeaders({'token': token!});

      print(await isFirstUser(userCredential));


      emit(AppStateLoggedIn(
        isLoading: false,
        user: user,
        firstUser: await isFirstUser(userCredential),
      ));
    } on FirebaseAuthException catch (e) {
      emit(AppStateLoggedOut(
        isLoading: false,
        authError: AuthError.from(e),
      ));
    }
  }


  Future<void> _googleLogin(
    AppEventGoogleLogin event, Emitter<AppState> emit) async {
          emit(const AppStateLoggedOut(
      isLoading: true,
    ));

    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication gAuth = await gUser!.authentication;


    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );

    try {
      final UserCredential userCredential =
      await FirebaseAuth.instance.signInWithCredential(credential);
      final user = userCredential.user!;

      final firstUserResult = await isFirstUser(userCredential);

      final userRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userCredential.user!.uid);
          await userRef.set({
            'userName': '',
            'lastName': '',
            'firstName': '',
            'email': user.email,
            'firstUser': true,
          });

      final http = locator.get<Http>();
      String? token = await FirebaseAuth.instance.currentUser?.getIdToken();
      http.addHeaders({'token': token!});
      emit(AppStateLoggedIn(
        isLoading: false,
        user: user,
        firstUser: firstUserResult,
      ));
    } on FirebaseAuthException catch (e) {
      emit(AppStateLoggedOut(
        isLoading: false,
        authError: AuthError.from(e),
      ));
    }
  }

  Future<void> _appleLogin(
      AppEventAppleLogin event, Emitter<AppState> emit) async {
    // Get the Apple ID credential using Apple Sign In
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName
      ],
    );

    // Create an OAuthCredential using the Apple ID credential
    final oauthCredential = OAuthProvider("apple.com").credential(
      accessToken: appleCredential.authorizationCode,
      idToken: appleCredential.identityToken,
    );

    try {
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(oauthCredential);
      final user = userCredential.user!;
      final firstUserResult = await isFirstUser(userCredential);

      final userRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userCredential.user!.uid);
          await userRef.set({
            'userName': '',
            'lastName': '',
            'firstName': '',
            'email': user.email,
            'firstUser': true,
          });

      final http = locator.get<Http>();

      String? token = await FirebaseAuth.instance.currentUser?.getIdToken();
      http.addHeaders({'token': token!});

      emit(AppStateLoggedIn(
        isLoading: false,
        user: user,
        firstUser: firstUserResult,
      ));
    } on FirebaseAuthException catch (e) {
      emit(AppStateLoggedOut(
        isLoading: false,
        authError: AuthError.from(e),
      ));
    } catch (error) {
      emit(const AppStateLoggedOut(
        isLoading: false,
      ));
    }
  }

  void _goToLogin(AppEventGoToLogin event, Emitter<AppState> emit) {
    emit(const AppStateLoggedOut(
      isLoading: false,
    ));
  }

  Future<void> _register(AppEventRegister event, Emitter<AppState> emit) async {
    emit(const AppStateIsInRegistrationView(
      isLoading: true,
    ));

    if (event.password != event.verifiedPassword) {
      emit(const AppStateIsInRegistrationView(
          isLoading: false, authError: AuthErrorPasswordNotMatch()));
      return; // Exit early
    }

    try {
      final credentials =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );

      final userRef = FirebaseFirestore.instance
          .collection('users')
          .doc(credentials.user!.uid);
      await userRef.set({
        'userName': event.userName,
        'lastName': event.lastName,
        'firstName': event.firstName,
        'email': event.email,
        'firstUser': true,
      });

      // emit(AppStateLoggedIn(
      //   isLoading: false,
      //   user: credentials.user!,
      // ));
    emit(const AppStateLoggedOut(isLoading: false));
    } on FirebaseAuthException catch (e) {
      emit(AppStateIsInRegistrationView(
        isLoading: false,
        authError: AuthError.from(e),
      ));
    }
  }

  Future<void> _initialize(
      AppEventInitialize event, Emitter<AppState> emit) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      emit(const AppStateLoggedOut(
        isLoading: false,
      ));
    } else {
      emit(AppStateLoggedIn(
        isLoading: false,
        user: user,
      ));
    }
  }

  Future<void> _logOut(AppEventLogOut event, Emitter<AppState> emit) async {
    emit(const AppStateLoggedOut(
      isLoading: true,
    ));
    await FirebaseAuth.instance.signOut();
    GoogleSignIn().signOut;

    emit(const AppStateLoggedOut(
      isLoading: false,
    ));
  }

  Future<void> _deleteAccount(
    AppEventDeleteAccount event, Emitter<AppState> emit) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    emit(const AppStateLoggedOut(
      isLoading: false,
    ));
    return;
  }
  emit(AppStateLoggedIn(
    isLoading: true,
    user: user,
  ));
  try {
    // Deleting user data from Firebase Storage
    final folderContents =
        await FirebaseStorage.instance.ref(user.uid).listAll();
    for (final item in folderContents.items) {
      await item.delete().catchError((_) {});
    }
    await FirebaseStorage.instance.ref(user.uid).delete().catchError((_) {});

    // Deleting user data from Firestore


    // Deleting user data from other collections
    final collectionsToDeleteFrom = ['check_in', 'reflections', 'user_stats', 'goals'];
    for (final collection in collectionsToDeleteFrom) {


      final userDocs = await FirebaseFirestore.instance
          .collection(collection)
          .where('user_id', isEqualTo: user.uid)
          .get();

      print('Found ${userDocs.docs.length} documents in $collection.');

      for (final doc in userDocs.docs) {
        await doc.reference.delete();
      }
    }

        final userRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
    await userRef.delete();

    // Deleting user authentication
    await user.delete();
    await FirebaseAuth.instance.signOut();
    emit(const AppStateLoggedOut(
      isLoading: false,
    ));
  } on FirebaseAuthException catch (e) {
    emit(AppStateLoggedIn(
      isLoading: false,
      user: user,
      // images: state.images ?? [],
      authError: AuthError.from(e),
    ));
  } on FirebaseException {
    emit(const AppStateLoggedOut(
      isLoading: false,
    ));
  }
}


  Future<void> _forgotPassword(
      AppEventForgotPassword event, Emitter<AppState> emit) async {
    emit(const AppStatePasswordReset(isLoading: true, isSuccessful: false));

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: event.email);
      emit(const AppStatePasswordReset(
        isLoading: false,
        isSuccessful: true,
      ));
      emit(const AppStateLoggedOut(isLoading: false));
    } 
    on FirebaseAuthException catch (e) {
      AuthError authError;
      if (e.code == 'no-current-user') {
        authError = AuthError.from(e);
      } else {
        authError = AuthError.from(e);
      }
      
      emit(AppStatePasswordReset(
        isLoading: false,
        isSuccessful: false,
        authError: authError,
      ));
    }
  }
}

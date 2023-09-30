import 'package:bbuddy_app/di/di.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:bbuddy_app/core/core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../../errors/auth_error.dart';
import './bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore

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

      emit(AppStateLoggedIn(
        isLoading: false,
        user: user,
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
      emit(AppStateLoggedIn(
        isLoading: false,
        user: user,
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
    emit(const AppStateLoggedOut(
      isLoading: true,
    ));

    try {
      // Trigger the Apple Sign-In process
      final appleResult = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      // Convert Apple Sign-In credentials to Firebase credentials
      final credential = OAuthProvider('apple.com').credential(
        idToken: appleResult.identityToken,
        accessToken: appleResult.authorizationCode,
      );

      // Sign in to Firebase with the Apple Sign-In credentials
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final user = userCredential.user!;
      emit(AppStateLoggedIn(
        isLoading: false,
        user: user,
      ));
    } on FirebaseAuthException catch (e) {
      emit(AppStateLoggedOut(
        isLoading: false,
        authError: AuthError.from(e),
      ));
    } catch (error) {
      emit(const AppStateLoggedOut(
        isLoading: false,
        // Handle other potential errors here, possibly create a custom error class for it
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
        'email': event.email
      });

      emit(AppStateLoggedIn(
        isLoading: false,
        user: credentials.user!,
      ));
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
      final folderContents =
          await FirebaseStorage.instance.ref(user.uid).listAll();
      for (final item in folderContents.items) {
        await item.delete().catchError((_) {});
      }
      await FirebaseStorage.instance.ref(user.uid).delete().catchError((_) {});
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
}

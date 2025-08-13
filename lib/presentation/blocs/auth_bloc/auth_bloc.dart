import 'package:bloc/bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AuthBloc() : super(AuthInitial()) {
    on<AuthStarted>((e, emit) {
      final user = _auth.currentUser;
      if (user != null) emit(AuthAuthenticated());
      else emit(AuthUnauthenticated());
    });
    on<AuthLoggedIn>((e, emit) => emit(AuthAuthenticated()));
    on<AuthLoggedOut>((e, emit) {
      _auth.signOut();
      emit(AuthUnauthenticated());
    });
  }
}

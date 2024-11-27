import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/models/requests/login_request.dart';
import 'package:shop/models/requests/register_request.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shop/blocs/blocs.dart';
import 'package:shop/repositories/auth/auth_repository.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'guest_state.dart';
part 'guest_cubit.freezed.dart';

class GuestCubit extends Cubit<GuestState> {
  final AuthRepository _authRepository;
  final AuthBloc _authBloc;

  
  Future<void> storeToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('authToken', token); 
  }

 Future<void> storeUserId(int userId) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setInt('userId', userId);
}

  GuestCubit({
    required AuthRepository authRepository,
    required AuthBloc authBloc,
  })  : _authRepository = authRepository,
        _authBloc = authBloc,
        super(
          const GuestState.initial(),
        );

  Future<String?> signIn(LoginData data) async {
    final response = await _authRepository.login(
      LoginRequest(email: data.name, password: data.password),
    );
    if (response.success) {
      await storeToken(response.data!.token);
      await storeUserId(response.data!.user.id);
      _authBloc.add(Authenticated(
        isAuthenticated: true,
        token: response.data!.token,
        user: response.data!.user,
      ));

      return null;
    }

    return response.message;
  }

  Future<String?> signUp(SignupData data) async {
    final response = await _authRepository.register(
      RegisterRequest(
          email: data.name!,
          password: data.password!,
          passwordConfirmation: data.password!),
    );
    if (response.success) {
      _authBloc.add(Authenticated(
        isAuthenticated: true,
        token: response.data!.token,
        user: response.data!.user,
      ));

      return null;
    }

    return response.message;
  }

  Future<void> signOut() async {
    _authRepository.logout();
    _authBloc.add(const Authenticated(
      isAuthenticated: false,
      user: null,
      token: null,
    ));
  }

}

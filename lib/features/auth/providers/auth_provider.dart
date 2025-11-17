import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/models/user_model.dart';
import '../../../data/repositories/auth_repository.dart';

part 'auth_provider.g.dart';

/// Current user stream provider
@riverpod
Stream<UserModel?> currentUser(CurrentUserRef ref) async* {
  final authRepo = ref.watch(authRepositoryProvider);

  await for (final authState in authRepo.authStateChanges) {
    final user = authState.session?.user;

    if (user == null) {
      yield null;
    } else {
      try {
        final userProfile = await authRepo.getUserProfile(user.id);
        yield userProfile;
      } catch (e) {
        yield null;
      }
    }
  }
}

/// Check if user is authenticated
@riverpod
bool isAuthenticated(IsAuthenticatedRef ref) {
  final user = ref.watch(currentUserProvider);

  return user.when(
    data: (user) => user != null,
    loading: () => false,
    error: (_, __) => false,
  );
}

/// Sign in with email controller
@riverpod
class SignInController extends _$SignInController {
  @override
  FutureOr<void> build() {}

  Future<void> signIn(String email, String password) async {
    state = const AsyncLoading();

    final authRepo = ref.read(authRepositoryProvider);
    state = await AsyncValue.guard(() async {
      await authRepo.signInWithEmail(email: email, password: password);
    });
  }
}

/// Sign up with email controller
@riverpod
class SignUpController extends _$SignUpController {
  @override
  FutureOr<void> build() {}

  Future<void> signUp({
    required String email,
    required String password,
    String? displayName,
  }) async {
    state = const AsyncLoading();

    final authRepo = ref.read(authRepositoryProvider);
    state = await AsyncValue.guard(() async {
      await authRepo.signUpWithEmail(
        email: email,
        password: password,
        displayName: displayName,
      );
    });
  }
}

/// Google sign in controller
@riverpod
class GoogleSignInController extends _$GoogleSignInController {
  @override
  FutureOr<void> build() {}

  Future<void> signInWithGoogle() async {
    state = const AsyncLoading();

    final authRepo = ref.read(authRepositoryProvider);
    state = await AsyncValue.guard(() async {
      await authRepo.signInWithGoogle();
    });
  }
}

/// Sign out controller
@riverpod
class SignOutController extends _$SignOutController {
  @override
  FutureOr<void> build() {}

  Future<void> signOut() async {
    state = const AsyncLoading();

    final authRepo = ref.read(authRepositoryProvider);
    state = await AsyncValue.guard(() async {
      await authRepo.signOut();
    });
  }
}

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../core/config/supabase_config.dart';
import '../../core/constants/app_constants.dart';
import '../models/user_model.dart';

part 'auth_repository.g.dart';

/// Authentication repository for handling user auth operations
class AuthRepository {
  final SupabaseClient _supabase;

  AuthRepository(this._supabase);

  /// Get current user
  User? get currentUser => _supabase.auth.currentUser;

  /// Get current user stream
  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;

  /// Sign in with email and password
  Future<UserModel> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw Exception('Sign in failed');
      }

      // Get or create user profile
      return await _getOrCreateUserProfile(response.user!);
    } catch (e) {
      throw Exception('Sign in failed: $e');
    }
  }

  /// Sign up with email and password
  Future<UserModel> signUpWithEmail({
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: displayName != null ? {'display_name': displayName} : null,
      );

      if (response.user == null) {
        throw Exception('Sign up failed');
      }

      // Create user profile
      return await _createUserProfile(
        userId: response.user!.id,
        email: email,
        displayName: displayName,
      );
    } catch (e) {
      throw Exception('Sign up failed: $e');
    }
  }

  /// Sign in with Google
  Future<UserModel> signInWithGoogle() async {
    try {
      // Web flow
      if (kIsWeb) {
        await _supabase.auth.signInWithOAuth(
          OAuthProvider.google,
          redirectTo: 'http://localhost:3000/auth/callback',
        );

        // Wait for auth state change
        final user = await _supabase.auth.onAuthStateChange
            .firstWhere((state) => state.session != null)
            .then((state) => state.session!.user);

        return await _getOrCreateUserProfile(user);
      }

      // Native flow
      final googleSignIn = GoogleSignIn(
        serverClientId: 'YOUR_SERVER_CLIENT_ID', // TODO: Add from env
      );

      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        throw Exception('Google sign in cancelled');
      }

      final googleAuth = await googleUser.authentication;
      final accessToken = googleAuth.accessToken;
      final idToken = googleAuth.idToken;

      if (accessToken == null || idToken == null) {
        throw Exception('Failed to get Google credentials');
      }

      final response = await _supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );

      if (response.user == null) {
        throw Exception('Google sign in failed');
      }

      return await _getOrCreateUserProfile(response.user!);
    } catch (e) {
      throw Exception('Google sign in failed: $e');
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
    } catch (e) {
      throw Exception('Sign out failed: $e');
    }
  }

  /// Get or create user profile in database
  Future<UserModel> _getOrCreateUserProfile(User user) async {
    try {
      // Try to get existing profile
      final response = await _supabase
          .from(TableNames.users)
          .select()
          .eq('id', user.id)
          .maybeSingle();

      if (response != null) {
        return UserModel.fromJson(response);
      }

      // Create new profile
      return await _createUserProfile(
        userId: user.id,
        email: user.email!,
        displayName: user.userMetadata?['display_name'] as String? ??
            user.userMetadata?['full_name'] as String?,
        avatarUrl: user.userMetadata?['avatar_url'] as String?,
      );
    } catch (e) {
      throw Exception('Failed to get user profile: $e');
    }
  }

  /// Create user profile in database
  Future<UserModel> _createUserProfile({
    required String userId,
    required String email,
    String? displayName,
    String? avatarUrl,
  }) async {
    try {
      final data = {
        'id': userId,
        'email': email,
        if (displayName != null) 'display_name': displayName,
        if (avatarUrl != null) 'avatar_url': avatarUrl,
      };

      final response =
          await _supabase.from(TableNames.users).insert(data).select().single();

      return UserModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to create user profile: $e');
    }
  }

  /// Get user profile by ID
  Future<UserModel?> getUserProfile(String userId) async {
    try {
      final response = await _supabase
          .from(TableNames.users)
          .select()
          .eq('id', userId)
          .maybeSingle();

      return response != null ? UserModel.fromJson(response) : null;
    } catch (e) {
      throw Exception('Failed to get user profile: $e');
    }
  }

  /// Update user profile
  Future<UserModel> updateUserProfile({
    required String userId,
    String? displayName,
    String? avatarUrl,
  }) async {
    try {
      final data = {
        if (displayName != null) 'display_name': displayName,
        if (avatarUrl != null) 'avatar_url': avatarUrl,
      };

      final response = await _supabase
          .from(TableNames.users)
          .update(data)
          .eq('id', userId)
          .select()
          .single();

      return UserModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to update user profile: $e');
    }
  }
}

/// Provider for AuthRepository
@riverpod
AuthRepository authRepository(AuthRepositoryRef ref) {
  return AuthRepository(supabase);
}

/// Provider for current user
@riverpod
Stream<User?> authStateChanges(AuthStateChangesRef ref) {
  final authRepo = ref.watch(authRepositoryProvider);
  return authRepo.authStateChanges.map((state) => state.session?.user);
}

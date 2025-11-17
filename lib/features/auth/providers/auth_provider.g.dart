// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$currentUserHash() => r'dcaf65025369d8c4a3fcdd1ec2279b9e80542051';

/// Current user stream provider
///
/// Copied from [currentUser].
@ProviderFor(currentUser)
final currentUserProvider = AutoDisposeStreamProvider<UserModel?>.internal(
  currentUser,
  name: r'currentUserProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$currentUserHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentUserRef = AutoDisposeStreamProviderRef<UserModel?>;
String _$isAuthenticatedHash() => r'8dedb8409a69c5ccc6330cb033204d7b5b663022';

/// Check if user is authenticated
///
/// Copied from [isAuthenticated].
@ProviderFor(isAuthenticated)
final isAuthenticatedProvider = AutoDisposeProvider<bool>.internal(
  isAuthenticated,
  name: r'isAuthenticatedProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$isAuthenticatedHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef IsAuthenticatedRef = AutoDisposeProviderRef<bool>;
String _$signInControllerHash() => r'f3d1f629a3c7ad65cdfba5ece6c06eda7b33a3c5';

/// Sign in with email controller
///
/// Copied from [SignInController].
@ProviderFor(SignInController)
final signInControllerProvider =
    AutoDisposeAsyncNotifierProvider<SignInController, void>.internal(
  SignInController.new,
  name: r'signInControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$signInControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SignInController = AutoDisposeAsyncNotifier<void>;
String _$signUpControllerHash() => r'1e8c965c08e25318f10f8578d7632a50fe2ad3bd';

/// Sign up with email controller
///
/// Copied from [SignUpController].
@ProviderFor(SignUpController)
final signUpControllerProvider =
    AutoDisposeAsyncNotifierProvider<SignUpController, void>.internal(
  SignUpController.new,
  name: r'signUpControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$signUpControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SignUpController = AutoDisposeAsyncNotifier<void>;
String _$googleSignInControllerHash() =>
    r'b60880ac3dac113d4443c8445e7c32dc7eaf4dfc';

/// Google sign in controller
///
/// Copied from [GoogleSignInController].
@ProviderFor(GoogleSignInController)
final googleSignInControllerProvider =
    AutoDisposeAsyncNotifierProvider<GoogleSignInController, void>.internal(
  GoogleSignInController.new,
  name: r'googleSignInControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$googleSignInControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$GoogleSignInController = AutoDisposeAsyncNotifier<void>;
String _$signOutControllerHash() => r'c4e6845fbed563b58ea2f6c8c92a6fce829e06c8';

/// Sign out controller
///
/// Copied from [SignOutController].
@ProviderFor(SignOutController)
final signOutControllerProvider =
    AutoDisposeAsyncNotifierProvider<SignOutController, void>.internal(
  SignOutController.new,
  name: r'signOutControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$signOutControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SignOutController = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

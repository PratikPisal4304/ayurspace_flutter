import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/user_profile.dart';
import '../data/models/dosha.dart';

/// User state
class UserState {
  final UserProfile? profile;
  final bool isLoading;
  final String? error;

  const UserState({
    this.profile,
    this.isLoading = false,
    this.error,
  });

  UserState copyWith({
    UserProfile? profile,
    bool? isLoading,
    String? error,
  }) {
    return UserState(
      profile: profile ?? this.profile,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// User notifier
class UserNotifier extends StateNotifier<UserState> {
  UserNotifier() : super(const UserState()) {
    _initUser();
  }

  void _initUser() {
    // Create a default user profile
    final defaultProfile = UserProfile(
      id: '1',
      name: 'Wellness Seeker',
      email: 'user@ayurspace.com',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    state = state.copyWith(profile: defaultProfile);
  }

  /// Update user name
  void updateName(String name) {
    if (state.profile != null) {
      state = state.copyWith(
        profile: state.profile!.copyWith(
          name: name,
          updatedAt: DateTime.now(),
        ),
      );
    }
  }

  /// Update user email
  void updateEmail(String email) {
    if (state.profile != null) {
      state = state.copyWith(
        profile: state.profile!.copyWith(
          email: email,
          updatedAt: DateTime.now(),
        ),
      );
    }
  }

  /// Save dosha result
  void saveDoshaResult(DoshaResult result) {
    if (state.profile != null) {
      state = state.copyWith(
        profile: state.profile!.copyWith(
          doshaResult: result,
          updatedAt: DateTime.now(),
        ),
      );
    }
  }

  /// Update user settings
  void updateSettings(UserSettings settings) {
    if (state.profile != null) {
      state = state.copyWith(
        profile: state.profile!.copyWith(
          settings: settings,
          updatedAt: DateTime.now(),
        ),
      );
    }
  }

  /// Update stats
  void incrementPlantsScanned() {
    if (state.profile != null) {
      state = state.copyWith(
        profile: state.profile!.copyWith(
          stats: state.profile!.stats.copyWith(
            plantsScanned: state.profile!.stats.plantsScanned + 1,
          ),
        ),
      );
    }
  }

  void incrementRemediesTried() {
    if (state.profile != null) {
      state = state.copyWith(
        profile: state.profile!.copyWith(
          stats: state.profile!.stats.copyWith(
            remediesTried: state.profile!.stats.remediesTried + 1,
          ),
        ),
      );
    }
  }
}

/// User provider
final userProvider = StateNotifierProvider<UserNotifier, UserState>(
  (ref) => UserNotifier(),
);

/// User profile provider
final userProfileProvider = Provider<UserProfile?>((ref) {
  return ref.watch(userProvider).profile;
});

/// User stats provider
final userStatsProvider = Provider<UserStats>((ref) {
  return ref.watch(userProvider).profile?.stats ?? const UserStats();
});

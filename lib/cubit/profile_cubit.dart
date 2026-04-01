import 'package:flutter_bloc/flutter_bloc.dart';
import '../repositories/app_repository.dart';
import '../services/storage_service.dart';
import '../utils/configs.dart';
import '../utils/app_logger.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(const ProfileInitial());

  /// Fetch user profile data from API
  Future<void> fetchProfile() async {
    emit(const ProfileLoading());

    try {
      AppLogger.auth('Fetching user profile data');
      
      final profileData = await AppRepository.getProfile();
      
      AppLogger.logObject('Profile data received', profileData.toJson(), 'Profile');
      
      // Get existing user data to preserve the token
      final existingUser = await StorageService.getUser();
      
      // Merge profile data with existing token
      final updatedUser = profileData.copyWith(
        token: existingUser?.token, // Preserve the existing token
      );
      
      // Update storage with merged user data
      await StorageService.saveUser(updatedUser);
      
      emit(ProfileLoaded(updatedUser));
    } on ApiException catch (e) {
      AppLogger.error('Profile fetch API Error: ${e.message}', 'Profile', e);
      emit(ProfileError(e.message, exception: e));
    } catch (e) {
      AppLogger.error('Profile fetch Unexpected Error', 'Profile', e);
      emit(const ProfileError('Failed to load profile data. Please try again.'));
    }
  }

  /// Clear error state
  void clearError() {
    if (state is ProfileError) {
      // Try to return to previous valid state or fetch fresh data
      final user = StorageService.user;
      if (user != null) {
        emit(ProfileLoaded(user));
      } else {
        fetchProfile();
      }
    }
  }
}
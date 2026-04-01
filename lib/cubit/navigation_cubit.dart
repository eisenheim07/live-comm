import 'package:flutter_bloc/flutter_bloc.dart';
import '../utils/app_logger.dart';
import 'navigation_state.dart';

class NavigationCubit extends Cubit<NavigationState> {
  NavigationCubit() : super(const NavigationChanged(0));

  /// Change the selected tab index
  void changeTab(int index) {
    AppLogger.navigation('Tab changed to index: $index');
    emit(NavigationChanged(index));
  }

  /// Navigate to Dashboard tab
  void goToDashboard() {
    changeTab(0);
  }
}

import 'package:equatable/equatable.dart';

abstract class NavigationState extends Equatable {
  const NavigationState();

  @override
  List<Object?> get props => [];
}

class NavigationChanged extends NavigationState {
  final int selectedIndex;

  const NavigationChanged(this.selectedIndex);

  @override
  List<Object?> get props => [selectedIndex];
}
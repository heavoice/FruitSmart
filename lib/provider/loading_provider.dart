import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoadingState extends StateNotifier<bool> {
  LoadingState() : super(false);

  void start() => state = true;
  void stop() => state = false;
}

final wishlistLoadingProvider =
    StateNotifierProvider<LoadingState, bool>((ref) => LoadingState());

final cartLoadingProvider =
    StateNotifierProvider<LoadingState, bool>((ref) => LoadingState());

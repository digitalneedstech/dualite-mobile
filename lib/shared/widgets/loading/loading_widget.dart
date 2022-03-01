import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadingOverlay extends StatelessWidget {
  final Widget child;
  final bool isLoading;
  final bool isFormSaveOverlay;

  const LoadingOverlay({
    required this.isLoading,
    this.isFormSaveOverlay=false,
    required this.child,
  }) ;
  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(
        child: Lottie.asset('assets/lotties/video_loader.json'),
      );
    }
    return child;
  }
}
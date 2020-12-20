import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade300.withOpacity(0.6),
      child: const Center(
        child: SpinKitCircle(
          color: Colors.green,
          size: 50,
        ),
      ),
    );
  }
}

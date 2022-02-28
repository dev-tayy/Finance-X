import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';

class FXSpinner extends StatelessWidget {
  const FXSpinner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset('assets/gifs/spinner.json'),
    );
  }
}

class FXLoader {
  static show(BuildContext context) {
    return Loader.show(context,
        progressIndicator: const FXSpinner(), overlayColor: Colors.white30);
  }

  static hide() {
    return Loader.hide();
  }
}

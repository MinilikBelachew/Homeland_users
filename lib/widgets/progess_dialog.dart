import 'package:flutter/material.dart';

class ProgressDialog extends StatefulWidget {
  final String message;

  const ProgressDialog({super.key, required this.message});

  @override
  _ProgressDialogState createState() => _ProgressDialogState();
}

class _ProgressDialogState extends State<ProgressDialog>
    with SingleTickerProviderStateMixin {

  AnimationController? _controller;
  Animation<double>? _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller!);
    _controller!.forward();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacityAnimation!,
      child: Material(
        type: MaterialType.transparency, // Transparent background
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0), // Larger radius
              boxShadow:  [
                BoxShadow(
                  blurRadius: 10.0, // Subtle shadow
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2.0,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.message,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 15.0), // Spacing below text
                CircularProgressIndicator( // Circular Progress Indicator
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

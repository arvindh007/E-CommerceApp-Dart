import 'package:flutter/material.dart';

class CircularProgress extends StatefulWidget {
  const CircularProgress({super.key});

  @override
  _CircularProgressState createState() => _CircularProgressState();
}

class _CircularProgressState extends State<CircularProgress> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: const Center(
        child: CircularProgressIndicator(
        ),
      ),
    );
  }
}

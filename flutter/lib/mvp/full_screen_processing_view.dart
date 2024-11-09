import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FullScreenProcessingView extends StatelessWidget {
  final VoidCallback process;

  const FullScreenProcessingView({Key? key, required this.process})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    process();
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Processing...",
              style: GoogleFonts.montserrat(
                  fontSize: 24, fontWeight: FontWeight.w800),
            ),
            CircularProgressIndicator(
              color: Colors.greenAccent.shade700,
            ),
          ],
        ),
      ),
    );
  }
}

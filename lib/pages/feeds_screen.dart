import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FeedsScreen extends StatelessWidget {
  const FeedsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Feeds',
        style: GoogleFonts.comicRelief(
          textStyle: const TextStyle(
            color: Colors.blue,
            letterSpacing: .5,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

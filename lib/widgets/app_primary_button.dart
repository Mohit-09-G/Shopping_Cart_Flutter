import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppPrimaryButton extends StatelessWidget {
  final String buttonText;
  final Function() onPressedTapped;
  const AppPrimaryButton(
      {super.key, required this.buttonText, required this.onPressedTapped});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  gradient: LinearGradient(
                      colors: [Color(0xFFAEDC81), Color(0xFF6CC51D)])),
              child: ElevatedButton(
                onPressed: () {
                  onPressedTapped();
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent),
                child: Text(
                  buttonText,
                  style: GoogleFonts.poppins(
                      fontSize: 15,
                      color: Color(0xFFFFFFFF),
                      fontWeight: FontWeight.w600),
                ),
              )),
        ),
      ],
    );
  }
}

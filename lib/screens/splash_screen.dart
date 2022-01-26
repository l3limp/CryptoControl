import 'package:cryptocontrol/themes.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    OurTheme _theme = OurTheme();
    return SafeArea(
      child: Scaffold(
        backgroundColor: _theme.primaryColor,
        body: InkWell(
          onTap: () {
            Navigator.popAndPushNamed(context, '/home');
          },
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                const Spacer(),
                Text(
                  "CryptoControl",
                  style: GoogleFonts.roboto(
                    textStyle:
                        TextStyle(color: _theme.secondaryColor, fontSize: 48),
                  ),
                ),
                const Spacer(),
                Text(
                  "Made by",
                  style: GoogleFonts.roboto(
                    textStyle:
                        TextStyle(color: _theme.secondaryColor, fontSize: 18),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "Vardaan",
                  style: GoogleFonts.roboto(
                    textStyle:
                        TextStyle(color: _theme.secondaryColor, fontSize: 12),
                  ),
                ),
                const SizedBox(
                  height: 100,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

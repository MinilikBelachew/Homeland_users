import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:users/screens/main_screen.dart';

import '../data_handler/app_data.dart';

class NoDriverAvailableDiaog extends StatelessWidget {
  const NoDriverAvailableDiaog({Key? key});

  @override
  Widget build(BuildContext context) {
    AppData languageProvider = Provider.of<AppData>(context);
    var language = languageProvider.isEnglishSelected;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        margin: const EdgeInsets.all(0),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                language ? "No Driver Found" : "ሹፌር አልተገኘም።",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                language
                    ? "Sorry, we couldn't find any drivers nearby. Please try again later."
                    : "ይቅርታ፣ በአቅራቢያ ምንም ሾፌሮችን ማግኘት አልቻልንም። እባክዎ ቆየት ብለው ይሞክሩ.",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor: Colors.blue,
                  minimumSize: const Size(double.infinity, 50),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      language ? "Close" : "ዝጋ",
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Icon(Icons.arrow_forward, color: Colors.white),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

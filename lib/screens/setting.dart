import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data_handler/app_data.dart';

class SettingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appData = Provider.of<AppData>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(appData.isEnglishSelected ? 'Profile' : 'ፕሮፋይል'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text with heading style
            Text(
              appData.isEnglishSelected ? 'Language:' : 'ቋንቋ:',
              style: Theme.of(context).textTheme.headline6, // Use theme styles
            ),
            const SizedBox(height: 10.0),
            // Row with spaced elements and switch with rounded theme
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(appData.isEnglishSelected ? 'English' : 'አማርኛ'),
                Switch(
                  value: appData.isEnglishSelected,
                  onChanged: (value) => appData.toggleLanguage(value),
                  activeTrackColor: Theme.of(context).primaryColor, // Use theme color
                  activeColor: Colors.white, // Use white for active toggle
                ),
              ],
            ),
            const Divider(thickness: 1.0), // Add a divider for separation
            const SizedBox(height: 20.0),
            // Text with body style
            Text(
              appData.isEnglishSelected
                  ? 'Other content of the profile page goes here...'
                  : 'የፕሮፋይል ጽሁፎች በዚህ ነው...',
              style: Theme.of(context).textTheme.bodyText1, // Use theme styles
            ),
          ],
        ),
      ),
    );
  }
}

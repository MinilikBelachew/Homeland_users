import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:users/data_handler/app_data.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({Key? key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    AppData languageProvider = Provider.of<AppData>(context);
    var language = languageProvider.isEnglishSelected;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          language ? 'About Homeland Logistics' : 'ስለ ሀገር ቤት ሎጅስቲክስ',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue, // Add a background color
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: Colors.black54,
                border: Border.all(color: Colors.black, width: 2.0),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.asset(
                  'images/home.png',
                  width: 100.0,
                  height: 100.0,
                ),
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              language ? 'Homeland Logistics' : 'ሀገር ቤት ሎጅስቲክስ',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              language
                  ? 'We are a leading logistics company that connects shippers and carriers for efficient and reliable freight transportation.'
                  : 'እኛ ቀልጣፋ እና አስተማማኝ የጭነት መጓጓዣ ላኪዎችን እና አጓጓዦችን የሚያገናኝ መሪ የሎጂስቲክስ ኩባንያ ነን።',
              style: TextStyle(fontSize: 16.0),
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 20.0),
            Text(
              language ? 'Our Mission:' : 'የእኛ ተልዕኮ',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              language
                  ? 'To revolutionize the logistics industry by providing a seamless and transparent platform for businesses to move their goods.'
                  : 'የንግድ ድርጅቶች ሸቀጦቻቸውን የሚያንቀሳቅሱበት ያልተቋረጠ እና ግልጽ መድረክ በማቅረብ የሎጂስቲክስ ኢንዱስትሪውን አብዮት ማድረግ።',
              style: TextStyle(fontSize: 16.0),
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 20.0),
            Text(
              language ? 'Contact Us:' : 'ያግኙን:',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Icon(Icons.email, color: Colors.blue),
                SizedBox(width: 10.0),
                Text('info@homelandlogistics.com'),
              ],
            ),
            SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Icon(Icons.phone, color: Colors.blue),
                SizedBox(width: 10.0),
                Text('+251 937637782'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

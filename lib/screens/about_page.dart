import 'package:flutter/material.dart';
class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'About Homeland Logistics',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue, // Add a background color
      ),
      body: SingleChildScrollView( // Allow scrolling for long content
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center, // Center elements horizontally
          children: <Widget>[
            // App logo or image with border
            Container(

              decoration: BoxDecoration(
                color: Colors.black54,
                border: Border.all(color: Colors.black, width: 2.0), // Add border
                borderRadius: BorderRadius.circular(10.0), // Rounded corners
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
              'Homeland Logistics',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.blue, // Add a color
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              'We are a leading logistics company that connects shippers and carriers for efficient and reliable freight transportation.',
              style: TextStyle(fontSize: 16.0),
              textAlign: TextAlign.justify, // Align text to justify
            ),
            SizedBox(height: 20.0),
            Text(
              'Our Mission:',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              'To revolutionize the logistics industry by providing a seamless and transparent platform for businesses to move their goods.',
              style: TextStyle(fontSize: 16.0),
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 20.0),
            Text(
              'Contact Us:',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.start, // Align icons to the left
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
                Text('+1 234-567-8901'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


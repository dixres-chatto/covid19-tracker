import 'dart:convert';

import 'package:covid19_tracker/datasource.dart';
import 'package:covid19_tracker/pages/countryPage.dart';
import 'package:covid19_tracker/panels/InfoPanel.dart';
import 'package:covid19_tracker/panels/mostaffectedcountries.dart';
import 'package:covid19_tracker/panels/worldwidepanel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map worldData;

  fetchWorldWideData() async {
    http.Response response = await http.get('https://corona.lmao.ninja/v2/all');

    setState(() {
      worldData = json.decode(response.body);
    });
  }

  List countryData;

  fetchCountryData() async {
    http.Response response =
        await http.get('https://corona.lmao.ninja/v2/countries');

    setState(() {
      countryData = json.decode(response.body);
    });
  }

  @override
  void initState() {
    fetchWorldWideData();
    fetchCountryData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('COVID-19 TRACKER'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(10),
              height: 100,
              color: Colors.orange[100],
              child: Text(
                DataSource.quote,
                style: TextStyle(
                  color: Colors.orange[800],
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Worldwide',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CountryPage()));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: primaryBlack,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: EdgeInsets.all(10),
                      child: Text(
                        'Regional',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            worldData == null
                ? CircularProgressIndicator()
                : WorldwidePanel(
                    worldData: worldData,
                  ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                'Most Affected Countries',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 10),
            countryData == null
                ? Container()
                : MostAffectPanel(countryData: countryData),
            InfoPanel(),
            SizedBox(
              height: 20,
            ),
            Center(
              child: Text(
                'WE ARE TOGETHER IN THE FIGHT',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}

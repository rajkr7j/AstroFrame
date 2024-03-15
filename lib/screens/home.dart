import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';

import 'package:astronomy_picture_of_the_day_app/models/apod.dart';
import 'package:astronomy_picture_of_the_day_app/widgets/image.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() {
    return _Content();
  }
}

class _Content extends State<HomeScreen> {
  final String? API_KEY = dotenv.env['API_KEY'];
  Apod? _apodData;
  var _isLoading = true;
  @override
  void initState() {
    _loadData();
    super.initState();
  }

  void _loadData() async {
    try {
      setState(() {
        _isLoading = true;
        _apodData = null;
      });
      final url = Uri.https(
        'api.nasa.gov',
        '/planetary/apod',
        {'api_key': '$API_KEY'},
      );
      final response = await http.get(url);

      if (response.statusCode >= 400) {
        setState(() {
          // _error = 'Failed to fetch data.';
        });
        return;
      }
      if (response.body == 'null') {
        setState(() {
          _isLoading = false;
        });
        return;
      }

      final Map<String, dynamic> listData = json.decode(response.body);

      Apod loadedData = Apod(
        title: listData["title"]!,
        date: listData["date"]!,
        imageUrl: listData["url"]!,
        copyRight: listData["copyright"]!,
        explanation: listData["explanation"]!,
      );

      setState(() {
        _apodData = loadedData;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        // _error = 'Something went wrong!. Please try again later.';
      });
    }
  }

  @override
  Widget build(context) {
    Widget content = Container(
      height: 600,
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
    if (!_isLoading) {
      content = Column(
        children: [
          Column(
            children: [
              Container(
                margin: const EdgeInsets.only(
                  left: 15,
                  top: 10,
                  right: 15,
                ),
                alignment: Alignment.centerLeft,
                child: Text(
                  _apodData!.title,
                  style: GoogleFonts.robotoCondensed(
                    fontSize: 35,
                    fontWeight: FontWeight.w600,
                    // color: Colors.white,
                  ),
                  softWrap: true,
                ),
              ),
            ],
          ),
          ImageWidget(
            imageUrl: _apodData!.imageUrl,
          ),
          Container(
            margin: const EdgeInsets.only(
              left: 25,
              top: 0,
              right: 15,
            ),
            alignment: Alignment.centerLeft,
            child: Text(
              _apodData!.date,
              style: GoogleFonts.exo2(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                // color: Colors.white,
              ),
              softWrap: true,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(
              left: 25,
              top: 20,
              right: 15,
            ),
            alignment: Alignment.centerLeft,
            child: Text(
              'Explanation:',
              style: GoogleFonts.exo2(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                // color: Colors.white,
              ),
              softWrap: true,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(
              left: 25,
              top: 0,
              right: 15,
            ),
            alignment: Alignment.centerLeft,
            child: Text(
              _apodData!.explanation,
              style: GoogleFonts.exo2(
                fontSize: 25,
                fontWeight: FontWeight.w200,
                // color: Colors.white,
              ),
              softWrap: true,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(
              left: 25,
              top: 0,
              right: 15,
            ),
            alignment: Alignment.centerLeft,
            child: Text(
              'CREDIT: ${_apodData!.copyRight}',
              style: GoogleFonts.exo2(
                fontSize: 25,
                fontWeight: FontWeight.w300,
                // color: Colors.white,
              ),
              softWrap: true,
            ),
          ),
        ],
      );
    }
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            title: const Text('Astronomy Picture of the Day'),
            elevation: 0,
            backgroundColor:
                const Color.fromARGB(0, 255, 255, 255).withAlpha(200),
            floating: false,
            pinned: true,
            flexibleSpace: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                child: Container(
                  color: Colors.transparent,
                ),
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  setState(() {
                    _isLoading = true;
                  });
                  _loadData();
                },
                icon: const Icon(Icons.refresh),
                tooltip: 'Refresh',
              ),
            ],
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Container(
                  // Your content here
                  child: content,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';

import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:neopop/neopop.dart';

import 'package:http/http.dart' as http;
import './copyRightedPdfData.dart';
import 'package:pretty_diff_text/pretty_diff_text.dart';
import 'package:string_similarity/string_similarity.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _pagecount = 0;
  String TEXT = '';
  String TEXT2 = '';
  String TEXT4 = '';
  String TEXT5 = '';
  String Percent = '';
  File? _selectedFile = null,
      _selectedFile2 = null,
      _selectedFile3 = null,
      _selectedFile4 = null;
  List<CopyRightedPdfData> _pdfData = [];
  CopyRightedPdfData? selected;
  List<String> s2 = [];
  Uint8List? _documentBytes;
  String Database = "chair table computer chair";
  String Teacher = "desk chair pen";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPdfData();
  }

  void _showResult(String text) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Column(
              children: [
                const Text('Extracted text from pdf,'),
                Text("pdf pages count:${_pagecount.toString()}."),
              ],
            ),
            content: Scrollbar(
              child: SingleChildScrollView(
                child: Text(text),
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
              ),
            ),
            actions: [
              TextButton(
                child: const Text('Close'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  Future<bool> getStorageAccess() async {
    var status = await Permission.storage.status;

    if (!status.isGranted) {
      status = await Permission.storage.request();
    }

    return status.isGranted;
  }

// for extract text from pdf and
  dynamic getFiles(type) async {
    _documentBytes = await http.readBytes(Uri.parse(_pdfData[0].file));

    PdfDocument document = PdfDocument(inputBytes: _documentBytes);

    int pageCount = document.pages.count;

    PdfTextExtractor extractor = PdfTextExtractor(document);

    String text = extractor.extractText();
    TEXT = text;

    print('TEXT:$TEXT');

    _showResult(text);

    if (pageCount > 0) {
      setState(() {
        _selectedFile = _pdfData[0].name.toString() as File;

        _pagecount = pageCount;
      });
    } else {
      //TODO: Pop up <Please select another file>
    }
  }

  dynamic getFiles4(type) async {
    bool isPermissionGranted = await getStorageAccess();
    if (isPermissionGranted) {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: type == 'pdf' ? ['pdf'] : ['jpg', 'jpeg', 'png'],
      );
      if (result != null) {
        List<File> files =
            result.paths.map((path) => File(path.toString())).toList();
        List<String> paths = [];
        for (var i = 0; i < files.length; i++) {
          paths.add(files[i].path);
        }

        if (type == 'pdf') {
          PdfDocument document =
              PdfDocument(inputBytes: File(paths[0]).readAsBytesSync());
          int pageCount = document.pages.count;
          PdfTextExtractor extractor = PdfTextExtractor(document);

          String pagesFullyMatched = '', pagesNotMatched = '';
          for (int i = 0; i < pageCount; i++) {
            String text = extractor.extractText(startPageIndex: i);
            TEXT2 = text;
            print('TEXT 2:$TEXT2');
            if (TEXT.contains(text)) {
              pagesFullyMatched = pagesFullyMatched + (i + 1).toString() + ', ';
            } else {
              pagesNotMatched = pagesNotMatched + (i + 1).toString() + ', ';
            }
          }
//Extract all the text from the document.

          TEXT4 = 'Pages Fully Matched: ${pagesFullyMatched}';
          TEXT5 = 'Pages Not Matched: ${pagesNotMatched}';

//Display the text.
          // _showResult(text);

          if (pageCount > 0) {
            setState(() {
              _selectedFile4 = File(paths[0]);
              // print('@@@@@PageCount of the pdf:$_pagecount');
              // print('########Extracted Text from pdf:${text}');
              _pagecount = pageCount;
            });
          } else {
            //TODO: Pop up <Please select another file>
          }
        } else {
          setState(() {});
        }
      }
    }
  }

  void reset() {
    setState(() {
      _selectedFile = null;
      _selectedFile2 = null;
      _selectedFile3 = null;
      TEXT = '';
      TEXT2 = '';
    });
  }

  Future<void> getPdfData() async {
    final url =
        Uri.parse('http://192.168.0.173:8085/api/printables/copyrighted_data/');
    final res = await http.get(url, headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    });

    final data = json.decode(res.body) as List<dynamic>;
    List<CopyRightedPdfData> PdfData = [];

    for (var i = 0; i < data.length; i++) {
      PdfData.add(CopyRightedPdfData.fromJson(data[i]));
    }
    for (var i = 0; i < PdfData.length; i++) {
      selected = PdfData[i];
    }
    setState(() {
      print("FILEEEEE:${PdfData[0].file}");
      _pdfData = PdfData;
    });
  }

  void calculateStringSimilarity(String string1, String string2) {
    final double similarityPercentage =
        StringSimilarity.compareTwoStrings(string1, string2) * 100;
    print('percent:${similarityPercentage.ceil()}');
    Percent = "Similarity Percent : ${similarityPercentage.ceil().toString()}";

    // return similarityPercentage;
  }

  List<String> uniqueList = [];
  List<String> uniqueList2 = [];
  bool checkWordSimilarity() {
    Set<String> words1 = Database.split(' ').toSet();
    Set<String> words2 = Teacher.split(' ').toSet();

    for (String word in words1) {
      if (words2.contains(word)) {
        print("common word is :$word");
        if (!s2.contains(word)) {
          s2.add(word);
        }
      }
    }
    for (String word in words2) {
      if (words1.contains(word)) {
        return true;
        // Word is present in multiple words, show error
      }
    }

    return false; // No word is present in multiple words
  }

  bool checkWordSimilarity2() {
    Set<String> words1 = Database.split(' ').toSet();
    Set<String> words2 = Teacher.split(' ').toSet();
    for (String word in words1) {
      if (!words2.contains(word)) {
        if (!uniqueList.contains(word)) {
          uniqueList.add(word);
        }
      }
    }
    for (String word in words2) {
      if (!words1.contains(word)) {
        if (!uniqueList2.contains(word)) {
          uniqueList2.add(word);
        }
      }
    }
    return true; // No word is present in multiple words
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.black, Colors.black],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
        ),
        title: const Text('OCR'),
      ),
      body: Container(
        color: Colors.white,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                NeoPopTiltedButton(
                    isFloating: false,
                    onTapDown: () => getFiles('pdf'),
                    onTapUp: () => getFiles('pdf'),
                    decoration: const NeoPopTiltedButtonDecoration(
                        color: Colors.black,
                        plunkColor: Colors.green,
                        shadowColor: Colors.black,
                        showShimmer: true),
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                      child: Text(
                        'DataBase',
                        style: TextStyle(color: Colors.white),
                      ),
                    )),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  decoration: BoxDecoration(border: Border.all(width: 2)),
                  child: Text(
                    _selectedFile == null
                        ? ''
                        : "Database Pdf=> ${_pdfData[0].name}",
                    style: const TextStyle(color: Colors.green),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                NeoPopTiltedButton(
                    isFloating: false,
                    onTapUp: () => getFiles4('pdf'),
                    decoration: const NeoPopTiltedButtonDecoration(
                        color: Colors.black,
                        plunkColor: Colors.green,
                        shadowColor: Colors.black,
                        showShimmer: true),
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                      child: Text(
                        "Teacher's pdf",
                        style: TextStyle(color: Colors.white),
                      ),
                    )),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  decoration: BoxDecoration(border: Border.all(width: 2)),
                  child: Text(
                      _selectedFile4 == null
                          ? ''
                          : "Teacher's pdf=>${_selectedFile4!.path.split("/").last.toString()}",
                      style: const TextStyle(color: Colors.green)),
                ),
                const SizedBox(
                  height: 10,
                ),
                NeoPopTiltedButton(
                    isFloating: true,
                    onTapUp: () => reset(),
                    decoration: const NeoPopTiltedButtonDecoration(
                        color: Colors.black,
                        plunkColor: Colors.green,
                        shadowColor: Colors.black,
                        showShimmer: true),
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                      child: Text(
                        'Reset',
                        style: TextStyle(color: Colors.white),
                      ),
                    )),
                const SizedBox(
                  height: 10,
                ),
                Text(TEXT4),
                Text(TEXT5),
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: Container(
                //     padding: const EdgeInsets.all(10),
                //     decoration: BoxDecoration(border: Border.all(width: 2)),
                //     child: PrettyDiffText(
                //         newText: Teacher,
                //         oldText: Database,
                //         // red background text is extra text added by teacher in pdf and [missing in teacher pdf]
                //         addedTextStyle: const TextStyle(
                //             backgroundColor: Colors.pink,
                //             fontSize: 18,
                //             color: Colors.white),
                //         // green background text is missing text from teacher pdf and[extra in database]
                //         deletedTextStyle: const TextStyle(
                //             backgroundColor: Colors.amber,
                //             fontSize: 18,
                //             color: Colors.white)),
                //   ),
                // ),
                // ElevatedButton(
                //     onPressed: () =>
                //         calculateStringSimilarity(Teacher, Database),
                //     child: const Text('Check percentage')),
                // Text(
                //   " ${Percent}%",
                //   style: const TextStyle(color: Colors.black),
                // ),
                Text(
                  'DataBase: $Database',
                  style: TextStyle(fontSize: 20),
                ),
                Text('Teacher: $Teacher', style: TextStyle(fontSize: 20)),
                const SizedBox(height: 16),
                if (checkWordSimilarity())
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(border: Border.all()),
                    child: Text(
                      "Common Words:${s2.toString()}",
                      style: TextStyle(color: Colors.red, fontSize: 20),
                    ),
                  ),
                const SizedBox(
                  height: 10,
                ),
                if (checkWordSimilarity2())
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(border: Border.all()),
                    child: Text(
                      "Extra in database: ${uniqueList.toString()}",
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                  ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(border: Border.all()),
                  child: Text(
                    "Extra in teacher: ${uniqueList2.toString()}",
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

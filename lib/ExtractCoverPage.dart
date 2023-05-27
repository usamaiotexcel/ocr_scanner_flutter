import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:neopop/neopop.dart';

import 'package:http/http.dart' as http;
import './copyRightedPdfData.dart';

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  int _pagecount = 0;
  String TEXT = '';
  String TEXT2 = '';
  String TEXT3 = '';
  String TEXT4 = '';
  String TEXT5 = '';
  File? _selectedFile = null,
      _selectedFile2 = null,
      _selectedFile3 = null,
      _selectedFile4 = null;
  List<CopyRightedPdfData> _pdfData = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPdfData();
    // getPdfBytes();
  }

  void _showResult(String text) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Column(
              children: [
                const Text('Extracted Text From Pdf,'),
                Text("Pdf pages count:${_pagecount.toString()}."),
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

  Uint8List? _documentBytes;

// for extract text from pdf and
  dynamic getFiles(type) async {
    _documentBytes = await http.readBytes(Uri.parse(_pdfData[0].file));

    PdfDocument document = PdfDocument(inputBytes: _documentBytes);

    int pageCount = document.pages.count;

    PdfTextExtractor extractor = PdfTextExtractor(document);

//Extract all the text from the document.
    String text = extractor.extractText();
    TEXT = text;

//Display the text.
    _showResult(text);

    if (pageCount > 0) {
      setState(() {
        _selectedFile = _pdfData[0].name.toString() as File;
        // print('@@@@@PageCount of the pdf:$_pagecount');
        // print('@@@@@ Extracted Text from Database:${text}');
        _pagecount = pageCount;
      });
    } else {
      //TODO: Pop up <Please select another file>
    }
  }
  //     }
  //   }
  // }

  dynamic getFiles1(type) async {
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

//Extract all the text from the document.
          String text = extractor.extractText();
          TEXT2 = text;

//Display the text.
          _showResult(text);

          if (pageCount > 0) {
            setState(() {
              _selectedFile2 = File(paths[0]);
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

  // for extract cover page from pdf
  dynamic getFiles2(type) async {
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

//Extract all the text from the document.
          String text = extractor.extractText(startPageIndex: 0);
          TEXT3 = text;

//Display the text.
          _showResult(text);

          if (pageCount > 0) {
            setState(() {
              _selectedFile3 = File(paths[0]);
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
      TEXT3 = '';
    });
  }

  checkStringEquality(String string1, String string2) {
    if (string1 == string2) {
      print('text are identical');
    } else {
      // Compare strings using relevant comparison techniques
      // For example, you can use the Levenshtein distance algorithm
      double similarityPercentage = calculateSimilarity(string1, string2);

      if (similarityPercentage > 0.8) {
        print('text are relevant');
      } else {
        print('text are not the same or relevant');
      }
    }
  }

  double calculateSimilarity(String string1, String string2) {
    // Implement a string comparison algorithm here
    // For example, you can use the Levenshtein distance algorithm
    // to calculate the similarity percentage between the two strings
    // There are also other algorithms and libraries available for string comparison

    // Placeholder implementation that compares the lengths of the strings
    double similarity = (string1.length <= string2.length)
        ? string1.length / string2.length
        : string2.length / string1.length;

    return similarity;
  }

  Future<void> getPdfData() async {
    final url =
        Uri.parse('http://192.168.0.173:8081/api/printables/copyrighted_data/');
    final res = await http.get(url, headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    });

    final data = json.decode(res.body) as List<dynamic>;
    List<CopyRightedPdfData> PdfData = [];

    for (var i = 0; i < data.length; i++) {
      PdfData.add(CopyRightedPdfData.fromJson(data[i]));
    }
    setState(() {
      print("FILEEEEE:${PdfData[0].file}");
      _pdfData = PdfData;
    });
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
        title: const Text('Gradient AppBar'),
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
                        : "Database pdf=>${_pdfData[0].file}",
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
                        'Teacher\'s pdf',
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
                          : "Teacher\'s pdf=>${_selectedFile4!.path.split("/").last.toString()}",
                      style: const TextStyle(color: Colors.green)),
                ),
                const SizedBox(
                  height: 10,
                ),
                // NeoPopTiltedButton(
                //     isFloating: true,
                //     onTapUp: () => getFiles2('pdf'),
                //     decoration: const NeoPopTiltedButtonDecoration(
                //         color: Colors.black,
                //         plunkColor: Colors.green,
                //         shadowColor: Colors.black,
                //         showShimmer: true),
                //     child: const Padding(
                //       padding:
                //           EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                //       child: Text(
                //         'Cover Page',
                //         style: TextStyle(color: Colors.white),
                //       ),
                //     )),
                // const SizedBox(
                //   height: 10,
                // ),
                // Container(
                //   decoration: BoxDecoration(border: Border.all(width: 2)),
                //   child: Text(
                //       _selectedFile3 == null
                //           ? ''
                //           : "Cover Pdf:${_selectedFile3!.path.split("/").last.toString()}",
                //       style: TextStyle(color: Colors.green)),
                // ),
                const SizedBox(
                  height: 10,
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
                  height: 20,
                ),
                // if (TEXT.contains(TEXT2))
                //   Padding(
                //     padding: const EdgeInsets.all(8.0),
                //     child: Container(
                //         padding: const EdgeInsets.all(10),
                //         decoration: BoxDecoration(
                //             border: Border.all(width: 3, color: Colors.red)),
                //         child: const Text('100% Same Content',
                //             style: TextStyle(color: Colors.red))),
                //   ),
                Text(TEXT4),
                Text(TEXT5),
                Column(children: [
                  Container(
                    child: checkStringEquality(TEXT, TEXT2),
                  )
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

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
  File? _selectedFile = null, _selectedFile2 = null, _selectedFile3 = null;

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

  dynamic getFiles(type) async {
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
          TEXT = text;

//Display the text.
          _showResult(text);

          if (pageCount > 0) {
            setState(() {
              _selectedFile = File(paths[0]);
              print('@@@@@PageCount of the pdf:$_pagecount');
              print('########Extracted Text from pdf:${text}');
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
              print('@@@@@PageCount of the pdf:$_pagecount');
              print('########Extracted Text from pdf:${text}');
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
              print('@@@@@PageCount of the pdf:$_pagecount');
              print('########Extracted Text from pdf:${text}');
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

//   dynamic getpdf(type) async {
//     bool isPermissionGranted = await getStorageAccess();
//     if (isPermissionGranted) {
//       FilePickerResult? result = await FilePicker.platform.pickFiles(
//         type: FileType.custom,
//         allowedExtensions: type == 'pdf' ? ['pdf'] : ['jpg', 'jpeg', 'png'],
//       );
//       if (result != null) {
//         List<File> files =
//             result.paths.map((path) => File(path.toString())).toList();
//         List<String> paths = [];
//         for (var i = 0; i < files.length; i++) {
//           paths.add(files[i].path);
//         }

//         if (type == 'pdf') {
//           PdfDocument document =
//               PdfDocument(inputBytes: File(paths[0]).readAsBytesSync());
//           PdfTextExtractor extractor = PdfTextExtractor(document);

// //Extract all the text from specific page.
//           List<TextLine> result1 =
//               extractor.extractTextLines(startPageIndex: 0);

// //Draw rectangle.
//           for (int i = 0; i < result1.length; i++) {
//             List<TextWord> wordCollection = result1[i].wordCollection;
//             for (int j = 0; j < wordCollection.length; j++) {
//               if ('As a vehicle for delivering' == wordCollection[j].text) {
// //Get the font name.
//                 String fontName = wordCollection[j].fontName;
// //Get the font size.
//                 double fontSize = wordCollection[j].fontSize;
// //Get the font style.
//                 List<PdfFontStyle> fontStyle = wordCollection[j].fontStyle;
// //Get the text.
//                 String text = wordCollection[j].text;
//                 String fontStyleText = '';
//                 for (int i = 0; i < fontStyle.length; i++) {
//                   fontStyleText += fontStyle[i].toString() + ' ';
//                 }
//                 fontStyleText = fontStyleText.replaceAll('PdfFontStyle.', '');
//                 _showResult(
//                     'Text : $text \r\n Font Name: $fontName \r\n Font Size: $fontSize \r\n Font Style: $fontStyleText');
//                 break;
//               }
//             }
//           }
// //Dispose the document.
//           document.dispose();
//         }
//       }
//     }
//   }
  void reset() {
    setState(() {
      _selectedFile = null;
      _selectedFile2 = null;
      _selectedFile3 = null;
    });
  }

  // func() {
  //   if (TEXT.compareTo(TEXT2) == 0) {
  //     return 'same content';
  //   } else {
  //     return '';
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed: () => getFiles('pdf'),
                child: Text(_selectedFile == null
                    ? 'pick pdf1'
                    : _selectedFile!.path.split("/").last.toString()),
              ),
              ElevatedButton(
                onPressed: () => getFiles1('pdf'),
                child: Text(_selectedFile2 == null
                    ? 'pick pdf2'
                    : _selectedFile2!.path.split("/").last.toString()),
              ),
              ElevatedButton(
                onPressed: () => getFiles2('pdf'),
                child: Text(_selectedFile3 == null
                    ? 'Cover Page'
                    : _selectedFile3!.path.split("/").last.toString()),
              ),
              ElevatedButton(
                onPressed: () => reset(),
                child: const Text('Reset'),
              ),
              // Text(func().toString()),
              TEXT.compareTo(TEXT2) == 0
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              border: Border.all(width: 2, color: Colors.red)),
                          child: const Text('Same Content',
                              style: TextStyle(color: Colors.red))),
                    )
                  : Text('Content is not same'),
            ],
          ),
        ),
      ),
    );
  }
}

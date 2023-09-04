import 'dart:io';

import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';


class Excelsheet extends StatefulWidget {
  const Excelsheet({Key? key}) : super(key: key);

  @override
  State<Excelsheet> createState() => _ExcelsheetState();
}

class _ExcelsheetState extends State<Excelsheet> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(

          child: Text("Create excel"),

          onPressed: createExcel,
        ),

      ),
    );
  }

   createExcel()async{

    final Workbook workbook = Workbook();
    final Worksheet sheet   = workbook.worksheets[0];
    sheet.getRangeByName("A1").setText("Hello World");
    final List<int>bytes = workbook.saveAsStream();
    workbook.dispose();

    final String path =(await getApplicationSupportDirectory()).path;
    final String fileName ="$path/Output.xlsx";
    final File file  = File (fileName);
    await file.writeAsBytes(bytes, flush: true);
    OpenFile.open(fileName);

  }


}


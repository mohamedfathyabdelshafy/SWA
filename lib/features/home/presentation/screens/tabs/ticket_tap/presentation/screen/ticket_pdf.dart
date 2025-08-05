import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:intl/intl.dart' as intl;

import 'package:pdf/widgets.dart' as pw;
import 'package:qr_flutter/qr_flutter.dart';
import 'package:sizer/sizer.dart';
import 'package:swa/config/routes/app_routes.dart';
import 'package:swa/core/utils/Navigaton_bottombar.dart';
import 'package:swa/core/utils/app_colors.dart';
import 'package:swa/core/utils/language.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/presentation/screens/more_screen.dart';
import 'package:swa/features/home/presentation/screens/tabs/ticket_tap/data/model/Ticketdetails_model.dart';

class PdfPreviewPage extends StatelessWidget {
  Message? ticket;
  PdfPreviewPage(this.ticket, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ticket!.cities!.sort((a, b) => a.orderIndex!.compareTo(b.orderIndex!));

    _printTicket(ticket!);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          LanguageClass.isEnglish ? 'Ticket' : 'التذكرة',
        ),
      ),
      body: PdfPreview(
        build: (context) => _printTicket(ticket!),
      ),
    );
  }

  bool _isArabic(String text) {
    for (int i = 0; i < text.length; i++) {
      final codeUnit = text.codeUnitAt(i);
      // Common Unicode range for Arabic characters
      if (codeUnit >= 0x0600 && codeUnit <= 0x06FF) {
        return true;
      }
    }
    return false;
  }

  pw.Widget _pdfDetailRow(
    pw.Font ttf,
    pw.Font ttfBold,
    bool isRtl, // This is the overall page direction (isAr from _printTicket)
    String label1,
    String value1,
    String label2,
    String value2,
  ) {
    // Create the content for the first column (label1 + value1)
    final pw.Widget column1Content = pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.start,
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        // The label part, its direction follows the overall document direction
        pw.Text(
          '$label1: ',
          style: pw.TextStyle(font: ttfBold, fontSize: 9),
          textDirection: isRtl ? pw.TextDirection.rtl : pw.TextDirection.ltr,
        ),
        pw.Directionality(
          textDirection: _isArabic(value1) ? pw.TextDirection.rtl : pw.TextDirection.ltr,
          child: pw.Text(
            value1,
            style: pw.TextStyle(font: ttf, fontSize: 9),
            // Text alignment within its Directionality context.
            // If the text itself is Arabic, align right. Otherwise, left.
          ),
        ),
      ],
    );

    // Create the content for the second column (label2 + value2)
    pw.Widget column2Content = pw.SizedBox.shrink(); // Default to empty if label2 is empty
    if (label2.isNotEmpty) {
      column2Content = pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.start,
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          // The label part, its direction follows the overall document direction
          pw.Text(
            '$label2: ',
            style: pw.TextStyle(font: ttfBold, fontSize: 9),
            textDirection: isRtl ? pw.TextDirection.rtl : pw.TextDirection.ltr,
          ),
          pw.Directionality(
            textDirection: _isArabic(value2) ? pw.TextDirection.rtl : pw.TextDirection.ltr,
            child: pw.Text(
              value2,
              style: pw.TextStyle(font: ttf, fontSize: 9),
              // Text alignment within its Directionality context.
            ),
          ),
        ],
      );
    }

    // Determine the order of columns based on the overall page direction (isRtl)
    List<pw.Widget> rowChildren;
    if (isRtl) {
      // For RTL overall layout, the second column content goes to the right, first to the left
      rowChildren = [
        pw.Expanded(child: column1Content),
        pw.Expanded(child: column2Content),
      ];
    } else {
      // For LTR overall layout, the first column content goes to the left, second to the right
      rowChildren = [
        pw.Expanded(child: column1Content),
        pw.Expanded(child: column2Content),
      ];
    }

    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey, width: 0.5),
      ),
      padding: const pw.EdgeInsets.symmetric(vertical: 3, horizontal: 5),
      child: pw.Row(children: rowChildren),
    );
  }

  // New function to handle printing
  Future<Uint8List> _printTicket(Message ticketDetails) async {
    final pdf = pw.Document();
    final isAr = !LanguageClass.isEnglish;

    final ttf = pw.Font.ttf(
      await rootBundle.load('assets/fonts/arabic_medium.ttf'),
    );
    final ttfBold = pw.Font.ttf(
      await rootBundle.load('assets/fonts/arabic_bold.ttf'),
    );

    final logo = pw.MemoryImage(
      (await rootBundle.load('assets/images/Logo.png')).buffer.asUint8List(),
    );

    final DateTime reservationDateTime = intl.DateFormat(
      'dd/MM/yyyy',
    ).parse(ticketDetails!.creationDate!);

    final String formattedReservationDate = intl.DateFormat(
      'yyyy-MM-dd',
    ).format(reservationDateTime);

    final DateTime tripDateTime = intl.DateFormat(
      'dd/MM/yyyy',
    ).parse(ticketDetails.tripDate!);
    final String tripReservationDate = intl.DateFormat(
      'yyyy-MM-dd',
    ).format(tripDateTime);
    final String qrCodeData = "Ticket Number: ${ticketDetails.ticketNumber.toString()}\n"
        "Customer Name: ${ticketDetails.customerName}\n"
        "Reservation Date: $formattedReservationDate\n"
        "Trip Date: $tripReservationDate\n"
        "Status: ${ticketDetails.statusName}";

    final qrData = await QrPainter(
      data: qrCodeData,
      version: QrVersions.auto,
      gapless: true,
    ).toImageData(200);

    final qrImage = pw.MemoryImage(qrData!.buffer.asUint8List());

    var patrnerlogo = null;

    if (ticket?.logoFilePath != null) {
      patrnerlogo = await networkImage(ticket!.logoFilePath!);
    }

    final parsedHtml = html_parser.parse(ticket!.policy!.first);

    List policyString = extractListItems(ticket!.policy!.first!);

    print(policyString.length);

    // Sort cities by orderIndex
    final sortedCities = (ticketDetails.cities ?? []).toList()
      ..sort((a, b) => (a.orderIndex ?? 0).compareTo(b.orderIndex ?? 0));

    pdf.addPage(pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        theme: pw.ThemeData.withFont(base: ttf, bold: ttfBold),
        margin: const pw.EdgeInsets.all(18),
        build: (context) {
          return List<pw.Widget>.generate(
            1,
            (index) {
              return pw.Directionality(
                textDirection: isAr ? pw.TextDirection.rtl : pw.TextDirection.ltr,
                child: pw.Container(
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.black, width: 1),
                  ),
                  padding: const pw.EdgeInsets.all(10), // Inner padding from border
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                    children: [
                      // Logo + QR + Ticket #
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Image(logo, height: 20),
                          pw.Image(qrImage, height: 35, width: 35),
                          pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.end,
                            children: [
                              patrnerlogo != null ? pw.Image(patrnerlogo!, height: 20) : pw.SizedBox(),
                              pw.Text(
                                '${isAr ? "رقم التذكرة" : "Ticket Num"}: ${ticketDetails.ticketNumber}',
                                style: pw.TextStyle(fontSize: 8),
                              ),
                              pw.Text(
                                ticketDetails.statusName ?? '',
                                style: pw.TextStyle(fontSize: 8),
                              ),
                            ],
                          ),
                        ],
                      ),
                      pw.SizedBox(height: 8),

                      // Table Rows
                      _pdfDetailRow(
                        ttf,
                        ttfBold,
                        isAr,
                        isAr ? 'اسم العميل' : 'Customer Name',
                        ticketDetails.customerName!,
                        isAr ? 'الهاتف' : 'Phone',
                        ticketDetails.customerPhone!,
                      ),
                      _pdfDetailRow(
                        ttf,
                        ttfBold,
                        isAr,
                        isAr ? 'من' : 'From',
                        ticketDetails.from!,
                        isAr ? 'إلى' : 'To',
                        ticketDetails.to!,
                      ),
                      _pdfDetailRow(
                        ttf,
                        ttfBold,
                        isAr,
                        isAr ? 'الخط' : 'Route',
                        ticketDetails.lineName!,
                        isAr ? ' ' : '',
                        "",
                      ),
                      _pdfDetailRow(
                        ttf,
                        ttfBold,
                        isAr,
                        isAr ? 'تاريخ الرحلة' : 'Trip Date',
                        ticketDetails.tripDate!,
                        isAr ? 'وقت القيام' : 'Departure Time',
                        ticketDetails.accessBusTime ?? '',
                      ),

                      _pdfDetailRow(
                        ttf,
                        ttfBold,
                        isAr,
                        isAr ? 'وقت الوصول' : 'Arrival time',
                        ticketDetails.arrivaltime ?? '',
                        "",
                        '',
                      ),
                      _pdfDetailRow(
                        ttf,
                        ttfBold,
                        isAr,
                        isAr ? 'السعر' : 'Price',
                        '${ticketDetails.price} ${Routes.curruncy ?? "EGP"}',
                        isAr ? 'رقم الرحلة' : 'Trip Number',
                        ticketDetails.tripNumber.toString(),
                      ),
                      _pdfDetailRow(
                        ttf,
                        ttfBold,
                        isAr,
                        isAr ? 'عدد المقاعد' : 'Seats count',
                        '${ticketDetails.seatNo.toString()}',
                        ticketDetails.seatNumbers!.split(',').length == 2
                            ? isAr
                                ? 'رقم المقعد'
                                : 'Seat No'
                            : isAr
                                ? 'ارقام المقاعد'
                                : 'Seats No',
                        ticketDetails.seatNumbers!,
                      ),
                      ticketDetails.penalty != 0.0
                          ? _pdfDetailRow(
                              ttf,
                              ttfBold,
                              isAr,
                              isAr ? "الغرامة" : "Penalty",
                              "${ticketDetails.penalty!.toStringAsFixed(2)} ${Routes.curruncy ?? "EGP"}",
                              "",
                              "",
                            )
                          : pw.SizedBox.shrink(),

                      // pw.SizedBox(height: 6),

                      // Bus Route Table
                      pw.Text(
                        isAr ? 'مسار الاتوبيس:' : 'Bus Route:',
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 9,
                        ),
                      ),
                      pw.SizedBox(height: 4),
                      if (sortedCities.isNotEmpty)
                        pw.Table.fromTextArray(
                          headers:
                              isAr ? ['المدينة والمحطات', 'المدينة والمحطات'] : ['City & Stations', 'City & Stations'],
                          data: _createCityStationTableData(
                            sortedCities,
                            isAr,
                            ttf,
                            ttfBold,
                          ),
                          border: pw.TableBorder.all(
                            color: PdfColors.grey,
                            width: 0.5,
                          ),
                          headerStyle: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 8,
                            font: ttfBold,
                          ),
                          headerDecoration: const pw.BoxDecoration(
                            color: PdfColors.grey300,
                          ),
                          cellAlignment: isAr ? pw.Alignment.centerRight : pw.Alignment.centerLeft,
                          cellStyle: pw.TextStyle(fontSize: 8, font: ttf),
                          columnWidths: {
                            0: const pw.FlexColumnWidth(1.0),
                            1: const pw.FlexColumnWidth(1.0),
                          },
                          headerHeight: 10,
                          cellHeight: 10,
                        )
                      else
                        pw.Text(
                          isAr ? 'لا توجد معلومات عن مسار الحافلة.' : 'No bus route information available.',
                          style: pw.TextStyle(fontSize: 8),
                        ),

                      pw.SizedBox(height: 10),

                      // Policy Block
                      pw.Container(
                        decoration: pw.BoxDecoration(
                          border: pw.Border.all(
                            color: PdfColors.grey,
                            width: 0.5,
                          ),
                          borderRadius: pw.BorderRadius.circular(6),
                        ),
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Center(
                              child: pw.Text(
                                isAr ? 'شروط الحجز' : 'Booking Terms & Conditions',
                                style: pw.TextStyle(
                                  fontSize: 10,
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                            ),
                            pw.SizedBox(height: 10),
                            ...policyString.map(
                              (text) => pw.Container(
                                margin: const pw.EdgeInsets.only(bottom: 2),
                                padding: const pw.EdgeInsets.all(4),
                                decoration: pw.BoxDecoration(
                                  color: PdfColors.grey200,
                                  borderRadius: pw.BorderRadius.circular(6),
                                  border: pw.Border.all(
                                    color: PdfColors.grey300,
                                    width: 0.5,
                                  ),
                                ),
                                child: pw.Directionality(
                                  textDirection: isAr ? pw.TextDirection.rtl : pw.TextDirection.ltr,
                                  child: pw.Text(
                                    text,
                                    style: pw.TextStyle(fontSize: 10, font: ttf),
                                    textAlign: isAr ? pw.TextAlign.right : pw.TextAlign.left,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }));

    return pdf.save();
  }

  // Helper function to create table data for cities and stations (two per row with numbering)
  List<List<pw.Widget>> _createCityStationTableData(
    List<City> cities,
    bool isAr,
    pw.Font ttf,
    pw.Font ttfBold,
  ) {
    final List<List<pw.Widget>> data = [];
    int cityCounter = 1;

    for (int i = 0; i < cities.length; i += 2) {
      List<pw.Widget> rowWidgets = [];

      // First city in the pair
      final city1 = cities[i];
      final sortedStations1 = city1.lineStationList!.toList()
        ..sort((a, b) => (a.orderIndex ?? 0).compareTo(b.orderIndex ?? 0));
      final stationsText1 =
          sortedStations1.map((s) => '${isAr ? s.station!.nameAr : s.station!.nameEn}').join(isAr ? ' - ' : ' - ');
      rowWidgets.add(
        pw.RichText(
          text: pw.TextSpan(
            text: '${cityCounter++} - ${city1.cityName}: ',
            style: pw.TextStyle(font: ttfBold, fontSize: 8),
            children: [
              pw.TextSpan(text: stationsText1, style: pw.TextStyle(font: ttf)),
            ],
          ),
        ),
      );

      // Second city in the pair (if available)
      if (i + 1 < cities.length) {
        final city2 = cities[i + 1];
        final sortedStations2 = city2.lineStationList!.toList()
          ..sort(
            (a, b) => (a.orderIndex ?? 0).compareTo(b.orderIndex ?? 0),
          );
        final stationsText2 =
            sortedStations2.map((s) => '${isAr ? s.station!.nameAr : s.station!.nameEn}').join(isAr ? ' - ' : ' - ');
        rowWidgets.add(
          pw.RichText(
            text: pw.TextSpan(
              text: '${cityCounter++} - ${city2.cityName}: ',
              style: pw.TextStyle(font: ttfBold, fontSize: 8),
              children: [
                pw.TextSpan(
                  text: stationsText2,
                  style: pw.TextStyle(font: ttf),
                ),
              ],
            ),
          ),
        );
      } else {
        // Add an empty cell if there's an odd number of cities
        rowWidgets.add(pw.Text(''));
      }
      if (isAr) {
        data.add(rowWidgets.reversed.toList());
      } else {
        data.add(rowWidgets);
      }
    }
    return data;
  }

  List<String> _extractPolicyItems(String html) {
    final liExp = RegExp(
      r"<ul><li[^>]>(.?)<\/li><ul>",
      multiLine: true,
      caseSensitive: false,
    );
    return liExp
        .allMatches(html)
        .map((m) => m.group(1) ?? '')
        .map((item) => item.replaceAll(RegExp(r"<[^>]+>"), '').trim())
        .where((item) => item.isNotEmpty)
        .toList();
  }

  List<String> extractListItems(String html) {
    final document = html_parser.parse(html);
    final listItems = document.getElementsByTagName('li');
    return listItems.map((e) => e.text.trim()).toList();
  }

  Future<Uint8List> makePdf() async {
    final imageLogo = (await rootBundle.load('assets/images/Logo.png')).buffer.asUint8List();

    final parsedHtml = html_parser.parse(ticket!.policy!.first);
    final textContent = parsedHtml.body?.text ?? 'No content';
    var data = await rootBundle.load("assets/fonts/arabic_medium.ttf");
    final ttf = pw.Font.ttf(data);

    final pdf = pw.Document();
    pdf.addPage(pw.MultiPage(
        theme: pw.ThemeData.withFont(
          base: ttf,
        ),
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return List<pw.Widget>.generate(
            1,
            (index) {
              return pw.Directionality(
                textDirection: LanguageClass.isEnglish ? pw.TextDirection.ltr : pw.TextDirection.rtl,
                child: pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  children: [
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Column(
                          children: [
                            pw.Text("Ticket Num: ${ticket!.ticketNumber.toString()}",
                                textDirection: LanguageClass.isEnglish ? pw.TextDirection.ltr : pw.TextDirection.rtl),
                            pw.Text("${ticket!.statusName.toString()}",
                                textDirection: LanguageClass.isEnglish ? pw.TextDirection.ltr : pw.TextDirection.rtl,
                                style: pw.TextStyle(color: PdfColor.fromHex("#ff5d4b"))),
                          ],
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                        ),
                        pw.Container(
                            width: 80,
                            height: 80,
                            child: pw.BarcodeWidget(
                              color: PdfColor.fromHex("#000000"),
                              barcode: pw.Barcode.qrCode(),
                              data: 'TicketNumber:${ticket!.ticketNumber.toString()},Status:${ticket!.statusName}',
                            )),
                        pw.Container(
                          alignment: pw.Alignment.topRight,
                          child: pw.Container(
                              width: 50,
                              height: 50,
                              decoration:
                                  pw.BoxDecoration(image: pw.DecorationImage(image: pw.MemoryImage(imageLogo)))),
                        ),
                      ],
                    ),
                    pw.Container(height: 10),
                    pw.Table(
                      border: pw.TableBorder.all(color: PdfColors.black),
                      children: [
                        pw.TableRow(
                          verticalAlignment: pw.TableCellVerticalAlignment.full,
                          children: [
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(10),
                              child: pw.Text(
                                  '${LanguageClass.isEnglish ? 'Cunstomer Name' : 'اسم العميل'} :  ${ticket!.customerName.toString()}',
                                  textDirection: LanguageClass.isEnglish ? pw.TextDirection.ltr : pw.TextDirection.rtl,
                                  textAlign: LanguageClass.isEnglish ? pw.TextAlign.left : pw.TextAlign.right,
                                  style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.normal)),
                            ),
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(10),
                              child: pw.Text(
                                  '${LanguageClass.isEnglish ? 'Mobile' : 'تليفون'} :  ${ticket!.customerPhone.toString()}',
                                  textDirection: LanguageClass.isEnglish ? pw.TextDirection.ltr : pw.TextDirection.rtl,
                                  textAlign: LanguageClass.isEnglish ? pw.TextAlign.left : pw.TextAlign.right,
                                  style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.normal)),
                            ),
                          ],
                        ),
                        pw.TableRow(
                          children: [
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(10),
                              child: pw.Text(
                                  '${LanguageClass.isEnglish ? 'From' : ' من'} :  ${ticket!.from.toString()}',
                                  textDirection: LanguageClass.isEnglish ? pw.TextDirection.ltr : pw.TextDirection.rtl,
                                  textAlign: LanguageClass.isEnglish ? pw.TextAlign.left : pw.TextAlign.right,
                                  style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.normal)),
                            ),
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(10),
                              child: pw.Text('${LanguageClass.isEnglish ? 'To' : 'الي'} :  ${ticket!.to.toString()}',
                                  textDirection: LanguageClass.isEnglish ? pw.TextDirection.ltr : pw.TextDirection.rtl,
                                  textAlign: LanguageClass.isEnglish ? pw.TextAlign.left : pw.TextAlign.right,
                                  style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.normal)),
                            ),
                          ],
                        ),
                      ],
                    ),
                    pw.Table(border: pw.TableBorder.all(color: PdfColors.black), children: [
                      pw.TableRow(children: [
                        pw.Container(
                          padding: const pw.EdgeInsets.all(10),
                          color: PdfColor.fromHex("#e5e7e9"),
                          alignment: pw.Alignment.center,
                          child: pw.Text('${LanguageClass.isEnglish ? "Cities & Stations" : 'المدن والمحطات'} ',
                              textDirection: LanguageClass.isEnglish ? pw.TextDirection.ltr : pw.TextDirection.rtl,
                              textAlign: LanguageClass.isEnglish ? pw.TextAlign.left : pw.TextAlign.right,
                              style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.normal)),
                        ),
                      ])
                    ]),
                    pw.Container(
                      decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.black)),
                      padding: const pw.EdgeInsets.all(10),
                      width: double.infinity,
                      child: pw.Wrap(
                          direction: pw.Axis.horizontal,
                          alignment: pw.WrapAlignment.start,
                          runAlignment: pw.WrapAlignment.start,
                          runSpacing: 20,
                          spacing: 0,
                          verticalDirection: pw.VerticalDirection.down,
                          crossAxisAlignment: pw.WrapCrossAlignment.start,
                          children: [
                            for (int i = 0; i < ticket!.cities!.length; i++)
                              pw.Container(
                                  width: 230,
                                  child: pw.Row(
                                      mainAxisAlignment: pw.MainAxisAlignment.start,
                                      crossAxisAlignment: pw.CrossAxisAlignment.center,
                                      mainAxisSize: pw.MainAxisSize.min,
                                      children: [
                                        pw.Text(
                                            '${ticket!.cities![i].orderIndex}- ${ticket!.cities![i].governorateName ?? ''}',
                                            textDirection:
                                                LanguageClass.isEnglish ? pw.TextDirection.ltr : pw.TextDirection.rtl,
                                            textAlign: LanguageClass.isEnglish ? pw.TextAlign.left : pw.TextAlign.right,
                                            style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.normal)),
                                        pw.Text('  ${ticket!.cities![i].cityName ?? ''}',
                                            textDirection:
                                                LanguageClass.isEnglish ? pw.TextDirection.ltr : pw.TextDirection.rtl,
                                            textAlign: LanguageClass.isEnglish ? pw.TextAlign.left : pw.TextAlign.right,
                                            style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.normal)),
                                      ]))
                          ]),
                    ),
                    pw.Table(
                      border: pw.TableBorder.all(color: PdfColors.black),
                      children: [
                        pw.TableRow(
                          children: [
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(10),
                              child: pw.Text(
                                  '${LanguageClass.isEnglish ? "Line" : 'المسار'} :  ${ticket!.lineName ?? ''}',
                                  textDirection: LanguageClass.isEnglish ? pw.TextDirection.ltr : pw.TextDirection.rtl,
                                  textAlign: LanguageClass.isEnglish ? pw.TextAlign.left : pw.TextAlign.right,
                                  style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.normal)),
                            ),
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(10),
                              child: pw.Text(
                                  '${LanguageClass.isEnglish ? "Penalty" : 'غرامة'} :  ${ticket!.penalty.toString() ?? ''}',
                                  textDirection: LanguageClass.isEnglish ? pw.TextDirection.ltr : pw.TextDirection.rtl,
                                  textAlign: LanguageClass.isEnglish ? pw.TextAlign.left : pw.TextAlign.right,
                                  style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.normal)),
                            ),
                          ],
                        ),
                        pw.TableRow(
                          children: [
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(10),
                              child: pw.Text(
                                  '${LanguageClass.isEnglish ? "Trip date" : 'تاريخ الرحلة'} :  ${ticket!.tripDate.toString()}',
                                  textDirection: LanguageClass.isEnglish ? pw.TextDirection.ltr : pw.TextDirection.rtl,
                                  textAlign: LanguageClass.isEnglish ? pw.TextAlign.left : pw.TextAlign.right,
                                  style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.normal)),
                            ),
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(10),
                              child: pw.Text(
                                  '${LanguageClass.isEnglish ? "Trip type" : ' نوع الرحلة'} :  ${ticket!.serviceType.toString()}',
                                  textDirection: LanguageClass.isEnglish ? pw.TextDirection.ltr : pw.TextDirection.rtl,
                                  textAlign: LanguageClass.isEnglish ? pw.TextAlign.left : pw.TextAlign.right,
                                  style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.normal)),
                            ),
                          ],
                        ),
                        pw.TableRow(
                          children: [
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(10),
                              child: pw.Text(
                                  '${LanguageClass.isEnglish ? "Trip time" : 'وقت القيام '} :  ${ticket!.accessBusTime.toString()}',
                                  textDirection: LanguageClass.isEnglish ? pw.TextDirection.ltr : pw.TextDirection.rtl,
                                  textAlign: LanguageClass.isEnglish ? pw.TextAlign.left : pw.TextAlign.right,
                                  style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.normal)),
                            ),
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(10),
                              child: pw.Text(
                                  '${LanguageClass.isEnglish ? "Price" : 'السعر'} :  ${ticket!.price.toString()}',
                                  textDirection: LanguageClass.isEnglish ? pw.TextDirection.ltr : pw.TextDirection.rtl,
                                  textAlign: LanguageClass.isEnglish ? pw.TextAlign.left : pw.TextAlign.right,
                                  style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.normal)),
                            ),
                          ],
                        ),
                        pw.TableRow(
                          children: [
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(10),
                              child: pw.Text(
                                  '${LanguageClass.isEnglish ? "Trip  num" : 'رقم الرحلة'} :  ${ticket!.tripNumber.toString()}',
                                  textDirection: LanguageClass.isEnglish ? pw.TextDirection.ltr : pw.TextDirection.rtl,
                                  textAlign: LanguageClass.isEnglish ? pw.TextAlign.left : pw.TextAlign.right,
                                  style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.normal)),
                            ),
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(10),
                              child: pw.Text(
                                  '${LanguageClass.isEnglish ? "Ticket num" : 'رقم التذكرة'} :  ${ticket!.ticketNumber.toString()}',
                                  textDirection: LanguageClass.isEnglish ? pw.TextDirection.ltr : pw.TextDirection.rtl,
                                  textAlign: LanguageClass.isEnglish ? pw.TextAlign.left : pw.TextAlign.right,
                                  style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.normal)),
                            ),
                          ],
                        ),
                        pw.TableRow(
                          children: [
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(10),
                              child: pw.Text(
                                  '${LanguageClass.isEnglish ? "Created by" : 'مكتب الاصدار'} :  ${ticket!.createdBy.toString()}',
                                  textDirection: LanguageClass.isEnglish ? pw.TextDirection.ltr : pw.TextDirection.rtl,
                                  textAlign: LanguageClass.isEnglish ? pw.TextAlign.left : pw.TextAlign.right,
                                  style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.normal)),
                            ),
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(10),
                              child: pw.Text(
                                  '${LanguageClass.isEnglish ? "Seat numbers" : 'رقم المقعد'} :  ${ticket!.seatNumbers.toString()}',
                                  textDirection: LanguageClass.isEnglish ? pw.TextDirection.ltr : pw.TextDirection.rtl,
                                  textAlign: LanguageClass.isEnglish ? pw.TextAlign.left : pw.TextAlign.right,
                                  style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.normal)),
                            ),
                          ],
                        ),
                      ],
                    ),
                    pw.Table(children: [
                      pw.TableRow(children: [
                        pw.Text(textContent,
                            textDirection: LanguageClass.isEnglish ? pw.TextDirection.ltr : pw.TextDirection.rtl,
                            textAlign: LanguageClass.isEnglish ? pw.TextAlign.start : pw.TextAlign.start,
                            style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.normal)),
                      ])
                    ]),
                  ],
                ),
              );
            },
          );
        }));

    return pdf.save();
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:sizer/sizer.dart';
import 'package:swa/core/utils/app_colors.dart';
import 'package:swa/core/utils/language.dart';
import 'package:swa/features/home/presentation/screens/tabs/ticket_tap/data/model/Ticketdetails_model.dart';

class PdfPreviewPage extends StatelessWidget {
  Message? ticket;
  int policylength;
  PdfPreviewPage(this.ticket, this.policylength, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          LanguageClass.isEnglish ? 'Ticket' : 'التذكرة',
        ),
      ),
      body: PdfPreview(
        build: (context) => makePdf(),
      ),
    );
  }

  Future<Uint8List> makePdf() async {
    final imageLogo =
        (await rootBundle.load('assets/images/Logo.png')).buffer.asUint8List();

    var data = await rootBundle.load("assets/fonts/arabic_medium.ttf");
    final ttf = pw.Font.ttf(data);

    final pdf = pw.Document();
    pdf.addPage(pw.Page(
      theme: pw.ThemeData.withFont(
        base: ttf,
      ),
      build: (context) {
        return pw.Directionality(
          textDirection: LanguageClass.isEnglish
              ? pw.TextDirection.ltr
              : pw.TextDirection.rtl,
          child: pw.ListView(
            children: [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    children: [
                      pw.Text("Ticket Num: ${ticket!.ticketNumber.toString()}",
                          textDirection: LanguageClass.isEnglish
                              ? pw.TextDirection.ltr
                              : pw.TextDirection.rtl),
                      pw.Text("${ticket!.statusName.toString()}",
                          textDirection: LanguageClass.isEnglish
                              ? pw.TextDirection.ltr
                              : pw.TextDirection.rtl,
                          style:
                              pw.TextStyle(color: PdfColor.fromHex("#ff5d4b"))),
                    ],
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                  ),
                  pw.Container(
                      width: 80,
                      height: 80,
                      child: pw.BarcodeWidget(
                        color: PdfColor.fromHex("#000000"),
                        barcode: pw.Barcode.qrCode(),
                        data:
                            'TicketNumber:${ticket!.ticketNumber.toString()},Status:${ticket!.statusName}',
                      )),
                  pw.Container(
                    alignment: pw.Alignment.topRight,
                    child: pw.Container(
                        width: 50,
                        height: 50,
                        decoration: pw.BoxDecoration(
                            image: pw.DecorationImage(
                                image: pw.MemoryImage(imageLogo)))),
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
                            textDirection: LanguageClass.isEnglish
                                ? pw.TextDirection.ltr
                                : pw.TextDirection.rtl,
                            textAlign: LanguageClass.isEnglish
                                ? pw.TextAlign.left
                                : pw.TextAlign.right,
                            style: pw.TextStyle(
                                fontSize: 14,
                                fontWeight: pw.FontWeight.normal)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(10),
                        child: pw.Text(
                            '${LanguageClass.isEnglish ? 'Mobile' : 'تليفون'} :  ${ticket!.customerPhone.toString()}',
                            textDirection: LanguageClass.isEnglish
                                ? pw.TextDirection.ltr
                                : pw.TextDirection.rtl,
                            textAlign: LanguageClass.isEnglish
                                ? pw.TextAlign.left
                                : pw.TextAlign.right,
                            style: pw.TextStyle(
                                fontSize: 14,
                                fontWeight: pw.FontWeight.normal)),
                      ),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(10),
                        child: pw.Text(
                            '${LanguageClass.isEnglish ? 'From' : ' من'} :  ${ticket!.from.toString()}',
                            textDirection: LanguageClass.isEnglish
                                ? pw.TextDirection.ltr
                                : pw.TextDirection.rtl,
                            textAlign: LanguageClass.isEnglish
                                ? pw.TextAlign.left
                                : pw.TextAlign.right,
                            style: pw.TextStyle(
                                fontSize: 14,
                                fontWeight: pw.FontWeight.normal)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(10),
                        child: pw.Text(
                            '${LanguageClass.isEnglish ? 'To' : 'الي'} :  ${ticket!.to.toString()}',
                            textDirection: LanguageClass.isEnglish
                                ? pw.TextDirection.ltr
                                : pw.TextDirection.rtl,
                            textAlign: LanguageClass.isEnglish
                                ? pw.TextAlign.left
                                : pw.TextAlign.right,
                            style: pw.TextStyle(
                                fontSize: 14,
                                fontWeight: pw.FontWeight.normal)),
                      ),
                    ],
                  ),
                ],
              ),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.black),
                children: [
                  pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(10),
                        child: pw.Text(
                            '${LanguageClass.isEnglish ? "Line" : 'المسار'} :  ${ticket!.description ?? ''}',
                            textDirection: LanguageClass.isEnglish
                                ? pw.TextDirection.ltr
                                : pw.TextDirection.rtl,
                            textAlign: LanguageClass.isEnglish
                                ? pw.TextAlign.left
                                : pw.TextAlign.right,
                            style: pw.TextStyle(
                                fontSize: 14,
                                fontWeight: pw.FontWeight.normal)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(10),
                        child: pw.Text(
                            '${LanguageClass.isEnglish ? "Penalty" : 'غرامة'} :  ${ticket!.penalty.toString() ?? ''}',
                            textDirection: LanguageClass.isEnglish
                                ? pw.TextDirection.ltr
                                : pw.TextDirection.rtl,
                            textAlign: LanguageClass.isEnglish
                                ? pw.TextAlign.left
                                : pw.TextAlign.right,
                            style: pw.TextStyle(
                                fontSize: 14,
                                fontWeight: pw.FontWeight.normal)),
                      ),
                    ],
                  ),
                ],
              ),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.black),
                children: [
                  pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(10),
                        child: pw.Text(
                            '${LanguageClass.isEnglish ? "Trip date" : 'تاريخ الرحلة'} :  ${ticket!.tripDate.toString()}',
                            textDirection: LanguageClass.isEnglish
                                ? pw.TextDirection.ltr
                                : pw.TextDirection.rtl,
                            textAlign: LanguageClass.isEnglish
                                ? pw.TextAlign.left
                                : pw.TextAlign.right,
                            style: pw.TextStyle(
                                fontSize: 14,
                                fontWeight: pw.FontWeight.normal)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(10),
                        child: pw.Text(
                            '${LanguageClass.isEnglish ? "Trip type" : ' نوع الرحلة'} :  ${ticket!.serviceType.toString()}',
                            textDirection: LanguageClass.isEnglish
                                ? pw.TextDirection.ltr
                                : pw.TextDirection.rtl,
                            textAlign: LanguageClass.isEnglish
                                ? pw.TextAlign.left
                                : pw.TextAlign.right,
                            style: pw.TextStyle(
                                fontSize: 14,
                                fontWeight: pw.FontWeight.normal)),
                      ),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(10),
                        child: pw.Text(
                            '${LanguageClass.isEnglish ? "Trip time" : 'وقت القيام '} :  ${ticket!.accessBusTime.toString()}',
                            textDirection: LanguageClass.isEnglish
                                ? pw.TextDirection.ltr
                                : pw.TextDirection.rtl,
                            textAlign: LanguageClass.isEnglish
                                ? pw.TextAlign.left
                                : pw.TextAlign.right,
                            style: pw.TextStyle(
                                fontSize: 14,
                                fontWeight: pw.FontWeight.normal)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(10),
                        child: pw.Text(
                            '${LanguageClass.isEnglish ? "Price" : 'السعر'} :  ${ticket!.price.toString()}',
                            textDirection: LanguageClass.isEnglish
                                ? pw.TextDirection.ltr
                                : pw.TextDirection.rtl,
                            textAlign: LanguageClass.isEnglish
                                ? pw.TextAlign.left
                                : pw.TextAlign.right,
                            style: pw.TextStyle(
                                fontSize: 14,
                                fontWeight: pw.FontWeight.normal)),
                      ),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(10),
                        child: pw.Text(
                            '${LanguageClass.isEnglish ? "Trip  num" : 'رقم الرحلة'} :  ${ticket!.tripNumber.toString()}',
                            textDirection: LanguageClass.isEnglish
                                ? pw.TextDirection.ltr
                                : pw.TextDirection.rtl,
                            textAlign: LanguageClass.isEnglish
                                ? pw.TextAlign.left
                                : pw.TextAlign.right,
                            style: pw.TextStyle(
                                fontSize: 14,
                                fontWeight: pw.FontWeight.normal)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(10),
                        child: pw.Text(
                            '${LanguageClass.isEnglish ? "Ticket num" : 'رقم التذكرة'} :  ${ticket!.ticketNumber.toString()}',
                            textDirection: LanguageClass.isEnglish
                                ? pw.TextDirection.ltr
                                : pw.TextDirection.rtl,
                            textAlign: LanguageClass.isEnglish
                                ? pw.TextAlign.left
                                : pw.TextAlign.right,
                            style: pw.TextStyle(
                                fontSize: 14,
                                fontWeight: pw.FontWeight.normal)),
                      ),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(10),
                        child: pw.Text(
                            '${LanguageClass.isEnglish ? "Created by" : 'مكتب الاصدار'} :  ${ticket!.createdBy.toString()}',
                            textDirection: LanguageClass.isEnglish
                                ? pw.TextDirection.ltr
                                : pw.TextDirection.rtl,
                            textAlign: LanguageClass.isEnglish
                                ? pw.TextAlign.left
                                : pw.TextAlign.right,
                            style: pw.TextStyle(
                                fontSize: 14,
                                fontWeight: pw.FontWeight.normal)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(10),
                        child: pw.Text(
                            '${LanguageClass.isEnglish ? "Seat numbers" : 'رقم المقعد'} :  ${ticket!.seatNumbers.toString()}',
                            textDirection: LanguageClass.isEnglish
                                ? pw.TextDirection.ltr
                                : pw.TextDirection.rtl,
                            textAlign: LanguageClass.isEnglish
                                ? pw.TextAlign.left
                                : pw.TextAlign.right,
                            style: pw.TextStyle(
                                fontSize: 14,
                                fontWeight: pw.FontWeight.normal)),
                      ),
                    ],
                  ),
                ],
              ),
              pw.Container(height: 10),
              pw.Container(
                child: pw.ListView.builder(
                  itemCount: ticket!.policy!.length,
                  direction: pw.Axis.vertical,
                  itemBuilder: (context, int index) {
                    return pw.Container(
                      alignment: LanguageClass.isEnglish
                          ? pw.Alignment.centerLeft
                          : pw.Alignment.centerRight,
                      margin: pw.EdgeInsets.symmetric(horizontal: 5),
                      child: pw.Text(
                        "${index + 1}- ${ticket!.policy![index]}",
                        textAlign: LanguageClass.isEnglish
                            ? pw.TextAlign.left
                            : pw.TextAlign.right,
                        textDirection: pw.TextDirection.rtl,
                        style: pw.TextStyle(fontSize: 12),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        );
      },
    ));

    return pdf.save();
  }
}

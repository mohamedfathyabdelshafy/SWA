import 'package:flutter/material.dart';
import 'package:swa/config/routes/app_routes.dart';
import 'package:swa/features/Swa_umra/models/Transportaion_list_model.dart';
import 'package:swa/features/Swa_umra/models/accomidation_model.dart';
import 'package:swa/features/Swa_umra/models/packages_list_model.dart';
import 'package:swa/features/Swa_umra/models/programs_model.dart';
import 'package:swa/features/Swa_umra/models/umral_trip_model.dart';
import 'package:swa/select_payment2/presentation/credit_card/model/card_model.dart';

class UmraDetails {
  static var tripList;
  static List bookedseatsgo = [];

  static List bookedseatsidgo = [];
  static List bookedseatsidback = [];

  static List bookedseatsback = [];

  static String promocodid = '';

  static String tripdate = '';
  static int campainid = 0;
  static int dateTypeID = 0;
  static int tripTypeUmrahID = 0;

  static String cityid = '';

  static String promocode = '';

  static String curruncy = Routes.curruncy!;

  static double dicount = 0;
  static int numberoftravellers = 0;

  static double afterdiscount = 0;

  static double discount = 0;

  static double transportationprice = 0;
  static double addprogramprice = 0;
  static double residenceprice = 0;
  static double totalprice = 0;

  static double totalBokkedprice = 0;

  static bool activetransport = true;
  static bool addprogram = true;

  static List<TransportationsSeats> reservedseats = [];

  static List<TransportList>? transportList = [];

  static List<Accomidationdetails>? accomidation = [];
  static List<AcoomidationRoom> accomidationRoom = [];
  static List<Programsdetails> umraprograms = [];
  static List<int> programsNumber = [];

  static List<TransportList>? finaltransportation = [];
  static List<AcoomidationRoom> finalaccomidationRoom = [];

  static List<Programsdetails> finalprogramslist = [];
  static List<int> finalcustomersprograms = [];

  static double totalPriceUmrah = 0;
  static double totlaPriceTransport = 0;
  static double totlaPriceResidence = 0;
  static double totlaPriceProgram = 0;

  static int? tripUmrahID = 0;
  static double differentPrice = 0;
  static bool isbusforumra = false;

  static List<TransportList>? swatransportList = [];

  static List<TransportationsSeats> Swabusreservedseats = [];

  static CardModel cardModel = CardModel(
    cardName: '',
    cardNumber: '',
    month: '',
  );

  static String cvv = '';
  static String phonenumber = '';
}

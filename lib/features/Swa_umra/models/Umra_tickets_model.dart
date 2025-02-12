class UmraTicketsModel {
  UmraTicketsModel({
    this.status,
    this.message,
    this.balance,
    this.object,
    this.text,
    this.obj,
  });

  final String? status;
  final Message? message;
  final dynamic balance;
  final dynamic object;
  final dynamic text;
  final dynamic obj;

  factory UmraTicketsModel.fromJson(Map<String, dynamic> json) {
    return UmraTicketsModel(
      status: json["status"],
      message:
          json["message"] == null ? null : Message.fromJson(json["message"]),
      balance: json["balance"],
      object: json["Object"],
      text: json["Text"],
      obj: json["Obj"],
    );
  }
}

class Message {
  Message({
    this.result,
    this.id,
    this.exception,
    this.status,
    this.isCanceled,
    this.isCompleted,
    this.creationOptions,
    this.asyncState,
    this.isFaulted,
  });

  final Result? result;
  final int? id;
  final dynamic exception;
  final int? status;
  final bool? isCanceled;
  final bool? isCompleted;
  final int? creationOptions;
  final dynamic asyncState;
  final bool? isFaulted;

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      result: json["Result"] == null ? null : Result.fromJson(json["Result"]),
      id: json["Id"],
      exception: json["Exception"],
      status: json["Status"],
      isCanceled: json["IsCanceled"],
      isCompleted: json["IsCompleted"],
      creationOptions: json["CreationOptions"],
      asyncState: json["AsyncState"],
      isFaulted: json["IsFaulted"],
    );
  }
}

class Result {
  Result({
    this.bookingList,
    this.isArabic,
  });

  final List<BookingList>? bookingList;
  final bool? isArabic;

  factory Result.fromJson(Map<String, dynamic> json) {
    return Result(
      bookingList: json["BookingList"] == null
          ? []
          : List<BookingList>.from(
              json["BookingList"]!.map((x) => BookingList.fromJson(x))),
      isArabic: json["IsArabic"],
    );
  }
}

class BookingList {
  BookingList({
    this.expirationdate,
    this.identificationNumber,
    this.agentName,
    this.cityName,
    this.customerCode,
    this.ticketNumer,
    this.customerMobile,
    this.customerAnotherMobile,
    this.canEdit,
    this.canCancel,
    this.umrahReservationId,
    this.tripUmrahId,
    this.customerId,
    this.totalPrice,
    this.creationDate,
    this.isDeleted,
    this.countryId,
    this.isPaid,
    this.discount,
    this.totalPriceAfterDiscount,
    this.transportation,
    this.accommodation,
    this.program,
    this.campainId,
    this.customerName,
    this.umrahDate,
    this.cityId,
    this.tripTypeUmrahId,
    this.isArabic,
  });

  final String? expirationdate;
  final dynamic identificationNumber;
  final String? agentName;
  final String? cityName;
  final int? customerCode;
  final dynamic ticketNumer;
  final dynamic customerMobile;
  final dynamic customerAnotherMobile;
  final bool? canEdit;
  final bool? canCancel;
  final int? umrahReservationId;
  final int? tripUmrahId;
  final int? customerId;
  final dynamic totalPrice;
  final DateTime? creationDate;
  final bool? isDeleted;
  final int? countryId;
  final bool? isPaid;
  final dynamic discount;
  final dynamic totalPriceAfterDiscount;
  final Transportation? transportation;
  final Accommodation? accommodation;
  final Accommodation? program;
  final int? campainId;
  final dynamic customerName;
  final String? umrahDate;
  final int? cityId;
  final int? tripTypeUmrahId;
  final bool? isArabic;

  factory BookingList.fromJson(Map<String, dynamic> json) {
    return BookingList(
      expirationdate: json["Expirationdate"],
      identificationNumber: json["IdentificationNumber"],
      agentName: json["AgentName"],
      cityName: json["CityName"],
      customerCode: json["CustomerCode"],
      ticketNumer: json["TicketNumer"],
      customerMobile: json["CustomerMobile"],
      customerAnotherMobile: json["CustomerAnotherMobile"],
      canEdit: json["CanEdit"],
      canCancel: json["CanCancel"],
      umrahReservationId: json["UmrahReservationID"],
      tripUmrahId: json["TripUmrahID"],
      customerId: json["CustomerID"],
      totalPrice: json["TotalPrice"],
      creationDate: DateTime.tryParse(json["CreationDate"] ?? ""),
      isDeleted: json["IsDeleted"],
      countryId: json["CountryID"],
      isPaid: json["IsPaid"],
      discount: json["Discount"],
      totalPriceAfterDiscount: json["TotalPriceAfterDiscount"],
      transportation: json["Transportation"] == null
          ? null
          : Transportation.fromJson(json["Transportation"]),
      accommodation: json["Accommodation"] == null
          ? null
          : Accommodation.fromJson(json["Accommodation"]),
      program: json["Program"] == null
          ? null
          : Accommodation.fromJson(json["Program"]),
      campainId: json["CampainID"],
      customerName: json["CustomerName"],
      umrahDate: json["UmrahDate"],
      cityId: json["CityID"],
      tripTypeUmrahId: json["TripTypeUmrahID"],
      isArabic: json["IsArabic"],
    );
  }
}

class Accommodation {
  Accommodation({
    this.title,
    this.qrCode,
    this.accommodationModel,
    this.isArabic,
    this.programList,
  });

  final String? title;
  final String? qrCode;
  final List<AccommodationModel>? accommodationModel;
  final bool? isArabic;
  final List<ProgramList>? programList;

  factory Accommodation.fromJson(Map<String, dynamic> json) {
    return Accommodation(
      title: json["Title"],
      qrCode: json["QrCode"],
      accommodationModel: json["AccommodationModel"] == null
          ? []
          : List<AccommodationModel>.from(json["AccommodationModel"]!
              .map((x) => AccommodationModel.fromJson(x))),
      isArabic: json["IsArabic"],
      programList: json["ProgramList"] == null
          ? []
          : List<ProgramList>.from(
              json["ProgramList"]!.map((x) => ProgramList.fromJson(x))),
    );
  }
}

class AccommodationModel {
  AccommodationModel({
    this.cityName,
    this.hotelName,
    this.date,
    this.nights,
    this.alternativeHotel,
    this.accommodationType,
    this.singleRoomCount,
    this.doubleRoomCount,
    this.tripleRoomCount,
    this.quadrupleroomCount,
    this.quintupleroom,
    this.childernUnderAge,
    this.childernAboveAge,
    this.tripUmrahType,
    this.note,
    this.accommodationList,
    this.isArabic,
  });

  final String? cityName;
  final String? hotelName;
  final String? date;
  final int? nights;
  final dynamic alternativeHotel;
  final String? accommodationType;
  final int? singleRoomCount;
  final int? doubleRoomCount;
  final int? tripleRoomCount;
  final int? quadrupleroomCount;
  final int? quintupleroom;
  final int? childernUnderAge;
  final int? childernAboveAge;
  final String? tripUmrahType;
  final dynamic note;
  final List<AccommodationList>? accommodationList;
  final bool? isArabic;

  factory AccommodationModel.fromJson(Map<String, dynamic> json) {
    return AccommodationModel(
      cityName: json["CityName"],
      hotelName: json["HotelName"],
      date: json["Date"],
      nights: json["Nights"],
      alternativeHotel: json["AlternativeHotel"],
      accommodationType: json["AccommodationType"],
      singleRoomCount: json["SingleRoomCount"],
      doubleRoomCount: json["DoubleRoomCount"],
      tripleRoomCount: json["TripleRoomCount"],
      quadrupleroomCount: json["QuadrupleroomCount"],
      quintupleroom: json["Quintupleroom"],
      childernUnderAge: json["ChildernUnderAge"],
      childernAboveAge: json["ChildernAboveAge"],
      tripUmrahType: json["TripUmrahType"],
      note: json["Note"],
      accommodationList: json["AccommodationList"] == null
          ? []
          : List<AccommodationList>.from(json["AccommodationList"]!
              .map((x) => AccommodationList.fromJson(x))),
      isArabic: json["IsArabic"],
    );
  }
}

class AccommodationList {
  AccommodationList({
    this.umrahAccommodationReservationId,
    this.customerId,
    this.tripUmrahId,
    this.price,
    this.personCount,
    this.umrahReservationId,
    this.tripUmrahAccommodationId,
    this.accommodationRoomId,
    this.isDelete,
    this.isActive,
    this.roomType,
    this.accommodationType,
    this.isArabic,
  });

  final int? umrahAccommodationReservationId;
  final int? customerId;
  final int? tripUmrahId;
  final dynamic price;
  final dynamic personCount;
  final int? umrahReservationId;
  final int? tripUmrahAccommodationId;
  final int? accommodationRoomId;
  final bool? isDelete;
  final bool? isActive;
  final String? roomType;
  final String? accommodationType;
  final bool? isArabic;

  factory AccommodationList.fromJson(Map<String, dynamic> json) {
    return AccommodationList(
      umrahAccommodationReservationId: json["UmrahAccommodationReservationID"],
      customerId: json["CustomerID"],
      tripUmrahId: json["TripUmrahID"],
      price: json["Price"],
      personCount: json["PersonCount"],
      umrahReservationId: json["UmrahReservationID"],
      tripUmrahAccommodationId: json["TripUmrahAccommodationID"],
      accommodationRoomId: json["AccommodationRoomID"],
      isDelete: json["IsDelete"],
      isActive: json["IsActive"],
      roomType: json["RoomType"],
      accommodationType: json["AccommodationType"],
      isArabic: json["IsArabic"],
    );
  }
}

class ProgramList {
  ProgramList({
    this.umrahProgramReservationId,
    this.customerId,
    this.tripUmrahId,
    this.price,
    this.personCount,
    this.childrnCount,
    this.food,
    this.additionalactivities,
    this.notes,
    this.umrahReservationId,
    this.tripUmrahProgramId,
    this.isDelete,
    this.isActive,
    this.title,
    this.date,
    this.isArabic,
  });

  final int? umrahProgramReservationId;
  final int? customerId;
  final int? tripUmrahId;
  final dynamic price;
  final dynamic personCount;
  final int? childrnCount;
  final dynamic food;
  final dynamic additionalactivities;
  final dynamic notes;
  final int? umrahReservationId;
  final int? tripUmrahProgramId;
  final bool? isDelete;
  final bool? isActive;
  final String? title;
  final String? date;
  final bool? isArabic;

  factory ProgramList.fromJson(Map<String, dynamic> json) {
    return ProgramList(
      umrahProgramReservationId: json["UmrahProgramReservationID"],
      customerId: json["CustomerID"],
      tripUmrahId: json["TripUmrahID"],
      price: json["Price"],
      personCount: json["PersonCount"],
      childrnCount: json["ChildrnCount"],
      food: json["Food"],
      additionalactivities: json["Additionalactivities"],
      notes: json["Notes"],
      umrahReservationId: json["UmrahReservationID"],
      tripUmrahProgramId: json["TripUmrahProgramID"],
      isDelete: json["IsDelete"],
      isActive: json["IsActive"],
      title: json["Title"],
      date: json["Date"],
      isArabic: json["IsArabic"],
    );
  }
}

class Transportation {
  Transportation({
    this.title,
    this.qrCode,
    this.tripTitle,
    this.fromDate,
    this.toDate,
    this.transportaionList,
    this.isArabic,
  });

  final String? title;
  final String? qrCode;
  final String? tripTitle;
  final String? fromDate;
  final String? toDate;
  final List<TransportaionList>? transportaionList;
  final bool? isArabic;

  factory Transportation.fromJson(Map<String, dynamic> json) {
    return Transportation(
      title: json["Title"],
      qrCode: json["QrCode"],
      tripTitle: json["TripTitle"],
      fromDate: json["FromDate"],
      toDate: json["ToDate"],
      transportaionList: json["TransportaionList"] == null
          ? []
          : List<TransportaionList>.from(json["TransportaionList"]!
              .map((x) => TransportaionList.fromJson(x))),
      isArabic: json["IsArabic"],
    );
  }
}

class TransportaionList {
  TransportaionList({
    this.notes,
    this.status,
    this.transportaionListClass,
    this.umrahTransportationReservationId,
    this.customerId,
    this.tripUmrahId,
    this.tripNumber,
    this.price,
    this.personCount,
    this.umrahReservationId,
    this.tripUmrahTransportationId,
    this.reservationId,
    this.isDeleted,
    this.isActive,
    this.seatCount,
    this.seatNumber,
    this.fromCity,
    this.toCity,
    this.fromDate,
    this.toDate,
    this.fromTime,
    this.toTime,
    this.fromStation,
    this.toStation,
    this.isArabic,
  });

  final String? notes;
  final String? status;
  final String? transportaionListClass;
  final int? umrahTransportationReservationId;
  final int? customerId;
  final int? tripUmrahId;
  final int? tripNumber;
  final dynamic price;
  final dynamic personCount;
  final int? umrahReservationId;
  final int? tripUmrahTransportationId;
  final int? reservationId;
  final bool? isDeleted;
  final bool? isActive;
  final int? seatCount;
  final String? seatNumber;
  final String? fromCity;
  final String? toCity;
  final String? fromDate;
  final String? toDate;
  final String? fromTime;
  final String? toTime;
  final String? fromStation;
  final String? toStation;
  final bool? isArabic;

  factory TransportaionList.fromJson(Map<String, dynamic> json) {
    return TransportaionList(
      notes: json["Notes"],
      status: json["Status"],
      transportaionListClass: json["Class"],
      umrahTransportationReservationId:
          json["UmrahTransportationReservationID"],
      customerId: json["CustomerID"],
      tripUmrahId: json["TripUmrahID"],
      tripNumber: json["TripNumber"],
      price: json["Price"],
      personCount: json["PersonCount"],
      umrahReservationId: json["UmrahReservationID"],
      tripUmrahTransportationId: json["TripUmrahTransportationID"],
      reservationId: json["ReservationID"],
      isDeleted: json["IsDeleted"],
      isActive: json["IsActive"],
      seatCount: json["SeatCount"],
      seatNumber: json["SeatNumber"],
      fromCity: json["FromCity"],
      toCity: json["ToCity"],
      fromDate: json["FromDate"],
      toDate: json["ToDate"],
      fromTime: json["FromTime"],
      toTime: json["ToTime"],
      fromStation: json["FromStation"],
      toStation: json["ToStation"],
      isArabic: json["IsArabic"],
    );
  }
}

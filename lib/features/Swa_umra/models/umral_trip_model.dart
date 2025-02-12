import 'package:swa/features/Swa_umra/models/Transportaion_list_model.dart';
import 'package:swa/features/Swa_umra/models/accomidation_model.dart';

class TransportationsSeats {
  List seatsnumber;
  int tripid;
  dynamic totalprice;
  TransportationsSeats({
    required this.seatsnumber,
    required this.tripid,
    required this.totalprice,
  });
}

class AcoomidationRoom {
  List<RoomTypeList> room;
  List<int> customernumbers;

  AcoomidationRoom({
    required this.room,
    required this.customernumbers,
  });
}

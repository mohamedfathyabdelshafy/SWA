import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swa/core/utils/app_colors.dart';
import 'package:swa/core/utils/language.dart';
import 'package:swa/core/utils/media_query_values.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/data/model/bus_classes_model.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/data/model/bus_images_model.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/data/model/stations_model.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/data/repo/more_repo.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/presentation/PLOH/more_cubit.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/presentation/PLOH/more_states.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/presentation/screens/abous_us.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/presentation/screens/widgets/carousel_widget.dart';
import 'package:swa/main.dart';

class BusImageClasses extends StatefulWidget {
  BusImageClasses({super.key,required this.typeClasses});
String typeClasses;
  @override
  State<BusImageClasses> createState() => _BusImageClassesState();
}

class _BusImageClassesState extends State<BusImageClasses> {
  MoreRepo moreRepo = MoreRepo(sl());
  BusImagesModel  busImageClasses  = BusImagesModel();
  @override
  void initState() {
    get();
    super.initState();
  }
  void get()async{
    await BlocProvider.of<MoreCubit>(context).getBusImage(typeClass: widget.typeClasses);
    busImageClasses = (await moreRepo.getBusImages(typeClass: widget.typeClasses))!;
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    double sizeHeight = context.height;
    double sizeWidth = context.width;
    return Directionality(
      textDirection: LanguageClass.isEnglish?TextDirection.ltr:TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(backgroundColor: AppColors.primaryColor,
          centerTitle: true,
          title: Text(
            LanguageClass.isEnglish? "Bus Classes":"انواع الاتوبيس",
            style: TextStyle(
                color: AppColors.white,
                fontSize: 34,
                fontFamily: "bold"),
          ),
        ),
        backgroundColor: Colors.black,
        body: BlocBuilder(
          bloc: BlocProvider.of<MoreCubit>(context),
          builder: (context,state){
            if(state is LoadingBusImage){
              return  Center(
                child: CircularProgressIndicator(color: AppColors.primaryColor,),
              );
            }
            return CarouselWidget(items: [
              ...List<Widget>.generate(
               busImageClasses.message?.imagePaths?.length??0,
                    (index) => Image.network( busImageClasses.message?.imagePaths?[index]??"https://www.wanderu.com/blog/wp-content/uploads/2016/10/limoliner-seats-1280x852.jpg"),
              ),
            ]);
          },

        ),
      ),
    );
  }
}

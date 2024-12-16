import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:swa/core/utils/media_query_values.dart';
import 'package:swa/features/home/presentation/screens/tabs/more_tap/data/model/Ads_model.dart';

class CarouselWidget extends StatefulWidget {
  final List<Widget> items;
  const CarouselWidget({required this.items, Key? key}) : super(key: key);

  @override
  State<CarouselWidget> createState() => _CarouselWidgetState();
}

class _CarouselWidgetState extends State<CarouselWidget> {
  @override
  Widget build(BuildContext context) {
    double sizeHeight = context.height;

    return Column(
      children: [
        CarouselSlider(
            items: widget.items,
            options: CarouselOptions(
              aspectRatio: 1,
              viewportFraction: 1,
              initialPage: 0,
              enableInfiniteScroll: true,
              reverse: false,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 3),
              autoPlayAnimationDuration: const Duration(milliseconds: 1200),
              autoPlayCurve: Curves.fastOutSlowIn,
              enlargeCenterPage: true,
              padEnds: false,
              enlargeFactor: 0,
              height: sizeHeight * 0.38,
              onPageChanged: (index, reason) {
                // CarouselCubit.get(context).changeIndex(index);
              },
              scrollDirection: Axis.horizontal,
            )),
        // const SizedBox(height: 8,),
        // BlocBuilder<CarouselCubit, CarouselState>(
        //   builder: (context, state) {
        //     return state is CarouselInitial?Row(
        //           mainAxisAlignment: MainAxisAlignment.center,
        //           children: List<Widget>.generate(
        //             widget.items.length,
        //                 (index) => Padding(
        //               padding: const EdgeInsets.all(3),
        //               child: index==state.index
        //                   ?
        //               Container(
        //                 width: 36.w,
        //                 height: 12.h,
        //                 decoration: BoxDecoration(
        //                   color: AppColors.white,
        //                   borderRadius: BorderRadius.circular(10.r),
        //                 ),
        //               )
        //                   :
        //               CircleAvatar(
        //                 radius: 6.r,
        //                 backgroundColor: index==state.index?AppColors.white:AppColors.black262626,
        //               ),
        //             ),
        //           ),
        //         ):SizedBox();
        //   },
        // ),
      ],
    );
  }
}

Widget contentAdvertisment(Advertisement advertisement, double sizeHeight) {
  return Container(
      padding: EdgeInsets.zero,
      alignment: Alignment.center,
      width: double.infinity,
      height: sizeHeight * 0.38,
      child: Image.network(
        advertisement.icon,
        fit: BoxFit.fill,
        height: sizeHeight * 0.38,
        width: double.infinity,
        alignment: Alignment.center,
      ));
}

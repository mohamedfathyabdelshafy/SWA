import 'package:flutter/material.dart';
import 'package:swa/core/utils/app_colors.dart';
import 'package:swa/core/utils/media_query_values.dart';
import 'package:swa/features/bus_reservation_layout/presentation/widgets/text_widget.dart';

class ContainerWidget extends StatelessWidget {
  ContainerWidget({super.key,
     this.color,
     this.height
  });
Color? color;

double? height;
  @override
  Widget build(BuildContext context) {
    double sizeHeight = context.height;
    return  Container(
      height: sizeHeight * height!,
      width: sizeHeight * height!,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color??AppColors.primaryColor,
          border: Border.all(color: AppColors.primaryColor)
      ),
    );
  }
}

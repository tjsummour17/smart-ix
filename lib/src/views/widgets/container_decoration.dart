import 'package:flutter/material.dart';

class ContainerDecoration {
  ContainerDecoration._();

  static BoxDecoration cardStyle(BuildContext context) => BoxDecoration(
        borderRadius: BorderRadius.circular(7),
        color: Theme.of(context).bottomAppBarColor,
        boxShadow: [
          BoxShadow(blurRadius: 3, color: Theme.of(context).shadowColor)
        ],
      );

  // static double getCardWidth(
  //   BuildContext context, {
  //   double minNumOfColumns = 2,
  //   double screenPadding = 40,
  // }) =>
  //     MediaQuery.of(context).size.width >= 800
  //         ? 500 / minNumOfColumns
  //         : (MediaQuery.of(context).size.width / minNumOfColumns) -
  //             (screenPadding / minNumOfColumns);
}

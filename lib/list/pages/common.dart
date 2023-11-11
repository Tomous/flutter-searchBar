//cell头的高度
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const double cellHeaderHeight = 30.0;
// cell的高度
const double cellHeight = 50.0;
// cell的高度
const double indexBarWidth = 130.0;

double screenWidth(BuildContext context) => MediaQuery.of(context).size.width;
double screenHeight(BuildContext context) => MediaQuery.of(context).size.height;

const INDEX_WORDS = [
  '🔍',
  '⭐️',
  'A',
  'B',
  'C',
  'D',
  'E',
  'F',
  'G',
  'H',
  'I',
  'J',
  'K',
  'L',
  'M',
  'N',
  'O',
  'P',
  'Q',
  'R',
  'S',
  'T',
  'U',
  'V',
  'W',
  'X',
  'Y',
  'Z',
];

//从本地加载json数据
Future<String> loadJsonFromAssets(String fileName) async {
  return await rootBundle.loadString(fileName);
}

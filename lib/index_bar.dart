import 'package:flutter/material.dart';
import 'package:list/common.dart';

class IndexBarWidget extends StatefulWidget {
  final void Function(String str) indexBarCallBack;
  const IndexBarWidget({
    super.key,
    required this.indexBarCallBack,
  });

  @override
  State<IndexBarWidget> createState() => _IndexBarWidgetState();
}

class _IndexBarWidgetState extends State<IndexBarWidget> {
  Color _bkColor = const Color.fromRGBO(1, 1, 1, 0.0);
  Color _textColor = Colors.black;

  double _indicatorY = 0.0;
  String _indicatorStr = 'A';
  bool _indicatorShow = false;
  @override
  void initState() {
    super.initState();
  }

// 获取选中的字符
  int getIndex(BuildContext context, Offset globalPosition) {
    // 拿到点前小部件(Container)的盒子
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    // 拿到y值
    double y = renderBox.globalToLocal(globalPosition).dy;
    // 算出字符高度
    double itemHeight = renderBox.size.height / INDEX_WORDS.length;
    // 算出第几个item
    // int index = y ~/ itemHeight;
    // 为了防止滑出区域后出现问题，所以index应该有个取值范围
    int index = (y ~/ itemHeight).clamp(0, INDEX_WORDS.length - 1);
    return index;
  }

  @override
  Widget build(BuildContext context) {
    //索引条
    final List<Widget> wordsList = [];
    for (var i = 0; i < INDEX_WORDS.length; i++) {
      wordsList.add(
        Expanded(
          child: Text(
            INDEX_WORDS[i],
            style: TextStyle(
              color: _textColor,
              fontSize: 14.0,
            ),
          ),
        ),
      );
    }
    return Row(
      children: [
        Container(
          alignment: Alignment(0.0, _indicatorY),
          width: indexBarWidth - 20.0,
          // color: Colors.red,
          child: _indicatorShow
              ? Stack(
                  alignment: const Alignment(-0.1, 0),
                  children: [
                    //应该放一张图片，没找到合适的，就用Container代替
                    Container(
                      width: 60.0,
                      height: 60.0,
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.all(
                          Radius.circular(30.0),
                        ),
                      ),
                    ),
                    Text(
                      _indicatorStr,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28.0,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                )
              : null,
        ),
        GestureDetector(
          onVerticalDragDown: (details) {
            int index = getIndex(context, details.globalPosition);
            widget.indexBarCallBack(INDEX_WORDS[index]);
            setState(() {
              _bkColor = const Color.fromRGBO(1, 1, 1, 0.5);
              _textColor = Colors.white;

              //显示气泡
              _indicatorY = 2.2 / INDEX_WORDS.length * index - 1.1;
              _indicatorStr = INDEX_WORDS[index];
              _indicatorShow = true;
            });
          },
          onVerticalDragEnd: (details) {
            setState(() {
              _bkColor = const Color.fromRGBO(1, 1, 1, 0.0);
              _textColor = Colors.black;

              // 隐藏气泡
              _indicatorShow = false;
            });
          },
          onVerticalDragUpdate: (details) {
            int index = getIndex(context, details.globalPosition);
            widget.indexBarCallBack(INDEX_WORDS[index]);

            //显示气泡
            setState(() {
              _indicatorY = 2.2 / INDEX_WORDS.length * index - 1.1;
              _indicatorStr = INDEX_WORDS[index];
              _indicatorShow = true;
            });
          },
          child: Container(
            color: _bkColor,
            width: 20.0,
            child: Column(
              children: wordsList,
            ),
          ),
        ),
      ],
    );
  }
}

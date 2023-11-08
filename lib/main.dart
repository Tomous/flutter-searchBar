import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:list/common.dart';
import 'package:list/index_bar.dart';
import 'package:list/user_name.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: '通讯录'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<DataList> _data = [];
  final List<DataList> _dataList = []; //数据
  late ScrollController _scrollController;
  //字典 里面放item和高度对应的数据
  final Map<String, double> _groupOffsetMap = {
    INDEX_WORDS[0]: 0.0, //放大镜
    INDEX_WORDS[1]: 0.0, //⭐️
  };
  final TextEditingController _textEditingController = TextEditingController();
  bool _isShowClear = false;
  String searchStr = '';
  @override
  void initState() {
    _load();
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _textEditingController.dispose();
    super.dispose();
  }

  void _load() async {
    String jsonData = await loadJsonFromAssets('assets/data.json');
    Map<String, dynamic> dict = json.decode(jsonData);
    List<dynamic> list = dict['data_list'];
    _data = list.map((e) => DataList.fromJson(e)).toList();
    // 排序
    _data.sort((a, b) => a.indexLetter.compareTo(b.indexLetter));

    _dataList.addAll(_data);
    // 循环计算，将每个头的位置算出来，放入字典
    var _groupOffset = 0.0;
    for (int i = 0; i < _dataList.length; i++) {
      if (i < 1) {
        //第一个cell一定有头
        _groupOffsetMap.addAll({_dataList[i].indexLetter: _groupOffset});
        _groupOffset += cellHeight + cellHeaderHeight;
      } else if (_dataList[i].indexLetter == _dataList[i - 1].indexLetter) {
        // 相同的时候只需要加cell的高度
        _groupOffset += cellHeight;
      } else {
        //第一个cell一定有头
        _groupOffsetMap.addAll({_dataList[i].indexLetter: _groupOffset});
        _groupOffset += cellHeight + cellHeaderHeight;
      }
    }
    print('dc------$_groupOffsetMap');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Stack(
        children: [
          //列表
          Container(
            child: Column(
              children: [
                Container(
                  height: 44,
                  color: Colors.red,
                  child: Row(
                    children: [
                      Container(
                        width: screenWidth(context) - 20,
                        height: 34,
                        margin: const EdgeInsets.only(left: 10, right: 10.0),
                        padding: const EdgeInsets.only(left: 10, right: 10.0),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(6)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.search),
                            Expanded(
                              child: TextField(
                                onChanged: _onChange,
                                controller: _textEditingController,
                                decoration: const InputDecoration(
                                  hintText: '请输入搜索内容',
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.only(
                                    left: 10,
                                    bottom: 12,
                                  ),
                                ),
                              ),
                            ),
                            if (_isShowClear)
                              GestureDetector(
                                onTap: () {
                                  _textEditingController.clear();
                                  setState(() {
                                    _onChange('');
                                  });
                                },
                                child: const Icon(Icons.cancel),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: _dataList.length,
                    itemBuilder: _itemForRow,
                  ),
                ),
              ],
            ),
          ),
          // 索引条
          Positioned(
            right: 0.0,
            top: screenHeight(context) / 8,
            height: screenHeight(context) / 2,
            width: indexBarWidth,
            child: IndexBarWidget(
              indexBarCallBack: (str) {
                print('拿到索引条选中的字符：$str');
                if (_groupOffsetMap[str] != null) {
                  _scrollController.animateTo(
                    _groupOffsetMap[str]!,
                    duration: const Duration(microseconds: 100),
                    curve: Curves.easeIn,
                  );
                } else {}
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget? _itemForRow(BuildContext context, int index) {
    DataList user = _dataList[index];
    //是否显示组名字
    bool hiddenTitle = index > 0 &&
        _dataList[index].indexLetter == _dataList[index - 1].indexLetter;
    return _itemCell(
      imageUrl: user.imageUrl,
      name: user.name,
      groupTitle: hiddenTitle ? null : user.indexLetter,
    );
  }

  _onChange(String text) {
    _isShowClear = text.isNotEmpty;

    _dataList.clear();
    searchStr = text;
    if (text.isNotEmpty) {
      for (int i = 0; i < _data.length; i++) {
        String name = _data[i].name;
        if (name.contains(text)) {
          _dataList.add(_data[i]);
        }
      }
    } else {
      _dataList.addAll(_data);
    }
    setState(() {});
  }
}

// ignore: camel_case_types
class _itemCell extends StatelessWidget {
  final String? imageUrl;
  final String name;
  final String? groupTitle;
  const _itemCell({
    this.imageUrl,
    required this.name,
    this.groupTitle,
  });

  @override
  Widget build(BuildContext context) {
    // TextStyle normalStyle = const TextStyle(
    //   fontSize: 16,
    //   color: Colors.black,
    // );
    // TextStyle highlightStyle = const TextStyle(
    //   fontSize: 16,
    //   color: Colors.green,
    // );
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: 10.0),
          height: groupTitle != null ? cellHeaderHeight : 0.0,
          color: Colors.grey,
          child: groupTitle != null ? Text(groupTitle!) : null,
        ),
        SizedBox(
          height: cellHeight,
          child: ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.red,
                image: imageUrl == null
                    ? null
                    : DecorationImage(
                        image: NetworkImage(imageUrl!),
                        fit: BoxFit.cover,
                      ),
                borderRadius: const BorderRadius.all(
                  Radius.circular(4),
                ),
              ),
            ),
            title: _title(name),
          ),
        ),
      ],
    );
  }

  Widget _title(String name) {
    // List<TextSpan> spans = [];
    // List<String> strs = name.split(searchStr);
    // for (int i = 0; i < strs.length; i++) {
    //   String str = strs[i];
    //   if (str == ''&&i<strs.length-1) {
    //     spans.add(TextSpan(text: searchStr, style: highlightStyle));
    //   } else {
    //     spans.add(TextSpan(text: str, style: normalStyle));
    //     if (i < strs.length - 1) {
    //       spans.add(TextSpan(text: searchStr, style: highlightStyle));
    //     }
    //   }
    // }
    // return RichText(text: TextSpan(children: spans));
    return Text(name);
  }
}

Future<String> loadJsonFromAssets(String fileName) async {
  return await rootBundle.loadString(fileName);
}

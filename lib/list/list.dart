import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:list/list/model/user_name.dart';
import 'package:list/list/pages/common.dart';
import 'package:list/list/pages/index_bar.dart';
import 'package:list/list/pages/item_cell.dart';
import 'package:list/list/pages/search_widget.dart';

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  List<DataList> _data = [];
  final List<DataList> _dataList = []; //数据
  late ScrollController _scrollController;
  //字典 里面放item和高度对应的数据
  final Map<String, double> _groupOffsetMap = {
    INDEX_WORDS[0]: 0.0, //放大镜
    INDEX_WORDS[1]: 0.0, //⭐️
  };
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
    var groupOffset = 0.0;
    for (int i = 0; i < _dataList.length; i++) {
      if (i < 1) {
        //第一个cell一定有头
        _groupOffsetMap.addAll({_dataList[i].indexLetter: groupOffset});
        groupOffset += cellHeight + cellHeaderHeight;
      } else if (_dataList[i].indexLetter == _dataList[i - 1].indexLetter) {
        // 相同的时候只需要加cell的高度
        groupOffset += cellHeight;
      } else {
        //第一个cell一定有头
        _groupOffsetMap.addAll({_dataList[i].indexLetter: groupOffset});
        groupOffset += cellHeight + cellHeaderHeight;
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
        title: const Text('通讯录'),
      ),
      body: Stack(
        children: [
          //列表
          Column(
            children: [
              // 搜索框
              SearchWidget(
                onSearchChange: (text) {
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
                },
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
    return ItemCell(
      imageUrl: user.imageUrl,
      name: user.name,
      groupTitle: hiddenTitle ? null : user.indexLetter,
    );
  }
}

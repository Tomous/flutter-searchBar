import 'package:flutter/material.dart';
import 'package:list/list/pages/common.dart';

class SearchWidget extends StatefulWidget {
  final void Function(String) onSearchChange;
  const SearchWidget({
    super.key,
    required this.onSearchChange,
  });

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  bool _isShowClear = false;
  final TextEditingController _textEditingController = TextEditingController();
  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }

  _onChange(String text) {
    _isShowClear = text.isNotEmpty;
    widget.onSearchChange(text);
  }
}

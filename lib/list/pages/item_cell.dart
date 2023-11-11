import 'package:flutter/material.dart';
import 'package:list/list/pages/common.dart';

class ItemCell extends StatelessWidget {
  final String? imageUrl;
  final String name;
  final String? groupTitle;
  const ItemCell({
    super.key,
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

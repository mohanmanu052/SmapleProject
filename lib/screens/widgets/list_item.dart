import 'package:flutter/material.dart';

class ListItem extends StatelessWidget {
  const ListItem(
      {Key? key,
      required this.title,
      required this.description,
      this.ondeleteTap})
      : super(key: key);
  final String? title;
  final String? description;
  final VoidCallback? ondeleteTap;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(4),
            child: Text(
              title ?? 'body1',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Divider(),
          Container(
            child: Text(
              description ?? 'Description',
              style: TextStyle(fontWeight: FontWeight.w400),
            ),
          ),
          Divider(),
          Container(
            child: InkWell(
              onTap: ondeleteTap,
              child: Icon(
                Icons.delete,
                size: 20,
                color: Colors.red,
              ),
            ),
          )
        ],
      ),
    );
  }
}

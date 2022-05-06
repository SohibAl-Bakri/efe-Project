import 'package:flutter/material.dart';

class AppCard extends StatelessWidget {
  final Text _title;
  final Text _subtitle;
  final Text _leading;
  final Text _trailing;

  AppCard({
    required Text title,
    required Text subtitle,
    required Text leading,
    required Text trailing,
  })  : _subtitle = subtitle,
        _title = title,
        _leading = leading,
        _trailing = trailing;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blueAccent,
      child: ListTile(
        title: _title,
        subtitle:_subtitle,
        leading: _leading,
        trailing:_trailing,
      ),
    );
  }
}

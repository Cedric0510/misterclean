import 'package:app/shared/styles/ui_constants.dart';
import 'package:app/shared/styles/decorations.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/cat.dart';
import '../pages/arguments.dart';
import '../pages/cat_detail_page.dart';

class CatItem extends StatelessWidget {
  final Cat _cat;

  final bool available = true;
  String fn() => _cat.name.substring(0, 1);

  CatItem(this._cat, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: Decorations.myBoxDecoration,
      child: InkWell(
        onTap: () {
          if (available) {
            Navigator.pushNamed(context, CatDetailPage.routeName,
                arguments: Arguments(_cat));
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(UI.pad),
          child: Row(mainAxisSize: MainAxisSize.max, children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.grey,
              child: Text(fn(),
                  style: const TextStyle(fontSize: 20, color: Colors.white)),
            ),
            const SizedBox(width: UI.s),
            Expanded(
                child: Column(children: [
              _catField("ID", _cat.id),
              _catDetail("Name", _cat.name),
              _catField("Origin", _cat.origin),
            ])),
          ]),
        ),
      ),
    );
  }

  Widget _catField(String field, String value) {
    return Row(
      children: [
        Text(
          '$field : ',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(value),
      ],
    );
  }
  //! DRY (Duplacted code)
  //? Créer qu'une seule méthode avec des paramètres
  Widget _catDetail(String field, String value) {
    return Row(
      children: [
        Text(
          '$field : ',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(value),
      ],
    );
  }
}

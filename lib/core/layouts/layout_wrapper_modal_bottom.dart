import 'package:flutter/material.dart';

class LayoutWrapperModalBottom extends StatelessWidget {
  const LayoutWrapperModalBottom({
    super.key,
    required this.child,
    required this.title,
  });

  final Widget child;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: SizedBox(
        height: 500,
        width: double.infinity,
        child: Column(
          children: <Widget>[
            //* TITULO DE LA TARJETA
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),

            //* SEPARADOR
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
              child: Divider(color: Colors.grey),
            ),

            Expanded(child: child),
          ],
        ),
      ),
    );
  }
}

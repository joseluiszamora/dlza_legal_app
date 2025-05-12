import 'package:dlza_legal_app/core/constants/app_defaults.dart';
import 'package:flutter/material.dart';

class LayoutMain extends StatelessWidget {
  const LayoutMain({super.key, required this.content});

  final Widget content;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Container(
          decoration:
              Theme.of(context).brightness == Brightness.dark
                  ? BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Theme.of(context).scaffoldBackgroundColor,
                        const Color(0xFF005954),
                        const Color(0xFF005954),
                        const Color(0xFF338b85),
                        Theme.of(context).scaffoldBackgroundColor,
                      ],
                    ),
                  )
                  : null,
          child: Column(
            children: <Widget>[
              // const Center(
              //   child: Image(
              //     image: AssetImage(AppImages.logo),
              //     fit: BoxFit.fill,
              //     width: 80,
              //   ),
              // ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(AppDefaults.margin),
                  child: content,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

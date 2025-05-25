import 'package:dlza_legal_app/core/blocs/marca/marca_bloc.dart';
import 'package:dlza_legal_app/views/marca/components/marca_search_section.dart';
import 'package:dlza_legal_app/views/marca/components/marca_list_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MarcaPage extends StatelessWidget {
  const MarcaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MarcaBloc()..add(const LoadMarcas()),
      child: const SafeArea(
        child: Column(
          children: [MarcaSearchSection(), Expanded(child: MarcaListSection())],
        ),
      ),
    );
  }
}

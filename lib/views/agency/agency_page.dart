import 'package:dlza_legal_app/views/agency/components/agency_list_section.dart';
import 'package:dlza_legal_app/views/agency/components/city_filter_section.dart';
import 'package:dlza_legal_app/views/agency/components/search_section.dart';
import 'package:dlza_legal_app/views/agency/components/pagination_options_section.dart';
import 'package:dlza_legal_app/views/agency/components/pagination_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dlza_legal_app/core/blocs/agency/agency_bloc.dart';

class AgencyPage extends StatelessWidget {
  const AgencyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AgencyBloc()..add(LoadAgencies()),
      child: SafeArea(
        child: Column(
          children: const [
            SearchSection(),
            CityFilterSection(),
            PaginationOptionsSection(),
            Expanded(child: AgencyListSection()),
            // PaginationSection(),
          ],
        ),
      ),
    );
  }
}

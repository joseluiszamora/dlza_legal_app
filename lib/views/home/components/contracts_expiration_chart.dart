import 'package:dlza_legal_app/core/models/agency.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dlza_legal_app/core/blocs/agency/agency_bloc.dart';

class ContractsExpirationChart extends StatelessWidget {
  const ContractsExpirationChart({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<AgencyBloc, AgencyState>(
      builder: (context, state) {
        if (state is AgencyLoading) {
          return SizedBox(
            height: 250,
            child: Center(
              child: CircularProgressIndicator(
                color: theme.colorScheme.primary,
              ),
            ),
          );
        } else if (state is AgencyLoaded) {
          final contractData = _processContractData(state.agencies);

          if (contractData.isEmpty) {
            return SizedBox(
              height: 250,
              child: Center(
                child: Text(
                  'No hay contratos por vencer',
                  style: theme.textTheme.titleMedium,
                ),
              ),
            );
          }

          return Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Próximos 12 meses', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 250,
                    child: _buildBarChart(contractData, theme),
                  ),
                ],
              ),
            ),
          );
        } else if (state is AgencyError) {
          return SizedBox(
            height: 250,
            child: Center(
              child: Text(
                'Error al cargar datos: ${state.message}',
                style: TextStyle(color: theme.colorScheme.error),
              ),
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Map<String, int> _processContractData(List<Agency> agencies) {
    final now = DateTime.now();
    final nextYear = DateTime(now.year + 1, now.month, now.day);
    final Map<String, int> monthlyContracts = {};

    // Inicializar los próximos 12 meses con 0 contratos
    for (int i = 0; i < 12; i++) {
      final month = DateTime(now.year, now.month + i, 1);
      final monthKey = DateFormat('MMM yy').format(month);
      monthlyContracts[monthKey] = 0;
    }

    // Contar contratos por mes
    for (final agency in agencies) {
      if (agency.finContratoVigente != null) {
        final contractEndDate = agency.finContratoVigente!;

        // Solo considerar contratos que vencen dentro del próximo año
        if (contractEndDate.isAfter(now) &&
            contractEndDate.isBefore(nextYear)) {
          final monthKey = DateFormat('MMM yy').format(contractEndDate);
          if (monthlyContracts.containsKey(monthKey)) {
            monthlyContracts[monthKey] = (monthlyContracts[monthKey] ?? 0) + 1;
          }
        }
      }
    }

    return monthlyContracts;
  }

  Widget _buildBarChart(Map<String, int> data, ThemeData theme) {
    final sortedKeys =
        data.keys.toList()..sort((a, b) {
          final dateA = DateFormat('MMM yy').parse(a);
          final dateB = DateFormat('MMM yy').parse(b);
          return dateA.compareTo(dateB);
        });

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: _calculateMaxY(data),
        minY: 0,
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            // tooltipBgColor: theme.colorScheme.primary.withOpacity(0.8),
            tooltipPadding: const EdgeInsets.all(8),
            tooltipMargin: 8,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              final monthKey = sortedKeys[groupIndex];
              return BarTooltipItem(
                '${data[monthKey]} contratos\nen $monthKey',
                TextStyle(
                  color: theme.colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value >= 0 && value < sortedKeys.length) {
                  final monthKey = sortedKeys[value.toInt()];
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Transform.rotate(
                      angle: -0.4,
                      child: Text(
                        monthKey,
                        style: TextStyle(
                          color:
                              theme.brightness == Brightness.dark
                                  ? Colors.white70
                                  : Colors.black54,
                          fontWeight: FontWeight.w500,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
              reservedSize: 30,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: (value, meta) {
                if (value == value.roundToDouble() && value >= 0) {
                  return Text(
                    value.toInt().toString(),
                    style: TextStyle(
                      color:
                          theme.brightness == Brightness.dark
                              ? Colors.white70
                              : Colors.black54,
                      fontWeight: FontWeight.w500,
                      fontSize: 10,
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: FlGridData(
          show: true,
          horizontalInterval: 1,
          getDrawingHorizontalLine:
              (value) => FlLine(
                color:
                    theme.brightness == Brightness.dark
                        ? Colors.white10
                        : Colors.black12,
                strokeWidth: 1,
              ),
          drawVerticalLine: false,
        ),
        borderData: FlBorderData(show: false),
        barGroups: _createBarGroups(data, sortedKeys, theme),
      ),
      swapAnimationDuration: const Duration(milliseconds: 800),
      swapAnimationCurve: Curves.easeInOutCubic,
    );
  }

  double _calculateMaxY(Map<String, int> data) {
    final maxValue =
        data.values.isEmpty
            ? 1
            : data.values.reduce((max, value) => max > value ? max : value);
    return maxValue < 5 ? 5.0 : (maxValue * 1.2);
  }

  List<BarChartGroupData> _createBarGroups(
    Map<String, int> data,
    List<String> sortedKeys,
    ThemeData theme,
  ) {
    final List<BarChartGroupData> barGroups = [];

    for (int i = 0; i < sortedKeys.length; i++) {
      final monthKey = sortedKeys[i];
      final value = data[monthKey] ?? 0;

      final color = _getBarColor(value, theme);

      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: value.toDouble(),
              color: color,
              width: 16,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(4),
              ),
            ),
          ],
        ),
      );
    }

    return barGroups;
  }

  Color _getBarColor(int count, ThemeData theme) {
    // Color según la cantidad de contratos
    if (count >= 5) {
      return Colors.blueGrey;
    } else if (count >= 3) {
      return Colors.blue[200]!;
    }
    return theme.colorScheme.primary;
  }
}

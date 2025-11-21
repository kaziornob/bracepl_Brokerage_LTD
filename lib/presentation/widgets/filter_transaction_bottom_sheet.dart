import 'package:bracepl_fund_management/domain/filter_data.dart';
import 'package:bracepl_fund_management/presentation/blocs/history/history_bloc.dart';
import 'package:bracepl_fund_management/presentation/blocs/history/history_event.dart';
import 'package:bracepl_fund_management/presentation/blocs/history/history_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/transaction.dart';

class FilterBottomSheet extends StatelessWidget {
  const FilterBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<HistoryBloc>(context);
    return BlocBuilder<HistoryBloc, HistoryState>(builder: (context, state) {
      final FilterData filter = (state).filterData;
      return Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom) +
                const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Filter Transactions',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            DropdownButtonFormField<TransactionType>(
              value: filter.type,
              decoration: const InputDecoration(labelText: 'Transaction Type'),
              items: TransactionType.values
                  .map((type) => DropdownMenuItem(
                        value: type,
                        child: Text(type.name.toUpperCase()),
                      ))
                  .toList(),
              onChanged: (value) {
                bloc.add(SetFilter(
                  filter.copyWith(
                    type: () => value,
                  ),
                ));
              },
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: filter.startDate ??
                            DateTime.now().subtract(const Duration(days: 30)),
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null) {
                        bloc.add(SetFilter(
                          filter.copyWith(
                            startDate: () => picked,
                          ),
                        ));
                      }
                    },
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Start Date',
                      ),
                      child: Text(filter.startDate != null
                          ? filter.startDate!.toLocal().toString().split(' ')[0]
                          : 'Any'),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: filter.endDate ?? DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null) {
                        bloc.add(SetFilter(
                          filter.copyWith(
                            endDate: () => picked,
                          ),
                        ));
                      }
                    },
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'End Date',
                      ),
                      child: Text(filter.endDate != null
                          ? filter.endDate!.toLocal().toString().split(' ')[0]
                          : 'Any'),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    bloc.add(SetFilter(const FilterData()));
                  },
                  child: const Text('Clear'),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {
                    final filter = (bloc.state).filterData;
                    print(
                        'Applying filters from bottom sheet: $filter from state ${bloc.state}');
                    bloc.add(ApplyFilters(filter));
                    Navigator.of(context).pop();
                  },
                  child: const Text('Apply'),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}

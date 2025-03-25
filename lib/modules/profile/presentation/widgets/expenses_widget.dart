import 'package:ctntelematics/modules/profile/domain/entitties/req_entities/expenses_req_entity.dart';
import 'package:ctntelematics/modules/profile/domain/entitties/resp_entities/expenses_resp_entity.dart';
import 'package:ctntelematics/modules/profile/presentation/bloc/profile_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../config/theme/app_style.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../service_locator.dart';

class VehicleExpensesWidget extends StatefulWidget {
  final String token;
  VehicleExpensesWidget({super.key, required this.token});

  @override
  _VehicleExpensesWidgetState createState() => _VehicleExpensesWidgetState();
}

class _VehicleExpensesWidgetState extends State<VehicleExpensesWidget> {
  late String fromDate;
  late String toDate;

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    fromDate = DateFormat('yyyy-MM-dd').format(DateTime(now.year, now.month, 1));
    toDate = DateFormat('yyyy-MM-dd').format(DateTime(now.year, now.month + 1, 0));
  }

  Future<void> _selectDate(BuildContext context, bool isFromDate) async {
    DateTime initialDate = isFromDate
        ? DateTime.parse(fromDate)
        : DateTime.parse(toDate);

    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
        if (isFromDate) {
          fromDate = formattedDate;
        } else {
          toDate = formattedDate;
        }
      });

      // Reload expenses based on the selected date range
      BlocProvider.of<GetExpensesBloc>(context).add(
        ExpensesEvent(ExpensesReqEntity(
            from: fromDate,
            to: toDate,
            token: widget.token
        )),
      );
      print("Print date >>>>>>>>"+ widget.token);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Vehicle Expenses', style: AppStyle.cardSubtitle)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildDateSelector("From", fromDate, true),
                _buildDateSelector("To", toDate, false),
              ],
            ),
          ),
          Expanded(
            child: BlocProvider(
              create: (_) => sl<GetExpensesBloc>()
                ..add(ExpensesEvent(ExpensesReqEntity(from: fromDate, to: toDate, token: widget.token))),
              child: BlocConsumer<GetExpensesBloc, ProfileState>(
                builder: (context, state) {
                  if (state is ProfileLoading) {
                    return const CustomContainerLoadingButton();
                  } else if (state is ExpensesDone) {
                    if (state.resp.expenses.data == null || state.resp.expenses.data.isEmpty) {
                      return _buildNoDataMessage('No available expenses');
                    }
                    return ListView.builder(
                      itemCount: state.resp.expenses.data.length,
                      itemBuilder: (context, index) {
                        var expense = state.resp.expenses.data[index];
                        return _buildVehicleSchedule(expense);
                      },
                    );
                  } else {
                    return _buildNoDataMessage('No records found');
                  }
                },
                listener: (context, state) {
                  if (state is ProfileFailure) {
                    if (state.message.contains("401")) {
                      Navigator.pushNamed(context, "/login");
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.message)),
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelector(String label, String date, bool isFromDate) {
    return Column(
      children: [
        Text(label, style: AppStyle.cardSubtitle),
        TextButton(
          onPressed: () => _selectDate(context, isFromDate),
          child: Text(date, style: AppStyle.cardfooter),
        ),
      ],
    );
  }

  Widget _buildVehicleSchedule(DatumEntity expense) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.grey.shade200,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitleValue("Expense Name", expense.expense_name ?? "N/A"),
          _buildTitleValue("Expense Location", expense.expense_location ?? "N/A"),
          _buildTitleValue("Expense Amount", expense.expense_amount ?? "N/A"),
          _buildTitleValue("Recipient Name", expense.recipient_name ?? "N/A"),
          _buildTitleValue("Recipient Type", expense.recipient_type ?? "N/A"),
          _buildTitleValue("Start Date", expense.created_at ?? "N/A"),
          const SizedBox(height: 10),
          const Divider(height: 2),
        ],
      ),
    );
  }

  Widget _buildTitleValue(String title, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: AppStyle.cardfooter.copyWith(fontWeight: FontWeight.bold)),
          Text(value ?? "N/A", style: AppStyle.cardfooter),
        ],
      ),
    );
  }

  Widget _buildNoDataMessage(String message) {
    return Center(child: Text(message, style: AppStyle.cardfooter));
  }
}


// class VehicleExpensesWidget extends StatelessWidget {
//   String token;
//   VehicleExpensesWidget({super.key, required this.token});
//
//   @override
//   Widget build(BuildContext context) {
//     // Get the first and last day of the current month
//     DateTime now = DateTime.now();
//     String fromDate = DateFormat('yyyy-MM-dd').format(DateTime(now.year, now.month, 1));
//     String toDate = DateFormat('yyyy-MM-dd').format(DateTime(now.year, now.month + 1, 0));
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Vehicle Expenses', style: AppStyle.cardSubtitle),
//       ),
//       body: BlocProvider(
//         create: (_) => sl<GetExpensesBloc>()
//           ..add(ExpensesEvent(ExpensesReqEntity(from: fromDate, to: toDate, token: token))),
//         child: BlocConsumer<GetExpensesBloc, ProfileState>(
//           builder: (context, state) {
//             if (state is ProfileLoading) {
//               return const CustomContainerLoadingButton();
//             } else if (state is ExpensesDone) {
//               if (state.resp.expenses.data == null || state.resp.expenses.data.isEmpty) {
//                 return _buildNoDataMessage('No available schedule');
//               }
//               return ListView.builder(
//                 shrinkWrap: true, // Allows the list to take only the required space
//                 physics: const NeverScrollableScrollPhysics(), // Prevents scrolling conflicts
//                 itemCount: state.resp.expenses.data.length,
//                 itemBuilder: (context, index) {
//                   var expense = state.resp.expenses.data[index];
//                   return _buildVehicleSchedule(expense);
//                 },
//               );
//             } else {
//               return _buildNoDataMessage('No records found');
//             }
//           },
//           listener: (context, state) {
//             if (state is ProfileFailure) {
//               if (state.message.contains("401")) {
//                 Navigator.pushNamed(context, "/login");
//               }
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(content: Text(state.message)),
//               );
//             }
//           },
//         ),
//       )
//     );
//
//   }
//
//   /// Builds the vehicle maintenance schedule
//   Widget _buildVehicleSchedule(DatumEntity expense) {
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 8.0),
//       padding: const EdgeInsets.all(10.0),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(5),
//         color: Colors.grey.shade200,
//       ),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 10.0),
//         child: Column(
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     _buildTitleText('Expense Name'),
//                     const SizedBox(height: 10),
//                     _buildTitleText('Expense Location'),
//                     const SizedBox(height: 10),
//                     _buildTitleText('Expense Amount'),
//                     const SizedBox(height: 10),
//                     _buildTitleText('Recipient Name'),
//                     const SizedBox(height: 10),
//                     _buildTitleText('Recipient Type'),
//                     const SizedBox(height: 10),
//                     _buildTitleText('Start Date'),
//                     const SizedBox(height: 10),
//                   ],
//                 ),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     _buildValueText(expense.expense_name ?? "N/A"),
//                     const SizedBox(height: 10),
//                     _buildValueText(expense.expense_location ?? "N/A"),
//                     const SizedBox(height: 10),
//                     _buildValueText(expense.expense_amount ?? "N/A"),
//                     const SizedBox(height: 10),
//                     _buildValueText(expense.recipient_name ?? "N/A"),
//                     const SizedBox(height: 10),
//                     _buildValueText(expense.recipient_type ?? "N/A"),
//                     const SizedBox(height: 10),
//                     _buildValueText(expense.created_at ?? "N/A"),
//                     Container(
//                         padding: const EdgeInsets.all(10),
//                         decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(5),
//                             border: Border.all(
//                               width: 0, color: Colors.grey.shade200,)),
//                         child: Text('',
//                           style: AppStyle.cardSubtitle.copyWith(
//                             color: Colors.grey.shade200,),)
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//             const SizedBox(height: 10),
//             const Divider(height: 2),
//           ],
//         ),
//       ),
//     );
//   }
//
//   /// Displays a no-data message
//   Widget _buildNoDataMessage(String message) {
//     return Center(child: Text(message, style: AppStyle.cardfooter));
//   }
//   /// Builds title text
//   Widget _buildTitleText(String text) {
//     return Text(text,
//         style: AppStyle.cardfooter.copyWith(fontWeight: FontWeight.bold));
//   }
//
//   /// Builds value text
//   Widget _buildValueText(String text) {
//     return Text(text, style: AppStyle.cardfooter);
//   }
//
// }
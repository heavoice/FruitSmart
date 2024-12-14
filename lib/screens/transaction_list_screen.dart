import 'package:flutter/material.dart';
import 'package:smart_shop_app/config/theme/app_colors.dart';
import 'package:smart_shop_app/main.dart';
import 'package:smart_shop_app/service/transaction/transaction_service.dart';
import 'package:intl/intl.dart';
import 'package:smart_shop_app/widget/app_dialog.dart';

class TransactionListScreen extends StatefulWidget {
  const TransactionListScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TransactionList createState() => _TransactionList();
}

class _TransactionList extends State<TransactionListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  width: double.infinity,
                  child: const Text(
                    "Transaction List",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                
              ],
            ),
          ),
          FutureBuilder(
            future: TransactionService().getTransactions(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return ListTile(
                          title: Container(
                        decoration: BoxDecoration(
                          color: AppColors.lightGrey.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        padding: EdgeInsets.all(84),
                      ));
                    },
                    childCount: 4,
                  ),
                );
              }

              final data = snapshot.data;

              if (data == null || data.isEmpty) {
                return SliverToBoxAdapter(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height - 200,
                    child: Center(
                      child: Text(
                        'No Transaction Found',
                      ),
                    ),
                  ),
                );
              }

              final transactions = snapshot.data as List<Map<String, dynamic>>;

              if (transactions.isNotEmpty) {
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final transaction =
                          Transaction.fromJson(transactions[index]);
                      return ListTile(
                        title: Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: AppColors.lightGrey.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Column(
                            children: [
                              Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    DateFormat('dd MMMM yyyy')
                                        .format(transaction.date),
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.grayText,
                                    ),
                                  ),
                StatusBadge(status: transaction.status),
              ],
            ),
                              Divider(
                                color: AppColors.lightGrey.withOpacity(0.8),
                                thickness: 1,
                                height: 20,
                              ),
                              Row(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 45,
                                        height: 45,
                                        decoration: BoxDecoration(
                                          color: Color(int.parse(
                                              '0xFF${transaction.product.primary_color}')),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Center(
                                          child: Image.network(
                                            transaction.product.image ?? '',
                                            width: 35,
                                            height: 35,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            transaction.product.name ?? "-",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Text(
                                            '${transaction.quantity} Pcs',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: AppColors.grayText,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                children: [
                                      Text(
                                        'Total Price',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: AppColors.grayText,
                                        ),
                                        textAlign: TextAlign.start,
                                      ),
                                      Text(
                                        '\$ ${transaction.totalPrice}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        textAlign: TextAlign.start,
                                      ),

                   
                                    ],
                                  ),
                                  if (transaction.status == 'success')
                                    SizedBox(
                                      width: 75,
                                      height: 30,
                                      child: TextButton(
                                          onPressed: () {
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AppDialog(
                                                    title: 'Reorder',
                                                    message:
                                                        'Do you want to reorder this product?',
                                                    cancelText: "Cancel",
                                                    confirmText: "Reorder",
                                                    onConfirm: () async {
                                                      try {
                                                        final currentUser =
                                                            supabase.auth
                                                                .currentUser;

                                                        if (currentUser ==
                                                            null) {
                                                          return;
                                                        }

                                                        final payload = {
                                                          "product_id":
                                                              transaction
                                                                  .product.id,
                                                          "quantity":
                                                              transaction
                                                                  .quantity,
                                                          "total_price":
                                                              transaction
                                                                  .totalPrice,
                                                          "status": "process",
                                                          "user_id":
                                                              currentUser.id,
                                                        };

                                                        await TransactionService()
                                                            .addTransaction(
                                                                [payload]);

                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                                SnackBar(
                                                          content: Text(
                                                              "Transaction successfully completed!"),
                                                          backgroundColor:
                                                              AppColors.primary,
                                                          duration: Duration(
                                                              seconds: 2),
                                                        ));

                                                        setState(() {});
                                                      } catch (e) {
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                                SnackBar(
                                                          content: Text(
                                                              "Failed to reorder transaction!"),
                                                          backgroundColor:
                                                              AppColors
                                                                  .secondary,
                                                          duration: Duration(
                                                              seconds: 2),
                                                        ));
                                                      } finally {
                                                        Navigator.pop(context);
                                                      }
                                                    },
                                                  );
                                                });
                                          },
                                          child: Text(
                                            'Reorder',
                                            style: TextStyle(
                                                color: AppColors.background,
                                                fontSize: 12),
                                          ),
                                          style: ButtonStyle(
                                            backgroundColor:
                                                WidgetStatePropertyAll<Color>(
                                              AppColors.primary,
                                            ),
                                            padding:
                                                const WidgetStatePropertyAll<
                                                        EdgeInsets>(
                                                    EdgeInsets.symmetric(
                                                        horizontal: 5,
                                                        vertical: 5)),
                                          )),
                                    )
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    childCount: transactions.length,
                  ),
                );
              }

              return SliverToBoxAdapter(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height - 200,
                  child: Center(
                    child: Text(
                      'No Transaction Found',
                    ),
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}



class StatusBadge extends StatelessWidget {
  final String status;
  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: status == "success"
            ? AppColors.primary.withOpacity(0.15)
            : status == "canceled"
                ? AppColors.secondary.withOpacity(0.1)
                : AppColors.warning.withOpacity(0.14),
      ),
      child: Text(
        status == "success"
            ? "Success"
            : status == "canceled"
                ? "Canceled"
                : "Process",
        style: TextStyle(
            color: status == "success"
                ? AppColors.primary
                : status == "canceled"
                    ? AppColors.secondary
                    : AppColors.warning,
            fontSize: 10,
            fontWeight: FontWeight.w500),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:smart_shop_app/config/theme/app_colors.dart';
import 'package:smart_shop_app/constant/transaction_list.dart';

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
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: GridView.builder(
                    gridDelegate:
                         SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: MediaQuery.of(context).size.width < 600
                          ? 1
                          : MediaQuery.of(context).size.width < 900
                              ? 2
                              : 3,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      childAspectRatio: 16 / 9,
                    ),
                    itemCount: transactionList.length,
                    shrinkWrap: true,
                    physics:
                        const NeverScrollableScrollPhysics(), // Menonaktifkan scrollbar
                    itemBuilder: (context, index) =>
                        TransactionItem(transaction: transactionList[index]),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TransactionItem extends StatelessWidget {
  final Transaction transaction;
  const TransactionItem({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.lightGrey.withOpacity(0.25),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Column(
            children: [
              Container(
            padding: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: AppColors.lightGrey, // Warna border
                  width: 0.6, // Ketebalan border
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    HugeIcon(
                        icon: HugeIcons.strokeRoundedShoppingBag02,
                        color: AppColors.primary),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Shopping",
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          transaction.date,
                          style: const TextStyle(
                            fontSize: 10,
                            color: AppColors.grayText,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                StatusBadge(status: transaction.status),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Image.asset(
                transaction.productImage,
                width: 50,
                height: 50,
              ),
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.productName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "${transaction.productQuantity} Pcs",
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.grayText,
                    ),
                  ),
                ],
              ),
            ],
          ),
         
            ],
          ),
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Total Price",
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: AppColors.grayText,
                    ),
                  ),
                  Text(
                    "\$${transaction.productPrice * transaction.productQuantity}",
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.darkSecondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              if (transaction.status == Status.success)
                SizedBox(
                  width: 60,
                  height: 23,
                  child: TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 2,
                      ),
                    ),
                    child: const Text(
                      "Reorder",
                      style: TextStyle(
                        color: AppColors.background,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              if (transaction.status == Status.process)
                SizedBox(
                  width: 50,
                  height: 23,
                  child: TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.amber,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 2,
                      ),
                    ),
                    child: const Text(
                      "Track",
                      style: TextStyle(
                        color: AppColors.background,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class StatusBadge extends StatelessWidget {
  final Status status;
  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: status == Status.success
            ? AppColors.primary.withOpacity(0.15)
            : status == Status.canceled
                ? AppColors.secondary.withOpacity(0.1)
                : AppColors.warning.withOpacity(0.14),
      ),
      child: Text(
        status == Status.success
            ? "Success"
            : status == Status.canceled
                ? "Canceled"
                : "Process",
        style: TextStyle(
            color: status == Status.success
                ? AppColors.primary
                : status == Status.canceled
                    ? AppColors.secondary
                    : AppColors.warning,
            fontSize: 10,
            fontWeight: FontWeight.w500),
      ),
    );
  }
}

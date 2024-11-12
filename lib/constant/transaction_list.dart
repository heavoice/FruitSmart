class Transaction {
  final String productName;
  final String productImage;
  final int productPrice;
  final int productQuantity;
  final String productCategory;
  final Status status;
  final String date;

  Transaction({
    required this.productName,
    required this.productImage,
    required this.productPrice,
    required this.productQuantity,
    required this.productCategory,
    required this.status,
    required this.date,
  });
}

enum Status {
  success,
  canceled,
  process,
}

List<Transaction> transactionList = [
  Transaction(
    productName: "Apple",
    productImage: "assets/img/apple.png",
    productPrice: 14,
    productQuantity: 5,
    productCategory: "fruits",
    status: Status.success,
    date: "29 May 2024",
  ),
  Transaction(
    productName: "Blueberry",
    productImage: "assets/img/blueberry.png",
    productPrice: 15,
    productQuantity: 10,
    productCategory: "fruits",
    status: Status.process,
    date: "29 May 2024",
  ),
  Transaction(
    productName: "broccoli",
    productImage: "assets/img/broccoli.png",
    productPrice: 25,
    productQuantity: 8,
    productCategory: "vegetables",
    status: Status.canceled,
    date: "29 May 2024",
  ),
  Transaction(
    productName: "Strawberry",
    productImage: "assets/img/strawberry.png",
    productPrice: 60,
    productQuantity: 3,
    productCategory: "fruits",
    status: Status.success,
    date: "29 May 2024",
  ),
  Transaction(
    productName: "Wagyu A5",
    productImage: "assets/img/meat.png",
    productPrice: 2000,
    productQuantity: 2,
    productCategory: "meat",
    status: Status.process,
    date: "29 May 2024",
  ),
];

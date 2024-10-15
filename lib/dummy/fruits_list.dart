class Product {
  final String id; // Add an id field
  final String name;
  final String description;
  final String image;
  final double price;
  final String color;
final String secondaryColor;
  Product({
    required this.id, // Make sure to pass this when creating a product
    required this.name,
    required this.description,
    required this.image,
    required this.price,
    required this.color,
    required this.secondaryColor,
  });
}

class CartItem {
  final Product product;
  int quantity;
  CartItem({required this.product, this.quantity = 1});
}

List<Product> cartItems = [];

final List<Product> products = [
  Product(
    id: '1',
    price: 1.45,
    name: 'Blueberries',
    description:
        'Blueberries are sweet, nutritious and wildly popular. Often labeled a superfood, they are low in calories and incredibly good for you.',
    image: 'assets/img/blueberry.png',
    color: "E3E5FE",
      secondaryColor: "B5B3DA"
  ),
  Product(
    id: '2',
    price: 2.45,
    name: 'Dragon Fruit',
    description:
        'Dragon fruit is a tropical fruit that has become increasingly popular in recent years. Though people primarily enjoy it for its unique look and taste, evidence suggests it may provide health benefits as well.',
    image: 'assets/img/dragon.png',
    color: "FFEEFF",
      secondaryColor: "ECB0E8"
  ),
  Product(
    id: '3',
    price: 2.5,
    name: 'Lychee',
    description:
        'Lychee is a tropical tree native to the Guangdong and Fujian provinces of southeastern China, where cultivation is documented from the 11th century.',
    image: 'assets/img/lychee.png',
    color: "D6FFD0",
      secondaryColor: "A6EFA1"
  ),
  Product(
    id: '4',
    price: 2.5,
    name: 'Mango',
    description:
        'Mangoes are a tropical fruit from the drupe family. They are indigenous to India, but are now grown in many tropical and subtropical regions.',
    image: 'assets/img/mango.png',
    color: "FDE18D",
      secondaryColor: "F8B05E"
  ),
  Product(
    id: '5',
    price: 2.5,
    name: 'Pinapple',
    description:
        'The pineapple is a tropical plant with an edible fruit and the most economically significant plant in the family Bromeliaceae.',
    image: 'assets/img/pineapple.png',
    color: "F4EFC9",
      secondaryColor: "F3E5A1"
  ),
  Product(
    id: '6',
    price: 2.5,
    name: 'Strawberry',
    description:
        'Strawberry is a widely grown hybrid species of the genus Fragaria, collectively known as the strawberries, which are cultivated worldwide for their fruit.',
    image: 'assets/img/strawberry.png',
    color: "F4BABF",
      secondaryColor: "F3B5BB"
  ),
];

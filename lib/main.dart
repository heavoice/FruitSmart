import 'package:flutter/material.dart';

void main() {
  runApp(const SmartShopApp());
}

class SmartShopApp extends StatelessWidget {
  const SmartShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FruitSmart',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
      routes: {
        '/product-list': (context) => const ProductListScreen(),
        '/detail': (context) => const ProductDetailScreen(),
      },
    );
  }
}

class Product {
  final String id; // Add an id field
  final String name;
  final String description;
  final String image;
  final double price; // Assuming you have a price field

  Product({
    required this.id, // Make sure to pass this when creating a product
    required this.name,
    required this.description,
    required this.image,
    required this.price,
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
      price: 15000,
      name: 'Anggur',
      description: 'Buah Anggur',
      image: 'assets/img/1.jpg'),
  Product(
      id: '2',
      price: 15000,
      name: 'Apel',
      description: 'Buah Apel',
      image: 'assets/img/2.jpg'),
  Product(
      id: '3',
      price: 15000,
      name: 'Naga',
      description: 'Buah Naga',
      image: 'assets/img/3.jpg'),
  Product(
      id: '4',
      price: 15000,
      name: 'Kelengkeng',
      description: 'Buah Kelengkeng',
      image: 'assets/img/4.jpg'),
  Product(
      id: '5',
      price: 15000,
      name: 'Melon',
      description: 'Buah Melon',
      image: 'assets/img/5.png'),
  Product(
      id: '6',
      price: 15000,
      name: 'Nanas',
      description: 'Buah Nanas',
      image: 'assets/img/6.jpg'),
  Product(
      id: '7',
      price: 15000,
      name: 'Strawberry',
      description: 'Buah Strawberry',
      image: 'assets/img/7.jpg'),
];

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('FruitSmart'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartScreen()),
              );
            },
          ),
        ],
      ),
      body: Center(
        // Center digunakan untuk menengahkan konten
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment
                .center, // Konten juga di tengah secara horizontal
            children: [
              const Text(
                'Selamat Datang di FruitSmart!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const Text(
                'Belanja produk buah-buahan terbaik dengan harga terjangkau.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                  height: 40), // Jarak lebih jauh antara teks dan gambar
              Image.network(
                'https://media.istockphoto.com/id/1253516957/id/vektor/belanja-online-dan-template-e-commerce-dengan-ilustrasi-vektor-kartun-orang.jpg?s=170667a&w=0&k=20&c=BhfXJwJWuOaJbBkOCDkTYrSjg4hPq3ngA-x8tz3vxJY=',
                fit: BoxFit.contain,
                height: 200,
              ),
              const SizedBox(height: 30), // Jarak di bawah gambar
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/product-list');
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue, // Warna teks tombol
                ),
                child: const Text('Belanja Sekarang'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.all(10), // Margin antara item
            padding: const EdgeInsets.all(16), // Padding di dalam item
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12), // Sudut yang membulat
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3), // Posisi bayangan
                ),
              ],
            ),
            child: ListTile(
              leading: Image.network(
                products[index].image,
                width: 100, // Lebar gambar item diperbesar
                height: 100, // Tinggi gambar diperbesar
                fit: BoxFit.cover, // Gambar dipotong sesuai kotak
              ),
              title: Text(
                products[index].name,
                style: const TextStyle(
                  fontSize: 18, // Ukuran teks lebih besar
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                products[index].description,
                style: const TextStyle(fontSize: 14),
              ),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/detail',
                  arguments: products[index],
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Product? product =
        ModalRoute.of(context)!.settings.arguments as Product?;

    if (product == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Product Detail'),
        ),
        body: const Center(
          child: Text('Product not found.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Detail'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(
                    product.image,
                    height: constraints.maxWidth > 600 ? 300 : 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.description,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Add product to cart
                      cart.add(product);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${product.name} added to cart!'),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    child: const Text(
                      'Add to Cart',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class Cart {
  List<CartItem> items = [];

  void add(Product product) {
    // Check if the product is already in the cart
    final existingItem = items.firstWhere(
      (item) => item.product.id == product.id, // Ensure Product has 'id'
      orElse: () => CartItem(
          product: product, quantity: 0), // Return a default item if not found
    );

    if (existingItem.quantity > 0) {
      // If exists, increase the quantity
      existingItem.quantity++;
    } else {
      // If not, add a new item
      items.add(CartItem(product: product));
    }
  }

  void clear() {
    items.clear();
  }
}

// Create an instance of Cart
final Cart cart = Cart(); // Rename cart variable to avoid conflict

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the cart items from the provider (or state management)
    final cartItems =
        cart.items; // Assuming you have a cart object that manages the cart

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      body: cartItems.isEmpty
          ? const Center(child: Text('Your cart is empty.'))
          : ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return ListTile(
                  leading: Image.network(item.product.image),
                  title: Text(item.product.name),
                  subtitle: Text('Quantity: ${item.quantity}'),
                  trailing:
                      Text('Price: \$${item.product.price * item.quantity}'),
                );
              },
            ),
    );
  }
}

import 'package:flutter/material.dart';

void main() {
  runApp(const SmartShopApp());
}

class SmartShopApp extends StatelessWidget {
  const SmartShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SmartShop',
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
  final String name;
  final String description;
  final String image;

  Product({required this.name, required this.description, required this.image});
}

final List<Product> products = [
  Product(
      name: 'Semangka',
      description: 'Buah Semangka',
      image: 'assets/img/1.jpg'),
  Product(name: 'Kiwi', description: 'Buah Kiwi', image: 'assets/img/2.jpg'),
  Product(name: 'Apel', description: 'Buah Apel', image: 'assets/img/3.jpg'),
  Product(name: 'Pir', description: 'Buah Pir', image: 'assets/img/4.jpg'),
  Product(
      name: 'Jeruk Limau?',
      description: 'Buah Jeruk Limau',
      image: 'assets/img/5.jpg'),
  Product(
      name: 'Manggis', description: 'Buah Manggis', image: 'assets/img/6.jpg'),
  Product(name: 'Jeruk', description: 'Buah Jeruk', image: 'assets/img/7.jpg'),
];

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('SmartShop'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Selamat Datang di SmartShop!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Text(
              'Belanja produk elektronik terbaik dengan harga terjangkau.',
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
    final Product product =
        ModalRoute.of(context)!.settings.arguments as Product;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Detail'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(product.image,
                height: 200, width: double.infinity, fit: BoxFit.cover),
            const SizedBox(height: 16),
            Text(
              product.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(product.description),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/product.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // เพิ่มตัวแปร products
  List<Product> products = [];

  @override
  void initState() {
    super.initState();
    getData(); // เรียกใช้เมธอดเมื่อเริ่มต้น
  }

  Future<void> getData() async {
    var url = Uri.https("fakestoreapi.com", "products");
    var response = await http.get(url);
    setState(() {
      products = productFromJson(response.body);
    });
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('IT@WU Shop')),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          Product product = products[index];
          var imgUrl = product.image;
          imgUrl ??=
              "https://icon-library.com/images/no-picture-available-icon/no-picture-available-icon-20.jpg";

          return ListTile(
            title: Text("${product.title}"),
            subtitle: Text("\$${product.price}"),
            leading: Image.network(imgUrl),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailScreen(product: product),
                ),
              );
            },
          );
        },
      ), // ListView.builder
    ); // Scaffold
  }
}

class DetailScreen extends StatefulWidget {
  final Product product;

  const DetailScreen({super.key, required this.product});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    var imgUrl = widget.product.image;
    imgUrl ??=
        "https://icon-library.com/images/no-picture-available-icon/no-picture-available-icon-20.jpg";

    return Scaffold(
      appBar: AppBar(
        title: const Text("Details"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Image.network(imgUrl),
          const SizedBox(height: 16.0),
          Text(
            widget.product.title ?? '',
            style: const TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            "\$${widget.product.price}",
            style: const TextStyle(fontSize: 20.0),
          ),
          const SizedBox(height: 8.0),
          Text(
            widget.product.description ?? '',
            style: const TextStyle(fontSize: 16.0),
          ),
          const SizedBox(height: 16.0),
          RatingBar.builder(
            itemBuilder: (context, index) => const Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (value) {
              // Do nothing
            },
            minRating: 0,
            itemCount: 5,
            allowHalfRating: true,
            direction: Axis.horizontal,
            itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
            initialRating: widget.product.rating?.rate ?? 0,
          ),
          const SizedBox(height: 8.0),
          Text(
              "Rating: ${widget.product.rating?.rate}/5 of ${widget.product.rating?.count}"),
        ],
      ),
    );
  }
}

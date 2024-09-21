import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:crud_app/models/product.dart';


class DeleteProductScreen extends StatefulWidget {
  final Product product;

  const DeleteProductScreen({super.key, required this.product});

  @override
  _DeleteProductScreenState createState() => _DeleteProductScreenState();
}

class _DeleteProductScreenState extends State<DeleteProductScreen> {
  bool _inProgress = false;

  Future<void> _deleteProduct() async {
    setState(() {
      _inProgress = true;
    });

    Uri uri = Uri.parse('http://164.68.107.70:6060/api/v1/DeleteProduct/${widget.product.id}');

    // Request body (even though it's a GET request, just mimicking as per your instruction)
    Map<String, dynamic> requestBody = {
      "id": widget.product.id.toString(),
    };

    // Make the GET request with headers and body encoded as query parameters
    Response response = await get(
      uri,
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product deleted successfully!')),
      );
      Navigator.pop(context, true);  // Return true to indicate success
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete product: ${response.statusCode}')),
      );
    }

    setState(() {
      _inProgress = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delete Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Are you sure you want to delete ${widget.product.productName}?'),
            const SizedBox(height: 20),
            _inProgress
                ? const CircularProgressIndicator()
                : ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: const Size.fromWidth(double.maxFinite),
              ),
              onPressed: _deleteProduct,
              child: const Text('Delete Product'),
            ),
          ],
        ),
      ),
    );
  }
}

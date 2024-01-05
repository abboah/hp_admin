import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hp_admin/models/product_model.dart';
import 'package:hp_admin/providers/product_provider.dart';
import 'package:provider/provider.dart';

class ProductWidget extends StatefulWidget {
  const ProductWidget({super.key});

  @override
  _ProductWidgetState createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<ProductWidget> {
  ProductProvider? productProvider;

  @override
  void initState() {
    super.initState();
    // Initialize productProvider here
    productProvider = Provider.of<ProductProvider>(context, listen: false);

    // Fetch data from the ProductProvider when the widget is created
    productProvider!.fetchProductsData().then((_) {
      print('Categories loaded: ${productProvider!.categories.length}');
      if (productProvider!.categories.isNotEmpty) {
        print(
            'First category products: ${productProvider!.categories[0].products.length}');
      }
    });
  }

  Category? selectedCategory;

  @override
  Widget build(BuildContext context) {
    int gridColumns = MediaQuery.of(context).size.width > 600 ? 4 : 2;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Categories'),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                      onPressed: () {
                        setState(() {
                          productProvider!.fetchProductsData();
                        });
                      },
                      icon: const Icon(CupertinoIcons.refresh_bold),
                      label: const Text("Refresh")),
                )
              ],
            ),
            _buildCategoryGrid(context),
            Text(selectedCategory?.name ?? "Products"),
            if (selectedCategory != null)
              _buildProductGrid(selectedCategory!.products, gridColumns),
          ],
        ),
      ),
      floatingActionButton: Visibility(
        visible: selectedCategory != null,
        child: FloatingActionButton(
          onPressed: () {
            _showAddProductDialog(context);
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildCategoryGrid(BuildContext context) {
    int gridColumnsCategory = MediaQuery.of(context).size.width > 600 ? 5 : 3;
    return GridView.builder(
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: gridColumnsCategory,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
      ),
      itemCount: productProvider!.categories.length,
      itemBuilder: (BuildContext context, index) {
        return GestureDetector(
          onTap: () {
            print(
                'Selected Category: ${productProvider!.categories[index].name}');
            setState(() {
              selectedCategory = productProvider!.categories[index];
            });
          },
          child: Card(
            margin: const EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.category, size: 30),
                const SizedBox(height: 8),
                Text(productProvider!.categories[index].name),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProductGrid(List<ProductModel> products, int gridColumns) {
    return GridView.builder(
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: gridColumns,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            _showEditProductDialog(context, products[index]);
          },
          child: Card(
            margin: const EdgeInsets.all(8),
            child: Column(
              children: [
                Image.network(
                  products[index].imageUrl,
                  height: 80,
                  width: 80,
                  fit: BoxFit.cover,
                ),
                Text(products[index].name),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showEditProductDialog(BuildContext context, ProductModel product) {
    // Implement your edit product dialog here
  }

  void _showAddProductDialog(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController priceController = TextEditingController();
    TextEditingController imageUrlController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Product'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Product Name'),
              ),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(labelText: 'Product Price'),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
              ),
              TextField(
                controller: imageUrlController,
                decoration: const InputDecoration(labelText: 'Image URL'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                String categoryName = selectedCategory?.name ?? '';
                String productName = nameController.text.trim();
                double productPrice =
                    double.tryParse(priceController.text) ?? 0.0;
                String productImageUrl = imageUrlController.text.trim();

                if (productName.isNotEmpty &&
                    productPrice > 0 &&
                    productImageUrl.isNotEmpty) {
                  ProductModel newProduct = ProductModel(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    name: productName,
                    price: productPrice.toString(),
                    imageUrl: productImageUrl,
                    category: '',
                  );

                  await addProductToCategory(categoryName, newProduct);

                  // Refresh the UI to display the new product
                  setState(() {
                    selectedCategory?.products.add(newProduct);
                  });

                  Navigator.of(context).pop(); // Close the dialog
                } else {
                  // Show an error or validation message if needed
                  // For simplicity, you can add a Text widget here or use Fluttertoast
                  print('Please fill in all fields with valid values.');
                }
              },
              child: const Text('Add Product'),
            ),
          ],
        );
      },
    );
  }
}

FirebaseFirestore firestore = FirebaseFirestore.instance;

Future<void> addProductToCategory(
    String categoryName, ProductModel newProduct) async {
  try {
    // Add the new product to the 'products' subcollection of the specified category
    await firestore
        .collection('categories')
        .doc(categoryName)
        .collection('products')
        .doc(newProduct.id)
        .set({
      'id': newProduct.id,
      'name': newProduct.name,
      'price': newProduct.price,
      'imageUrl': newProduct.imageUrl,
    });

    print('Product added successfully');
  } catch (e) {
    print('Error adding product: $e');
    // Handle the error as needed
  }
}

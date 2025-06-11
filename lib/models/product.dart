class Product {
  final String name;
  final String price;
  final String image;
  final String category;
  final String weight;
  final String description;
  final double rating;
  final int reviews;

  Product({
    required this.name,
    required this.price,
    required this.image,
    required this.category,
    required this.weight,
    required this.description,
    this.rating = 4.65,
    this.reviews = 126,
  });
}

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});
}

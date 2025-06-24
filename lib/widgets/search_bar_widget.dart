import 'package:flutter/material.dart';
import '../providers/cart_provider.dart';

class SearchBarWidget extends StatefulWidget {
  final CartProvider cartProvider;
  final VoidCallback onCartTap;
  final Function(String) onSearchSubmit;

  const SearchBarWidget({
    Key? key,
    required this.cartProvider,
    required this.onCartTap,
    required this.onSearchSubmit,
  }) : super(key: key);

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final TextEditingController _controller = TextEditingController();

  void _submitSearch() {
    final query = _controller.text.trim();
    widget.onSearchSubmit(query);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          // Text field
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Cari produk...',
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
              onSubmitted: (_) => _submitSearch(),
            ),
          ),
          const SizedBox(width: 8),
          // Tombol search
          IconButton(
            icon: Icon(Icons.search, color: Colors.green[800]),
            onPressed: _submitSearch,
          ),
          const SizedBox(width: 8),
          // Cart with badge
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.shopping_cart, color: Colors.green[700]),
                onPressed: widget.onCartTap,
              ),
              if (widget.cartProvider.itemCount > 0)
                Positioned(
                  right: 4,
                  top: 4,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 20,
                      minHeight: 20,
                    ),
                    child: Center(
                      child: Text(
                        '${widget.cartProvider.itemCount}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
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

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../favorites/favorites_provider.dart';
import '../catalog_service.dart';

class ProductCard extends ConsumerStatefulWidget {
  final Product product;
  final Function(GlobalKey, String) onAdd;

  const ProductCard({super.key, required this.product, required this.onAdd});

  @override
  ConsumerState<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends ConsumerState<ProductCard> {
  bool _imageError = false;

  static const Map<String, String> _categoryEmojis = {
    'soif': '🥤',
    'faim': '🍔',
    'snack': '🍿',
    'plage': '🏖️',
    'default': '🛒',
  };

  @override
  Widget build(BuildContext context) {
    final GlobalKey imageKey = GlobalKey();
    final emoji = _categoryEmojis[widget.product.categoryId.toLowerCase()] ?? 
                  _categoryEmojis['default']!;
    final isFavorite = ref.watch(favoritesProvider).contains(widget.product.id);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: _imageError || widget.product.imageUrl.isEmpty
                        ? Text(emoji, style: const TextStyle(fontSize: 48))
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              widget.product.imageUrl,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                WidgetsBinding.instance.addPostFrameCallback((_) {
                                  if (mounted) setState(() => _imageError = true);
                                });
                                return const SizedBox();
                              },
                            ),
                          ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.product.name,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.text,
                              height: 1.2,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.star_rounded, size: 14, color: AppColors.accent),
                              const SizedBox(width: 2),
                              const Text(
                                "4.8",
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.text,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${widget.product.price.toStringAsFixed(0)} MAD",
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                              color: AppColors.text,
                            ),
                          ),
                          GestureDetector(
                            onTap: widget.product.isAvailable
                                ? () => widget.onAdd(imageKey, widget.product.imageUrl)
                                : null,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            right: 12,
            top: 12,
            child: GestureDetector(
              onTap: () {
                ref.read(favoritesProvider.notifier).toggleFavorite(widget.product.id);
              },
              child: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border_rounded,
                size: 18,
                color: AppColors.error,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

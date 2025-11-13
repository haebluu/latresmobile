import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/favorite_controller.dart';
import '../models/anime_model.dart';
import 'detail_page.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final favCtrl = Provider.of<FavoriteController>(context);

    if (favCtrl.favorites.isEmpty) {
      return const Center(
        child: Text(
          'Belum ada anime favorit',
          style: TextStyle(fontSize: 16, color: Colors.black54),
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.63,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: favCtrl.favorites.length,
      itemBuilder: (context, idx) {
        final AnimeModel anime = favCtrl.favorites[idx];

        return GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => DetailPage(anime: anime)),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.9),
                  const Color.fromRGBO(255, 198, 222, 0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.pink.shade100.withOpacity(0.4),
                  blurRadius: 8,
                  offset: const Offset(2, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Poster
                  Expanded(
                    flex: 7,
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Image.network(
                            anime.imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: Colors.grey.shade300,
                              child: const Icon(Icons.broken_image),
                            ),
                          ),
                        ),
                        // Tombol hapus
                        Positioned(
                          right: 8,
                          top: 8,
                          child: InkWell(
                            onTap: () => favCtrl.remove(anime),
                            child: CircleAvatar(
                              radius: 14,
                              backgroundColor: Colors.white.withOpacity(0.8),
                              child: const Icon(
                                Icons.delete,
                                color: Colors.red,
                                size: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Info anime
                  Expanded(
                    flex: 4,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(255, 240, 245, 1),
                        borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(20),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            anime.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Color.fromRGBO(206, 1, 88, 1),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.star,
                                  size: 16, color: Colors.orange),
                              const SizedBox(width: 4),
                              Text(
                                anime.score.toStringAsFixed(2),
                                style: const TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Flexible(
                                child: Text(
                                  '${anime.type ?? "-"} · ${anime.episodes ?? "?"} eps',
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.black54,
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
            ),
          ),
        );
      },
    );
  }
}

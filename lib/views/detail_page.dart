import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/anime_model.dart';
import '../controllers/favorite_controller.dart';

class DetailPage extends StatelessWidget {
  final AnimeModel anime;

  const DetailPage({required this.anime, super.key});

  @override
  Widget build(BuildContext context) {
    // Menggunakan Consumer agar hanya IconButton yang me-rebuild,
    // bukan seluruh widget DetailPage.
    return Consumer<FavoriteController>(
      builder: (context, favCtrl, child) {
        final bool isFav = favCtrl.isFavorite(anime);
        
        return Scaffold(
          backgroundColor: const Color.fromRGBO(252, 241, 245, 1),
          appBar: AppBar(
            title: Text(anime.title),
            backgroundColor: const Color.fromRGBO(255, 198, 222, 1),
            actions: [
              IconButton(
                icon: Icon(
                  isFav ? Icons.favorite : Icons.favorite_border,
                  color: isFav ? Colors.red : const Color.fromRGBO(206, 1, 88, 1),
                  size: 26,
                ),
                onPressed: () => favCtrl.toggleFavorite(anime),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              // Pastikan perataan kolom adalah di tengah
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Poster
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    anime.imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    errorBuilder: (_, __, ___) => Container(
                      height: 300,
                      color: Colors.grey.shade300,
                      child: const Icon(Icons.broken_image, size: 60),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Title (Sudah di tengah karena Column crossAxisAlignment: center)
                Text(
                  // Asumsi properti titleEnglish ada di AnimeModel Anda.
                  // Jika tidak ada, gunakan anime.title saja.
                  anime.title,
                  textAlign: TextAlign.center, // Tambahkan ini agar teks juga rata tengah
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),

                // --- BAGIAN YANG DIREVISI: Rating dan Info Dibungkus Center ---
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min, // Penting agar Row tidak melebar
                    children: [
                      const Icon(Icons.star, color: Colors.orange, size: 22),
                      const SizedBox(width: 6),
                      Text(
                        anime.score.toStringAsFixed(2),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '${anime.type ?? "-"} · ${anime.episodes ?? 0} eps · ${anime.rating ?? "-"}',
                        style: const TextStyle(fontSize: 14, color: Colors.black54),
                      ),
                    ],
                  ),
                ),
                // -----------------------------------------------------------------

                const SizedBox(height: 12),
                if (anime.year != null)
                  Text(
                    'Year: ${anime.year}',
                    style: const TextStyle(color: Colors.black54),
                  ),

                const SizedBox(height: 16),

                // Genre chips (Perlu dibungkus Center agar rapi)
                Center(
                  child: Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    alignment: WrapAlignment.center, // Agar chip rata tengah
                    children: anime.genres
                        .map(
                          (g) => Chip(
                            label: Text(g),
                            backgroundColor:  Color.fromRGBO(255, 237, 245, 1),
                            labelStyle: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),

                const Divider(height: 32, color: Color.fromRGBO(206, 1, 88, 1)),

                // Synopsis (Kembalikan perataan ke kiri untuk membaca yang lebih baik)
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Synopsis',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  anime.synopsis,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black87,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.justify,
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }
}
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/anime_controller.dart';
import '../controllers/favorite_controller.dart';
import 'detail_page.dart';
import 'favorites_page.dart';
import 'profile_page.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;
  final pages =  [HomeList(), FavoritesPage(), ProfilePage()];

  @override
  Widget build(BuildContext context) {
    String appBarTitle;
    switch (currentIndex) {
      case 1:
        appBarTitle = 'My Favorite';
        break;
      case 2:
        appBarTitle = 'Profile';
        break;
      default:
        appBarTitle = 'Top Anime';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
        backgroundColor: const Color.fromRGBO(255, 198, 222, 1),
      ),
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (i) => setState(() => currentIndex = i),
        selectedItemColor: const Color.fromRGBO(206, 1, 88, 1),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorites'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class HomeList extends StatefulWidget {
  const HomeList({Key? key}) : super(key: key);

  @override
  State<HomeList> createState() => _HomeListState();
}

class _HomeListState extends State<HomeList> {
  @override
  void initState() {
    super.initState();
    final ctrl = Provider.of<AnimeController>(context, listen: false);
    if (ctrl.animes.isEmpty) ctrl.fetch();
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = Provider.of<AnimeController>(context);
    final favCtrl = Provider.of<FavoriteController>(context);

    if (ctrl.loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (ctrl.error != null) {
      return Center(child: Text('Error: ${ctrl.error}'));
    }

    return RefreshIndicator(
      onRefresh: () => ctrl.fetch(),
      child: GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.53,
          crossAxisSpacing: 12,
          mainAxisSpacing: 8,
        ),
        itemCount: ctrl.animes.length,
        itemBuilder: (context, idx) {
          final anime = ctrl.animes[idx];
          final bool isFav = favCtrl.isFavorite(anime);

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
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
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
                    // Poster Anime
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
                          // Tombol favorit (hati)
                          Positioned(
                            right: 8,
                            top: 8,
                            child: InkWell(
                              onTap: () => favCtrl.toggleFavorite(anime),
                              child: CircleAvatar(
                                radius: 14,
                                backgroundColor: Colors.white.withOpacity(0.8),
                                child: Icon(
                                  isFav
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: isFav
                                      ? Colors.red
                                      : const Color.fromRGBO(206, 1, 88, 1),
                                  size: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Info Anime
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
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              anime.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
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
      ),
    );
  }
}
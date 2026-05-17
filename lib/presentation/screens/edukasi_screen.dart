import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../domain/entities/artikel.dart';
import '../widgets/article_card.dart';
import 'article_detail_screen.dart';

class EdukasiScreen extends StatefulWidget {
  const EdukasiScreen({super.key});

  @override
  State<EdukasiScreen> createState() => _EdukasiScreenState();
}

class _EdukasiScreenState extends State<EdukasiScreen> {
  String _selectedKategori = 'Semua';
  String _searchQuery = '';

  List<Artikel> _artikelList = [];
  bool isLoading = true;

  // 🔥 LIST KATEGORI
  final List<String> kategoriList = [
    'Semua',
    'Budidaya',
    'Hama & Penyakit',
    'Panen',
  ];

  // 🔥 FILTER ARTIKEL
  List<Artikel> get _filteredArtikel {
    List<Artikel> filtered = _artikelList;

    // FILTER KATEGORI
    if (_selectedKategori != 'Semua') {
      filtered = filtered
          .where((a) => a.kategori == _selectedKategori)
          .toList();
    }

    // FILTER SEARCH
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((a) {
        return a.judul
            .toLowerCase()
            .contains(_searchQuery.toLowerCase());
      }).toList();
    }

    return filtered;
  }

  @override
  void initState() {
    super.initState();
    fetchArtikel();
  }

  Future<void> fetchArtikel() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('articles')
          .orderBy('createdAt', descending: true)
          .get();

      final list = snapshot.docs
          .map((doc) => Artikel.fromFirestore(doc.data(), doc.id))
          .toList();

      setState(() {
        _artikelList = list;
        isLoading = false;
      });
    } catch (e) {
      debugPrint("Error fetch artikel: $e");

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📚 ${AppStrings.edukasiTitle}'),
      ),

      // 🔥 BODY
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : CustomScrollView(
              slivers: [
                // 🔥 HEADER
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 🔥 SEARCH BAR
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 10,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: TextField(
                            onChanged: (value) {
                              setState(() {
                                _searchQuery = value;
                              });
                            },
                            decoration: const InputDecoration(
                              hintText: 'Cari artikel edukasi...',
                              prefixIcon:
                                  Icon(Icons.search_rounded),
                              border: InputBorder.none,
                              contentPadding:
                                  EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // 🔥 KATEGORI
                        _buildKategoriSection(),

                        const SizedBox(height: 20),

                        // 🔥 TITLE
                        Text(
                          AppStrings.latestArticles,
                          style:
                              Theme.of(context).textTheme.titleMedium,
                        ),

                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                ),

                // 🔥 LIST ARTIKEL
                SliverPadding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16),
                  sliver: _filteredArtikel.isEmpty
                      ? SliverToBoxAdapter(
                          child: _EmptyState(
                            kategori: _selectedKategori,
                          ),
                        )
                      : SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final artikel =
                                  _filteredArtikel[index];

                              return Padding(
                                padding:
                                    const EdgeInsets.only(
                                  bottom: 14,
                                ),
                                child: ArticleCard(
                                  artikel: artikel,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            ArticleDetailScreen(
                                          artikel: artikel,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                            childCount:
                                _filteredArtikel.length,
                          ),
                        ),
                ),

                const SliverToBoxAdapter(
                  child: SizedBox(height: 24),
                ),
              ],
            ),
    );
  }

  // 🔥 KATEGORI SECTION
  Widget _buildKategoriSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.kategoriLabel,
          style: Theme.of(context).textTheme.titleMedium,
        ),

        const SizedBox(height: 10),

        SizedBox(
          height: 38,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: kategoriList.length,
            separatorBuilder: (_, __) =>
                const SizedBox(width: 8),
            itemBuilder: (_, index) {
              final kat = kategoriList[index];

              final isActive =
                  kat == _selectedKategori;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedKategori = kat;
                  });
                },
                child: AnimatedContainer(
                  duration:
                      const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 9,
                  ),
                  decoration: BoxDecoration(
                    color: isActive
                        ? AppColors.primary
                        : Colors.grey.shade200,
                    borderRadius:
                        BorderRadius.circular(20),
                  ),
                  child: Text(
                    kat,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isActive
                          ? Colors.white
                          : Colors.grey.shade700,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// 🔥 EMPTY STATE
class _EmptyState extends StatelessWidget {
  final String kategori;

  const _EmptyState({
    required this.kategori,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: Column(
        children: [
          const Text(
            '🌿',
            style: TextStyle(fontSize: 50),
          ),
          const SizedBox(height: 12),
          Text(
            'Belum ada artikel untuk kategori "$kategori"',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
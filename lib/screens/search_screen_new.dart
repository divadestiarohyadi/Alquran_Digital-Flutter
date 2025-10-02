import 'package:flutter/material.dart';
import '../models/hadith_models.dart';
import '../services/hadith_api_service.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<HadithNarrator> narrators = [];
  List<Hadith> hadiths = [];
  bool isLoadingNarrators = true;
  bool isLoadingHadiths = false;
  String? selectedNarrator;
  int currentPage = 1;
  bool hasMoreData = true;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadNarrators();
    _loadPopularHadiths();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (!isLoadingHadiths && hasMoreData) {
        _loadMoreHadiths();
      }
    }
  }

  Future<void> _loadNarrators() async {
    setState(() {
      isLoadingNarrators = true;
    });

    final loadedNarrators = await HadithApiService.getNarrators();

    // If API fails, use popular narrators
    if (loadedNarrators.isEmpty) {
      final popularNarrators = HadithApiService.getPopularNarrators();
      final narratorsList = popularNarrators
          .map((n) => HadithNarrator(
                slug: n['slug']!,
                name: n['name']!,
                description: n['description']!,
              ))
          .toList();

      setState(() {
        narrators = narratorsList;
        isLoadingNarrators = false;
      });
    } else {
      setState(() {
        narrators = loadedNarrators;
        isLoadingNarrators = false;
      });
    }
  }

  Future<void> _loadPopularHadiths() async {
    setState(() {
      isLoadingHadiths = true;
      hadiths.clear();
      currentPage = 1;
      hasMoreData = true;
    });

    final response = await HadithApiService.getAllHadiths(
      page: currentPage,
      limit: 20,
      query: searchQuery.isNotEmpty ? searchQuery : null,
    );

    if (response != null) {
      setState(() {
        hadiths = response.data;
        hasMoreData = response.pagination != null &&
            currentPage < response.pagination!.totalPages;
        isLoadingHadiths = false;
      });
    } else {
      setState(() {
        isLoadingHadiths = false;
      });
    }
  }

  Future<void> _loadHadithsByNarrator(String narratorSlug) async {
    setState(() {
      isLoadingHadiths = true;
      hadiths.clear();
      currentPage = 1;
      hasMoreData = true;
      selectedNarrator = narratorSlug;
    });

    final response = await HadithApiService.getHadithsByNarrator(
      narratorSlug,
      page: currentPage,
      limit: 20,
      query: searchQuery.isNotEmpty ? searchQuery : null,
    );

    if (response != null) {
      setState(() {
        hadiths = response.data;
        hasMoreData = response.pagination != null &&
            currentPage < response.pagination!.totalPages;
        isLoadingHadiths = false;
      });
    } else {
      setState(() {
        isLoadingHadiths = false;
      });
    }
  }

  Future<void> _loadMoreHadiths() async {
    if (isLoadingHadiths || !hasMoreData) return;

    setState(() {
      isLoadingHadiths = true;
    });

    currentPage++;

    HadithResponse? response;
    if (selectedNarrator != null) {
      response = await HadithApiService.getHadithsByNarrator(
        selectedNarrator!,
        page: currentPage,
        limit: 20,
        query: searchQuery.isNotEmpty ? searchQuery : null,
      );
    } else {
      response = await HadithApiService.getAllHadiths(
        page: currentPage,
        limit: 20,
        query: searchQuery.isNotEmpty ? searchQuery : null,
      );
    }

    if (response != null) {
      final hadithResponse = response;
      setState(() {
        hadiths.addAll(hadithResponse.data);
        if (hadithResponse.pagination != null) {
          hasMoreData = currentPage < hadithResponse.pagination!.totalPages;
        } else {
          hasMoreData = false;
        }
        isLoadingHadiths = false;
      });
    } else {
      setState(() {
        isLoadingHadiths = false;
      });
    }
  }

  void _performSearch() {
    searchQuery = _searchController.text.trim();
    if (selectedNarrator != null) {
      _loadHadithsByNarrator(selectedNarrator!);
    } else {
      _loadPopularHadiths();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Hadist Nabi ﷺ',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF2E7D32),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Color(0xFF2E7D32),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    onSubmitted: (_) => _performSearch(),
                    decoration: InputDecoration(
                      hintText: 'Cari hadist...',
                      prefixIcon:
                          const Icon(Icons.search, color: Color(0xFF2E7D32)),
                      suffixIcon: IconButton(
                        icon:
                            const Icon(Icons.search, color: Color(0xFF2E7D32)),
                        onPressed: _performSearch,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 15),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Narrator Filter
                if (!isLoadingNarrators && narrators.isNotEmpty)
                  SizedBox(
                    height: 40,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buildNarratorChip('Semua', null),
                        ...narrators.map((narrator) =>
                            _buildNarratorChip(narrator.name, narrator.slug)),
                      ],
                    ),
                  ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: isLoadingHadiths && hadiths.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(color: Color(0xFF2E7D32)),
                        SizedBox(height: 16),
                        Text('Memuat hadist...'),
                      ],
                    ),
                  )
                : hadiths.isEmpty
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.book, size: 64, color: Colors.grey),
                            SizedBox(height: 16),
                            Text(
                              'Tidak ada hadist ditemukan',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(16),
                        itemCount: hadiths.length + (isLoadingHadiths ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == hadiths.length) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.all(16),
                                child: CircularProgressIndicator(
                                    color: Color(0xFF2E7D32)),
                              ),
                            );
                          }
                          return _buildHadithCard(hadiths[index]);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildNarratorChip(String name, String? slug) {
    final isSelected = selectedNarrator == slug;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(
          name,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF2E7D32),
            fontWeight: FontWeight.w600,
          ),
        ),
        selected: isSelected,
        selectedColor: const Color(0xFF1B5E20),
        backgroundColor: Colors.white,
        onSelected: (selected) {
          if (slug == null) {
            setState(() {
              selectedNarrator = null;
            });
            _loadPopularHadiths();
          } else {
            _loadHadithsByNarrator(slug);
          }
        },
      ),
    );
  }

  Widget _buildHadithCard(Hadith hadith) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2E7D32),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    hadith.narrator,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  'No. ${hadith.number}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Arabic Text
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green[100]!),
              ),
              child: Text(
                hadith.arab,
                style: const TextStyle(
                  fontSize: 18,
                  height: 1.8,
                  fontFamily: 'Amiri',
                ),
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
              ),
            ),
            const SizedBox(height: 12),

            // Indonesian Translation
            Text(
              hadith.indonesian,
              style: const TextStyle(
                fontSize: 14,
                height: 1.6,
                color: Colors.black87,
              ),
              textAlign: TextAlign.justify,
            ),

            // Grade and Theme (if available)
            if (hadith.grade != null || hadith.theme != null) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  if (hadith.grade != null) ...[
                    Icon(Icons.verified, size: 16, color: Colors.green[600]),
                    const SizedBox(width: 4),
                    Text(
                      hadith.grade!,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.green[600],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                  if (hadith.grade != null && hadith.theme != null)
                    const SizedBox(width: 16),
                  if (hadith.theme != null) ...[
                    Icon(Icons.topic, size: 16, color: Colors.blue[600]),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        hadith.theme!,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue[600],
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

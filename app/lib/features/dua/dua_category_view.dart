import 'package:arrahma_shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_framework/flutter_framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inherited_state/inherited_state.dart';
import 'package:recase/recase.dart';

import 'dua_view.dart';

class DuaCategoryView extends StatefulWidget {
  const DuaCategoryView({Key? key, this.categories}) : super(key: key);
  final List<DuaCategory>? categories;

  @override
  State<DuaCategoryView> createState() => _DuaCategoryViewState();
}

class _DuaCategoryViewState extends State<DuaCategoryView> {
  final defaultCountInGrid = 9;

  String searchQuery = '';

  AppData? _appData;

  late int countInGrid;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    countInGrid = defaultCountInGrid;
    final appData = context.on<AppData>();
    _appData = appData;

    if (allCategories != null &&
        filteredCategories.every((c) => c.imageUrl == null)) countInGrid = 0;

    return Scaffold(
      appBar: AppBar(
        title: Text('Duas & Dhikr'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 0, horizontal: 16.0),
              ),
              onChanged: (query) {
                setState(() {
                  searchQuery = query;
                });
              },
            ),
          ),
          Expanded(
            child: CustomScrollView(
              slivers: [
                if (searchQuery.isNotEmpty &&
                    filteredCategories.isEmpty &&
                    filteredDuas.isEmpty)
                  SliverToBoxAdapter(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'No results found for "$searchQuery"',
                        style: TextStyle(
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                          color: theme.splashColor,
                        ),
                      ),
                    ),
                  ),
                if (countInGrid > 0)
                  SliverPadding(
                    padding: const EdgeInsets.all(8.0),
                    sliver: SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 8.0,
                        crossAxisSpacing: 8.0,
                        childAspectRatio: 1.0,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          if (allCategories == null)
                            return Center(
                                child: Text('No dua categories found'));
                          if (index >= filteredCategories.length) return null;
                          final category = filteredCategories[index];
                          return InkWell(
                            onTap: () {
                              onCategoryTap(category);
                            },
                            child: Card(
                              color: Colors.grey[500],
                              child: Center(
                                child: category.imageUrl != null
                                    ? Image(
                                        image: ImageUtils.fromNetworkWithCached(
                                          category.imageUrl!,
                                        ),
                                      )
                                    : Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.book,
                                            size: 40,
                                          ),
                                          const SizedBox(height: 8.0),
                                          FittedBox(
                                            child: Text(
                                              category.title,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                              ),
                            ),
                          );
                        },
                        childCount: allCategories != null
                            ? filteredCategories.length > countInGrid
                                ? countInGrid
                                : filteredCategories.length
                            : 0,
                      ),
                    ),
                  ),
                if (searchQuery.isNotEmpty && filteredCategories.isNotEmpty && filteredCategories.length > countInGrid)
                  SliverToBoxAdapter(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        "Categories",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: theme.primaryColor,
                        ),
                      ),
                    ),
                  ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      if (index >= filteredCategories.length - countInGrid)
                        return null;
                      final category = filteredCategories[index + countInGrid];
                      return _buildListTile(
                          category,
                          category.title.titleCase.isEmpty
                              ? category.duas.first.title ?? category.title
                              : category.title.titleCase,
                          category.titleUrdu.titleCase.isEmpty
                              ? category.duas.first.titleUrdu ?? category.titleUrdu
                              : category.titleUrdu.titleCase,
                          index + countInGrid + 1);
                    },
                    childCount: allCategories != null
                        ? filteredCategories.length > countInGrid
                            ? filteredCategories.length - countInGrid
                            : 0
                        : 0,
                  ),
                ),
                if (searchQuery.isNotEmpty && filteredDuas.isNotEmpty)
                  // Heading for the first list
                  SliverToBoxAdapter(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        "Duas",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: theme.primaryColor,
                        ),
                      ),
                    ),
                  ),
                if (searchQuery.isNotEmpty && filteredDuas.isNotEmpty)
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        if (index >= filteredDuas.length) return null;
                        final duaEntry = filteredDuas[index];
                        final catIndex = allCategories!.indexOf(duaEntry.key);
                        return _buildListTile(
                          duaEntry.key,
                          duaEntry.value.title?.titleCase ??
                              '${duaEntry.key.title.titleCase} - Dua ${index + 1}',
                          duaEntry.value.titleUrdu ?? duaEntry.key.titleUrdu,
                          catIndex + 1,
                          index,
                        );
                      },
                      childCount:
                          allCategories != null ? filteredDuas.length : 0,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListTile(
      DuaCategory category, String title, String titleUrdu, int leadingCount,
      [int index = 0]) {
    return ListTile(
      onTap: () {
        onCategoryTap(category, index);
      },
      title: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        titleUrdu,
        style: GoogleFonts.gulzar(
          height: 1.8,
          fontSize: 16,
        ),
      ),
      leading: Text(
        leadingCount.toString(),
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void onCategoryTap(DuaCategory category, [int index = 0]) {
    if (category.categories != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => DuaCategoryView(
            categories: category.categories,
          ),
        ),
      );
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DuaView(
          category: category,
          duaIndex: index,
        ),
      ),
    );
  }

  List<DuaCategory>? get allCategories {
    return widget.categories ?? _appData!.duaCategories;
  }

  bool startsWithWord(String text, String query) {
    final lowerText = text.toLowerCase();
    final lowerQuery = query.toLowerCase();
    final escapedQuery = RegExp.escape(lowerQuery);

    // (^|\s) means "start of string OR whitespace"
    final pattern = RegExp('(^|\\s)$escapedQuery');
    return pattern.hasMatch(lowerText);
  }

  List<String> getCategorySearchValues(DuaCategory category) {
    return [category.title, category.titleUrdu, category.notes]
        .where((c) => c != null)
        .map((c) => c!)
        .toList();
  }

  List<DuaCategory> get filteredCategories {
    if (searchQuery.isEmpty) {
      return allCategories!;
    }
    return allCategories!.where((category) {
      // Gather all text fields for this category
      final fields = <String?>[
        category.title,
        category.titleUrdu,
        category.notes,
        // Flatten the sub-category text fields, if any
        ...?category.categories
            ?.map(getCategorySearchValues)
            .expand((valueList) => valueList)
            .map((text) => text), // each "text" is a String
      ];

      // Check if ANY field has a whole-word match
      return fields
          .where((f) => f != null && f.isNotEmpty)
          .map((f) => f!) // non-null
          .any((fieldValue) => startsWithWord(fieldValue, searchQuery));
    }).toList();
  }

  List<MapEntry<DuaCategory, Dua>> get filteredDuas {
    if (searchQuery.isEmpty) {
      // Return all
      return allCategories!
          .expand((c) => c.duas.map((d) => MapEntry(c, d)))
          .toList();
    }

    return allCategories!
        .expand((c) => c.duas.map((d) => MapEntry(c, d)))
        .where((entry) {
      final fields = <String?>[
        entry.value.title,
        entry.value.titleUrdu,
        entry.value.dua,
        entry.value.duaEnglish,
        entry.value.duaUrdu,
        entry.value.notes,
      ];

      return fields
          .where((f) => f != null && f.isNotEmpty)
          .map((f) => f!)
          .any((fieldValue) => startsWithWord(fieldValue, searchQuery));
    }).toList();
  }
}

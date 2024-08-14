import 'package:arrahma_shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:inherited_state/inherited_state.dart';

class DuaView extends StatefulWidget {
  @override
  State<DuaView> createState() => _DuaViewState();
}

class _DuaViewState extends State<DuaView> {
  final countInGrid = 6;

  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final appData = context.on<AppData>();
    final duas = appData.drawerItems
        .firstWhere((item) => item.title == 'Reading material')
        .children!
        .firstWhere((item) => item.title == 'Dua')
        .content!
        .surahs;
    final filteredItems = duas
        .where((item) =>
            item.name != null &&
            item.name!.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();
    return Column(
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
              SliverPadding(
                padding: const EdgeInsets.all(8.0),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 8.0,
                    crossAxisSpacing: 8.0,
                    childAspectRatio: 1.0,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      if (index >= filteredItems.length) return null;
                      return InkWell(
                        onTap: () {
                          // Handle tap event
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content:
                                    Text('${filteredItems[index]} tapped!')),
                          );
                        },
                        child: Card(
                          color: Colors.grey[500],
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.book,
                                    size: 40,
                                  ),
                                  const SizedBox(height: 8.0),
                                  Text(
                                    filteredItems[index].name!,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    childCount: filteredItems.length > countInGrid
                        ? countInGrid
                        : filteredItems.length,
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if (index >= filteredItems.length - countInGrid)
                      return null;
                    return ListTile(
                      onTap: () {
                        // Handle tap event
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                                  '${filteredItems[index + countInGrid]} tapped!')),
                        );
                      },
                      title: Text(filteredItems[index + countInGrid].name!),
                      leading: Icon(Icons.book),
                    );
                  },
                  childCount: filteredItems.length > countInGrid
                      ? filteredItems.length - countInGrid
                      : 0,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

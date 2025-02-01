import 'package:arrahma_shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recase/recase.dart';
import 'package:share/share.dart';

class DuaView extends StatefulWidget {
  const DuaView({Key? key, required this.category, this.duaIndex = 0})
      : super(key: key);
  final DuaCategory category;
  final int duaIndex;

  @override
  State<DuaView> createState() => _DuaViewState();
}

class _DuaViewState extends State<DuaView> {
  late PageController _pageController;

  int selectedindex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.duaIndex);
    selectedindex = widget.duaIndex;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const SelectableText('Duas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              final dua = widget.category.duas[selectedindex];
              Share.share(_buildShareText(),
                  subject: dua.title ?? widget.category.title);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              if (widget.category.title.isNotEmpty) const SizedBox(height: 16),
              if (widget.category.title.isNotEmpty)
                SelectableText(
                  widget.category.title.titleCase,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: theme.primaryColor,
                  ),
                ),
              if (widget.category.title.isNotEmpty) const SizedBox(height: 8),
              if (widget.category.titleUrdu.isNotEmpty)
                SelectableText(
                  widget.category.titleUrdu,
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                  style: GoogleFonts.gulzar(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: theme.primaryColor,
                  ),
                ),
              if (widget.category.titleUrdu.isNotEmpty)
                const SizedBox(height: 16),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (int page) {
                    setState(() {
                      selectedindex = page;
                    });
                  },
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.category.duas.length,
                  itemBuilder: (context, index) {
                    final dua = widget.category.duas[index];
                    return DuaPage(
                      dua: dua,
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  runSpacing: 8.0,
                  children: _buildPageIndicator(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < widget.category.duas.length; i++) {
      list.add(i == selectedindex ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  Widget _indicator(bool isActive) {
    return Container(
      height: 10,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 150),
        margin: EdgeInsets.symmetric(horizontal: 4.0),
        height: isActive ? 10 : 8.0,
        width: isActive ? 12 : 8.0,
        decoration: BoxDecoration(
          boxShadow: [
            isActive
                ? BoxShadow(
                    color: Color(0XFF2FB7B2).withOpacity(0.72),
                    blurRadius: 4.0,
                    spreadRadius: 1.0,
                    offset: Offset(
                      0.0,
                      0.0,
                    ),
                  )
                : BoxShadow(
                    color: Colors.transparent,
                  )
          ],
          shape: BoxShape.circle,
          color: isActive ? Color(0XFF6BC4C9) : Color(0XFFEAEAEA),
        ),
      ),
    );
  }

  String _buildShareText() {
    final text = [
      widget.category.title,
      widget.category.titleUrdu,
      widget.category.duas[selectedindex].title,
      widget.category.duas[selectedindex].titleUrdu,
      widget.category.duas[selectedindex].notes,
      widget.category.duas[selectedindex].dua,
      widget.category.duas[selectedindex].duaEnglish,
      widget.category.duas[selectedindex].duaUrdu
    ].where((element) => element != null).join('\n\n');
    return '''
$text

Sent by: ArRahmah Duaa App ©️ 
ArRahmah Islamic Institute 2009  
[www.arrahma.org]
''';
  }
}

class DuaPage extends StatelessWidget {
  final Dua dua;

  const DuaPage({
    Key? key,
    required this.dua,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          if (dua.title != null)
            SelectableText(
              dua.title!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          if (dua.title != null) const SizedBox(height: 8),

          if (dua.titleUrdu != null)
            SelectableText(
              dua.titleUrdu!,
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
              style: GoogleFonts.gulzar(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          if (dua.titleUrdu != null) const SizedBox(height: 24),

          // Arabic text
          SelectableText(
            dua.dua,
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
            style: GoogleFonts.scheherazadeNew(
              fontSize: 22,
            ),
          ),
          const SizedBox(height: 16),

          if (dua.duaEnglish != null)
            SelectableText(
              dua.duaEnglish!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
              ),
            ),
          if (dua.duaEnglish != null) const SizedBox(height: 16),

          // Urdu translation
          if (dua.duaUrdu != null)
            SelectableText(
              dua.duaUrdu!,
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
              style: GoogleFonts.gulzar(
                fontSize: 16,
              ),
            ),
        ],
      ),
    );
  }
}

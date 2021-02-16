import 'package:arrahma_shared/shared.dart';
import 'package:xml/xml.dart';
import 'package:html2md/html2md.dart' as html2md;

import '../scraper_base.dart';
import '../utils.dart';

class MediaScraper extends ScraperBase<MediaContent> {
  const MediaScraper(IScraper scraper, this.url) : super(scraper);

  final String url;

  @override
  Future<MediaContent> scrape() async {
    final doc = await scraper.navigateTo(url);
    if (doc == null) return null;
    final hasImageViewer = doc.querySelector('#sv-container') != null;
    if (hasImageViewer) {
      final parsedUrl = Uri.parse(url);
      final galleryDataUrl = parsedUrl
          .replace(
              pathSegments: parsedUrl.pathSegments
                  .take(parsedUrl.pathSegments.length - 1)
                  .toList()
                    ..add('gallery.xml'))
          .toString();
      final xmlStr = await scraper.download(galleryDataUrl, 'application/xml');
      final doc = XmlDocument.parse(xmlStr);
      final images = doc.rootElement
          .findElements('image')
          .map((n) => n.attributes
              .singleWhere((a) => a.name.local == 'imageURL')
              .value
              .toAbsolute(url))
          .map((i) => Utils.getItemByUrl(i))
          .toList();
      return MediaContent(
          items: images.map((i) => MediaItem(item: i)).toList());
    } else if (doc.querySelector('#ramadancontainer') != null) {
      final items =
          doc.querySelectorAll('#table1 #ramadancontainer,#ramadansec2d');
      final mediaItems = items.map((i) {
        final title = i.text.cleanedText;
        final link = Utils.getItemByUrl(
            i.querySelector('a')?.attributes['href']?.toAbsolute(url));
        final img = i.querySelector('img');
        final imageUrl =
            img != null ? img.attributes['src']?.toAbsolute(url) : null;
        return MediaItem(
          title: title,
          item: link,
          imageUrl: imageUrl,
        );
      });
      return MediaContent(
        items: mediaItems.toList(),
      );
    } else if (doc.querySelector('#studentportion') != null) {
      final title =
          doc.querySelector('#studentportion #studentheading').text.cleanedText;
      final desEl = doc.querySelector(
          '#studentportion #testins, #studentportion #weeklyupdatetable');
      if (desEl != null) {
        desEl.querySelectorAll('#testselectbox').forEach((e) => e.remove());
      }
      final descriptionMd = html2md.convert(desEl?.innerHtml);
      final content = MediaContent(
        title: title,
        description: descriptionMd,
        items: [],
      );
      final items = doc.querySelectorAll('#studentportion #studentlink p');
      if (items?.isNotEmpty ?? false) {
        content.items.addAll(items.where((i) => i.children.isNotEmpty).map((i) {
          return MediaItem(
            title: i.text.cleanedText,
            item: Utils.getItemByUrl(
              i.querySelector('a').attributes['href']?.toAbsolute(url),
            ),
          );
        }));
      } else {
        final sections = doc.querySelectorAll('#studentportion #studentrbox');
        sections.forEach((s) {
          final title = s.querySelector('#studenttestprep1').text.cleanedText;
          content.items.add(MediaItem(
            title: title,
          ));
          final options = s
              .querySelectorAll('select option:not([selected])')
              .map((o) => MediaItem(
                    title: o.text.cleanedText,
                    item: Utils.getItemByUrl(
                        o.attributes['value'].toAbsolute(url)),
                  ));
          content.items.addAll(options);
        });
      }

      return content;
    } else if (doc.querySelector('#containerm') != null) {
      return MediaContent(
        title: doc.querySelector('#containerm #heading1')?.text?.cleanedText,
        description: html2md.convert(
            '<div>${doc.querySelectorAll('#containerm p, #containerm a').map((i) => i.outerHtml).join('\n')}</div>'),
      );
    } else if (doc.querySelector('#containerd') != null) {
      final formContainer = doc.querySelector('#containerd');
      final formIframe = formContainer.querySelector('iframe');
      final formSrc = formIframe.attributes['src'].toAbsolute(url);
      return MediaContent(
        title: formContainer.querySelector('h1').text.cleanedText,
        description: formContainer.querySelector('h4').text.cleanedText,
        items: [
          MediaItem(
            item: Item(
                isDirectSource: true, type: ItemType.WebForm, data: formSrc),
          )
        ],
      );
    }
    return null;
  }
}

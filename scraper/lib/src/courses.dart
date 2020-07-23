import 'package:arrahma_models/models.dart';
import 'package:recase/recase.dart';

import 'scraper_base.dart';
import 'utils.dart';

class CourseScraper implements ScraperBase<List<CourseItem>> {
  @override
  Future<List<CourseItem>> scrape(IScraper scraper) async {
    final doc = await scraper.navigateTo('');
    final courseList = doc.querySelectorAll('.column5 .box2');
    return courseList
        .map(
          (course) => CourseItem(
            title: course.querySelector('.box_h').text.cleanedText.titleCase,
            imageUrl: course
                .querySelector('img')
                .attributes['src']
                .toAbsolute(scraper.currentUrl),
            items: course
                .querySelectorAll('a')
                .where((e) => e.text?.trim()?.isNotEmpty ?? false)
                .map(
                  (i) => CourseSubItem(
                    name: i.text.cleanedText.titleCase,
                    link: i.attributes['href'].toAbsolute(scraper.currentUrl),
                  ),
                )
                .toList(),
          ),
        )
        .toList();
  }
}

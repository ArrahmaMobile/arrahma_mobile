import 'package:http/http.dart';
import 'package:scraper/scraper.dart';

Future main(List<String> arguments) async {
  print(await Scraper(Client()).initiate());
}

import 'package:arrahma_mobile_app/main_drawer.dart';
import 'package:arrahma_mobile_app/widgets/carousel_indicator.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //scafford -- presents a screen to the user
      drawer: MainDrawer(),
      appBar: AppBar(
        centerTitle: true,
        //AppBar -- Rending a navigation bae with title
        title: Image.asset(
            'assets/images/home_page_images/aarhman_mainImage.png',
            fit: BoxFit.cover),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            _buildBanner(),
            const SizedBox(height: 10),
            _broadcast(),
          ],
        ),
      ),
    );
  }

  Widget _buildBanner() {
    return CarouselIndicator(
      items: [
        GestureDetector(
            onTap: _latestFridayLecture,
            child: Image.asset(
                'assets/images/home_page_images/front_page_banner1.jpg')),
        GestureDetector(
            onTap: _launchTazkeer,
            child: Image.asset(
                'assets/images/home_page_images/front_page_banner2.jpg')),
        GestureDetector(
            onTap: _launchShawaal,
            child: Image.asset(
                'assets/images/home_page_images/front_page_banner3.jpg')),
      ],
    );
  }

  _latestFridayLecture() async {
    const url = 'http://arrahma.org/taf2019mp3/juz3/june26_20-imran33-44.mp3';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _launchTazkeer() async {
    const url = 'http://www.arrahma.org/tazkeer_n/tazkeer.php';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _launchShawaal() async {
    const url =
        'https://filedn.com/lYVXaQXjsnDpmndt09ArOXz/tarbiyyatimp3/fastsofshawal.mp3';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget _broadcast() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      childAspectRatio: 2.3,
      children: <Widget>[
        GestureDetector(
            onTap: _launchFacebook,
            child: Image.asset('assets/images/home_page_images/facebook.png')),
        GestureDetector(
            onTap: _launchMixlr,
            child:
                Image.asset('assets/images/home_page_images/mixlr_logo.png')),
        GestureDetector(
            onTap: _launchPhone,
            child: Image.asset(
                'assets/images/home_page_images/contact_information.png')),
        GestureDetector(
            onTap: _launchYoutube,
            child: Image.asset('assets/images/home_page_images/youtube.png')),
      ],
    );
  }

  _launchMixlr() async {
    const url = 'https://mixlr.com/arrahma-live/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _launchFacebook() async {
    const url = 'https://www.facebook.com/arrahmah.islamic.institute/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _launchYoutube() async {
    const url = 'https://www.youtube.com/c/arrahmahislamicinstitute';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _launchPhone() async {
    const url = 'tel:+1 712 432 1001#491760789';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

import 'package:arrahma_mobile_app/main_drawer.dart';
import 'package:arrahma_mobile_app/widgets/carousel_indicator.dart';
import 'package:carousel_slider/carousel_slider.dart';
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
        title: Image.asset('assets/images/AarhmanMainImage.png',
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
        Image.asset('assets/images/FrontPageBanner1.jpg'),
        Image.asset('assets/images/FrontPageBanner2.jpg'),
        Image.asset('assets/images/FrontPageBanner3.jpg'),
      ],
    );
  }

  Widget _broadcast() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      childAspectRatio: 2.3,
      children: <Widget>[
        GestureDetector(
            onTap: _launchFacebook,
            child: Image.asset('assets/images/Facebook.png')),
        GestureDetector(
            onTap: _launchMixlr,
            child: Image.asset('assets/images/MIXLRLogo.png')),
        GestureDetector(
            onTap: _launchPhone,
            child: Image.asset('assets/images/ContactInformation.png')),
        GestureDetector(
            onTap: _launchYoutube,
            child: Image.asset('assets/images/Youtube.png')),
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

// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../ads/banner_ad_widget.dart';
import '../audio/audio_controller.dart';
import '../audio/sounds.dart';
import '../in_app_purchase/in_app_purchase.dart';
import '../player_progress/player_progress.dart';
import '../style/palette.dart';
import '../style/responsive_screen.dart';
import 'custom_name_dialog.dart';
import 'settings.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  static const _gap = SizedBox(height: 60);

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsController>();
    final audioController = context.watch<AudioController>();
    final palette = context.watch<Palette>();

    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/darts/danny-noppert-story-5-overlay.jpg"),
              fit: BoxFit.cover
          )
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: ResponsiveScreen(
          squarishMainArea: ListView(
            children: [
              _gap,
              const Text(
                'Einstellungen',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Permanent Marker',
                  fontSize: 40,
                  height: 1,
                ),
              ),
              _gap,
              const _NameChangeLine(
                'Name',
              ),
              ValueListenableBuilder<bool>(
                valueListenable: settings.soundsOn,
                builder: (context, soundsOn, child) => _SettingsLine(
                  'Sound FX',
                  Icon(soundsOn ? Icons.graphic_eq : Icons.volume_off),
                  onSelected: () => settings.toggleSoundsOn(),
                ),
              ),
              ValueListenableBuilder<bool>(
                valueListenable: settings.musicOn,
                builder: (context, musicOn, child) => _SettingsLine(
                  'Musik',
                  Icon(musicOn ? Icons.music_note : Icons.music_off),
                  onSelected: () => settings.toggleMusicOn(),
                ),
              ),
              Consumer<InAppPurchaseController?>(
                  builder: (context, inAppPurchase, child) {
                    if (inAppPurchase == null) {
                      // In-app purchases are not supported yet.
                      // Go to lib/main.dart and uncomment the lines that create
                      // the InAppPurchaseController.
                      return const SizedBox.shrink();
                    }

                    Widget icon;
                    VoidCallback? callback;
                    if (inAppPurchase.adRemoval.active) {
                      icon = const Icon(Icons.check);
                    } else if (inAppPurchase.adRemoval.pending) {
                      icon = const CircularProgressIndicator();
                    } else {
                      icon = const Icon(Icons.ad_units);
                      callback = () {
                        inAppPurchase.buy();
                      };
                    }
                    return _SettingsLine(
                      'Ads entfernen',
                      icon,
                      onSelected: callback,
                    );
                  }),
              _SettingsLine(
                'Ergebnisse l??schen',
                const Icon(Icons.delete),
                onSelected: () {
                  context.read<PlayerProgress>().reset();

                  final messenger = ScaffoldMessenger.of(context);
                  messenger.showSnackBar(
                    const SnackBar(
                        content: Text('Dein Spielstand wurde zur??ckgesetzt.')),
                  );
                },
              ),
              _gap,
              BannerAdWidget(),
              _gap,
            ],
          ),
          rectangularMenuArea: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
            ),
            onPressed: () {
              audioController.playSfx(SfxType.buttonTap);
              GoRouter.of(context).pop();
            },
            child: const Text('Zur??ck',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Permanent Marker',
                fontSize: 25,
                height: 1,
              ),),
          ),
        ),
      ),
    );
  }
}

class _NameChangeLine extends StatelessWidget {
  final String title;

  const _NameChangeLine(this.title);

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsController>();

    return InkResponse(
      highlightShape: BoxShape.rectangle,
      onTap: () => showCustomNameDialog(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title,
                style: const TextStyle(
                  fontFamily: 'Permanent Marker',
                  fontSize: 25,
                  color: Colors.black
                )),
            const Spacer(),
            ValueListenableBuilder(
              valueListenable: settings.playerName,
              builder: (context, name, child) => Text(
                '???$name???',
                style: const TextStyle(
                  fontFamily: 'Permanent Marker',
                  fontSize: 25,
                  color: Colors.black
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsLine extends StatelessWidget {
  final String title;

  final Widget icon;

  final VoidCallback? onSelected;

  const _SettingsLine(this.title, this.icon, {this.onSelected});

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      highlightShape: BoxShape.rectangle,
      onTap: onSelected,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: 'Permanent Marker',
                  fontSize: 25,
                    color: Colors.black
                ),
              ),
            ),
            icon,
          ],
        ),
      ),
    );
  }
}

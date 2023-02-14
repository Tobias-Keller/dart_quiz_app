// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:game_template/src/main_menu/main_menu_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../ads/banner_ad_widget.dart';
import '../audio/audio_controller.dart';
import '../audio/sounds.dart';
import '../player_progress/player_progress.dart';
import '../style/palette.dart';
import '../style/responsive_screen.dart';
import 'levels.dart';

class LevelSelectionScreen extends StatelessWidget {
  const LevelSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();
    final playerProgress = context.watch<PlayerProgress>();

    return Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/darts/danny-noppert-story-1.jpg"),
                fit: BoxFit.cover
            )
        ),
        child: Scaffold(
          backgroundColor: Colors.white60,
          body: ResponsiveScreen(
            squarishMainArea: Column(
              children: [
                Transform.rotate(
                  angle: -0.1,
                  child: const Text(
                    'Wie schwer\ndarf es sein?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'Permanent Marker',
                        fontSize: 45,
                        height: 1,
                        color: Colors.black
                    ),
                  ),
                ),
                const SizedBox(height: 0),
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      for (final level in gameLevels)
                        ListTile(
                         /* enabled: playerProgress.highestLevelReached >=
                              level.number - 1,*/
                          onTap: () {
                            final audioController = context.read<AudioController>();
                            audioController.playSfx(SfxType.buttonTap);

                            GoRouter.of(context)
                                .go('/play/session/${level.number}');
                          },
                          title: Ink(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white70
                            ),
                            padding: const EdgeInsets.all(20),
                            child: Center(
                              child: Text('${level.name}',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Permanent Marker',
                                  fontSize: 25,
                                  height: 1,
                                ),),
                            ),
                          )
                        ),
                      const SizedBox(height: 20,),
                      BannerAdWidget(),
                    ],
                  ),
                ),
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
                final audioController = context.read<AudioController>();
                audioController.playSfx(SfxType.buttonTap);
                GoRouter.of(context).go('/');
              },
              child: const Text('Zurück',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Permanent Marker',
                  fontSize: 25,
                  height: 1,
                ),),
            ),
          ),
        )
    );
  }
}

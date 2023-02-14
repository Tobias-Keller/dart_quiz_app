// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../audio/audio_controller.dart';
import '../audio/sounds.dart';
import '../games_services/games_services.dart';
import '../settings/settings.dart';
import '../style/palette.dart';
import '../style/responsive_screen.dart';
import 'package:glitcheffect/glitcheffect.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();
    final gamesServicesController = context.watch<GamesServicesController?>();
    final settingsController = context.watch<SettingsController>();
    final audioController = context.watch<AudioController>();

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/darts/danny-noppert-story-6.jpg"),
              fit: BoxFit.cover
        )
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: ResponsiveScreen(
          mainAreaProminence: 0.45,
          squarishMainArea: Center(
            child: Column(
              children: <Widget>[
                _gap,
                _gap,
                Transform.rotate(
                  angle: -0.1,
                  child: const Text(
                    'DART QUIZ',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'Permanent Marker',
                        fontSize: 55,
                        height: 1,
                        color: Colors.black
                    ),
                  )
                ),
                _gap,
                Transform.rotate(
                  angle: -0.1,
                  child: const Text(
                    'Teste dein Wissen rund um das Thema Dart',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'Permanent Marker',
                        fontSize: 20,
                        height: 1,
                        color: Colors.black
                    ),
                  ),
                )
              ],
            )
          ),
          rectangularMenuArea: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 32),
                child: ValueListenableBuilder<bool>(
                  valueListenable: settingsController.muted,
                  builder: (context, muted, child) {
                    return TextButton.icon(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.black
                      ),
                      onPressed: () {settingsController.toggleMuted();},
                      icon: Icon(muted ? Icons.volume_off : Icons.volume_up),
                      label: Text(muted ? 'Ton einschalten' : 'Ton ausschalten',
                      style: TextStyle(
                        color: Colors.black
                      ),)
                    );
                  },
                ),
              ),
              _gap,
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                ),
                onPressed: () {
                  audioController.playSfx(SfxType.buttonTap);
                  GoRouter.of(context).go('/play');
                },
                child: const Text('Quiz starten',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Permanent Marker',
                    fontSize: 25,
                    height: 1,
                  ),),
              ),
              _gap,
              if (gamesServicesController != null) ...[
                /*_hideUntilReady(
                  ready: gamesServicesController.signedIn,
                  child: ElevatedButton(
                    onPressed: () => gamesServicesController.showAchievements(),
                    child: const Text('Achievements'),
                  ),
                ),
                _gap,*/
                _hideUntilReady(
                  ready: gamesServicesController.signedIn,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                    ),
                    onPressed: () => gamesServicesController.showLeaderboard(),
                    child: const Text('Die Rangliste',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Permanent Marker',
                        fontSize: 25,
                        height: 1,
                      ),),
                  ),
                ),
              ],
              _gap,
              ElevatedButton(
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
                  GoRouter.of(context).push('/settings');
                },
                child: const Text('Deine Einstellungen',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Permanent Marker',
                    fontSize: 25,
                    height: 1,
                  ),),
              ),
              _gap,
            ],
          ),
        ),
      )
    );
  }

  /// Prevents the game from showing game-services-related menu items
  /// until we're sure the player is signed in.
  ///
  /// This normally happens immediately after game start, so players will not
  /// see any flash. The exception is folks who decline to use Game Center
  /// or Google Play Game Services, or who haven't yet set it up.
  Widget _hideUntilReady({required Widget child, required Future<bool> ready}) {
    return FutureBuilder<bool>(
      future: ready,
      builder: (context, snapshot) {
        // Use Visibility here so that we have the space for the buttons
        // ready.
        return Visibility(
          visible: snapshot.data ?? false,
          maintainState: true,
          maintainSize: true,
          maintainAnimation: true,
          child: child,
        );
      },
    );
  }

  static const _gap = SizedBox(height: 10);
}

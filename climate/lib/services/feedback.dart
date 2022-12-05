import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';

class SoundService {
  // private constructor
  SoundService._();
  final AudioCache _player = AudioCache(
    prefix: 'assets/audio/',
  );
  Future<void> loadSounds() async {
    await _player.load(
      'hitmarker_2.mp3',
    );
  }

  Future<void> playTapDownSound() async {
    HapticFeedback.lightImpact();
    await _player.play(
      'hitmarker_2.mp3',
      mode: PlayerMode.LOW_LATENCY,
    );
  }

  /// Cached instance of [SoundService]
  static SoundService _instance;

  /// return an instance of [SoundService]
  static SoundService get instance {
    // set the instance if it's null
    _instance ??= SoundService._();
    // return the instance
    return _instance;
  }
}

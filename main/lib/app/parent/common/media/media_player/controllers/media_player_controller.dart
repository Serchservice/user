import 'package:user/library.dart';
import 'package:just_audio/just_audio.dart';
import 'package:get/get.dart';

class MediaPlayerController extends GetxController {
  final String audio;
  MediaPlayerController({required this.audio});
  final state = MediaPlayerState();

  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void onInit() {
    state.audio.value = audio;
    _loadAudio();

    super.onInit();
  }

  @override
  void onReady() {
    _audioPlayer.positionStream.listen((position) {
      state.currentPosition.value = position.inSeconds.toDouble();
    });

    _audioPlayer.playerStateStream.listen((value) {
      if(value.processingState == ProcessingState.completed) {
        state.isPlaying.value = false;
      } else if(value.processingState == ProcessingState.ready && value.playing) {
        state.isPlaying.value = true;
      }
    });

    super.onReady();
  }

  void _loadAudio() async {
    if(audio.isNotEmpty) {
      await _audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(audio)));
      state.totalDuration.value = _audioPlayer.duration?.inSeconds.toDouble() ?? 0;
    }
  }

  Future<void> playAudio() async {
    if(audio.isNotEmpty) {
      if(state.currentPosition.value == state.totalDuration.value) {
        seek(0.0);
      }
      _audioPlayer.play();
      state.isPlaying.value = true;
    } else {
      notify.error(message: "Unable to play audio. Audio file not found");
    }
  }

  String playingTime() {
    int totalSeconds = state.currentPosition.value.toInt();
    String minutes = CommonUtility.formatAudioTimer(totalSeconds ~/ 60);
    String seconds = CommonUtility.formatAudioTimer(totalSeconds % 60);
    return "$minutes : $seconds";
  }

  Future<void> pauseAudio() async {
    await _audioPlayer.pause();
    state.isPlaying.value = false;
  }

  void seek(double value) async {
    state.currentPosition.value = value;
    _audioPlayer.seek(Duration(seconds: value.toInt()));
    if(!state.isPlaying.value) {
      _audioPlayer.pause();
    }
  }

  @override
  void onClose() {
    _audioPlayer.dispose();

    super.onClose();
  }
}
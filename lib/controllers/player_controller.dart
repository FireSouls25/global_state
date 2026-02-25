import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import '../models/song.dart';

class PlayerController extends GetxController {
  final AudioPlayer _audioPlayer = AudioPlayer();

  final Rx<Song?> currentSong = Rx<Song?>(null);
  final RxBool isPlaying = false.obs;
  final RxList<Song> playlist = <Song>[].obs;
  final RxInt currentIndex = 0.obs;
  final Rx<Duration> position = Duration.zero.obs;
  final Rx<Duration> duration = Duration.zero.obs;
  final RxString errorMessage = ''.obs;

  final List<Song> _demoSongs = [
    Song(
      id: '1',
      title: 'Bohemian Rhapsody',
      artist: 'Queen',
      album: 'A Night at the Opera',
      imageUrl: 'https://picsum.photos/seed/1/300/300',
      audioUrl: 'https://www.kozco.com/tech/LRMonoPhase4.wav',
      duration: const Duration(minutes: 5, seconds: 55),
    ),
    Song(
      id: '2',
      title: 'Stairway to Heaven',
      artist: 'Led Zeppelin',
      album: 'Led Zeppelin IV',
      imageUrl: 'https://picsum.photos/seed/2/300/300',
      audioUrl: 'https://www.kozco.com/tech/LRMonoPhase4.wav',
      duration: const Duration(minutes: 8, seconds: 2),
    ),
    Song(
      id: '3',
      title: 'Hotel California',
      artist: 'Eagles',
      album: 'Hotel California',
      imageUrl: 'https://picsum.photos/seed/3/300/300',
      audioUrl: 'https://www.kozco.com/tech/LRMonoPhase4.wav',
      duration: const Duration(minutes: 6, seconds: 30),
    ),
    Song(
      id: '4',
      title: 'Sweet Child O Mine',
      artist: 'Guns N Roses',
      album: 'Appetite for Destruction',
      imageUrl: 'https://picsum.photos/seed/4/300/300',
      audioUrl: 'https://www.kozco.com/tech/LRMonoPhase4.wav',
      duration: const Duration(minutes: 5, seconds: 56),
    ),
    Song(
      id: '5',
      title: 'Smells Like Teen Spirit',
      artist: 'Nirvana',
      album: 'Nevermind',
      imageUrl: 'https://picsum.photos/seed/5/300/300',
      audioUrl: 'https://www.kozco.com/tech/LRMonoPhase4.wav',
      duration: const Duration(minutes: 5, seconds: 1),
    ),
  ];

  @override
  void onInit() {
    super.onInit();
    playlist.assignAll(_demoSongs);

    _audioPlayer.positionStream.listen((pos) {
      position.value = pos;
    });

    _audioPlayer.durationStream.listen((dur) {
      if (dur != null) {
        duration.value = dur;
      }
    });

    _audioPlayer.playerStateStream.listen((state) {
      isPlaying.value = state.playing;
      if (state.processingState == ProcessingState.completed) {
        next();
      }
    });
  }

  @override
  void onClose() {
    _audioPlayer.dispose();
    super.onClose();
  }

  Future<void> playSong(Song song, {List<Song>? songs}) async {
    if (songs != null) {
      playlist.assignAll(songs);
      currentIndex.value = songs.indexWhere((s) => s.id == song.id);
    }
    currentSong.value = song;

    try {
      await _audioPlayer.setUrl(song.audioUrl);
      await _audioPlayer.play();
      errorMessage.value = '';
    } catch (e) {
      errorMessage.value = 'Error: $e';
      print('Error al reproducir: $e');
    }
  }

  void togglePlayPause() {
    if (isPlaying.value) {
      _audioPlayer.pause();
    } else {
      _audioPlayer.play();
    }
  }

  void play() {
    _audioPlayer.play();
  }

  void pause() {
    _audioPlayer.pause();
  }

  Future<void> next() async {
    if (playlist.isEmpty) return;
    currentIndex.value = (currentIndex.value + 1) % playlist.length;
    final song = playlist[currentIndex.value];
    currentSong.value = song;

    try {
      await _audioPlayer.setUrl(song.audioUrl);
      await _audioPlayer.play();
    } catch (e) {
      print('Error al reproducir siguiente: $e');
    }
  }

  Future<void> previous() async {
    if (playlist.isEmpty) return;
    currentIndex.value =
        (currentIndex.value - 1 + playlist.length) % playlist.length;
    final song = playlist[currentIndex.value];
    currentSong.value = song;

    try {
      await _audioPlayer.setUrl(song.audioUrl);
      await _audioPlayer.play();
    } catch (e) {
      print('Error al reproducir anterior: $e');
    }
  }

  void seekTo(Duration pos) {
    _audioPlayer.seek(pos);
  }

  void removeSong(Song song) {
    final index = playlist.indexWhere((s) => s.id == song.id);
    if (index != -1) {
      playlist.removeAt(index);
      if (currentSong.value?.id == song.id) {
        if (playlist.isNotEmpty) {
          final newIndex = index < playlist.length
              ? index
              : playlist.length - 1;
          currentIndex.value = newIndex;
          playSong(playlist[newIndex]);
        } else {
          currentSong.value = null;
          _audioPlayer.stop();
        }
      }
    }
  }

  bool get hasSong => currentSong.value != null;
}

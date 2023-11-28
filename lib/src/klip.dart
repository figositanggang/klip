import 'package:flutter/material.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:video_player/video_player.dart';

class Klip extends StatefulWidget {
  // ! Page Controller for 'PreloadPage'
  final PreloadPageController pageController;

  // ! List of Video Urls
  final List<String> videoUrls;

  const Klip({
    super.key,
    required this.pageController,
    required this.videoUrls,
  });

  @override
  State<Klip> createState() => _KlipState();
}

class _KlipState extends State<Klip> {
  late Future<List<VideoPlayerController>> _initializeVideoPlayers;

  @override
  void initState() {
    super.initState();

    _initializeVideoPlayers = initialize();
  }

  // ! initializing video players
  Future<List<VideoPlayerController>> initialize() async {
    List<VideoPlayerController> videoPlayerControllers = [];

    for (var videoUrl in widget.videoUrls) {
      videoPlayerControllers
          .add(VideoPlayerController.networkUrl(Uri.parse(videoUrl)));
    }

    return videoPlayerControllers;
  }

  // ! play or pause the video
  void playOrPause({
    required List<VideoPlayerController> videoPlayerControllers,
    required int index,
  }) async {
    // ! play current index
    if (!videoPlayerControllers[index].value.isPlaying) {
      try {
        await videoPlayerControllers[index].play();
      } catch (e) {
        //
      }
    }

    // ! pause other index
    else if (videoPlayerControllers[index + 1].value.isPlaying) {
      try {
        await videoPlayerControllers[index + 1].pause();
        await videoPlayerControllers[index + 1].seekTo(Duration.zero);
      } catch (e) {
        //
      }
    } else if (videoPlayerControllers[index - 1].value.isPlaying) {
      try {
        await videoPlayerControllers[index - 1].pause();
        await videoPlayerControllers[index - 1].seekTo(Duration.zero);
      } catch (e) {
        //
      }
    }
  }

  // ! refresh video players
  refresh() {
    _initializeVideoPlayers = initialize();

    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeVideoPlayers,
      builder: (context, snapshot) {
        // ? WAITING
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Material(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // ? NO KLIPS
        if (!snapshot.hasData) {
          return const Material(
            child: Center(
              child: Text(
                "Klip masih kosong",
                style: TextStyle(fontSize: 20),
              ),
            ),
          );
        }

        // ? RETURN KLIPS
        final docs = snapshot.data!;
        return Scaffold(
          backgroundColor: Colors.black,
          body: RefreshIndicator(
            onRefresh: () async {
              refresh();
            },
            child: NestedScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  // @ App Bar
                  const SliverAppBar(
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    scrolledUnderElevation: 0,
                    title: Text(
                      "Klips",
                      style: TextStyle(color: Colors.white),
                    ),
                    floating: true,
                    snap: true,
                  ),
                ];
              },
              body: RefreshIndicator(
                onRefresh: () async {},
                child: NotificationListener<ScrollEndNotification>(
                  onNotification: (notification) {
                    var page = widget.pageController.page!.round();

                    playOrPause(
                      index: page,
                      videoPlayerControllers: docs,
                    );

                    return false;
                  },
                  child: PreloadPageView.builder(
                    controller: widget.pageController,
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemCount: docs.length,
                    preloadPagesCount: 5,
                    itemBuilder: (context, index) {
                      return _VideoPlayer(videoPlayerController: docs[index]);
                    },
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _VideoPlayer extends StatefulWidget {
  final VideoPlayerController videoPlayerController;
  const _VideoPlayer({required this.videoPlayerController});

  @override
  State<_VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<_VideoPlayer> {
  late Future initialize;

  @override
  void initState() {
    super.initState();

    initialize = widget.videoPlayerController.initialize()
      ..then((value) {
        widget.videoPlayerController.setLooping(true);
      });
  }

  @override
  void dispose() {
    try {
      widget.videoPlayerController.pause();
    } catch (e) {
      //
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: initialize,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Text("Loading"),
          );
        }
        return Stack(
          children: [
            Center(
              child: AspectRatio(
                aspectRatio: widget.videoPlayerController.value.aspectRatio,
                child: VideoPlayer(widget.videoPlayerController),
              ),
            ),
            GestureDetector(
              onTap: () {
                if (widget.videoPlayerController.value.isPlaying) {
                  widget.videoPlayerController.pause();
                } else {
                  widget.videoPlayerController.play();
                }
              },
            ),
          ],
        );
      },
    );
  }
}

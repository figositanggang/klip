## Before using:
```cmd
flutter pub add preload_page_view
```

## Example:
```dart
class VideoScrenn extends StatefulWidget {
  const VideoScrenn({super.key});

  @override
  State<VideoScrenn> createState() => VideoScrennState();
}

class VideoScrennState extends State<VideoScrenn> {
  late List<String> videoUrls = [
    "https://drive.google.com/uc?export=download&id=1sZ5MfBw9WyKuOpYxuJuboh_vNXQgfQVe",
    "https://drive.google.com/uc?export=download&id=1-9htcCAC-aKUYEL-uBvMpT7TMD1ktMXp",
    "https://drive.google.com/uc?export=download&id=1VWH8k-Mmy5M0HBwfFWQAj8gJ5-OSKijF",
  ];

  @override
  Widget build(BuildContext context) {
    return Klip(
      pageController: PreloadPageController(),
      videoUrls: videoUrls,
    );
  }
}
```


## Reports:
If there is bugs or any errors, you can email me on hamonangansitanggang29@gmail.com

# Happy Coding 😘😘
![MuaKissGIF (2)](https://github.com/figositanggang/klip/assets/82425222/41cbfee5-9406-4078-b07b-10d0ba7aa339)

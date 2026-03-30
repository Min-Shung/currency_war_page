import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:currency_wars/custom_drawer.dart';
import 'expansion_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Video Background',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

// === 首頁實作 ===
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    // 初始化影片控制器
    _controller = VideoPlayerController.asset('assets/videos/IMG_9460.MP4')
      ..initialize().then((_) {
        _controller.setLooping(true); // 設定循環播放
        _controller.setVolume(0.0);   // 若不需要影片聲音，可設為靜音
        _controller.play();           // 自動播放
        setState(() {});              // 更新畫面以顯示第一幀
      });
  }

  @override
  void dispose() {
    _controller.dispose(); // 釋放控制器資源
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(currentPage: '首頁'),// 綁定側邊欄元件
      // 確保 Scaffold.of(context) 能正確取得 Scaffold 狀態以開啟側邊欄
      body: Builder(
        builder: (BuildContext innerContext) {
          return _controller.value.isInitialized
              //GestureDetector 來偵測滑動
              ? GestureDetector(
                  // 確保整個螢幕範圍都能接收到滑動手勢
                  behavior: HitTestBehavior.opaque,
                  
                  // 偵測垂直滑動結束的瞬間
                  onVerticalDragEnd: (details) {
                    // 這裡設定為：如果往上滑的速度超過 100，就切換頁面
                    if (details.primaryVelocity != null && details.primaryVelocity! < -100) {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) => const ExpansionPage(),
                          transitionsBuilder: (context, animation, secondaryAnimation, child) {
                            const begin = Offset(0.0, 1.0); // 從底部開始
                            const end = Offset.zero;
                            const curve = Curves.ease;

                            final tween = Tween(begin: begin, end: end).chain(
                              CurveTween(curve: curve),
                            );

                            final offsetAnimation = animation.drive(tween);

                            return SlideTransition(
                              position: offsetAnimation,
                              child: child,
                            );
                          },
                        ),
                      );
                    }
                  },
                  
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // --- 底層：影片背景 ---
                      FittedBox(
                        fit: BoxFit.cover, // 確保影片覆蓋整個螢幕
                        child: SizedBox(
                          width: _controller.value.size.width,
                          height: _controller.value.size.height,
                          child: VideoPlayer(_controller),
                        ),
                      ),
                      
                      // --- 上層：透明按鈕 ---
                      Positioned(
                        top: 60.0,  
                        left: 5.0, 
                        width: 50.0, 
                        height: 30.0, 
                        child: GestureDetector(
                          // 確保按鈕本身也能精準接收點擊
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            Scaffold.of(innerContext).openDrawer();
                          },
                          child: Container(
                            color: Colors.transparent, 
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : const Center(child: CircularProgressIndicator()); 
        },
      ),
    );
  }
}
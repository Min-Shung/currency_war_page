import 'package:flutter/material.dart';
import 'package:currency_wars/custom_drawer.dart';

class MoreContentPage extends StatefulWidget {
  const MoreContentPage({super.key});

  @override
  State<MoreContentPage> createState() => _MoreContentPageState();
}

class _MoreContentPageState extends State<MoreContentPage> {
  // === 這裡的分類與內容，您可以替換成「更多內容」的實際文字 ===
  final List<String> _categories = ['新增投資策略', '新增投資環境', '新增競爭對手', '攻略更新', '編輯攻略'];
  final List<String> _contents = [
    '【分解萬物】、【輪迴不止】、【瓊玉專家：青雀】等大量新投資策略，現已加入貨幣戰爭。',
    '【英雄登場】、【命運禮物】、【特邀專家：停雲】等新投資環境，現已加入貨幣戰爭。',
    '新競爭對手陣營【智識實驗室】、【金血記憶聯盟】、【火花網路傳媒】、【蟲人兵器】現已加入貨幣戰爭。',
    '【攻略大全】已編列4.0版本擴充後的全新角色、羈絆內容。改良了【最近熱門】排序，新增了攻略版本號提醒功能與過期提示功能。',
    '4.0版本更新後，攻略工具將新增【編輯攻略】功能。開拓者可以編輯因版本更新受影響的攻略，使其符合當下版本最新環境。',
  ];
  final ScrollController _scrollController = ScrollController();
  int _currentIndex = 0;

  void _goToPrevious() {
    setState(() {
      if (_currentIndex == 0) {
        _currentIndex = _categories.length - 1; 
      } else {
        _currentIndex--;
      }
    });
    _scrollToIndex(_currentIndex); 
  }

  void _goToNext() {
    setState(() {
      if (_currentIndex == _categories.length - 1) {
        _currentIndex = 0; 
      } else {
        _currentIndex++;
      }
    });
    _scrollToIndex(_currentIndex); 
  }

  void _setIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
    _scrollToIndex(index); 
  }

  void _scrollToIndex(int index) {
    if (!_scrollController.hasClients) return; 

    double targetScrollOffset = 0;

    if (index == 0) {
      targetScrollOffset = 0.0;
    } else if (index == _categories.length - 1) {
      targetScrollOffset = _scrollController.position.maxScrollExtent;
    } else {
      double screenWidth = MediaQuery.of(context).size.width;
      double itemWidth = 150 + 16;
      targetScrollOffset = (itemWidth * index) - (screenWidth - itemWidth) / 2;

      double maxScroll = _scrollController.position.maxScrollExtent;
      if (targetScrollOffset > maxScroll) targetScrollOffset = maxScroll;
      if (targetScrollOffset < 0) targetScrollOffset = 0;
    }

    _scrollController.animateTo(
      targetScrollOffset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, 
      // === 修改點：currentPage 改為 '更多內容' ===
      drawer: const CustomDrawer(currentPage: '更多內容'),
      body: Builder(
        builder: (BuildContext innerContext) {
          return Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                // === 這裡請換成「更多內容」頁面的背景圖檔名 ===
                image: AssetImage('assets/images/IMG_9534.JPG'), 
                fit: BoxFit.contain, 
              ),
            ),
            child: SafeArea(
              child: Stack(
                children: [
                  Positioned(
                    top: 10,  
                    left: 3, 
                    width: 50, 
                    height: 30, 
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque, 
                      onTap: () {
                        Scaffold.of(innerContext).openDrawer(); 
                      },
                      child: Container(
                        color:Colors.transparent, 
                      ),
                    ),
                  ),
                  
                  Positioned(
                    top: 123,     
                    left: 68,  
                    width: 120,  
                    height: 33,  
                    child: Container(
                      color: const Color(0x01000000), 
                      alignment: Alignment.centerLeft,
                      child: Text(
                        _categories[_currentIndex],
                        style: const TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ),
                  ),

                  Positioned(
                    top: 171,
                    left: 23,
                    right: 23,
                    height: 190,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 420,
                          child: ClipPath(
                            clipper: CutCornerClipper(cutSize: 10),
                            child: IndexedStack(
                              index: _currentIndex,
                              children: List.generate(_categories.length, (index) {
                                return Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage('assets/images/more$index.JPG'),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),
                        ),
                      Positioned(
                        left: 6,
                        child: GestureDetector(
                          onTap: _goToPrevious,
                          child: Container(
                            width: 20,  
                            height: 60,
                            alignment: Alignment.center, 
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 16, 19, 45), 
                              border: Border.all(
                                color: const Color.fromARGB(255, 87, 101, 212), 
                                width: 1, 
                              ),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.arrow_back_ios,
                                size: 16,
                                color: Color.fromARGB(255, 87, 101, 212), 
                              ),
                            ),
                          ),
                        ),
                      ),

                      Positioned(
                        right: 6,
                        child: GestureDetector(
                          onTap: _goToNext,
                          child: Container(
                            width: 20,
                            height: 60,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 16, 19, 45), 
                              border: Border.all(
                                color: const Color.fromARGB(255, 87, 101, 212),
                                width: 1,
                              ),
                            ),
                            child: const Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: Color.fromARGB(255, 87, 101, 212), 
                            ),
                          ),
                        ),
                      ),
                      ],
                    ),
                  ),
                  
                  Positioned(
                    top: 380,    
                    left: 23,
                    right: 23,
                    height: 146,  
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      color: Colors.transparent,
                      child: SingleChildScrollView(
                        child: Text(
                          _contents[_currentIndex],
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),

                  Positioned(
                    bottom: 120,
                    left: 0,
                    right: 0,
                    height: 60,
                    child: SingleChildScrollView(
                      controller: _scrollController, 
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(_categories.length, (index) {
                          final isSelected = _currentIndex == index;

                          return GestureDetector(
                            onTap: () {
                              _setIndex(index); 
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: ClipPath(
                                clipper: DiagonalCutClipper(cutSize: 10),
                                child: Container(
                                  padding: isSelected ? const EdgeInsets.all(2) : EdgeInsets.zero,
                                  color: isSelected ? Colors.white : Colors.transparent,
                                  child: ClipPath(
                                    clipper: DiagonalCutClipper(cutSize: 10),
                                    child: Container(
                                      width: 150,
                                      height: 32,
                                      decoration: const BoxDecoration(
                                        image: DecorationImage(
                                          // === 滑動按鈕的背景圖維持原樣 ===
                                          image: AssetImage('assets/images/IMG_9528.JPG'),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          _categories[index],
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: isSelected
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                            shadows: const [
                                              Shadow(
                                                color: Colors.black,
                                                blurRadius: 4,
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      ),
    );
  }
}

// === 下方保留您自訂的 Clipper ===
class CutCornerClipper extends CustomClipper<Path> {
  final double cutSize;

  CutCornerClipper({this.cutSize = 10});

  @override
  Path getClip(Size size) {
    return Path()
      ..moveTo(cutSize, 0)
      ..lineTo(size.width - cutSize, 0)
      ..lineTo(size.width, cutSize)
      ..lineTo(size.width, size.height - cutSize)
      ..lineTo(size.width - cutSize, size.height)
      ..lineTo(cutSize, size.height)
      ..lineTo(0, size.height - cutSize)
      ..lineTo(0, cutSize)
      ..close();
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

class DiagonalCutClipper extends CustomClipper<Path> {
  final double cutSize;

  DiagonalCutClipper({this.cutSize = 10});

  @override
  Path getClip(Size size) {
    return Path()
      ..moveTo(cutSize, 0)                     
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height - cutSize) 
      ..lineTo(size.width - cutSize, size.height)
      ..lineTo(0, size.height)
      ..lineTo(0, cutSize)
      ..close();
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
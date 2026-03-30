import 'package:flutter/material.dart';
import 'package:currency_wars/custom_drawer.dart';
import 'main.dart'; 
import 'bond_update.dart'; 

class ExpansionPage extends StatefulWidget {
  const ExpansionPage({super.key});

  @override
  State<ExpansionPage> createState() => _ExpansionPageState();
}

class _ExpansionPageState extends State<ExpansionPage> {
  // 定義所有的標題內容
  final List<String> _categories = ['新員工', '專家顧問', '獎勵擴充', '職級擴充', '內容調整'];
  final List<String> _contents = [
  '大理花、爻光、火花三位角色將作為新員工在4.0版本更新後立即加入貨幣戰爭。',
  '新增【專家顧問】機制。\n 4.0版本更新後，加拉赫、停雲、青雀將成為【專家顧問】。\n 【專家顧問】初始不參與普通的商店招募，但開拓者可以在對局中拓過特定的【投資環境】、【投資策略】或【專家邀請函】解鎖【專家顧問】。解鎖後，他們將在本局內與其他員工一樣，可在商店中購買、升星級穿戴裝備，並擁有之前所屬的羈絆。',
  '「晉升等級」上限提升至110級，提升晉升等級可獲得自塑塵脂、星瓊等獎勵。\n同時，新增了部分「羈絆鏈路」與「預期收益」的內容，完成挑戰可獲得星瓊、遺器殘骸、漫遊指南等獎勵。',
  '最高值及難度將提升至[A8]財富造物主30。',
  '大量羈絆和角色得到了加強，同時改良了部分角色的羈絆、費用、站位和賦能。',
  ];
  final ScrollController _scrollController = ScrollController();
  int _currentIndex = 0;

  // 切換到上一個 (支援循環並連動底部滾動)
  void _goToPrevious() {
    setState(() {
      if (_currentIndex == 0) {
        _currentIndex = _categories.length - 1; // 跳到最後一個
      } else {
        _currentIndex--;
      }
    });
    _scrollToIndex(_currentIndex); // 呼叫滾動
  }

  // 切換到下一個 (支援循環並連動底部滾動)
  void _goToNext() {
    setState(() {
      if (_currentIndex == _categories.length - 1) {
        _currentIndex = 0; // 跳回第一個
      } else {
        _currentIndex++;
      }
    });
    _scrollToIndex(_currentIndex); // 呼叫滾動
  }

  // 直接點擊下方按鈕切換
  void _setIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
    _scrollToIndex(index); // 呼叫滾動
  }

  //計算並滾動到指定位置
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

      // 避免超出範圍
      double maxScroll = _scrollController.position.maxScrollExtent;
      if (targetScrollOffset > maxScroll) targetScrollOffset = maxScroll;
      if (targetScrollOffset < 0) targetScrollOffset = 0;
    }

    // 執行滑動動畫
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
      drawer: const CustomDrawer(currentPage: '擴充一覽'),//側邊欄
      body: Builder(
        builder: (BuildContext innerContext) {
          return GestureDetector(
            // 確保整個畫面包含透明區域都能接收滑動手勢
            behavior: HitTestBehavior.opaque, 
            onVerticalDragEnd: (details) {
              // primaryVelocity 大於 0 表示向下滑，小於 0 表示向上滑
              // 設定 300 作為閾值，避免輕微誤觸就觸發切換
              final velocity = details.primaryVelocity ?? 0;

              if (velocity < -300) {
                // 👆 【向上滑】：跳轉回 HomePage (畫面從下往上滑出)
                Navigator.pushAndRemoveUntil(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) => const HomePage(),
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      const begin = Offset(0.0, 1.0); // 從畫面正下方進入
                      const end = Offset.zero;
                      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: Curves.easeOutQuart));
                      return SlideTransition(position: animation.drive(tween), child: child);
                    },
                    transitionDuration: const Duration(milliseconds: 300),
                  ),
                  (route) => false, // 清除歷史堆疊，避免記憶體爆滿
                );
              } else if (velocity > 300) {
                // 👇 【向下滑】：跳轉到 BondUpdatePage (畫面從上往下滑入)
                Navigator.pushReplacement( // 使用 pushReplacement 替換當前頁面
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) => const BondUpdatePage(),
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      const begin = Offset(0.0, -1.0); // 從畫面正上方進入
                      const end = Offset.zero;
                      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: Curves.easeOutQuart));
                      return SlideTransition(position: animation.drive(tween), child: child);
                    },
                    transitionDuration: const Duration(milliseconds: 300),
                  ),
                );
              }
            },
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/IMG_9478.JPG'), 
                  fit: BoxFit.contain, 
                ),
              ),
              child: SafeArea(
                child: Stack(
                  children: [
                    Positioned(
                      top: 10,  
                      left: 3, 
                      width: 58, 
                      height: 30, 
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque, // 確保透明也能點擊
                        onTap: () {
                          // 點擊開啟側邊欄
                          Scaffold.of(innerContext).openDrawer(); 
                        },
                        child: Container(
                          color:Colors.transparent, 
                        ),
                      ),
                    ),
                    // 1. 小標題區塊
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

                    // ------------------------------------------------
                    // 2. 中間紅黃框 (主要圖片/角色展示區)
                    // ------------------------------------------------
                    Positioned(
                      top: 171,
                      left: 23,
                      right: 23,
                      height: 190,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          //中間圖片展示區
                          SizedBox(
                            width: 420,
                            child: ClipPath(
                              clipper: CutCornerClipper(cutSize:10),
                              child: Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage('assets/images/exp$_currentIndex.JPG'),
                                    fit: BoxFit.cover, 
                                  ),
                                ),
                              ),
                            ),
                          ),

                        // 左按鈕 (永遠顯示)
                        Positioned(
                          left: 6,
                          child: GestureDetector(
                            onTap: _goToPrevious,
                            child: Container(
                              width: 20,  
                              height: 60,
                              alignment: Alignment.center, 
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 16, 19, 45), // 永遠有底色
                                border: Border.all(
                                  color: const Color.fromARGB(255, 87, 101, 212), 
                                  width: 1, 
                                ),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.arrow_back_ios,
                                  size: 16,
                                  color: Color.fromARGB(255, 87, 101, 212), // 永遠顯示圖示
                                ),
                              ),
                            ),
                          ),
                        ),

                        // 右按鈕 (永遠顯示)
                        Positioned(
                          right: 6,
                          child: GestureDetector(
                            onTap: _goToNext,
                            child: Container(
                              width: 20,
                              height: 60,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 16, 19, 45), // 永遠有底色
                                border: Border.all(
                                  color: const Color.fromARGB(255, 87, 101, 212),
                                  width: 1,
                                ),
                              ),
                              child: const Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                                color: Color.fromARGB(255, 87, 101, 212), // 永遠顯示圖示
                              ),
                            ),
                          ),
                        ),
                        ],
                      ),
                    ),
                    // ------------------------------------------------
                    // 3. 下方紅框 (描述文字區塊)
                    // ------------------------------------------------
                    Positioned(
                      top: 380,     // 距離頂部的像素 (確保在主要內容的下方)
                      left: 23,
                      right: 23,
                      height: 146,  // 框框的高度
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

                    // ------------------------------------------------
                    // 4. 底部滑動選單 (白框區域)
                    // ------------------------------------------------
                    Positioned(
                      bottom: 120,
                      left: 0,
                      right: 0,
                      height: 60,
                      child: SingleChildScrollView(
                        controller: _scrollController, // 綁定 controller
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(_categories.length, (index) {
                            final isSelected = _currentIndex == index;

                            return GestureDetector(
                              onTap: () {
                                // ✅ 這裡現在只需要呼叫這個函式，它就會幫我們處理狀態更新和滾動了！
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
            ),
          );
        }
      ),
    );
  }
}

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
      ..moveTo(cutSize, 0)                     // 左上切角
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height - cutSize) // 右下切角
      ..lineTo(size.width - cutSize, size.height)
      ..lineTo(0, size.height)
      ..lineTo(0, cutSize)
      ..close();
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
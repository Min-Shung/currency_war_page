import 'package:flutter/material.dart';
import 'package:currency_wars/custom_drawer.dart';

class BondUpdatePage extends StatefulWidget {
  const BondUpdatePage({super.key});

  @override
  State<BondUpdatePage> createState() => _BondUpdatePageState();
}

class _BondUpdatePageState extends State<BondUpdatePage> {
  // === 這裡的分類與內容，您可以替換成「羈絆更新」的實際文字 ===
  final List<String> _categories = ['羈絆一', '羈絆二', '羈絆三', '羈絆四', '羈絆五' ,'羈絆六' ,'羈絆七'];
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

    // 🌟 1. 如果是第 1, 2 個 (index 0 或 1)，直接滑到最左邊
    if (index <= 1) {
      targetScrollOffset = 0.0;
    } 
    // 🌟 2. 如果是倒數第 1, 2 個 (例如總長7，即 index 5 或 6)，直接滑到最右邊
    else if (index >= _categories.length - 2) {
      targetScrollOffset = _scrollController.position.maxScrollExtent;
    } 
    // 🌟 3. 中間的項目 (index 2, 3, 4...) 則維持置中計算
    else {
      double screenWidth = MediaQuery.of(context).size.width;
      // 圖示寬度 50 + 左右 Padding (8*2) = 66
      double itemWidth = 50 + 16;
      targetScrollOffset = (itemWidth * index) - (screenWidth - itemWidth) / 2;

      // 避免計算結果超出極限範圍
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
      drawer: const CustomDrawer(currentPage: '羈絆更新'),
      body: Builder(
        builder: (BuildContext innerContext) {
          return Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/IMG_9537.JPG'), 
                fit: BoxFit.contain, 
              ),
            ),
            child: SafeArea(
              child: Stack(
                children: [
                  //側邊欄
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
                    top: 101,
                    left: 11,
                    right: 11,
                    height: 458,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 458,
                            child: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage('assets/images/bond$_currentIndex.JPG'),
                                  fit: BoxFit.cover, 
                                ),
                              ),
                            ),
                        ),

                        Positioned(
                          left: 6,
                          top:140,
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque, 
                            onTap: _goToPrevious,
                            child: Container(
                              width: 40,
                              height: 60,
                              color: Colors.transparent, 
                            ),
                          ),
                        ),

                        Positioned(
                          right: 6,
                          top:140,
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque, 
                            onTap: _goToNext,
                            child: Container(
                              width: 40,  
                              height: 60,
                              color: Colors.transparent, 
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),       

                  if (_currentIndex == 2) // 🌟 關鍵：加上這行 if 判斷，只有條件成立時才會渲染底下的 UI
                    Positioned(
                      top: 423,     
                      left: 24,
                      right: 24,
                      height: 107,  
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        color: Colors.transparent,
                        child: const SingleChildScrollView(
                          child: Text(
                            '「大理花」（1費）將加入「擊破」羈絆。「大理花」能使未處於弱點擊破狀態下的敵人也可受到超擊破傷害。\n「靈砂」新增「治療」羈絆，費用由4費調整為2費，重新製作了其角色賦能效果。調整為「戰技和終結技可以召喚更多【浮元】，每隻【浮元】提高我方小隊的傷害增幅和傷害減免，並可自動治療生命值較低的隊員。\n此外，提高了羈絆效果提供的場上/後台強度加成，加強了羈絆內部分角色。',
                            style: TextStyle(
                              color: Colors.white, 
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ),
                    ),

                  //row按鈕
                  Positioned(
                    bottom: 100, // 稍微調高一點，給放大效果預留空間
                    left: 0,
                    right: 0,
                    height: 90, // 加高容器，避免放大時被裁切
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center, // 確保垂直置中
                        children: [
                          ...List.generate(_categories.length, (index) {
                            final isSelected = _currentIndex == index;

                            return GestureDetector(
                              onTap: () {
                                _setIndex(index);
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: AnimatedScale(
                                  scale: isSelected ? 1.2 : 1.0, // 選中時放大 
                                  duration: const Duration(milliseconds: 200),
                                  curve: Curves.easeOutBack,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      // 1. 底層的圓形圖片
                                      Container(
                                        width: 55,
                                        height: 55,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          // 外圍金邊 (未選中時顯示，選中時也會有)
                                          border: Border.all(color: const Color(0xFFC9A063), width: 1.5),
                                          image: DecorationImage(
                                            // 🌟 這裡使用動態檔名載入不同圖示
                                            image: AssetImage('assets/images/icon$index.png'),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      
                                      // 2. 選中時：蓋上一層半透明白色
                                      if (isSelected)
                                        Container(
                                          width: 55,
                                          height: 55,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white.withOpacity(0.3), // 半透明白
                                          ),
                                        ),

                                      // 3. 選中時：外圍的點點圈圈
                                      if (isSelected)
                                        SizedBox(
                                          width: 58, // 比裡面的圖示稍微大一點
                                          height: 58,
                                          // CustomPaint 用來繪製自訂形狀
                                          child: CustomPaint(
                                            painter: DottedCirclePainter(),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                        ],
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



// === 繪製外圍點點圈圈的畫筆 ===
class DottedCirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color.fromARGB(255, 249, 246, 242) 
      ..strokeWidth = 1.0 // 
      ..strokeCap = StrokeCap.round 
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final whiteRingPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 1.0 // 控制白環的粗細
      ..style = PaintingStyle.stroke;
      
    // 設定白環的半徑。
    final whiteRingRadius = (size.width / 2) - 3.0; 
    canvas.drawCircle(center, whiteRingRadius, whiteRingPaint);
    // 定義菱形的畫筆 
    final diamondPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill; 

    // 定義菱形的大小
    const double diamondHalfWidth = 2.6;  
    const double diamondHalfHeight = 1.9; 

    // 建立一個繪製菱形路徑的共用函式
    void drawRhombus(Canvas canvas, Offset centerPoint, Paint paint) {
      Path path = Path();
      // 上頂點
      path.moveTo(centerPoint.dx, centerPoint.dy - diamondHalfHeight);
      // 右頂點
      path.lineTo(centerPoint.dx + diamondHalfWidth, centerPoint.dy);
      // 下頂點
      path.lineTo(centerPoint.dx, centerPoint.dy + diamondHalfHeight);
      // 左頂點
      path.lineTo(centerPoint.dx - diamondHalfWidth, centerPoint.dy);
      path.close(); // 封閉路徑，形成一個菱形

      canvas.drawPath(path, paint);
    }

    // 計算左、右菱形的中心點位置 (剛好在白環路徑上)
    final leftDiamondCenter = Offset(center.dx - whiteRingRadius, center.dy);
    final rightDiamondCenter = Offset(center.dx + whiteRingRadius, center.dy);

    // 執行繪製
    drawRhombus(canvas, leftDiamondCenter, diamondPaint);
    drawRhombus(canvas, rightDiamondCenter, diamondPaint);
    // 2. 控制密度
    const double dashWidth = 0.3; // 點點的長度 (變短)
    const double dashSpace = 1.74; // 點點的間距 (變小，讓點點更密集)
    
    final double circumference = 2 * 3.14159 * radius;
    final int dashCount = (circumference / (dashWidth + dashSpace)).floor();

    for (int i = 0; i < dashCount; i++) {
      final double angle = (i * (dashWidth + dashSpace)) / radius;
      final double nextAngle = angle + (dashWidth / radius);
      
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        angle,
        nextAngle - angle,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
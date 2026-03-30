import 'package:flutter/material.dart';
import 'expansion_page.dart';
import 'more_content.dart';
import 'bond_update.dart';

class CustomDrawer extends StatelessWidget {
  final String currentPage;
  const CustomDrawer({super.key, required this.currentPage});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        drawerTheme: const DrawerThemeData(
          backgroundColor: Colors.transparent, 
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.zero, 
          ),
        ),
      ),
      child: Drawer(
        width: 240,
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/IMG_9490.JPG'),
              fit: BoxFit.cover, 
            ),
          ),
          child: SafeArea(
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 50), 
                    
                    // --- 1. 首頁 ---
                    _buildMenuItem(
                      title: '首頁', 
                      isSelected: currentPage == '首頁',
                      onTap: () {
                        Navigator.pop(context); // 先關閉側邊欄
                        if (currentPage != '首頁') {
                          Navigator.popUntil(context, (route) => route.isFirst);
                        }
                      }
                    ),

                    // --- 2. 擴充一覽 ---
                    _buildMenuItem(
                      title: '擴充一覽', 
                      isSelected: currentPage == '擴充一覽', 
                      onTap: () {
                        Navigator.pop(context); 
                        if (currentPage != '擴充一覽') {
                          // 🌟 關鍵修改：使用 Duration.zero 達成瞬間切換
                          Navigator.push(
                            context, 
                            PageRouteBuilder(
                              pageBuilder: (context, animation, secondaryAnimation) => const ExpansionPage(),
                              transitionDuration: Duration.zero, 
                              reverseTransitionDuration: Duration.zero, 
                            ),
                          );
                        }
                      }
                    ),

                    // --- 3. 羈絆更新 ---
                    _buildMenuItem(
                      title: '羈絆更新', 
                      isSelected: currentPage == '羈絆更新', 
                      onTap: () {
                        Navigator.pop(context); 
                        if (currentPage != '更多內容') {
                          Navigator.push(
                            context, 
                            PageRouteBuilder(
                              pageBuilder: (context, animation, secondaryAnimation) => const BondUpdatePage(),
                              transitionDuration: Duration.zero, 
                              reverseTransitionDuration: Duration.zero, 
                            ),
                          );
                        }
                      }
                    ),

                    // --- 4. 更多內容 ---
                    _buildMenuItem(
                      title: '更多內容', 
                      isSelected: currentPage == '更多內容', 
                      onTap: () {
                        Navigator.pop(context); 
                        if (currentPage != '更多內容') {
                          Navigator.push(
                            context, 
                            PageRouteBuilder(
                              pageBuilder: (context, animation, secondaryAnimation) => const MoreContentPage(),
                              transitionDuration: Duration.zero, 
                              reverseTransitionDuration: Duration.zero, 
                            ),
                          );
                        }
                      }
                    ),
                    
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
                      child: Divider(color: Color.fromARGB(146, 255, 255, 255), thickness: 1),
                    ),
                    
                    // --- 5. 攻略大全 ---
                    _buildMenuItem(
                      title: '攻略大全', 
                      isSelected: currentPage == '攻略大全', 
                      showArrow: true,
                      onTap: () { Navigator.pop(context); }
                    ),
                  ],
                ),

                Positioned(
                  top: 5.0, 
                  left: 5.0, 
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque, 
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 30,  
                      height: 30, 
                      color: const Color(0x01000000), 
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- 建構個別選單項目的元件 ---
  Widget _buildMenuItem({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
    bool showArrow = false, 
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 60,
        decoration: isSelected
            ? const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/IMG_9465.JPG'),
                  fit: BoxFit.fill, 
                ),
              )
            : null, 
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min, 
            children: [
              Text(
                title,
                style: TextStyle(
                  color: isSelected ? const Color(0xFF2A2D64) : Colors.white70,
                  fontSize: 18,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  letterSpacing: 2.0, 
                ),
              ),
              
              //showArrow 為 true，就在文字右邊加上圖示
              if (showArrow) ...[
                const SizedBox(width: 4), 
                Icon(
                  Icons.arrow_outward, 
                  size: 16, 
                  // 顏色跟文字保持一致
                  color: isSelected ? const Color(0xFF2A2D64) : Colors.white70, 
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
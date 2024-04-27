import 'dart:async';

import 'package:flappy_bird_app/my_bird.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Vị trí mặc định lúc đầu sẽ là giữa trục dọc, tức 0
  // Biến sẽ thay đổi khi phát hiện thao tác chạm của người dùng
  static double birdYaxis = 0;

  // Các biến xử lý quá trình nhảy của Dogy
  //! Trục X
  double time = 0;
  //! Trục Y
  double height = 0;
  //! Mấu chốt là mỗi khi bấm nhảy, ta cần biết chiều cao hiện tại của Dody
  double initialHeight = birdYaxis;
  //! Cho biết game đã bắt đầu hay chưa
  bool gameHasStarted = false;

  void jump() {
    setState(() {
      // Các thông số này cần cập nhập lại, mỗi khi cho Dogy nhảy
      time = 0;
      initialHeight = birdYaxis;
    });
  }

  void startGame() {
    // Cho biết game đã bắt đầu
    gameHasStarted = true;

    //! Bật bộ Timer, với tuần suất cập nhập mỗi 50ms
    Timer.periodic(const Duration(milliseconds: 50), (timer) {
      // Tương ứng 50ms đã qua, theo trục X
      time += 0.05;
      // Sự thay đổi độ cao sau 50ms đã qua, theo trục Y, giả định vận tốc là (2.8)
      height = -4.9 * time * time + 2.8 * time;
      // Cập nhập vị trí mới của Dogy lên màn hình sau 50ms đã qua
      setState(() {
        birdYaxis = initialHeight - height;
      });
      // Nếu Dogy chạm đất
      if (birdYaxis > 1) {
        // Huỷ bộ Timer
        timer.cancel();
        // Cho biết game đã kết thúc
        gameHasStarted = false;
        // Đưa Dogy về lại vị trí mặc định //?
        setState(() {
          birdYaxis = 0;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: GestureDetector(
              onTap: () {
                if (gameHasStarted) {
                  // Thực hiện nhiều lần (duy trì bộ Timer)
                  // Với những lần Tap về sau
                  jump();
                } else {
                  // Chỉ thực hiện 1 lần (bật bộ Timer)
                  // Với lần Tap khởi động game
                  startGame();
                }
              },
              child: AnimatedContainer(
                duration: const Duration(microseconds: 0),
                // Để tạo hiệu ứng Dogy nhảy
                // Vị trí trục ngang luôn nằm ở giữa, tức là 0
                // Còn vị trí trục dọc sẽ là biến động thay đổi từ -1 đến +1
                alignment: Alignment(0, birdYaxis),
                color: Colors.blue,
                child: MyBird(),
              ),
            ),
          ),
          Container(
            height: 15,
            color: Colors.green,
          ),
          Expanded(
            child: Container(
              color: Colors.brown,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'SCORE',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        '0',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 35,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'BEST',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        '0',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 35,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'dart:async';

import 'package:flappy_bird_app/barries.dart';
import 'package:flappy_bird_app/my_bird.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Vị trí bắt đầu game của Dogy
  static const double BIRD_Y_AXIS = 0;

  // Hệ số bắt đầu cho phương trình nhảy và rơi
  static const double TIME = 0;
  static const double HEIGHT = 0;

  // Vị trí bắt đầu của rào cản đầu tiên
  static const double BARRIER_X_ONE = 1.0;

  // Vị trí Dogy nằm trên đất
  static const double ON_GROUND = 1.1;

  // Tốc độ bay của Dogy
  static const double SPEED_FLY = 0.05;

  // Khoảng cách giữa các rào cản
  static const double BETWEEN_BARRIES = 2;

  /* ----------------------------------------------------------------------- */

  // Vị trí mặc định lúc đầu của Dogy sẽ là giữa trục dọc, tức 0
  // Biến sẽ thay đổi khi phát hiện thao tác chạm của người dùng
  double birdYaxis = BIRD_Y_AXIS;

  // Các biến xử lý quá trình nhảy của Dogy
  //! Trục X
  double time = TIME;
  //! Trục Y
  double height = HEIGHT;
  //! Mấu chốt là mỗi khi bấm nhảy, ta cần biết chiều cao hiện tại của Dody
  double initialHeight = BIRD_Y_AXIS;
  //! Cho biết game đã bắt đầu hay chưa
  bool gameHasStarted = false;

  // Các biến xử lý quá trình trượt của các rào cản
  //! Vị trí mặc định lúc đầu của rào cản đầu tiên
  double barrierXOne = BARRIER_X_ONE;
  //! Khoảng cách giữa ràn cản thứ hai so với rào cản đầu tiên
  double barrierXTwo = BARRIER_X_ONE + BETWEEN_BARRIES;

  /* ----------------------------------------------------------------------- */

  bool flagBarrierOne = true;
  bool flagBarrierTwo = true;

  int score = 0;
  int scoreMax = 0;

  /* ----------------------------------------------------------------------- */

  void jump() {
    setState(() {
      // Các thông số này cần cập nhập lại, mỗi khi cho Dogy nhảy
      time = 0;
      initialHeight = birdYaxis;
    });
  }

  void startGame() {
    // Cho biết game đã bắt đầu
    if (!gameHasStarted) {
      gameHasStarted = true;
      // Reset các thông số về lại mặc định
      birdYaxis = BIRD_Y_AXIS;
      time = TIME;
      height = HEIGHT;
      initialHeight = BIRD_Y_AXIS;
      barrierXOne = BARRIER_X_ONE;
      barrierXTwo = BARRIER_X_ONE + BETWEEN_BARRIES;
      //
      score = 0;
      flagBarrierOne = true;
      flagBarrierOne = true;
    }

    //! Bật bộ Timer, với tuần suất cập nhập mỗi 50ms
    Timer.periodic(const Duration(milliseconds: 50), (timer) {
      // Tương ứng 50ms đã qua, theo trục X
      time += 0.05;
      // Sự thay đổi độ cao sau 50ms đã qua, theo trục Y, giả định vận tốc nhảy và rơi là (2.8)
      height = -4.9 * time * time + 2.8 * time;

      // Cập nhập hoạt ảnh mới sau 50ms đã qua
      setState(() {
        // Nếu Dogy chạm đất
        if (birdYaxis > 1) {
          // Huỷ bộ Timer
          timer.cancel();

          // Cho biết game đã kết thúc
          gameHasStarted = false;

          // Đặt Dogy nằm trên đất
          birdYaxis = ON_GROUND;

          // Hiển thị kết quả tốt nhất
          if (score > scoreMax) scoreMax = score;
        }
        // Ngược lại vẫn chưa chạm đất
        else {
          // Cập nhập vị trí mới của Dogy
          birdYaxis = initialHeight - height;

          // Đồng thời cho dịch chuyển các rào chắn
          if (barrierXOne < -2) {
            barrierXOne = barrierXTwo + BETWEEN_BARRIES;
            flagBarrierOne = true;
          } else {
            barrierXOne -= SPEED_FLY;
          }
          if (barrierXTwo < -2) {
            barrierXTwo = barrierXOne + BETWEEN_BARRIES;
            flagBarrierTwo = true;
          } else {
            barrierXTwo -= SPEED_FLY;
          }

          // Kiểm tra Dogy có vượt qua rào chưa để tính điểm
          if (barrierXOne < 0) {
            if (flagBarrierOne) {
              flagBarrierOne = false;
              ++score;
            }
          }
          if (barrierXTwo < 0) {
            if (flagBarrierTwo) {
              flagBarrierTwo = false;
              ++score;
            }
          }
        }
      });
    });
  }

  /* ----------------------------------------------------------------------- */

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              flex: 2,
              child: Stack(
                children: [
                  /* ------------------------------------------------------- */
                  AnimatedContainer(
                    duration: const Duration(microseconds: 0),
                    // Để tạo hiệu ứng Dogy nhảy
                    // Vị trí trục ngang luôn nằm ở giữa, tức là 0
                    // Còn vị trí trục dọc sẽ là biến động thay đổi
                    alignment: Alignment(0, birdYaxis),
                    color: Colors.blue,
                    child: const MyBird(),
                  ),
                  /* ------------------------------------------------------- */
                  Container(
                    alignment: const Alignment(0, -0.3),
                    // Chỉ hiển thị khi chưa bắt đầu game
                    child: gameHasStarted
                        ? const Text('')
                        : const Text(
                            'T A P    T O    P L A Y',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                  ),
                  /* --------------------- Rào chắn một -------------------- */
                  AnimatedContainer(
                    alignment: Alignment(barrierXOne, 1.1),
                    duration: const Duration(milliseconds: 0),
                    child: const MyBarries(
                      size: 200.0,
                    ),
                  ),
                  AnimatedContainer(
                    alignment: Alignment(barrierXOne, -1.1),
                    duration: const Duration(milliseconds: 0),
                    child: const MyBarries(
                      size: 150.0,
                    ),
                  ),
                  /* --------------------- Rào chắn hai -------------------- */
                  AnimatedContainer(
                    alignment: Alignment(barrierXTwo, 1.1),
                    duration: const Duration(milliseconds: 0),
                    child: const MyBarries(
                      size: 150.0,
                    ),
                  ),
                  AnimatedContainer(
                    alignment: Alignment(barrierXTwo, -1.1),
                    duration: const Duration(milliseconds: 0),
                    child: const MyBarries(
                      size: 200.0,
                    ),
                  ),
                  /* ------------------------------------------------------- */
                ],
              ),
            ),
            Container(
              height: 15,
              color: Colors.green[800],
            ),
            Expanded(
              child: Container(
                color: Colors.brown,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'SCORE',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          '$score',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 35,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'BEST',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          '$scoreMax',
                          style: const TextStyle(
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
      ),
    );
  }
}

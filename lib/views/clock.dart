import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class Clock extends StatefulWidget {
  const Clock({super.key});

  @override
  State<Clock> createState() => _ClockState();
}

enum Indicator {
  seconds,
  minutes,
  hours,
}

class _ClockState extends State<Clock> {
  double counterSeconds = (pi * 2 / 60) * DateTime.now().second;
  double counterMinutes = (pi * 2 / 60) * DateTime.now().minute;
  double counterHours = (pi * 2 / 60) * DateTime.now().hour;

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 1), (timer) {
      counterSeconds = (pi * 2 / 60) * DateTime.now().second;
      counterMinutes = (pi * 2 / 60) * DateTime.now().minute;
      counterHours = (pi * 2 / 60) * DateTime.now().hour * 5;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[400],
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.indigoAccent.withOpacity(0.3),
                offset: const Offset(-15, 15),
                blurRadius: 30,
                spreadRadius: 3,
              ),
              BoxShadow(
                color: Colors.grey[100]!.withOpacity(0.35),
                offset: const Offset(5, -15),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Stack(
            children: [
              CustomPaint(
                size: Size(300, 300),
                painter: ClockBackgroundPainter(),
              ),
              Transform.rotate(
                angle: counterSeconds,
                child: CustomPaint(
                  size: const Size(300, 300),
                  painter: ClockIndicatorPainter(Indicator.seconds),
                ),
              ),
              Transform.rotate(
                angle: counterMinutes,
                child: CustomPaint(
                  size: const Size(300, 300),
                  painter: ClockIndicatorPainter(Indicator.minutes),
                ),
              ),
              Transform.rotate(
                angle: counterHours,
                child: CustomPaint(
                  size: const Size(300, 300),
                  painter: ClockIndicatorPainter(Indicator.hours),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ClockBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // draw a clock background circle
    final paint = Paint();
    paint.color = Colors.grey.shade200;
    paint.style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      145,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class ClockIndicatorPainter extends CustomPainter {
  Indicator indicator;
  ClockIndicatorPainter(this.indicator);

  void paintLine({
    required Color color,
    required double strokeWidth,
    required Size size,
    required double length,
    required Canvas canvas,
  }) {
    final linePaint = Paint();
    linePaint.color = color;
    linePaint.style = PaintingStyle.stroke;
    linePaint.strokeWidth = strokeWidth;
    linePaint.strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(size.width / 2, size.height / 2 + 15);
    path.lineTo(size.width / 2, size.height / 2 - length);

    canvas.drawPath(path, linePaint);
  }

  @override
  void paint(Canvas canvas, Size size) {
    // draw a line for second in the middle clock
    if (indicator == Indicator.seconds) {
      paintLine(
        color: Colors.red.shade900,
        strokeWidth: 4,
        size: size,
        length: 100,
        canvas: canvas,
      );
    } else if (indicator == Indicator.minutes) {
      paintLine(
        color: Colors.grey.shade800,
        strokeWidth: 5,
        size: size,
        length: 80,
        canvas: canvas,
      );
    } else if (indicator == Indicator.hours) {
      paintLine(
        color: Colors.black87,
        strokeWidth: 7,
        size: size,
        length: 65,
        canvas: canvas,
      );
    }

    // draw a small circle in the middle
    final paintMiniCircle = Paint();
    paintMiniCircle.color = Colors.black;
    paintMiniCircle.style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      7,
      paintMiniCircle,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

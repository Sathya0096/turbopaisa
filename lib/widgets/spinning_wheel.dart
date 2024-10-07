import 'package:flutter/material.dart';
import 'package:offersapp/api/model/SpinWheelResponse.dart';
import 'package:offersapp/generated/assets.dart';

const double pi = 3.1415926535897932;

class SpinController {
  final counter = ValueNotifier<bool?>(null);

  setValue(bool value) {
    counter.value = value;
  }
}

class SpinningWheelWidget<T> extends StatefulWidget {
  final List<T> sectors; // = [100, 1000, 400, 800, 7000, 5000, 300, 2000];
  final double width;
  final double height;
  final Image image;
  final Function? onEnd;
  final int selectedIndex;
  final SpinController controller;

  const SpinningWheelWidget(
      {Key? key,
      required this.sectors,
      required this.width,
      required this.height,
      required this.image,
      required this.selectedIndex,
      this.onEnd,
      required this.controller})
      : super(key: key);

  @override
  State<SpinningWheelWidget> createState() => _SpinningWheelWidgetState();
}

class _SpinningWheelWidgetState extends State<SpinningWheelWidget>
    with SingleTickerProviderStateMixin {
  // int randomSectorIndex = -1;
  List<double> sectorRadians = [];
  bool isSpin = false;

  late AnimationController controller;
  late Animation animation;

  @override
  void initState() {
    super.initState();
    generateSectorRadian();
    //
    // sectors = sectors.reversed.toList();
    // widget.sectors.forEach((element) {
    //   print(element.amount);
    // });

    controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: 100));
    Tween<double> tween = Tween(begin: 0, end: 1);
    var curve = CurvedAnimation(parent: controller, curve: Curves.decelerate);
    animation = tween.animate(curve);
    controller.addListener(() {
      if (controller.isCompleted) {
        print((widget.sectors[widget.selectedIndex] as Spinlist).amount);
        widget.onEnd!();
        setState(() {
          isSpin = false;
        });
      }
    });
    widget.controller.counter.addListener(() {
      setState(() {
        if (!isSpin) {
          spinning();
          isSpin = true;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Stack(
        children: [
          Container(
            // padding: EdgeInsets.only(top: 20, left: 5),
            // width: widget.width,
            // height: widget.height,
            child: InkWell(
              onTap: null,
              // () {
              // setState(() {
              //   if (!isSpin) {
              //     spinning();
              //     isSpin = true;
              //   }
              // });
              // },
              child: AnimatedBuilder(
                animation: animation,
                builder: (context, child) {
                  // return Transform.rotate(angle: controller.value * angle);
                  return Transform.rotate(
                    angle: 0.349065925202812, //20 degrees due to image rotation
                    child: Transform.rotate(
                      angle: controller.value * angle,
                      child: Container(
                        margin: EdgeInsets.all(widget.width * 0.07),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.contain,
                            // image: AssetImage(Assets.imagesRoulette2),
                            // image: AssetImage(Assets.imagesRoulette8300),
                            image: widget.image.image,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Image.asset(
              Assets.imagesRouletteCenter300,
              width: 80,
              height: 80,
            ),
          ),
        ],
      ),
    );
  }

  double angle = 0;

  void spinning() {
    // randomSectorIndex = 2;
    // print(sectors[randomSectorIndex]);

    double randomRadian = generateRandomRadianToSpinTo();
    controller.reset();

    angle = randomRadian;
    // print(angle);
    controller.forward();
    // sectorRadians.forEach((element) => print(element));
    // sectors.forEach((element) => print(element));
  }

  void generateSectorRadian() {
    double sectorRadian = 2 * pi / widget.sectors.length;
    for (int i = 0; i < widget.sectors.length; i++) {
      sectorRadians.add((i + 1) * sectorRadian);
    }
  }

  double generateRandomRadianToSpinTo() {
    return (2 * pi * widget.sectors.length) +
        sectorRadians[widget.selectedIndex];
  }
}

import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CongratulationAnimationForeground extends StatefulWidget {
  const CongratulationAnimationForeground(
      {Key key, @required this.child, this.playOnStart = true})
      : super(key: key);

  @override
  _CongratulationAnimationForegroundState createState() =>
      _CongratulationAnimationForegroundState();
  final Widget child;
  final bool playOnStart;
}

class _CongratulationAnimationForegroundState
    extends State<CongratulationAnimationForeground>
    with SingleTickerProviderStateMixin {
  AnimationController _movementController;

  CongratulationController _congratulationController;

  Animation _moveAnimation;

  @override
  void initState() {
    _movementController =
        AnimationController(vsync: this, duration: const Duration(seconds: 3));
    _congratulationController = CongratulationController();
    _congratulationController.addListener(() {
      _movementController.reset();
      _movementController.forward();
    });

    _movementController.addListener(() {
      setState(() {});
    });

    if (widget.playOnStart) {
      _movementController.forward();
    }

    super.initState();
  }

  @override
  void dispose() {
    _movementController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _moveAnimation =
        CurvedAnimation(parent: _movementController, curve: Curves.easeInQuint);
    _moveAnimation = Tween(begin: 1.0, end: 0.0).animate(_moveAnimation);

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return CustomPaint(
          size: Size(constraints.maxWidth, constraints.maxHeight),
          foregroundPainter: ParticlePainter(
              time: _moveAnimation.value,
              stop: _movementController.isCompleted,
              congratulationController: _congratulationController),
          child: widget.child,
        );
      },
    );
  }
}

class CongratulationController extends ChangeNotifier {
  CongratulationController() {
    init = false;
    particles = [];
  }

  bool init;

  List<_Particle> particles;

  void play() {
    notifyListeners();
  }

  void stop() {}

  void reset() {}
}

class ParticlePainter extends CustomPainter {
  ParticlePainter(
      {this.time,
      CongratulationController congratulationController,
      this.opacity = 1,
      this.stop = false})
      : _congratulationController = congratulationController;

  final double time;
  final CongratulationController _congratulationController;
  final double opacity;
  final bool stop;

  @override
  void paint(Canvas canvas, Size size) {
    if (!_congratulationController.init) {
      _congratulationController.init = true;
      _congratulationController.particles.clear();
      const LinearGradient redLinear = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xffff0304),
            Color(0xffd90203),
            Color(0xffaa0103),
            Color(0xff870103),
            Color(0xff720103),
            Color(0xff6b0103),
            Color(0xffff0304),
            Color(0xffd90203),
            Color(0xffaa0103),
            Color(0xff870103),
            Color(0xff720103),
            Color(0xff6b0103),
          ],
          stops: [
            0.033,
            0.078,
            0.145,
            0.203,
            0.251,
            0.283,
            0.692,
            0.748,
            0.83,
            0.902,
            0.961,
            1
          ]);

      const LinearGradient yellowLinear = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xffffffd0),
            Color(0xffffc800),
            Colors.orange,
            Color(0xffff9000),
            Color(0xffff8900),
            Color(0xffffffd0),
            Color(0xffffb900),
            Color(0xffff9600),
            Color(0xffff8100),
            Color(0xffff7a00),
          ],
          stops: [
            0.006,
            0.062,
            0.169,
            0.257,
            0.315,
            0.568,
            0.644,
            0.731,
            0.802,
            0.849,
          ]);

      const LinearGradient blueLinear = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xff00e0ff),
            Color(0xff00d2f2),
            Color(0xff00a3c7),
            Color(0xff0080a7),
            Color(0xff006b94),
            Color(0xff00648d),
            Color(0xff00e0ff),
            Color(0xff00d2f2),
            Color(0xff00a3c7),
            Color(0xff0080a7),
            Color(0xff006b94),
            Color(0xff00648d),
          ],
          stops: [
            0.006,
            0.029,
            0.124,
            0.207,
            0.276,
            0.32,
            0.568,
            0.589,
            0.673,
            0.748,
            0.809,
            0.849,
          ]);

      const LinearGradient purpleLinear = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xff5a00f1),
            Color(0xffff8ef8),
            Color(0xffed7ef1),
            Color(0xffc057e0),
            Color(0xff7919c4),
            Color(0xff6f10c1),
            Color(0xffca63f0),
            Color(0xffe67cff),
            Color(0xffff8ef8),
          ],
          stops: [
            0.006,
            0.253,
            0.309,
            0.42,
            0.574,
            0.596,
            0.809,
            0.871,
            1,
          ]);

      // const Path spiralShape =

      double startX = 705.394;
      double startY = 29.963;

      final Path spiralShape = Path()
        ..moveTo(727.691 - startX, 48.452 - startY)
        ..cubicTo(722.005 - startX, 49.019 - startY, 716.461 - startX,
            49.278 - startY, 711.64 - startX, 51.305 - startY)
        ..cubicTo(
            710.3145859889776 - startX,
            51.797436006334074 - startY,
            709.1179616063575 - startX,
            52.58378917205584 - startY,
            708.1400147790811 - startX,
            53.605001118751424 - startY)
        ..cubicTo(
            707.4044803295974 - startX,
            54.555445937373 - startY,
            706.8409799916043 - startX,
            55.62728111480474 - startY,
            706.474992554236 - startX,
            56.77199940166186 - startY)
        ..cubicTo(
            706.0213307734784 - startX,
            57.79740005234926 - startY,
            705.7262885028466 - startX,
            58.885853137605544 - startY,
            705.6000136165482 - startX,
            60.00000115786975 - startY)
        ..cubicTo(
            705.5925253200702 - startX,
            62.41718036146286 - startY,
            706.5983060953846 - startX,
            64.72688536586323 - startY,
            708.3730049566711 - startX,
            66.36800046439427 - startY)
        ..cubicTo(
            707.6896600182132 - startX,
            64.7591538748344 - startY,
            707.8508275579563 - startX,
            62.91584699004966 - startY,
            708.8030219664911 - startX,
            61.45000190439497 - startY)
        ..cubicTo(
            709.8093816325145 - startX,
            60.034100630937594 - startY,
            711.1644938679087 - startX,
            58.902199561922515 - startY,
            712.7369709087915 - startX,
            58.163997625967156 - startY)
        ..cubicTo(
            718.77 - startX,
            54.98199999999999 - startY,
            726.8449999999999 - startX,
            54.55199999999999 - startY,
            734.5029999999999 - startX,
            53.806 - startY)
        ..cubicTo(
            735.4652551932115 - startX,
            53.747804531338744 - startY,
            736.4182590745264 - startX,
            53.58449950311907 - startY,
            737.344995445459 - startX,
            53.31899967065137 - startY)
        ..cubicTo(
            737.6189999999999 - startX,
            53.227999999999994 - startY,
            737.911 - startX,
            53.062999999999995 - startY,
            737.8449999999999 - startX,
            52.79599999999999 - startY)
        ..cubicTo(
            737.9388089509513 - startX,
            52.30225422293999 - startY,
            738.0032555181723 - startX,
            51.80337768704161 - startY,
            738.0379849852155 - startX,
            51.30199895630243 - startY)
        ..cubicTo(
            736.7379999999999 - startX,
            49.85799999999999 - startY,
            737.4259999999999 - startX,
            47.71399999999999 - startY,
            735.7949999999998 - startX,
            46.49499999999999 - startY)
        ..cubicTo(734.883 - startX, 45.815 - startY, 733.476 - startX,
            47.878 - startY, 727.691 - startX, 48.452 - startY)
        ..close();

      // startX = 710.287;
      // startY = 35.02;
      startX = 703.169;
      startY = 34.888;

      spiralShape.addPath(
          Path()
            ..moveTo(735.581 - startX, 57.957 - startY)
            ..cubicTo(
                736.0889279891328 - startX,
                56.03953076044857 - startY,
                736.377443228908 - startX,
                54.07058199040221 - startY,
                736.4410148607383 - startX,
                52.088001051090494 - startY)
            ..cubicTo(
                736.3170971857614 - startX,
                50.14961471603181 - startY,
                735.5563463543515 - startX,
                48.306446227546026 - startY,
                734.2769580121712 - startX,
                46.84499732128364 - startY)
            ..cubicTo(
                724.3770000000001 - startX,
                36.538 - startY,
                714.1030000000001 - startX,
                36.434 - startY,
                710.777 - startX,
                34.887 - startY)
            ..cubicTo(711.063 - startX, 35.02 - startY, 710.287 - startX,
                37.124 - startY, 712.4050000000001 - startX, 38.359 - startY)
            ..cubicTo(713.542 - startX, 39.023 - startY, 732.655 - startX,
                48.247 - startY, 735.581 - startX, 57.957 - startY)
            ..close(),
          Offset.zero);

      // startX = 713.9465286788324;
      // startY = 66.578;
      startX = 701.793;
      startY = 21.283;
      spiralShape.addPath(
          Path()
            ..moveTo(718.009 - startX, 67.961 - startY)
            ..cubicTo(
                716.67 - startX,
                68.161 - startY,
                715.2090000000001 - startX,
                68.394 - startY,
                714.547 - startX,
                69.295 - startY)
            ..cubicTo(
                714.2757178137249 - startX,
                69.7127319149718 - startY,
                714.1143909081936 - startX,
                70.19224088365117 - startY,
                714.0779998636154 - startX,
                70.68899998649884 - startY)
            ..cubicTo(
                713.9465286788324 - startX,
                71.68467867623627 - startY,
                713.9465286788324 - startX,
                72.69332046817392 - startY,
                714.0779957683451 - startX,
                73.68899956331603 - startY)
            ..cubicTo(
                715.4601281491023 - startX,
                72.73126771805998 - startY,
                717.1087454243543 - startX,
                72.23304382163406 - startY,
                718.7899816174067 - startX,
                72.26499815186895 - startY)
            ..cubicTo(
                720.6511550721168 - startX,
                72.25285558644558 - startY,
                722.5109271179963 - startX,
                72.3694672364657 - startY,
                724.3559940080268 - startX,
                72.61399939932693 - startY)
            ..cubicTo(
                727.5706666666666 - startX,
                72.93733333333333 - startY,
                730.7613333333334 - startX,
                73.13366666666667 - startY,
                733.928 - startX,
                73.203 - startY)
            ..cubicTo(734.836 - startX, 73.223 - startY, 735.871 - startX,
                73.176 - startY, 736.228 - startX, 72.56400000000001 - startY)
            ..cubicTo(
                734.723 - startX,
                71.26400000000001 - startY,
                732.5649999999999 - startX,
                70.784 - startY,
                730.746 - startX,
                69.828 - startY)
            ..cubicTo(
                729.114 - startX,
                68.97 - startY,
                727.3009999999999 - startX,
                66.571 - startY,
                725.463 - startX,
                66.578 - startY)
            ..cubicTo(
                724.2629877714597 - startX,
                66.70608957696824 - startY,
                723.077313463582 - startX,
                66.94442952818478 - startY,
                721.9210093798774 - startX,
                67.29000087429506 - startY)
            ..cubicTo(
                720.6276666666665 - startX,
                67.5380000000000 - startY,
                719.3236666666667 - startX,
                67.76166666666667 - startY,
                718.009 - startX,
                67.961 - startY)
            ..close(),
          Offset.zero);

      startX = 705.453;
      startY = 26.273;

      spiralShape.addPath(
          Path()
            ..moveTo(711.539 - startX, 57.952 - startY)
            ..cubicTo(
                715.348 - startX,
                59.539 - startY,
                719.1759999999999 - startX,
                61.077 - startY,
                722.961 - startX,
                62.726 - startY)
            ..cubicTo(724.696 - startX, 63.484 - startY, 726.561 - startX,
                64.207 - startY, 728.224 - startX, 65.07 - startY)
            ..cubicTo(
                730.1020000000001 - startX,
                66.04199999999999 - startY,
                731.96 - startX,
                67.05199999999999 - startY,
                733.8240000000001 - startX,
                68.04299999999999 - startY)
            ..lineTo(739.09 - startX, 70.83699999999999 - startY)
            ..cubicTo(
                739.6161434833899 - startX,
                71.08776169936121 - startY,
                740.108119189681 - startX,
                71.40465588722496 - startY,
                740.5540075119742 - startX,
                71.7800007281164 - startY)
            ..cubicTo(
                741.7830000000001 - startX,
                72.92599999999999 - startY,
                740.854 - startX,
                74.317 - startY,
                740.5540000000001 - startX,
                75.33299999999998 - startY)
            ..cubicTo(
                740.354 - startX,
                76.02033333333333 - startY,
                740.152 - startX,
                76.70733333333331 - startY,
                739.9480000000001 - startX,
                77.39399999999998 - startY)
            ..cubicTo(
                739.5190000000001 - startX,
                78.84899999999998 - startY,
                737.1290000000001 - startX,
                76.86699999999998 - startY,
                736.3180000000001 - startX,
                76.35299999999998 - startY)
            ..cubicTo(
                735.4250000000001 - startX,
                75.78799999999998 - startY,
                734.493 - startX,
                75.27399999999999 - startY,
                733.541 - startX,
                74.79499999999997 - startY)
            ..cubicTo(
                726.1700000000001 - startX,
                71.08199999999998 - startY,
                718.777 - startX,
                67.39499999999997 - startY,
                711.2320000000001 - startX,
                64.02099999999997 - startY)
            ..cubicTo(
                709.6650000000001 - startX,
                63.32099999999997 - startY,
                707.2410000000001 - startX,
                62.57299999999997 - startY,
                706.3820000000001 - startX,
                61.120999999999974 - startY)
            ..cubicTo(
                706.0009602545088 - startX,
                60.47515591406564 - startY,
                705.7096184155359 - startX,
                59.78044356131871 - startY,
                705.5160005012092 - startX,
                59.05600004195422 - startY)
            ..cubicTo(
                705.4298036487343 - startX,
                58.36112838014149 - startY,
                705.4486816352132 - startX,
                57.6572491699977 - startY,
                705.5719703865136 - startX,
                56.96799760900217 - startY)
            ..cubicTo(
                705.6420000000002 - startX,
                56.357999999999976 - startY,
                705.8970000000002 - startX,
                54.95099999999997 - startY,
                705.8970000000002 - startX,
                54.95099999999997 - startY)
            ..cubicTo(
                705.8970000000002 - startX,
                54.95099999999997 - startY,
                708.6830000000001 - startX,
                56.501999999999974 - startY,
                709.6070000000002 - startX,
                57.02099999999997 - startY)
            ..cubicTo(
                710.232399372943 - startX,
                57.36857517307994 - startY,
                710.8774914030195 - startX,
                57.67943473829803 - startY,
                711.5390177608643 - startX,
                57.952001446551215 - startY)
            ..close(),
          Offset.zero);
      startX = 702.821;
      startY = 20.464;
      spiralShape.addPath(
          Path()
            ..moveTo(711.608 - startX, 75.934 - startY)
            ..cubicTo(
                711.352 - startX,
                78.211 - startY,
                713.2449999999999 - startX,
                79.666 - startY,
                715.7719999999999 - startX,
                80.994 - startY)
            ..cubicTo(723.5 - startX, 85.054 - startY, 731.7 - startX,
                90.3 - startY, 735.321 - startX, 97.358 - startY)
            ..cubicTo(734.875 - startX, 96.489 - startY, 735.673 - startX,
                95.047 - startY, 735.663 - startX, 94.158 - startY)
            ..cubicTo(735.612 - startX, 89.18 - startY, 729.963 - startX,
                84.419 - startY, 725.722 - startX, 80.525 - startY)
            ..cubicTo(
                722.8746666666666 - startX,
                77.90899999999999 - startY,
                720.0246666666667 - startX,
                75.29466666666667 - startY,
                717.172 - startX,
                72.682 - startY)
            ..cubicTo(
                716.8743834153316 - startX,
                72.4263226663022 - startY,
                716.6005939165701 - startX,
                72.14416551782303 - startY,
                716.3539900369486 - startX,
                71.83899900086318 - startY)
            ..cubicTo(
                715.9150000000001 - startX,
                71.256 - startY,
                715.106 - startX,
                69.009 - startY,
                715.5310000000001 - startX,
                68.482 - startY)
            ..cubicTo(
                715.5310000000001 - startX,
                68.482 - startY,
                713.5310000000001 - startX,
                70.963 - startY,
                713.1110000000001 - startX,
                71.739 - startY)
            ..cubicTo(
                712.4025287666868 - startX,
                72.98216288876246 - startY,
                711.9038428429647 - startX,
                74.33361525657351 - startY,
                711.6349980784148 - startX,
                75.73899979548652 - startY)
            ..cubicTo(711.622 - startX, 75.808 - startY, 711.614 - startX,
                75.872 - startY, 711.608 - startX, 75.934 - startY)
            ..close(),
          Offset.zero);

      startX = 224.176;
      startY = 218.991;

      final Path rectangleShape = Path()
        ..moveTo(276.4 - startX, 356.814 - startY)
        ..lineTo(224.176 - startX, 310.5 - startY)
        ..cubicTo(224.176 - startX, 310.5 - startY, 286.4 - startX,
            283.46 - startY, 276.62 - startX, 218.991 - startY)
        ..lineTo(328.057 - startX, 252.69100000000003 - startY)
        ..cubicTo(
            328.057 - startX,
            252.69100000000003 - startY,
            309.484 - startX,
            318.214 - startY,
            276.4 - startX,
            356.814 - startY)
        ..close();

      startX = 79.39200000000001;
      startY = -17.068;

      final Path curvedShape = Path()
        ..moveTo(83.221 - startX, -17.068 - startY)
        ..cubicTo(
            83.221 - startX,
            -17.068 - startY,
            90.605 - startX,
            16.850999999999996 - startY,
            79.39200000000001 - startX,
            31.724 - startY)
        ..cubicTo(
            79.39200000000001 - startX,
            31.724 - startY,
            97.56700000000001 - startX,
            29.07 - startY,
            100.403 - startX,
            3.7680000000000007 - startY)
        ..cubicTo(100.4 - startX, 3.7670000000000003 - startY, 91.011 - startX,
            -12.327 - startY, 83.221 - startX, -17.068 - startY)
        ..close();

      startX = 41.778;
      startY = 210.033;

      startX = 173.9725391936938;
      startY = 403.97386566475956;

      final Path circleShape = Path()
        ..moveTo(206.024 - startX, 420.0 - startY)
        ..cubicTo(
            206.02453727892103 - startX,
            428.8512746653313 - startY,
            198.84929133123887 - startX,
            436.02696840914933 - startY,
            189.99798587464744 - startX,
            436.0269684137553 - startY)
        ..cubicTo(
            181.14668041805604 - startX,
            436.0269684183612 - startY,
            173.97143446290588 - startX,
            428.8512746820107 - startY,
            173.97198682829983 - startX,
            419.99996924265446 - startY)
        ..cubicTo(
            173.9725391936938 - startX,
            411.1486638032982 - startY,
            181.14868069076735 - startX,
            403.97386566475956 - startY,
            189.9999860784175 - startX,
            403.9749704001512 - startY)
        ..cubicTo(
            198.84928297380375 - startX,
            403.9772013921597 - startY,
            206.02234027944277 - startX,
            411.1507063424134 - startY,
            206.0239964323396 - startX,
            419.99999272697664 - startY)
        ..close();

      final List<double> loopParticles = [-1000, -3300, -2500, -1800];
      for (final double offsetY in loopParticles) {
        _congratulationController.particles.addAll([
          _Particle(
            path: rectangleShape,
            gradient: redLinear,
            scale: 0.3,
            startTranslate: Offset(-size.width * 0.1, -10),
            endTranslate: Offset(-size.width * 0.1, 100 + offsetY),
          ),
          _Particle(
            path: rectangleShape,
            gradient: blueLinear,
            scale: 0.5,
            startTranslate: Offset(size.width * 0.1, -10),
            endTranslate: Offset(size.width * 0.1, 200 + offsetY),
          ),
          // _Particle(
          //   path: spiralShape,
          //   gradient: blueLinear,
          //   scale: 1,
          //   rotation: 70,
          //   startTranslate: Offset(size.width * 0.5, -10),
          //   endTranslate: Offset(size.width * 0.5, 150 + offsetY),
          // ),
          _Particle(
            path: spiralShape,
            gradient: blueLinear,
            scale: 1,
            rotation: 70,
            startTranslate: Offset(size.width * 0.5, -10),
            endTranslate: Offset(size.width * 0.5, 150 + offsetY),
          ),
          // _Particle(
          //   path: spiralShape,
          //   gradient: yellowLinear,
          //   scale: 1.4,
          //   rotation: 30,
          //   startTranslate: Offset(size.width * 0.8, -10),
          //   endTranslate: Offset(size.width * 0.8, 150 + offsetY),
          // ),
          _Particle(
            path: spiralShape,
            gradient: redLinear,
            scale: 1.4,
            rotation: 30,
            startTranslate: Offset(size.width * 0.3, -10),
            endTranslate: Offset(size.width * 0.3, 400 + offsetY),
          ),
          _Particle(
            path: spiralShape,
            gradient: redLinear,
            scale: 1.4,
            rotation: 30,
            startTranslate: Offset(size.width * 0.3, -10),
            endTranslate: Offset(size.width * 0.3, 400 + offsetY),
          ),
          // _Particle(
          //   path: circleShape,
          //   gradient: redLinear,
          //   scale: 1.4,
          //   rotation: 30,
          //   startTranslate: Offset(size.width * 0.3, -10),
          //   endTranslate: Offset(size.width * 0.3, 350 + offsetY),
          // ),
          _Particle(
            path: circleShape,
            gradient: yellowLinear,
            scale: 1.4,
            rotation: 30,
            startTranslate: Offset(size.width * 0.3, -10),
            endTranslate: Offset(size.width * 0.3, 100 + offsetY),
          ),
          _Particle(
            path: circleShape,
            gradient: yellowLinear,
            scale: 1.4,
            rotation: 30,
            startTranslate: Offset(size.width * 0.3, -10),
            endTranslate: Offset(size.width * 0.3, 350 + offsetY),
          ),
          // _Particle(
          //   path: circleShape,
          //   gradient: yellowLinear,
          //   scale: 1.4,
          //   rotation: 30,
          //   startTranslate: Offset(size.width * 0.3, -10),
          //   endTranslate: Offset(size.width * 0.3, 350 + offsetY),
          // ),
          _Particle(
            path: rectangleShape,
            gradient: yellowLinear,
            scale: 0.1,
            rotation: 30,
            startTranslate: Offset(size.width * 0.3, -10),
            endTranslate: Offset(size.width * 0.3, 500 + offsetY),
          ),
          _Particle(
            path: rectangleShape,
            color: const Color(0xff5A00F1),
            scale: 0.1,
            rotation: 30,
            startTranslate: Offset(size.width * 0.3, -10),
            endTranslate: Offset(size.width * 0.3, 500 + offsetY),
          ),
          _Particle(
            path: rectangleShape,
            color: const Color(0xff5A00F1),
            scale: 0.4,
            rotation: 30,
            startTranslate: Offset(size.width * 0.3, -10),
            endTranslate: Offset(size.width * 0.3, 0 + offsetY),
          ),
          _Particle(
            path: rectangleShape,
            color: const Color(0xffFF0304),
            scale: 0.3,
            rotation: 80,
            startTranslate: Offset(size.width * 0.6, -10),
            endTranslate: Offset(size.width * 0.6, 0 + offsetY),
          ),
          // _Particle(
          //   path: rectangleShape,
          //   gradient: purpleLinear,
          //   scale: 0.4,
          //   rotation: 120,
          //   startTranslate: Offset(size.width * 0.8, -10),
          //   endTranslate: Offset(size.width * 0.8, 0 + offsetY),
          // ),
          _Particle(
            path: rectangleShape,
            gradient: purpleLinear,
            scale: 0.2,
            rotation: 120,
            startTranslate: Offset(size.width * 0.1, -10),
            endTranslate: Offset(size.width * 0.1, 0 + offsetY),
          ),
          _Particle(
            path: rectangleShape,
            gradient: blueLinear,
            scale: 0.2,
            rotation: 190,
            startTranslate: const Offset(-30, 0),
            endTranslate: Offset(-30, 0 + offsetY),
          ),
          // _Particle(
          //   path: circleShape,
          //   gradient: blueLinear,
          //   scale: 1,
          //   rotation: 0,
          //   startTranslate: const Offset(0, 0),
          //   endTranslate: Offset(0, 100 + offsetY),
          // ),
          _Particle(
            path: curvedShape,
            gradient: blueLinear,
            scale: 0.5,
            rotation: 0,
            startTranslate: const Offset(0, 0),
            endTranslate: Offset(0, 300 + offsetY),
          ),
          // _Particle(
          //   path: curvedShape,
          //   gradient: blueLinear,
          //   scale: 0.5,
          //   rotation: 0,
          //   startTranslate: const Offset(0, 0),
          //   endTranslate: Offset(0, 300 + offsetY),
          // ),
          _Particle(
            path: rectangleShape,
            gradient: blueLinear,
            scale: 0.5,
            rotation: 80,
            startTranslate: const Offset(0, 0),
            endTranslate: Offset(0, 300 + offsetY),
          ),
          _Particle(
            path: rectangleShape,
            gradient: redLinear,
            scale: 0.3,
            rotation: 120,
            startTranslate: const Offset(0, 0),
            endTranslate: Offset(0, 500 + offsetY),
          ),
          // _Particle(
          //   path: rectangleShape,
          //   gradient: redLinear,
          //   scale: 0.1,
          //   rotation: 120,
          //   startTranslate: const Offset(0, 0),
          //   endTranslate: Offset(0, 700 + offsetY),
          // ),
          _Particle(
            path: rectangleShape,
            gradient: yellowLinear,
            scale: 0.1,
            rotation: 330,
            startTranslate: const Offset(0, 0),
            endTranslate: Offset(0, 650 + offsetY),
          ),
          _Particle(
            path: rectangleShape,
            gradient: yellowLinear,
            scale: 0.5,
            rotation: 330,
            startTranslate: const Offset(0, 0),
            endTranslate: Offset(0, 650 + offsetY),
          ),
          // _Particle(
          //   path: rectangleShape,
          //   gradient: purpleLinear,
          //   scale: 0.5,
          //   rotation: 270,
          //   startTranslate: const Offset(0, 0),
          //   endTranslate: Offset(0, 580 + offsetY),
          // ),
          _Particle(
            path: rectangleShape,
            color: const Color(0xffFF8900),
            scale: 0.3,
            rotation: 210,
            startTranslate: Offset(size.width * 0.1, 0),
            endTranslate: Offset(size.width * 0.1, 480 + offsetY),
          ),
          _Particle(
            path: rectangleShape,
            color: const Color(0xff00648D),
            scale: 0.3,
            rotation: 80,
            startTranslate: Offset(size.width * 0.1, 0),
            endTranslate: Offset(size.width * 0.1, 430 + offsetY),
          ),
          _Particle(
            path: curvedShape,
            color: const Color(0xff5A00F1),
            scale: 0.9,
            rotation: 80,
            startTranslate: Offset(size.width * 0.1, 0),
            endTranslate: Offset(size.width * 0.1, 430 + offsetY),
          ),
          _Particle(
            path: curvedShape,
            color: const Color(0xffFF8EF8),
            scale: 0.9,
            rotation: 230,
            startTranslate: Offset(size.width * 0.5, 0),
            endTranslate: Offset(size.width * 0.5, 430 + offsetY),
          ),
          // _Particle(
          //   path: curvedShape,
          //   color: const Color(0xffFF0304),
          //   scale: 0.9,
          //   rotation: 0,
          //   startTranslate: Offset(size.width * 0.8, 0),
          //   endTranslate: Offset(size.width * 0.8, 430 + offsetY),
          // ),
          _Particle(
            path: curvedShape,
            color: const Color(0xff6F10C1),
            scale: 0.6,
            rotation: 147,
            startTranslate: Offset(size.width * 0.8, 0),
            endTranslate: Offset(size.width * 0.8, 360 + offsetY),
          ),
          _Particle(
            path: rectangleShape,
            color: const Color(0xffFFE700),
            scale: 0.3,
            rotation: 130,
            startTranslate: Offset(size.width * 0.44, 0),
            endTranslate: Offset(size.width * 0.44, 300 + offsetY),
          ),
          // _Particle(
          //   path: rectangleShape,
          //   color: const Color(0xff0080A7),
          //   scale: 0.3,
          //   rotation: 110,
          //   startTranslate: Offset(size.width * 0.44, 0),
          //   endTranslate: Offset(size.width * 0.44, 230 + offsetY),
          // ),
          _Particle(
            path: rectangleShape,
            color: const Color(0xff0080A7),
            scale: 0.2,
            rotation: 110,
            startTranslate: Offset(size.width * 0.6, 0),
            endTranslate: Offset(size.width * 0.6, 150 + offsetY),
          ),
          _Particle(
            path: rectangleShape,
            color: const Color(0xffFF0304),
            scale: 0.2,
            rotation: 170,
            startTranslate: Offset(size.width * 0.6, 0),
            endTranslate: Offset(size.width * 0.6, 100 + offsetY),
          ),
          _Particle(
            path: rectangleShape,
            color: const Color(0xffC057E0),
            scale: 0.2,
            rotation: 170,
            startTranslate: Offset(size.width * 0.3, 0),
            endTranslate: Offset(size.width * 0.3, 100 + offsetY),
          ),
          // _Particle(
          //   path: rectangleShape,
          //   gradient: yellowLinear,
          //   scale: 0.2,
          //   rotation: 130,
          //   startTranslate: Offset(size.width * 0.2, 0),
          //   endTranslate: Offset(size.width * 0.2, 100 + offsetY),
          // ),
          _Particle(
            path: circleShape,
            gradient: purpleLinear,
            scale: 0.5,
            rotation: 130,
            startTranslate: Offset(size.width * 0.15, 0),
            endTranslate: Offset(size.width * 0.15, 100 + offsetY),
          ),
          _Particle(
            path: curvedShape,
            gradient: purpleLinear,
            scale: 1.4,
            rotation: 80,
            startTranslate: Offset(size.width * 0.15, 0),
            endTranslate: Offset(size.width * 0.15, 180 + offsetY),
          ),
          _Particle(
            path: curvedShape,
            gradient: purpleLinear,
            scale: 1.4,
            rotation: 80,
            startTranslate: Offset(size.width * 0.15, 0),
            endTranslate: Offset(size.width * 0.15, 180 + offsetY),
          ),
          _Particle(
            path: curvedShape,
            gradient: blueLinear,
            scale: 1.4,
            rotation: 80,
            startTranslate: Offset(size.width * 0.93, 0),
            endTranslate: Offset(size.width * 0.93, 240 + offsetY),
          ),
          // _Particle(
          //   path: curvedShape,
          //   gradient: redLinear,
          //   scale: 1.4,
          //   rotation: 40,
          //   startTranslate: Offset(size.width * 0.93, 0),
          //   endTranslate: Offset(size.width * 0.93, 780 + offsetY),
          // ),
          _Particle(
            path: spiralShape,
            gradient: purpleLinear,
            scale: 1.4,
            rotation: 350,
            startTranslate: Offset(size.width * 0.76, 0),
            endTranslate: Offset(size.width * 0.76, 700 + offsetY),
          ),
          _Particle(
            path: spiralShape,
            gradient: yellowLinear,
            scale: 1,
            rotation: 350,
            startTranslate: Offset(size.width * 0.46, 0),
            endTranslate: Offset(size.width * 0.46, 700 + offsetY),
          ),
          _Particle(
            path: rectangleShape,
            gradient: yellowLinear,
            scale: 0.3,
            rotation: 350,
            startTranslate: Offset(size.width * 0.5, 0),
            endTranslate: Offset(size.width * 0.5, 700 + offsetY),
          ),
          // _Particle(
          //   path: rectangleShape,
          //   gradient: blueLinear,
          //   scale: 0.3,
          //   rotation: 230,
          //   startTranslate: Offset(size.width * 0.245, 0),
          //   endTranslate: Offset(size.width * 0.245, 670 + offsetY),
          // ),
          _Particle(
            path: rectangleShape,
            color: Colors.orange,
            scale: 0.4,
            rotation: 135,
            startTranslate: Offset(size.width * 0.245, 0),
            endTranslate: Offset(size.width * 0.245, 600 + offsetY),
          ),
          _Particle(
            path: curvedShape,
            color: Colors.orange,
            scale: 1,
            rotation: 235,
            startTranslate: Offset(size.width * 0.245, 0),
            endTranslate: Offset(size.width * 0.245, 580 + offsetY),
          ),
          _Particle(
            path: curvedShape,
            color: Colors.blue,
            scale: 1,
            rotation: 130,
            startTranslate: Offset(size.width * 0.7, 0),
            endTranslate: Offset(size.width * 0.7, 580 + offsetY),
          ),
          // _Particle(
          //   path: rectangleShape,
          //   gradient: blueLinear,
          //   scale: 0.3,
          //   rotation: 130,
          //   startTranslate: Offset(size.width * 0.7, 0),
          //   endTranslate: Offset(size.width * 0.7, 500 + offsetY),
          // ),
          _Particle(
            path: circleShape,
            gradient: redLinear,
            scale: 0.3,
            rotation: 46,
            startTranslate: Offset(size.width * 0.83, 0),
            endTranslate: Offset(size.width * 0.83, 500 + offsetY),
          ),
          _Particle(
            path: circleShape,
            gradient: purpleLinear,
            scale: 0.8,
            rotation: 46,
            startTranslate: Offset(size.width * 0.56, 0),
            endTranslate: Offset(size.width * 0.56, 500 + offsetY),
          ),
        ]);
      }
    }

    for (final _Particle particle in _congratulationController.particles) {
      particle.draw(canvas, size, time, opacity: opacity, stop: stop);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class _Particle {
  _Particle(
      {this.path,
      this.rotation = 0,
      this.startTranslate = Offset.zero,
      this.endTranslate = Offset.zero,
      this.scale = 1,
      this.gradient,
      this.color,
      this.speed = 4200});

  final Path path;
  final double rotation;
  final Offset startTranslate;
  final Offset endTranslate;
  final double scale;
  final Gradient gradient;
  final Color color;
  final double speed;

  double angleToRadian(double angle) {
    return (angle * pi) / 180.0;
  }

  void draw(Canvas canvas, Size size, double time,
      {double opacity = 1, bool stop = false}) {
    final Rect bound = path.getBounds();
    final double sinRadians = sin(angleToRadian(rotation));
    final double oneMinusCosRadians = 1 - cos(angleToRadian(rotation));
    final Offset center = path.getBounds().center;
    final double originX =
        sinRadians * center.dy + oneMinusCosRadians * center.dx;
    final double originY =
        -sinRadians * center.dx + oneMinusCosRadians * center.dy;

    final transform = Matrix4.identity();
    transform
      ..translate(startTranslate.dx, endTranslate.dy + speed * (1 - time))
      ..translate(bound.width / 2, bound.height / 2)
      ..scale(scale, scale)
      ..translate(-bound.width / 2, -bound.height / 2)
      ..translate(originX, originY)
      ..rotateZ(angleToRadian(rotation));
    final Path transformPath = path.transform(transform.storage);
    final Rect rect = transformPath.getBounds();
    final Paint paint = gradient != null
        ? (Paint()
          ..shader = gradient.createShader(rect)
          ..color = Colors.white.withOpacity(opacity))
        : (Paint()..color = color.withOpacity(opacity));
    canvas.drawPath(transformPath, paint);
  }
}

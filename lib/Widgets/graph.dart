import 'dart:math';

import 'package:convex_hull/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';

import 'kps.dart';
import 'jm.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'Custom_Point.dart';

class Graph extends StatefulWidget {
  const Graph({super.key});

  @override
  State<Graph> createState() => _GraphState();
}

class _GraphState extends State<Graph> {

  List<Custom_Point> data = [Custom_Point(42.16910237683471, 16.47521630399296), Custom_Point(33.28603603453433, 65.70808697382), Custom_Point(24.992391605946306, 11.155862140390704), Custom_Point(94.350586225767, 82.21504983930603),
    Custom_Point(99.97811149812297, 60.324319820188286), Custom_Point(1.2146043830746134, 18.569561419251414), Custom_Point(31.54297453978152, 37.63460065560344), Custom_Point(79.0536162895914, 99.92227954605843),
    Custom_Point(58.18755185906848, 65.86104350324136), Custom_Point(83.32525385766093, 41.20266533865522), Custom_Point(32.69283695177603, 88.27330894743083), Custom_Point(66.88273071545527, 99.38665868075229),
    Custom_Point(82.25212265196988, 4.089106923682206), Custom_Point(5.180225784275083, 66.83678236715531), Custom_Point(90.21442237616486, 74.22084752064602), Custom_Point(89.08497975155873, 47.335626330853046),
    Custom_Point(59.893465248908996, 62.38213180560639), Custom_Point(32.51990478624196, 76.37937140923734), Custom_Point(39.6818036828954, 11.425420417380083), Custom_Point(70.12414686299546, 84.14832920833062),
    Custom_Point(23.911170375074818, 84.26621248470319), Custom_Point(43.54692129204856, 15.294297034645998), Custom_Point(20.999747404116608, 4.881872171661783), Custom_Point(32.634108244028525, 40.393820060880216),
    Custom_Point(80.91301898245236, 15.467054388762257), Custom_Point(21.668122697750647, 74.02926298742578), Custom_Point(98.84702525880395, 32.58208129108049), Custom_Point(19.42882090080844, 94.03980460083214),
    Custom_Point(47.6378407770865, 76.22108806063356), Custom_Point(73.35194354311392, 90.61970259555632), Custom_Point(5.572275187409814, 23.629067361367294), Custom_Point(77.38192026286721, 93.45424274703859),
    Custom_Point(27.041940955143453, 27.940212819277278), Custom_Point(17.073394779055274, 46.860374313383815), Custom_Point(19.205944864679125, 6.930248037912978), Custom_Point(46.92171032248533, 7.646590200626324),
    Custom_Point(35.990586489634715, 22.427564433662695), Custom_Point(29.95829777676169, 16.628579762407703), Custom_Point(38.6844756621471, 77.10824669274776), Custom_Point(97.66282273521274, 76.34310704048617),
    Custom_Point(36.69305316203477, 45.35969395687809), Custom_Point(42.55143725883062, 30.915562428107222), Custom_Point(99.78264406014176, 40.201256738382554), Custom_Point(18.68049755175438, 83.22914649560032),
    Custom_Point(65.42201407997513, 16.185371345809042), Custom_Point(78.96588166233131, 98.26386090252271), Custom_Point(20.663929232870505, 67.08058588300025), Custom_Point(61.29584329704105, 12.012686281297436),
    Custom_Point(94.31357920900867, 69.41203316679598), Custom_Point(34.29169762126649, 14.024517202027331), Custom_Point(29.615905880812754, 55.69442392550044), Custom_Point(93.75095615436304, 91.42870402971394),
    Custom_Point(75.54081508068846, 36.99263883166988), Custom_Point(44.429194108716864, 39.422301011967576), Custom_Point(66.6834205337171, 2.047774725367524), Custom_Point(3.3993322038869955, 57.84646987950393),
    Custom_Point(34.61872060915816, 26.307529947641186), Custom_Point(46.56839878012116, 39.5596303588045), Custom_Point(49.123149351281015, 88.26308219878443), Custom_Point(62.825026962675736, 86.14590902172952),
    Custom_Point(31.958856319607065, 1.0883159734254022), Custom_Point(5.315451254513759, 85.38734716235128), Custom_Point(60.02276309956487, 41.137601921246045), Custom_Point(85.31899650363708, 31.16722092613482),
    Custom_Point(35.161469114284884, 11.97336965342437), Custom_Point(92.8887207726991, 46.879882152661764), Custom_Point(61.044681517303914, 19.37587065027959), Custom_Point(89.76716138741791, 23.584972704551156),
    Custom_Point(91.92782877814093, 75.64752207204053), Custom_Point(26.908903481421365, 67.69669242324743), Custom_Point(45.115847644384566, 71.50275005238788), Custom_Point(12.396047813064293, 54.82112340979728),
    Custom_Point(31.288191860406055, 62.103966004098844), Custom_Point(18.907952239277147, 81.98742268012236), Custom_Point(47.13488338436829, 77.32519417669839), Custom_Point(3.4848178595141333, 14.044536500598959),
    Custom_Point(96.87422403206132, 64.7418551943852), Custom_Point(40.33196221527668, 98.74254755073342), Custom_Point(52.202631456719864, 11.97666413160341), Custom_Point(53.712368874811965, 9.913820693442865),
    Custom_Point(67.72200156700391, 40.495477038361784), Custom_Point(29.55704337795433, 20.373285941306918), Custom_Point(83.13562475935588, 92.02671104044755), Custom_Point(11.80906451741961, 78.72031015209512),
    Custom_Point(52.45826626022807, 35.211683339977064), Custom_Point(80.74454156949894, 13.626440914703931), Custom_Point(34.133896008833695, 57.40609054743757), Custom_Point(84.4853176670685, 76.99554635437629),
    Custom_Point(42.03938798989477, 17.96436922019613), Custom_Point(48.580983012997066, 6.098739721323199), Custom_Point(55.13957733831689, 23.05093676376606), Custom_Point(50.596800059004444, 93.56086649966558),
    Custom_Point(16.09852645587, 0.03773899125076863), Custom_Point(8.910706633699238, 76.38337413619864), Custom_Point(27.068109067853907, 2.836746047720573), Custom_Point(19.197850822443563, 51.316758488337435),
    Custom_Point(84.79005598549651, 42.07401508383326), Custom_Point(65.9784567663108, 40.1997047351206), Custom_Point(0.07635123266565014, 76.89855853227596), Custom_Point(7.422230762026905, 18.22972267244363),
    Custom_Point(51.193842228764176, 99.20088426761058), Custom_Point(97.29809201950812, 8.428514816246313), Custom_Point(44.22915716359221, 45.416153264966), Custom_Point(76.43789978896946, 8.288402988183318),
    Custom_Point(60.03301512517047, 72.79615657228777), Custom_Point(19.187022136421916, 30.616697908664325), Custom_Point(98.25878762426544, 24.47688035961544), Custom_Point(23.786616035684062, 43.91568968754347),
    Custom_Point(13.413898799352708, 99.51635212516447), Custom_Point(96.72997199040603, 41.39157983401791), Custom_Point(82.86034214716209, 90.23695415395858), Custom_Point(52.07627668537993, 13.245430762198618),
    Custom_Point(69.51433519362493, 39.33241314603562), Custom_Point(21.064268083283878, 30.979682415408185), Custom_Point(31.91573820477409, 6.380320279267759), Custom_Point(59.65491353244163, 46.93915773101913),
    Custom_Point(63.74688463622711, 3.129480178473454), Custom_Point(65.9673811787689, 78.89975798778093), Custom_Point(18.925968623215383, 41.02521615838668), Custom_Point(56.453046665438, 71.25003709903181),
    Custom_Point(98.30528336064496, 24.548678989079843), Custom_Point(71.5528660624621, 39.69381956433369), Custom_Point(50.86458104336404, 11.068224720470333), Custom_Point(78.71326617368963, 66.47501587746622),
    Custom_Point(99.93862642356856, 87.73452888186625), Custom_Point(9.236622271995888, 28.559777053390857), Custom_Point(98.35105712969138, 34.86654663462097), Custom_Point(71.74239257223283, 19.845162152879748),
    Custom_Point(42.763673146961146, 76.25518573960801), Custom_Point(24.854797960052256, 25.85246258979277), Custom_Point(31.712236098369438, 36.139360792735545), Custom_Point(37.06970602736605, 12.840892502051805),
    Custom_Point(7.1754863674535985, 69.6153819893573), Custom_Point(69.4147356717294, 14.255930854826104), Custom_Point(34.85718727773352, 23.571458509321896), Custom_Point(27.112497389961643, 92.51806241939518),
    Custom_Point(4.6060518583735055, 66.14699728167427), Custom_Point(15.298790005705376, 78.93896421466604), Custom_Point(41.148644890947224, 1.1747554068161525), Custom_Point(23.52970048861478, 51.14185051416749),
    Custom_Point(10.87050674721739, 32.24214071855429), Custom_Point(43.282725269782674, 88.454924440565), Custom_Point(30.98182398469764, 22.54983878737815), Custom_Point(85.62687252964064, 32.97807829855828),
    Custom_Point(90.83240515888437, 66.26614431427225), Custom_Point(9.445444916088451, 83.79722121444826), Custom_Point(45.745023884296934, 87.04708205938272), Custom_Point(74.6464619799116, 58.750629036806814),
    Custom_Point(23.626733804588753, 16.753214643175163), Custom_Point(58.82372260272988, 27.792727729632748), Custom_Point(70.19581059055679, 18.22581115370019), Custom_Point(81.93110584504765, 83.97892908728349),
    Custom_Point(36.40585366825058, 48.50919208840947), Custom_Point(71.49403794215834, 38.18159897754907), Custom_Point(62.42467507075678, 48.29307225613051), Custom_Point(61.9363245963763, 64.77674548435444),
    Custom_Point(93.63608159761323, 51.82213554130877), Custom_Point(45.3436746747994, 86.39781687299839), Custom_Point(82.3393283383554, 36.774865619471896), Custom_Point(68.46127676247878, 6.388603208440968),
    Custom_Point(63.14405346026049, 64.67993354458415), Custom_Point(49.42097043207725, 74.43697925760624), Custom_Point(68.07095325950228, 42.30182750745443), Custom_Point(95.23300164211246, 42.388414731782476),
    Custom_Point(51.92798504859015, 89.48508563783821), Custom_Point(96.67100415118438, 36.14360461536323), Custom_Point(19.7079730014319, 94.42600753681339), Custom_Point(66.5928413020076, 31.098068708715253),
    Custom_Point(92.34035059388933, 4.248221642057115), Custom_Point(33.41211914316018, 63.36787926557037), Custom_Point(9.547042090155378, 31.205415244563216), Custom_Point(19.330065275145447, 53.500775912728706),
    Custom_Point(87.18098600534174, 76.72694417183554), Custom_Point(98.21756929940983, 66.40103566325197), Custom_Point(63.254892243611785, 62.74957250309947), Custom_Point(14.21808177415218, 60.16730213323547),
    Custom_Point(44.31103240007912, 59.41304505977947), Custom_Point(31.6267099933317, 76.6816383519653), Custom_Point(4.550297517319435, 16.986499939982803), Custom_Point(72.52524613584627, 58.29279459666004),
    Custom_Point(79.82284877366834, 86.47608179647665), Custom_Point(40.337961468991445, 9.099658457993831), Custom_Point(9.98936191226063, 47.47574884979573), Custom_Point(25.77085652775708, 89.08399178154498),
    Custom_Point(97.888390693576, 13.668778372039036), Custom_Point(41.58308143202418, 22.25536631730849), Custom_Point(69.13945537339077, 50.15078822123875), Custom_Point(61.311491411635814, 49.80075824617663),
    Custom_Point(8.652078624844005, 52.321743064921364), Custom_Point(73.31600377356413, 44.649032319441126), Custom_Point(33.213086285777436, 95.94173221121002), Custom_Point(93.9433135507388, 21.118607555882573),
    Custom_Point(95.09954699804663, 97.83053691906002), Custom_Point(35.79545405894182, 96.95635260537796), Custom_Point(48.06108291352751, 9.567077237033805), Custom_Point(38.815999038873784, 85.1331548218624),
    Custom_Point(51.08866954243205, 42.33930368699595), Custom_Point(82.35502524735463, 79.97968727876213), Custom_Point(4.570234839120024, 48.55311788996646), Custom_Point(44.34484273607402, 78.89212091552625)];
  List<Custom_Point> final_convex_hull = [];
  List<List<Custom_Point>> upperBridgePoints = [];
  List<List<Custom_Point>> lowerBridgePoints = [];
  List<Custom_Point> quadrilateral = [];
  List<List<Custom_Point>> removedPoints = [];
  List<List<List<Custom_Point>>> Ordered = [];
  int splice = 0;
  Custom_Point p = Custom_Point(0, 0);
  Custom_Point q = Custom_Point(0, 0);
  List<Custom_Point> currline = [Custom_Point(0, 0), Custom_Point(0, 0)];

  List<List<Custom_Point>> updates = [];
  List<Custom_Point> hull = [];
  List<List<Custom_Point>> removedP = [];
  List<Custom_Point> temp = [];

  double speed = 1;

  double pointx = 0;
  double pointy = 0;

  int numberOfPoints = 10; // Default number of points

  void setNumberOfPoints(String value) {
    setState(() {
      numberOfPoints = int.tryParse(value) ?? 10; // Default to 10 if invalid input
    });
    }
  void generateRandomPoints() {
    clearPoints();
    setState(() {
      data = List.generate(
        numberOfPoints,
            (index) => Custom_Point(
          Random().nextDouble()*100.toDouble(), // Random X value between 0 and 100
          Random().nextDouble()*100.toDouble(), // Random Y value between 0 and 100
        ),
      );
    });
    print("sadf");
    print(data);
  }

  void addPointx(String point) {
    setState(() {
      pointx = double.parse(point);
    });
  }

  void addPointy(String point) {
    setState(() {
      pointy = double.parse(point);
    });
  }

  void addPoint() {
    setState(() {
      data.add(Custom_Point(pointx, pointy));
    });
  }

  void runAlgo() async {
    resetwithoutclear();
    animatedPoints ap = kirkPatrick(data);
    print(ap);
    setState(() {
      Ordered = ap.Ordered;
    });

    for (int i = 0; i < Ordered.length; i++) {
      setState(() {
        upperBridgePoints.add(Ordered[i][0]);
      });

      await Future.delayed( Duration(milliseconds: 1000~/speed));
      setState(() {
        quadrilateral = Ordered[i][1];
      });
      if(Ordered[i][1].isEmpty) {
        continue;
      }

      await Future.delayed(Duration(milliseconds: 1000~/speed));
      setState(() {
        removedPoints.add(Ordered[i][2]);
      });

      await Future.delayed(Duration(milliseconds: 1000~/speed));
    }
    await Future.delayed(Duration(milliseconds: 1000~/speed));
    setState(() {
  final_convex_hull = ap.final_convex_hull;
});
  }

  void runAlgojm() async {

    print(data.length);
    animatedPointsjm jm = new animatedPointsjm([],[]);
    jm = jarvisMarch(data);
    resetwithoutclear();
    setState(() {
      updates = jm.updates;
      removedP = jm.removedP;
      hull.add(updates[0][0]);
    });

    for (int i = 0; i < updates.length; i++) {
      setState(() {
        if (i >= 3) {
          temp += removedP[i - 3];
        }
        print("kasjdklfjas");
        p = updates[i][0];
        print("jklasdf");
        currline[0] = p;
        print("mffff");
      });

      for (int j = 1; j < updates[i].length; j++) {
        setState(() {
          q = updates[i][j];
          currline[1] = q;
        });
        await Future.delayed(Duration(milliseconds: 1000~/speed));
      }

      await Future.delayed(Duration(milliseconds: 1000~/speed));
      setState(() {
        hull.add(updates[i][updates[i].length - 1]);
      });
    }
    setState(() {
      hull.add(hull[0]);
      p = q;
    });
  }

  void clearPoints() {
    setState(() {
      data = [];
      final_convex_hull = [];
      upperBridgePoints = [];
      lowerBridgePoints = [];
      quadrilateral = [];
      removedPoints = [];
      Ordered = [];
      splice = 0;
      p = Custom_Point(0, 0);
      q = Custom_Point(0, 0);
      currline = [Custom_Point(0, 0), Custom_Point(0, 0)];
      updates = [];
      hull = [];
      removedP = [];
      temp = [];
      pointx = 0;
      pointy = 0;
    });
  }

  void resetwithoutclear(){
    setState(() {
      final_convex_hull = [];
      upperBridgePoints = [];
      lowerBridgePoints = [];
      quadrilateral = [];
      removedPoints = [];
      Ordered = [];
      splice = 0;
      p = Custom_Point(0, 0);
      q = Custom_Point(0, 0);
      currline = [Custom_Point(0, 0), Custom_Point(0, 0)];
      updates = [];
      hull = [];
      removedP = [];
      temp = [];
      pointx = 0;
      pointy = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child:Padding(padding: EdgeInsets.all(20),
      child: Column(
        children: [
          SfCartesianChart(
            plotAreaBackgroundColor: kColorPlotBack,
            backgroundColor: kColorSecondary,
            margin: EdgeInsets.all(20),
            primaryXAxis: const NumericAxis(
              minimum: -10,
              maximum: 110,
                title: AxisTitle(text: 'X'),
                crossesAt: 0,
                placeLabelsNearAxisLine: false),
            primaryYAxis: const NumericAxis(
              minimum: -10,
              maximum: 110,
                title: AxisTitle(text: 'Y'),
                crossesAt: 0,
                placeLabelsNearAxisLine: false),
            series: <CartesianSeries>[
              ScatterSeries<Custom_Point, double>(
                color: kColorPoints,
                dataSource: data,
                xValueMapper: (Custom_Point data, _) => data.x as double?,
                yValueMapper: (Custom_Point data, _) => data.y,
              ),
              ...upperBridgePoints.map((List<Custom_Point> points) {
                return LineSeries<Custom_Point, double>(
                    animationDuration: 0,
                    dataSource: points,
                    xValueMapper: (Custom_Point data, _) => data.x as double?,
                    yValueMapper: (Custom_Point data, _) => data.y,
                    color: kColorGreen,
                    width: 2);
              }),
              LineSeries<Custom_Point, double>(
                animationDuration: 0,

                dataSource: quadrilateral,
                xValueMapper: (Custom_Point data, _) => data.x as double?,
                yValueMapper: (Custom_Point data, _) => data.y,
                color: kColorRed,
              ),
              ...removedPoints.map((List<Custom_Point> points) {
                return ScatterSeries<Custom_Point, double>(
                  animationDuration: 0,

                  dataSource: points,
                  xValueMapper: (Custom_Point data, _) => data.x as double?,
                  yValueMapper: (Custom_Point data, _) => data.y,
                  color: kColorRed,
                  // pointColorMapper: (Custom_Point data, _) => Colors.blue,
                  // pointBorderColorMapper: (Custom_Point data, _) => Colors.blue,
                  // borderWidth: 2
                );
              }),

              LineSeries<Custom_Point, double>(
                  animationDuration: 0,
                  dataSource: final_convex_hull,
                  xValueMapper: (Custom_Point data, _) => data.x as double?,
                  yValueMapper: (Custom_Point data, _) => data.y,
                  color: kColorConvexHull,
                  width: 4),
              LineSeries<Custom_Point, double>(
                  animationDuration: 100,
                  dataSource: hull,
                  xValueMapper: (Custom_Point data, _) => data.x as double?,
                  yValueMapper: (Custom_Point data, _) => data.y,
                  color: kColorGreen,
                  width: 2),
              LineSeries<Custom_Point, double>(
                  animationDuration: 0,
                  dataSource: [p, q],
                  xValueMapper: (Custom_Point data, _) => data.x as double?,
                  yValueMapper: (Custom_Point data, _) => data.y,
                  color: kColorRed,
                  width: 2),
              ScatterSeries<Custom_Point, double>(
                animationDuration: 0,
                dataSource: temp,
                xValueMapper: (Custom_Point data, _) => data.x as double?,
                yValueMapper: (Custom_Point data, _) => data.y,
                color: kColorRed,
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 30,
                child: TextField(
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    border: OutlineInputBorder(),
                    hintText: 'X',
                  ),
                  onChanged: (String value) {
                    addPointx(value);
                  },
                ),
              ),
              SizedBox(width: 8,),
              Container(
                width: 100,
                height: 30,
                child: TextField(
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    border: OutlineInputBorder(),
                    hintText: 'Y',
                  ),
                  onChanged: (String value) {
                    addPointy(value);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(width: 20),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 8,),
              ElevatedButton(
                onPressed: addPoint,
                child: const Text('Add Custom Point'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: clearPoints,
                child: const Text('Clear Points'),
              ),
            ],
          ),
          SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 300,
                height: 50,
                child: TextField(
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    border: OutlineInputBorder(),
                    hintText: 'Number of points (default 10)',
                  ),
                  onChanged: (String value) {
                    setNumberOfPoints(value);
                  },
                ),
              ),
              SizedBox(width: 10),
              // Button to generate random points
              ElevatedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  backgroundColor: MaterialStateProperty.all<Color>(kColorPrimary),
                ),
                onPressed: generateRandomPoints,
                child: const Text('Generate', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),

          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  backgroundColor: MaterialStateProperty.all<Color>(kColorPrimary),
                ),
                onPressed: runAlgo,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: const Text('Run Kirk Patrick Seidel Algorithm', style: TextStyle(color: Colors.white)),
                ),
              ),
              SizedBox(width: 20),
              ElevatedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  backgroundColor: MaterialStateProperty.all<Color>(kColorPrimary),
                ),
                onPressed: runAlgojm,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: const Text('Run Jarvis March Algorithm', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Container(width: 400, child:
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Speed: '),
              Slider(value: speed,
                  min: 1,
                  max: 20,
                  onChanged: (value) {
                setState(() {
                  speed = value;
                });
              }),
            ],
          )),
        ],
      )),
    );
  }
}

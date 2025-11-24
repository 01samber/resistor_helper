import 'package:flutter/material.dart';

class ListViewDemo extends StatefulWidget {
  const ListViewDemo({super.key});

  @override
  State<ListViewDemo> createState() => _ListViewDemoState();
}

class _ListViewDemoState extends State<ListViewDemo> {
  // Preset examples: each item contains title and four color band names for a 4-band resistor
  final List<Map<String, dynamic>> data = [
    {
      "Title": "Example A",
      "Bands": ["yellow", "violet", "red", "gold"], // 4.7 kΩ ±5%
    },
    {
      "Title": "Example B",
      "Bands": ["brown", "black", "orange", "gold"], // 10 kΩ ±5%
    },
    {
      "Title": "Example C",
      "Bands": ["red", "red", "brown", "brown"], // 2.2 Ω ±1%
    },
    {
      "Title": "Example D",
      "Bands": ["orange", "orange", "yellow", "gold"], // 33 x 10^4? (check)
    },
  ];

  // Color-to-digit map for resistor color code (standard)
  final Map<String, int> colorDigit = {
    'black': 0,
    'brown': 1,
    'red': 2,
    'orange': 3,
    'yellow': 4,
    'green': 5,
    'blue': 6,
    'violet': 7,
    'grey': 8,
    'white': 9,
  };

  // Multipliers (power of ten)
  final Map<String, double> multiplier = {
    'black': 1,
    'brown': 10,
    'red': 100,
    'orange': 1e3,
    'yellow': 1e4,
    'green': 1e5,
    'blue': 1e6,
    'gold': 0.1,
    'silver': 0.01,
    'white': 1e9, // rarely used but present
  };

  // Tolerance map
  final Map<String, String> tolerance = {
    'brown': '±1%',
    'red': '±2%',
    'gold': '±5%',
    'silver': '±10%',
    // default if not provided
  };

  // Helper: convert numeric ohm value to readable string (Ω, kΩ, MΩ)
  String formatOhms(double value) {
    if (value >= 1e6) {
      return (value / 1e6).toStringAsFixed(2) + ' MΩ';
    } else if (value >= 1e3) {
      return (value / 1e3).toStringAsFixed(2) + ' kΩ';
    } else {
      // show integer if it's effectively integer
      if (value == value.roundToDouble()) {
        return value.toInt().toString() + ' Ω';
      }
      return value.toStringAsPrecision(3) + ' Ω';
    }
  }

  // Core logic: given 4 color names, compute value and tolerance string
  Map<String, String> computeResistorValue(List<String> bands) {
    // Expecting at least 3: digit1, digit2, multiplier, optional tolerance
    if (bands.length < 3) {
      return {'value': 'Invalid', 'explanation': 'Not enough bands'};
    }

    // read first two digits
    int? d1 = colorDigit[bands[0]];
    int? d2 = colorDigit[bands[1]];
    double? mult = multiplier[bands[2]];

    if (d1 == null || d2 == null || mult == null) {
      return {
        'value': 'Invalid colors',
        'explanation': 'Unknown color in bands',
      };
    }

    double base = (d1 * 10 + d2) * mult;

    String tol = '';
    if (bands.length >= 4 && tolerance.containsKey(bands[3])) {
      tol = tolerance[bands[3]]!;
    } else {
      tol = '±20%'; // default if no tolerance band
    }

    String valueStr = formatOhms(base) + ' ' + tol;

    String explanation =
        'Digits: $d1 and $d2 → ${(d1 * 10 + d2)}. Multiplier = ${mult.toString()} → result ${base.toString()} ohms. Tolerance: $tol';

    return {'value': valueStr, 'explanation': explanation};
  }

  // Small widget: a colored square showing band color
  Widget bandSwatch(String colorName) {
    Color c;
    switch (colorName) {
      case 'black':
        c = Colors.black;
        break;
      case 'brown':
        c = Color(0xFF8B4513);
        break;
      case 'red':
        c = Colors.red;
        break;
      case 'orange':
        c = Colors.orange;
        break;
      case 'yellow':
        c = Colors.yellow;
        break;
      case 'green':
        c = Colors.green;
        break;
      case 'blue':
        c = Colors.blue;
        break;
      case 'violet':
        c = Colors.purple;
        break;
      case 'grey':
        c = Colors.grey;
        break;
      case 'white':
        c = Colors.white;
        break;
      case 'gold':
        c = Color(0xFFD4AF37);
        break;
      case 'silver':
        c = Color(0xFFC0C0C0);
        break;
      default:
        c = Colors.transparent;
    }

    return Container(
      width: 18,
      height: 18,
      margin: EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: c,
        border: Border.all(color: Colors.black26),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }

  // Show details in a bottom sheet (keeps the app single-page)
  void showDetails(List<String> bands, String title) {
    final result = computeResistorValue(bands);

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Row(children: bands.map((b) => bandSwatch(b)).toList()),
              SizedBox(height: 12),
              Text('Value: ${result['value']}', style: TextStyle(fontSize: 18)),
              SizedBox(height: 8),
              Text(
                'Explanation:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(result['explanation'] ?? ''),
              SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Close'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resistor Color Code Helper'),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(12),
        itemCount: data.length,
        itemBuilder: (context, index) {
          final item = data[index];
          final List<String> bands = List<String>.from(item['Bands'] as List);
          final computed = computeResistorValue(bands);

          return Column(
            children: [
              SizedBox(height: 8),
              Card(
                elevation: 3,
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 12,
                  ),
                  title: Text(item['Title'] as String),
                  subtitle: Text(computed['value'] ?? ''),
                  leading: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: bands.map((b) => bandSwatch(b)).toList(),
                  ),
                  onTap: () {
                    showDetails(bands, item['Title'] as String);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

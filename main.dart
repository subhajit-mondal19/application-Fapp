import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyAIApp());
}

class MyAIApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NelAI',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

// ---------------- Home Page ----------------
class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });

    if (index == 1) {
      // Books
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const PdfViewerPage(path: "assets/books/book1.pdf"),
        ),
      );
    } else if (index == 3) {
      // Deals
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DealsPage(),
        ),
      );
    } else if (index == 4) {
      // Settings
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SettingsPage(),
        ),
      );
    } else if (index == 0) {
      // Weather
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WeatherPage(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Top App Bar
      appBar: AppBar(
        title: const Text("NelAI"),
        actions: [
          IconButton(icon: const Icon(Icons.history), onPressed: () {}),
          IconButton(icon: const Icon(Icons.account_circle), onPressed: () {}),
        ],
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "How May I\nHelp You.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search",
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTap,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.wb_sunny), label: "Weather"),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: "Books"),
          BottomNavigationBarItem(icon: Icon(Icons.mic), label: "Speech"),
          BottomNavigationBarItem(icon: Icon(Icons.store), label: "Deals"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
        ],
      ),
    );
  }
}

// ---------------- PDF Viewer ----------------
class PdfViewerPage extends StatelessWidget {
  final String path;

  const PdfViewerPage({super.key, required this.path});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Book PDF")),
      body: PdfView(
        controller: PdfController(
          document: PdfDocument.openAsset(path),
        ),
      ),
    );
  }
}

// ---------------- Deals Page ----------------
class DealsPage extends StatelessWidget {
  final List<Map<String, dynamic>> products = [
    {"name": "Tomatoes", "quantity": "50kg"},
    {"name": "Potatoes", "quantity": "100kg"},
    {"name": "Wheat", "quantity": "200kg"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Local Deals")),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          TextEditingController priceController = TextEditingController();
          return Card(
            margin: const EdgeInsets.all(10),
            child: ListTile(
              title: Text("${products[index]['name']} - ${products[index]['quantity']}"),
              subtitle: TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Offer Price",
                ),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.send),
                onPressed: () {
                  String offer = priceController.text;
                  if (offer.isNotEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Offer ₹$offer submitted for ${products[index]['name']}")),
                    );
                  }
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

// ---------------- Settings Page ----------------
class SettingsPage extends StatefulWidget {
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String selectedLanguage = "English";
  bool darkMode = false;
  bool notifications = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Account Settings", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),

            // Email
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),

            // Password
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            const Text("Preferences", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),

            // Language Selection
            Row(
              children: [
                const Text("Language: ", style: TextStyle(fontSize: 16)),
                const SizedBox(width: 10),
                DropdownButton<String>(
                  value: selectedLanguage,
                  items: ["English", "Hindi", "Bengali", "Tamil"].map((lang) {
                    return DropdownMenuItem(
                      value: lang,
                      child: Text(lang),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        selectedLanguage = value;
                      });
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 15),

            // Theme toggle
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Dark Mode", style: TextStyle(fontSize: 16)),
                Switch(
                  value: darkMode,
                  onChanged: (value) {
                    setState(() {
                      darkMode = value;
                    });
                  },
                ),
              ],
            ),

            // Notifications toggle
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Notifications", style: TextStyle(fontSize: 16)),
                Switch(
                  value: notifications,
                  onChanged: (value) {
                    setState(() {
                      notifications = value;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 25),

            // Save button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Settings Saved! Email: ${emailController.text}, Language: $selectedLanguage")),
                  );
                },
                child: const Text("Save Settings"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// ---------------- Weather Page ----------------
class WeatherPage extends StatefulWidget {
  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  List dailyWeather = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchWeather();
  }

  Future<void> fetchWeather() async {
    String apiKey = "52d82c3cde8bc7b08ed8016151312329"; // Replace with your API key
    String city = "Kerala";
    String url =
        "https://api.openweathermap.org/data/2.5/forecast/daily?q=$city&cnt=7&appid=$apiKey&units=metric";

    try {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        Map data = json.decode(response.body);
        setState(() {
          dailyWeather = data['list'];
          loading = false;
        });
      } else {
        print("Error fetching weather");
        loading = false;
      }
    } catch (e) {
      print(e);
      loading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("7-Day Weather Forecast")),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: dailyWeather.length,
        itemBuilder: (context, index) {
          var day = dailyWeather[index];
          return ListTile(
            title: Text("Day ${index + 1}"),
            subtitle: Text(
                "Temp: ${day['temp']['day']}°C, Weather: ${day['weather'][0]['description']}"),
          );
        },
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SubscriptionScreen extends StatefulWidget {
  @override
  _SubscriptionScreenState createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> with SingleTickerProviderStateMixin {
  bool alreadyPurchased = false;
  bool freeTrialEnabled = false;
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    _loadSubscriptionStatus();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  Future<void> _loadSubscriptionStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      alreadyPurchased = prefs.getBool('alreadyPurchased') ?? false;
      freeTrialEnabled = prefs.getBool('freeTrialEnabled') ?? false;
    });
  }

  Future<void> _saveSubscriptionStatus() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('alreadyPurchased', alreadyPurchased);
    await prefs.setBool('freeTrialEnabled', freeTrialEnabled);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              "assets/sub.jpg",
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () => setState(() {
                      alreadyPurchased = !alreadyPurchased;
                      _saveSubscriptionStatus();
                    }),
                    child: Text(
                      "Already Purchased?",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    height: 32,
                    width: 188,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: TabBar(
                      controller: tabController,
                      labelColor: Colors.blue,
                      unselectedLabelColor: Colors.white,
                      indicator: BoxDecoration(
                        color: Color(0xff322828),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      tabs: [
                        Tab(text: "Monthly"),
                        Tab(text: "Yearly"),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Write and speak in many languages like a PRO',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: TabBarView(
                      controller: tabController,
                      children: [
                        SubscriptionDetails(plan: 'Monthly', price: 'EGP 499.99/month'),
                        SubscriptionDetails(plan: 'Yearly', price: 'EGP 4,999.99/year'),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Not sure yet?',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              'Enable Free Trial',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        Transform.scale(
                          scale: 1.2,
                          child: Switch(
                            value: freeTrialEnabled,
                            onChanged: (value) {
                              setState(() {
                                freeTrialEnabled = value;
                                _saveSubscriptionStatus();
                              });
                            },
                            activeColor: Colors.yellow,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => _handleContinue(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[900],
                      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 50),
                      textStyle: TextStyle(fontSize: 18),
                    ),
                    child: Text(
                      'Continue',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleContinue() {
    if (freeTrialEnabled) {
      Navigator.pushReplacementNamed(context, '/text');
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Confirm Purchase'),
          content: Text('Are you sure you want to purchase the ${tabController.index == 1 ? "Yearly" : "Monthly"} plan?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  alreadyPurchased = true;
                  _saveSubscriptionStatus();
                });
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/text');
              },
              child: Text('Purchase'),
            ),
          ],
        ),
      );
    }
  }
}

class SubscriptionDetails extends StatelessWidget {
  final String plan;
  final String price;

  SubscriptionDetails({required this.plan, required this.price});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.blue.shade700,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.yellow,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                'POPULAR',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Astro AI Translator Pro',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 5),
            Text(
              'Get unlimited access to voice and camera translation.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
            SizedBox(height: 10),
            Text(
              price,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:type_fast/screens/typing_test/typing_test_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _totalPages = 5;

  // Define the theme colors
  static const Color primaryColor = Color(0xFFDBEAF9);
  static const Color accentColor = Color(0xFF3297FD);
  static const Color textLight = Color(0xFF6C7589);
  static const Color backgroundLight = Color(0xFFF8FCFF);

  final List<Map<String, dynamic>> _onboardingData = [
    {
      'title': 'Master Your Typing Skills!',
      'description':
          'Take your typing speed & accuracy to the next level! Whether you’re a student, programmer, writer, or just love typing—this app will turn you into a keyboard ninja!',
      'animation': 'assets/animations/keyboard_typing.json',
      'listItems': [
        {
          'text': 'Train like a pro & type faster than ever',
          'icon': Icons.speed
        },
        {
          'text': 'Works seamlessly with OTG & Bluetooth keyboards',
          'icon': Icons.bluetooth
        },
        {
          'text': 'Perfect for students, professionals & typists',
          'icon': Icons.person
        },
        {
          'text': 'No lag, no ads—just pure typing practice',
          'icon': Icons.block
        },
        {
          'text': 'Optimized for Android, smooth & lightweight',
          'icon': Icons.android
        },
      ],
    },
    {
      'title': 'Choose Your Challenge!',
      'description':
          'No boring typing drills here! Push yourself with dynamic challenges. Pick from Easy, Medium, or Hard modes, and practice the most commonly used words in real-world typing.',
      'animation': 'assets/animations/practice_levels.json',
      'listItems': [
        {
          'text': 'Easy, Medium, Hard—pick your battle!',
          'icon': Icons.fitness_center
        },
        {
          'text': 'Train with the Top 200, 500, or 1000 words',
          'icon': Icons.sort
        },
        {
          'text': 'Custom practice sessions tailored to you',
          'icon': Icons.settings
        },
        {
          'text': 'Fun & engaging typing exercises',
          'icon': Icons.videogame_asset
        },
        {
          'text': 'Restart & refresh anytime—never stop improving',
          'icon': Icons.refresh
        },
      ],
    },
    {
      'title': 'Track Your Progress & Improve!',
      'description':
          'You can’t improve what you don’t measure! Get **real-time insights** into your typing speed, accuracy, and overall progress. See how you’re improving over time!',
      'animation': 'assets/animations/statistics_chart.json',
      'listItems': [
        {'text': 'Live speed & accuracy tracking', 'icon': Icons.bar_chart},
        {
          'text': 'See how much you’ve improved daily',
          'icon': Icons.trending_up
        },
        {
          'text': 'Personalized feedback on weak areas',
          'icon': Icons.psychology
        },
        {
          'text': 'Compare past & present scores for motivation',
          'icon': Icons.timeline
        },
        {
          'text': 'Stay motivated with daily & weekly goals',
          'icon': Icons.emoji_events
        },
      ],
    },
    {
      'title': 'Smart Practice Reminders',
      'description':
          'Consistency is the key to mastery! Set reminders that fit your schedule and receive exclusive pro tips to **type smarter, not harder**!',
      'animation': 'assets/animations/notifications.json',
      'listItems': [
        {
          'text': 'Custom reminders—never miss a session!',
          'icon': Icons.calendar_today
        },
        {
          'text': 'Daily tips to improve typing efficiency',
          'icon': Icons.lightbulb_outline
        },
        {
          'text': 'Practice streaks—build a typing habit!',
          'icon': Icons.local_fire_department
        },
        {
          'text': 'Stay consistent & reach your typing goals',
          'icon': Icons.repeat
        },
        {
          'text': 'Challenge friends & beat your own records',
          'icon': Icons.group
        },
      ],
    },
    {
      'title': 'Achieve Your Typing Goals!',
      'description':
          'This isn’t just another typing app—it’s a **powerful skill booster**! Whether you want to break speed records or just type comfortably, this is the only tool you need!',
      'animation': 'assets/animations/rocket_launch.json',
      'listItems': [
        {
          'text': 'More features than online typing test websites',
          'icon': Icons.web
        },
        {
          'text': 'Fast. Efficient. Pro-level typing trainer',
          'icon': Icons.flash_on
        },
        {
          'text': 'Challenge yourself to beat your own best!',
          'icon': Icons.flag
        },
        {
          'text': 'Level up your typing like a true professional',
          'icon': Icons.workspace_premium
        },
        {
          'text': 'Join thousands of users mastering their typing!',
          'icon': Icons.people
        },
      ],
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _totalPages - 1) {
      _pageController.animateToPage(
        _currentPage + 1,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutQuint,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.animateToPage(
        _currentPage - 1,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutQuint,
      );
    }
  }

  Future<void> _completeOnboarding() async {
    // Mark onboarding as completed
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboardingCompleted', true);

    // Navigate to the main app
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const TypingTestScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get screen size for responsive design
    final Size screenSize = MediaQuery.of(context).size;
    final double screenHeight = screenSize.height;
    final double screenWidth = screenSize.width;

    // Responsive text scale factor
    final double scaleFactor = MediaQuery.textScalerOf(context).scale(1.0);

    // Responsive sizing
    final double headerPadding = screenHeight * 0.02;
    final double pagePadding = screenWidth * 0.06;
    final double animationHeight = screenHeight * 0.22;

    return Scaffold(
      backgroundColor: backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            // Skip button and page indicator row
            Padding(
              padding: EdgeInsets.fromLTRB(
                  pagePadding, headerPadding, pagePadding, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Page indicators
                  Row(
                    children: List.generate(
                      _totalPages,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.only(right: 6),
                        height: 8,
                        width: _currentPage == index ? 24 : 8,
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? accentColor
                              : primaryColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),

                  // Page number indicator positioned in header
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDBEAF9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${_currentPage + 1}/$_totalPages',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF3297FD),
                      ),
                    ),
                  ),

                  // Skip button
                  TextButton(
                    onPressed: _completeOnboarding,
                    style: TextButton.styleFrom(
                      foregroundColor: accentColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                    child: Row(
                      children: [
                        const Text(
                          'Skip',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.arrow_forward_rounded,
                          size: 16,
                          color: accentColor,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Main content (Page View)
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                itemCount: _onboardingData.length,
                itemBuilder: (context, index) {
                  return OnboardingPage(
                    title: _onboardingData[index]['title'],
                    description: _onboardingData[index]['description'],
                    animationPath: _onboardingData[index]['animation'],
                    listItems: _onboardingData[index]['listItems'],
                    animationHeight: animationHeight,
                    screenWidth: screenWidth,
                    textScaleFactor: scaleFactor,
                  );
                },
              ),
            ),

            // Navigation buttons
            Container(
              padding: EdgeInsets.fromLTRB(
                  pagePadding, 0, pagePadding, screenHeight * 0.04),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back button - hidden on first page
                  _currentPage > 0
                      ? InkWell(
                          onTap: _previousPage,
                          borderRadius: BorderRadius.circular(50),
                          child: Container(
                            padding: EdgeInsets.all(screenWidth * 0.04),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.arrow_back_rounded,
                              color: textLight,
                            ),
                          ),
                        )
                      : SizedBox(width: screenWidth * 0.12),

                  // Next/Start button
                  InkWell(
                    onTap: _nextPage,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.08,
                        vertical: screenHeight * 0.018,
                      ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF5EAAFF), Color(0xFF3297FD)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color:
                                const Color(0xFF3297FD).withValues(alpha: 0.3),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _currentPage == _totalPages - 1
                                ? 'Start Typing'
                                : 'Next',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16 * scaleFactor,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                          SizedBox(width: screenWidth * 0.02),
                          const Icon(
                            Icons.arrow_forward_rounded,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final String title;
  final String description;
  final String animationPath;
  final List<Map<String, dynamic>> listItems;
  final double animationHeight;
  final double screenWidth;
  final double textScaleFactor;

  const OnboardingPage({
    super.key,
    required this.title,
    required this.description,
    required this.animationPath,
    required this.listItems,
    required this.animationHeight,
    required this.screenWidth,
    required this.textScaleFactor,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate responsive parameters
    final double horizontalPadding = screenWidth * 0.06;
    final double itemSpacing = screenWidth * 0.04;
    final double iconSize = screenWidth * 0.048;

    // Adapt number of list items based on screen size
    final int visibleItems = MediaQuery.of(context).size.height < 600 ? 3 : 5;
    final listItemsToShow = listItems.take(visibleItems).toList();

    return LayoutBuilder(builder: (context, constraints) {
      // Adjust title font size based on available width
      final double titleFontSize = constraints.maxWidth < 360 ? 22 : 26;
      final double listItemFontSize = constraints.maxWidth < 360 ? 14 : 16;

      return SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: constraints.maxHeight * 0.02),

              // Animation with background effect
              Container(
                height: animationHeight,
                width: double.infinity,
                margin:
                    EdgeInsets.symmetric(horizontal: horizontalPadding * 0.5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFDBEAF9).withValues(alpha: 0.7),
                      blurRadius: 30,
                      spreadRadius: 5,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Main animation
                    Lottie.asset(
                      animationPath,
                      fit: BoxFit.contain,
                      height: animationHeight * 0.9,
                      width: constraints.maxWidth * 0.8,
                      repeat: true,
                      animate: true,
                    ),
                  ],
                ),
              ),

              SizedBox(height: constraints.maxHeight * 0.04),

              // Title with gradient highlight
              Container(
                margin:
                    EdgeInsets.symmetric(horizontal: horizontalPadding * 0.5),
                child: ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [Color(0xFF2A2D34), Color(0xFF4A6580)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ).createShader(bounds),
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: titleFontSize * textScaleFactor,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1.2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),

              SizedBox(height: constraints.maxHeight * 0.025),

              // Feature List Items with scrollable container if needed
              ...List.generate(
                listItemsToShow.length,
                (index) => Padding(
                  padding: EdgeInsets.only(bottom: itemSpacing),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all(screenWidth * 0.02),
                        decoration: BoxDecoration(
                          color: const Color(0xFFDBEAF9),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          listItemsToShow[index]['icon'],
                          color: const Color(0xFF3297FD),
                          size: iconSize,
                        ),
                      ),
                      SizedBox(width: itemSpacing),
                      Expanded(
                        child: Text(
                          listItemsToShow[index]['text'],
                          style: TextStyle(
                            fontSize: listItemFontSize * textScaleFactor,
                            color: const Color(0xFF6C7589),
                            height: 1.4,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

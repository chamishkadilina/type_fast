// lib/providers/typing_test_provider.dart
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../constants/word_list.dart';
import '../widgets/result_dialog.dart';
import '../main.dart';

class TypingTestProvider extends ChangeNotifier {
  final List<String> currentWords = [];
  final List<bool> wordStatus = [];
  int currentWordIndex = 0;
  Timer? _timer;
  int secondsRemaining = 60;
  bool isTestActive = false;
  final int wordsPerLine = 12;
  String currentTypedWord = '';
  bool isFirstWord = true;
  bool isCurrentWordCorrect = true;

  // Statistics
  int correctWords = 0;
  int wrongWords = 0;
  int totalKeystrokes = 0;
  List<bool> completedWordStatuses = [];

  TypingTestProvider() {
    generateNewWordList();
  }

  void generateNewWordList() {
    currentWords.clear();
    wordStatus.clear();
    var random = Random();

    for (int i = 0; i < wordsPerLine * 2; i++) {
      currentWords.add(
        defaultWordList[random.nextInt(defaultWordList.length)],
      );
      wordStatus.add(false);
    }
    notifyListeners();
  }

  void startTest() {
    _timer?.cancel();
    secondsRemaining = 60;
    currentWordIndex = 0;
    currentTypedWord = '';
    isFirstWord = true;
    isTestActive = false;
    _resetStats();

    // Reset word status
    wordStatus.fillRange(0, wordStatus.length, false);

    isCurrentWordCorrect = true;
    notifyListeners();
  }

  void restartTest() {
    _timer?.cancel();
    secondsRemaining = 60;
    currentWordIndex = 0;
    currentTypedWord = '';
    isFirstWord = true;
    isTestActive = false;
    _resetStats();

    // Generate new words for restart
    generateNewWordList();

    isCurrentWordCorrect = true;
    notifyListeners();
  }

  void checkWord(String value) {
    if (!isTestActive && value.isNotEmpty) {
      isTestActive = true;
      _startTimer();
    }

    if (!isTestActive || currentWordIndex >= currentWords.length) return;

    // Track keystrokes
    if (value.length > currentTypedWord.length) {
      totalKeystrokes++;
    }

    String targetWord = currentWords[currentWordIndex];

    if (value.endsWith(' ')) {
      String typedWord = value.trim();

      if (typedWord.isNotEmpty) {
        bool isCorrect = typedWord == targetWord;
        wordStatus[currentWordIndex] = isCorrect;
        completedWordStatuses.add(isCorrect);

        if (isCorrect) {
          correctWords++;
        } else {
          wrongWords++;
        }

        currentWordIndex++;
        isFirstWord = false;
        isCurrentWordCorrect = true; // Reset for next word

        if (currentWordIndex >= currentWords.length) {
          generateNewWordList();
          currentWordIndex = 0;
        }
      }
    } else {
      currentTypedWord = value;

      if (value.isNotEmpty) {
        // Update current word typing status
        isCurrentWordCorrect = targetWord.startsWith(value);
        wordStatus[currentWordIndex] = isCurrentWordCorrect;
      } else {
        isCurrentWordCorrect = true; // Reset when empty
      }
    }

    notifyListeners();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining > 0) {
        secondsRemaining--;
        notifyListeners();
      } else {
        endTest();
      }
    });
  }

  void endTest() {
    _timer?.cancel();
    _timer = null;
    isTestActive = false;

    // Show result dialog
    if (navigatorKey.currentContext != null) {
      showDialog(
        context: navigatorKey.currentContext!,
        barrierDismissible: false,
        builder: (context) => ResultDialog(
          wpm: correctWords,
          keystrokes: totalKeystrokes,
          accuracy: correctWords > 0
              ? (correctWords / (correctWords + wrongWords) * 100)
                  .toStringAsFixed(2)
              : "0",
          correctWords: correctWords,
          wrongWords: wrongWords,
        ),
      );
    }

    notifyListeners();
  }

  void _resetStats() {
    correctWords = 0;
    wrongWords = 0;
    totalKeystrokes = 0;
    completedWordStatuses.clear();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

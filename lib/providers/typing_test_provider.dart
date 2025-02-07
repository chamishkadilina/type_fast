// lib/providers/typing_test_provider.dart
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../constants/word_list.dart';
import '../widgets/result_dialog.dart';
import '../main.dart';

enum DifficultyMode { easy, medium, hard }

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
  DifficultyMode currentMode = DifficultyMode.easy;

  // Available time durations in seconds
  final List<int> availableDurations = [
    60,
    120,
    300,
    600
  ]; // 1, 2, 5, 10 minutes
  int currentDurationIndex = 0;
  int selectedDuration = 60; // Track the actual test duration

  // Statistics
  int correctWords = 0;
  int wrongWords = 0;
  int totalKeystrokes = 0;
  List<bool> completedWordStatuses = [];

  TypingTestProvider() {
    generateNewWordList();
  }

  void cycleDuration() {
    if (!isTestActive) {
      currentDurationIndex =
          (currentDurationIndex + 1) % availableDurations.length;
      secondsRemaining = availableDurations[currentDurationIndex];
      selectedDuration = availableDurations[currentDurationIndex];
      notifyListeners();
    }
  }

  void cycleMode() {
    if (!isTestActive) {
      switch (currentMode) {
        case DifficultyMode.easy:
          currentMode = DifficultyMode.medium;
          break;
        case DifficultyMode.medium:
          currentMode = DifficultyMode.hard;
          break;
        case DifficultyMode.hard:
          currentMode = DifficultyMode.easy;
          break;
      }
      generateNewWordList();
      notifyListeners();
    }
  }

  void generateNewWordList() {
    currentWords.clear();
    wordStatus.clear();
    var random = Random();

    // Select word list based on current mode
    List<String> selectedWordList;
    switch (currentMode) {
      case DifficultyMode.easy:
        selectedWordList = easyWordList;
        break;
      case DifficultyMode.medium:
        selectedWordList = mediumWordList;
        break;
      case DifficultyMode.hard:
        selectedWordList = hardWordList;
        break;
    }

    for (int i = 0; i < wordsPerLine * 2; i++) {
      currentWords.add(
        selectedWordList[random.nextInt(selectedWordList.length)],
      );
      wordStatus.add(false);
    }
    notifyListeners();
  }

  void startTest() {
    _timer?.cancel();
    secondsRemaining = availableDurations[currentDurationIndex];
    selectedDuration = availableDurations[currentDurationIndex];
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
    secondsRemaining = availableDurations[currentDurationIndex];
    selectedDuration = availableDurations[currentDurationIndex];
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

    // Calculate WPM based on the selected duration
    double minutes = selectedDuration / 60.0;
    int calculatedWPM = (correctWords / minutes).round();

    // Show result dialog
    if (navigatorKey.currentContext != null) {
      showDialog(
        context: navigatorKey.currentContext!,
        barrierDismissible: false,
        builder: (context) => ResultDialog(
          wpm: calculatedWPM,
          keystrokes: totalKeystrokes,
          accuracy: correctWords > 0
              ? (correctWords / (correctWords + wrongWords) * 100)
                  .toStringAsFixed(2)
              : "0",
          correctWords: correctWords,
          wrongWords: wrongWords,
          testDurationInMinutes: minutes,
          currentMode: currentMode,
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

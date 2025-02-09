// lib/providers/typing_test_provider.dart
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../constants/difficulty_mode.dart';
import '../constants/word_list.dart';
import '../screens/typing_test/widgets/result_dialog.dart';
import '../main.dart';

class TypingTestProvider extends ChangeNotifier {
  final List<String> _currentWords = [];
  final List<bool> _wordStatus = [];
  int _currentWordIndex = 0;
  Timer? _timer;
  int _secondsRemaining = 60;
  bool _isTestActive = false;
  final int _wordsPerLine = 12;
  String _currentTypedWord = '';
  bool _isFirstWord = true;
  bool _isCurrentWordCorrect = true;
  DifficultyMode _currentMode = DifficultyMode.easy;

  // Available time durations in seconds
  final List<int> _availableDurations = [
    60,
    120,
    300,
    600
  ]; // 1, 2, 5, 10 minutes
  int _currentDurationIndex = 0;
  int _selectedDuration = 60;

  // Statistics
  int _correctWords = 0;
  int _wrongWords = 0;
  int _totalKeystrokes = 0;
  final List<bool> _completedWordStatuses = [];

  // Getters
  List<String> get currentWords => _currentWords;
  List<bool> get wordStatus => _wordStatus;
  int get currentWordIndex => _currentWordIndex;
  int get secondsRemaining => _secondsRemaining;
  bool get isTestActive => _isTestActive;
  int get wordsPerLine => _wordsPerLine;
  String get currentTypedWord => _currentTypedWord;
  bool get isFirstWord => _isFirstWord;
  bool get isCurrentWordCorrect => _isCurrentWordCorrect;
  DifficultyMode get currentMode => _currentMode;
  List<int> get availableDurations => _availableDurations;
  int get currentDurationIndex => _currentDurationIndex;
  int get selectedDuration => _selectedDuration;
  int get correctWords => _correctWords;
  int get wrongWords => _wrongWords;
  int get totalKeystrokes => _totalKeystrokes;
  List<bool> get completedWordStatuses => _completedWordStatuses;

  TypingTestProvider() {
    generateNewWordList();
  }

  void cycleDuration() {
    if (!_isTestActive) {
      _currentDurationIndex =
          (_currentDurationIndex + 1) % _availableDurations.length;
      _secondsRemaining = _availableDurations[_currentDurationIndex];
      _selectedDuration = _availableDurations[_currentDurationIndex];
      notifyListeners();
    }
  }

  void cycleMode() {
    if (!_isTestActive) {
      switch (_currentMode) {
        case DifficultyMode.easy:
          _currentMode = DifficultyMode.medium;
        case DifficultyMode.medium:
          _currentMode = DifficultyMode.hard;
        case DifficultyMode.hard:
          _currentMode = DifficultyMode.easy;
      }
      generateNewWordList();
      notifyListeners();
    }
  }

  void generateNewWordList() {
    _currentWords.clear();
    _wordStatus.clear();
    var random = Random();

    // Select word list based on current mode
    List<String> selectedWordList = wordLists[_currentMode.name] ?? [];

    if (selectedWordList.isEmpty) return;

    for (int i = 0; i < _wordsPerLine * 2; i++) {
      _currentWords.add(
        selectedWordList[random.nextInt(selectedWordList.length)],
      );
      _wordStatus.add(false);
    }
    notifyListeners();
  }

  void startTest() {
    _timer?.cancel();
    _secondsRemaining = _availableDurations[_currentDurationIndex];
    _selectedDuration = _availableDurations[_currentDurationIndex];
    _currentWordIndex = 0;
    _currentTypedWord = '';
    _isFirstWord = true;
    _isTestActive = false;
    _resetStats();

    // Reset word status
    _wordStatus.fillRange(0, _wordStatus.length, false);

    _isCurrentWordCorrect = true;
    notifyListeners();
  }

  void restartTest() {
    _timer?.cancel();
    _secondsRemaining = _availableDurations[_currentDurationIndex];
    _selectedDuration = _availableDurations[_currentDurationIndex];
    _currentWordIndex = 0;
    _currentTypedWord = '';
    _isFirstWord = true;
    _isTestActive = false;
    _resetStats();

    // Generate new words for restart
    generateNewWordList();

    _isCurrentWordCorrect = true;
    notifyListeners();
  }

  void checkWord(String value) {
    if (!_isTestActive && value.isNotEmpty) {
      _isTestActive = true;
      _startTimer();
    }

    if (!_isTestActive || _currentWordIndex >= _currentWords.length) return;

    // Track keystrokes
    if (value.length > _currentTypedWord.length) {
      _totalKeystrokes++;
    }

    String targetWord = _currentWords[_currentWordIndex];

    if (value.endsWith(' ')) {
      String typedWord = value.trim();

      if (typedWord.isNotEmpty) {
        bool isCorrect = typedWord == targetWord;
        _wordStatus[_currentWordIndex] = isCorrect;
        _completedWordStatuses.add(isCorrect);

        if (isCorrect) {
          _correctWords++;
        } else {
          _wrongWords++;
        }

        _currentWordIndex++;
        _isFirstWord = false;
        _isCurrentWordCorrect = true; // Reset for next word

        if (_currentWordIndex >= _currentWords.length) {
          generateNewWordList();
          _currentWordIndex = 0;
        }
      }
    } else {
      _currentTypedWord = value;

      if (value.isNotEmpty) {
        // Update current word typing status
        _isCurrentWordCorrect = targetWord.startsWith(value);
        _wordStatus[_currentWordIndex] = _isCurrentWordCorrect;
      } else {
        _isCurrentWordCorrect = true; // Reset when empty
      }
    }

    notifyListeners();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        _secondsRemaining--;
        notifyListeners();
      } else {
        endTest();
      }
    });
  }

  void endTest() {
    _timer?.cancel();
    _timer = null;
    _isTestActive = false;
    _currentTypedWord = ''; // Reset typed word

    // Calculate WPM based on the selected duration
    double minutes = _selectedDuration / 60.0;
    int calculatedWPM = (_correctWords / minutes).round();

    // Show result dialog
    if (navigatorKey.currentContext != null) {
      showDialog(
        context: navigatorKey.currentContext!,
        barrierDismissible: false,
        builder: (context) => ResultDialog(
          wpm: calculatedWPM,
          keystrokes: _totalKeystrokes,
          accuracy: _correctWords > 0
              ? (_correctWords / (_correctWords + _wrongWords) * 100)
                  .toStringAsFixed(2)
              : "0",
          correctWords: _correctWords,
          wrongWords: _wrongWords,
          testDurationInMinutes: minutes,
          currentMode: _currentMode,
        ),
      );
    }

    notifyListeners();
  }

  void _resetStats() {
    _correctWords = 0;
    _wrongWords = 0;
    _totalKeystrokes = 0;
    _completedWordStatuses.clear();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

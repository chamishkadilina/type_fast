// lib/screens/typing_test/widgets/typing_input.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:type_fast/providers/theme_provider.dart';
import 'package:type_fast/providers/typing_test_provider.dart';

class TypingInput extends StatefulWidget {
  const TypingInput({super.key});

  @override
  State<TypingInput> createState() => _TypingInputState();
}

class _TypingInputState extends State<TypingInput> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Listen to changes in the provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<TypingTestProvider>(context, listen: false);
      provider.addListener(() {
        // Clear text field when timer is over or test is restarted
        if (!provider.isTestActive && _controller.text.isNotEmpty) {
          _controller.clear();
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Consumer<TypingTestProvider>(
        builder: (context, provider, _) {
          // Clear text field when mode changes
          if (!provider.isTestActive) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _controller.clear();
            });
          }

          return TextField(
            controller: _controller,
            autofocus: true,
            style: TextStyle(
              color: isDarkMode ? Colors.white : Colors.black,
            ),
            onChanged: (value) {
              provider.checkWord(value);
              if (value.endsWith(' ') && provider.isTestActive) {
                _controller.clear();
              }
            },
            decoration: InputDecoration(
              hintText: 'Start typing..',
              hintStyle: TextStyle(
                color: isDarkMode ? Colors.white54 : Colors.grey.shade500,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
              border: InputBorder.none,
            ),
          );
        },
      ),
    );
  }
}

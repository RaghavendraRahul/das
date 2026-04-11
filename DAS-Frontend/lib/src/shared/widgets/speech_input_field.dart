import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';

/// A text field with an integrated speech-to-text microphone button.
class SpeechInputField extends StatefulWidget {
  final TextEditingController controller;
  final String? hintText;
  final String? labelText;
  final int maxLines;
  final FocusNode? focusNode;
  final bool autofocus;

  const SpeechInputField({
    super.key,
    required this.controller,
    this.hintText,
    this.labelText,
    this.maxLines = 3,
    this.focusNode,
    this.autofocus = false,
  });

  @override
  State<SpeechInputField> createState() => _SpeechInputFieldState();
}

class _SpeechInputFieldState extends State<SpeechInputField>
    with SingleTickerProviderStateMixin {
  final SpeechToText _speech = SpeechToText();
  bool _isListening = false;
  bool _speechAvailable = false;
  late AnimationController _pulseController;
  String _lastRecognizedWords = '';

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _initSpeech();
  }

  Future<void> _initSpeech() async {
    _speechAvailable = await _speech.initialize(
      onError: (error) {
        debugPrint('Speech error: $error');
        setState(() {
          _isListening = false;
          _lastRecognizedWords = widget.controller.text;
        });
        _pulseController.stop();
      },
      onStatus: (status) {
        debugPrint('Speech status: $status');
        if (status == 'done' || status == 'notListening') {
          setState(() {
            _isListening = false;
            _lastRecognizedWords = widget.controller.text;
          });
          _pulseController.stop();
        }
      },
    );
    setState(() {});
  }

  void _startListening() async {
    if (!_speechAvailable) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Speech recognition not available')),
      );
      return;
    }

    setState(() {
      _isListening = true;
      _lastRecognizedWords = widget.controller.text;
    });
    _pulseController.repeat(reverse: true);

    await _speech.listen(
      onResult: _onSpeechResult,
      listenFor: const Duration(seconds: 30),
      pauseFor: const Duration(seconds: 3),
      listenOptions: SpeechListenOptions(
        cancelOnError: true,
        partialResults: true,
        listenMode: ListenMode.confirmation,
      ),
    );
  }

  void _stopListening() async {
    await _speech.stop();
    setState(() {
      _isListening = false;
      _lastRecognizedWords = widget.controller.text; // Save current text
    });
    _pulseController.stop();
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      // Update text field with recognized words (both partial and final)
      final recognizedWords = result.recognizedWords;
      if (recognizedWords.isNotEmpty) {
        // If we have previous text, append with a space
        final baseText = _lastRecognizedWords.trim();
        widget.controller.text =
            baseText.isEmpty ? recognizedWords : '$baseText $recognizedWords';

        // Move cursor to end
        widget.controller.selection = TextSelection.fromPosition(
          TextPosition(offset: widget.controller.text.length),
        );

        // If this is a final result, update the base text
        if (result.finalResult) {
          _lastRecognizedWords = widget.controller.text;
        }
      }
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _speech.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.labelText != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              widget.labelText!,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
              ),
            ),
          ),
        Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1F2937) : Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _isListening
                  ? Colors.red
                  : (isDark ? const Color(0xFF374151) : Colors.grey.shade300),
              width: _isListening ? 2 : 1,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: TextField(
                  controller: widget.controller,
                  focusNode: widget.focusNode,
                  maxLines: widget.maxLines,
                  autofocus: widget.autofocus,
                  decoration: InputDecoration(
                    hintText: widget.hintText,
                    hintStyle: TextStyle(color: Colors.grey.shade500),
                    contentPadding: const EdgeInsets.all(12),
                    border: InputBorder.none,
                  ),
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8, bottom: 8),
                child: AnimatedBuilder(
                  animation: _pulseController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _isListening
                          ? 1.0 + (_pulseController.value * 0.2)
                          : 1.0,
                      child: IconButton(
                        onPressed: _speechAvailable
                            ? (_isListening ? _stopListening : _startListening)
                            : null,
                        icon: Icon(
                          _isListening ? Icons.stop : Icons.mic,
                          color: _isListening
                              ? Colors.red
                              : (_speechAvailable ? Colors.blue : Colors.grey),
                        ),
                        tooltip: _isListening
                            ? 'Stop listening'
                            : 'Start voice input',
                        style: IconButton.styleFrom(
                          backgroundColor: _isListening
                              ? Colors.red.withAlpha(30)
                              : Colors.blue.withAlpha(20),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        if (_isListening)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  'Listening...',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.red.shade400,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

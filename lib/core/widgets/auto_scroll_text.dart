import 'package:flutter/material.dart';

class SmartAutoScrollText extends StatefulWidget {
  final String text;
  final TextStyle style;
  final double width;
  final Duration duration;

  const SmartAutoScrollText({
    Key? key,
    required this.text,
    required this.style,
    required this.width,
    this.duration = const Duration(seconds: 1),
  }) : super(key: key);

  @override
  _SmartAutoScrollTextState createState() => _SmartAutoScrollTextState();
}

class _SmartAutoScrollTextState extends State<SmartAutoScrollText>
    with SingleTickerProviderStateMixin {
  late ScrollController _scrollController;
  late AnimationController _animationController;
  bool _shouldScroll = false;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();
    _animationController = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkOverflow();
    });
  }

  void _checkOverflow() {
    final textPainter = TextPainter(
      text: TextSpan(text: widget.text, style: widget.style),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: double.infinity);

    setState(() {
      _shouldScroll = textPainter.width > widget.width;
    });

    if (_shouldScroll) {
      _startScrolling();
    }
  }

  void _startScrolling() {
    _animationController.repeat(reverse: false);
    _animationController.addListener(() {
      final maxScrollExtent = _scrollController.position.maxScrollExtent;
      final offset = maxScrollExtent * _animationController.value;
      _scrollController.jumpTo(offset);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: 30,
      child: _shouldScroll
          ? ListView(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              children: [
                Center(
                  child: Text(
                    widget.text,
                    style: widget.style,
                  ),
                ),
              ],
            )
          : Center(
              child: Text(
                widget.text,
                style: widget.style,
              ),
            ),
    );
  }
}

// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CopyButton extends StatefulWidget {
  final String code;
  final bool isDark;

  const CopyButton({super.key, required this.code, required this.isDark});

  @override
  State<CopyButton> createState() => _CopyButtonState();
}

class _CopyButtonState extends State<CopyButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTap(context) async {
    setState(() => _isPressed = true);
    _animationController.forward();

    await Clipboard.setData(ClipboardData(text: widget.code));

    // Show enhanced snackbar
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Container(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.green[400]!.withOpacity(0.3),
                        Colors.green[300]!.withOpacity(0.2),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: Colors.green[300]!.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    Icons.check_circle_rounded,
                    color: Colors.green[200],
                    size: 20,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Code Copied Successfully!',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 0.2,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Content is now in your clipboard',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[300],
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.1,
                        ),
                      ),
                    ],
                  ),
                ),
                // Small close button
                GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.close, color: Colors.grey[400], size: 14),
                  ),
                ),
              ],
            ),
          ),
          duration: const Duration(milliseconds: 3000),
          backgroundColor: widget.isDark
              ? const Color(0xFF1F2937)
              : const Color(0xFF111827),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          margin: const EdgeInsets.only(bottom: 24, left: 16, right: 16),
          elevation: 12,
          clipBehavior: Clip.antiAlias,
        ),
      );
    }

    // Reset button state
    await Future.delayed(const Duration(milliseconds: 100));
    if (mounted) {
      _animationController.reverse();
      setState(() => _isPressed = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: InkWell(
            onTap: () => _handleTap(context),
            borderRadius: BorderRadius.circular(6),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                gradient: LinearGradient(
                  colors: _isPressed
                      ? widget.isDark
                            ? [
                                Colors.green[700]!.withOpacity(0.8),
                                Colors.green[600]!.withOpacity(0.6),
                              ]
                            : [
                                Colors.green[200]!.withOpacity(0.9),
                                Colors.green[300]!.withOpacity(0.7),
                              ]
                      : widget.isDark
                      ? [
                          Colors.grey[700]!.withOpacity(0.8),
                          Colors.grey[600]!.withOpacity(0.6),
                        ]
                      : [
                          Colors.grey[100]!.withOpacity(0.9),
                          Colors.grey[200]!.withOpacity(0.7),
                        ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border.all(
                  color: _isPressed
                      ? Colors.green[400]!.withOpacity(0.8)
                      : widget.isDark
                      ? Colors.grey[500]!.withOpacity(0.8)
                      : Colors.grey[400]!.withOpacity(0.6),
                  width: 0.8,
                ),
                boxShadow: [
                  BoxShadow(
                    color: widget.isDark
                        ? Colors.black.withOpacity(0.3)
                        : Colors.grey.withOpacity(0.2),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _isPressed ? Icons.check : Icons.copy,
                    size: 14,
                    color: _isPressed
                        ? Colors.green[300]
                        : widget.isDark
                        ? Colors.grey[200]
                        : Colors.grey[700],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _isPressed ? 'Copied!' : 'Copy',
                    style: TextStyle(
                      fontSize: 11,
                      color: _isPressed
                          ? Colors.green[300]
                          : widget.isDark
                          ? Colors.grey[200]
                          : Colors.grey[700],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// ignore_for_file: deprecated_member_use

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';

class MessageComposer extends StatefulWidget {
  final Function(String, List<String>) onSend; // Updated to include attachments
  final bool isStreaming;
  final VoidCallback onStop;

  const MessageComposer({super.key, 
    required this.onSend,
    required this.isStreaming,
    required this.onStop,
  });

  @override
  State<MessageComposer> createState() => _MessageComposerState();
}

class _MessageComposerState extends State<MessageComposer> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  bool _hasText = false;
  final List<XFile> _selectedFiles = [];

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _hasText = _controller.text.trim().isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if ((_controller.text.trim().isNotEmpty || _selectedFiles.isNotEmpty) &&
        !widget.isStreaming) {
      final attachmentPaths = _selectedFiles.map((file) => file.path).toList();
      widget.onSend(_controller.text.trim(), attachmentPaths);
      _controller.clear();
      setState(() {
        _selectedFiles.clear();
      });
      _focusNode.requestFocus();
    }
  }

  Future<void> _selectFiles() async {
    const XTypeGroup typeGroup = XTypeGroup(
      label: 'images and documents',
      extensions: <String>[
        'jpg',
        'jpeg',
        'png',
        'gif',
        'pdf',
        'txt',
        'doc',
        'docx',
      ],
    );

    final List<XFile> files = await openFiles(
      acceptedTypeGroups: <XTypeGroup>[typeGroup],
    );

    if (files.isNotEmpty) {
      setState(() {
        _selectedFiles.addAll(files);
      });
    }
  }

  void _removeFile(int index) {
    setState(() {
      _selectedFiles.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        children: [
          // Show selected files
          if (_selectedFiles.isNotEmpty) ...[
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 12),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _selectedFiles.asMap().entries.map((entry) {
                  final index = entry.key;
                  final file = entry.value;
                  final fileName = file.name;
                  final isImage = [
                    'jpg',
                    'jpeg',
                    'png',
                    'gif',
                  ].contains(fileName.split('.').last.toLowerCase());

                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceContainer,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Theme.of(
                          context,
                        ).colorScheme.outline.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isImage ? Icons.image : Icons.attach_file,
                          size: 16,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            fileName,
                            style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 6),
                        GestureDetector(
                          onTap: () => _removeFile(index),
                          child: Icon(
                            Icons.close,
                            size: 16,
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],

          // Input row
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Attachment button
              Container(
                margin: const EdgeInsets.only(right: 8),
                child: IconButton(
                  onPressed: widget.isStreaming ? null : _selectFiles,
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceContainer,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Theme.of(
                          context,
                        ).colorScheme.outline.withOpacity(0.2),
                      ),
                    ),
                    child: Icon(
                      Icons.attach_file,
                      color: widget.isStreaming
                          ? Theme.of(
                              context,
                            ).colorScheme.onSurface.withOpacity(0.3)
                          : Theme.of(context).colorScheme.primary,
                      size: 20,
                    ),
                  ),
                ),
              ),

              // Text input
              Expanded(
                child: Container(
                  constraints: const BoxConstraints(maxHeight: 120),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainer,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: Theme.of(
                        context,
                      ).colorScheme.outline.withOpacity(0.2),
                    ),
                  ),
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    maxLines: null,
                    enabled: !widget.isStreaming,
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Message AI...',
                      hintStyle: TextStyle(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.5),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      border: InputBorder.none,
                      suffixIcon: widget.isStreaming
                          ? Container(
                              margin: const EdgeInsets.only(right: 8),
                              child: IconButton(
                                onPressed: widget.onStop,
                                icon: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.error,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    Icons.stop,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              ),
                            )
                          : (_hasText || _selectedFiles.isNotEmpty)
                          ? Container(
                              margin: const EdgeInsets.only(right: 8),
                              child: IconButton(
                                onPressed: _sendMessage,
                                icon: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    Icons.arrow_upward,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              ),
                            )
                          : null,
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

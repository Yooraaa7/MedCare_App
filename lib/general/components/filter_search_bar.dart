import 'package:flutter/material.dart';

class FilterSearchBar extends StatefulWidget {
  final ValueChanged<String> onChanged;
  final String hintText;
  final Color? bgColor;
  final Widget? trialing;

  const FilterSearchBar({
    super.key,
    required this.onChanged,
    this.bgColor,
    this.trialing,
    this.hintText = 'Search anything...',
  });

  @override
  State<FilterSearchBar> createState() => _FilterSearchBarState();
}

class _FilterSearchBarState extends State<FilterSearchBar> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final effectiveBgColor = widget.bgColor ?? Theme.of(context).colorScheme.secondary;

    return SearchBar(
      controller: _controller, 
      padding: const WidgetStatePropertyAll<EdgeInsets>(
        EdgeInsets.fromLTRB(16, 0, 10, 0),
      ),
      backgroundColor: WidgetStatePropertyAll(effectiveBgColor),
      hintText: widget.hintText,
      textStyle: WidgetStatePropertyAll(Theme.of(context).textTheme.bodyMedium),
      elevation: const WidgetStatePropertyAll(4),
      onChanged: (value) {
        widget.onChanged(value);
      },
      leading: const Icon(
        Icons.search,
        size: 20,
      ),
      trailing: [
        ValueListenableBuilder(
          valueListenable: _controller,
          builder: (context, value, child) {
            // Check if user has typed anything
            final bool hasText = value.text.isNotEmpty;

            return hasText
                ? IconButton(
                    icon: const Icon(Icons.clear, size: 20),
                    onPressed: () {
                      _controller.clear();
                      widget.onChanged('');
                    },
                  )
                : (widget.trialing ?? const SizedBox.shrink());
          },
        ),
      ],
    );
  }
}
import 'package:flutter/material.dart';
import 'daily_text.dart';

class DailyAppBar extends StatefulWidget {
  final String title;
  final ValueChanged<String>? onSearchChanged; // Agora é opcional

  const DailyAppBar({super.key, required this.title, this.onSearchChanged});

  @override
  State<DailyAppBar> createState() => _DailyHomeAppBarState();
}

class _DailyHomeAppBarState extends State<DailyAppBar> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      if (widget.onSearchChanged != null) {
        widget.onSearchChanged!(_searchController.text);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: const Icon(
                Icons.menu_outlined,
                size: 30,
              ),
            ),
            _isSearching
                ? Expanded(
              child: TextField(
                controller: _searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Procurar por pacientes',
                  border: InputBorder.none,
                ),
                onSubmitted: (value) {
                  setState(() {
                    _isSearching = false;
                  });
                },
              ),
            )
                : DailyText.text(widget.title).header.medium.bold,

            if (widget.onSearchChanged != null)
              IconButton(
                icon: Icon(_isSearching ? Icons.close : Icons.search, size: 36),
                onPressed: () {
                  setState(() {
                    if (_isSearching) {
                      _isSearching = false;
                      _searchController.clear();
                    } else {
                      _isSearching = true;
                    }
                  });
                },
              ),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

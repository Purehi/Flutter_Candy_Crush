import 'package:flutter/material.dart';

import '../model/combo.dart';
import '../model/tile.dart';

class AnimationComboCollapse extends StatefulWidget {
  const AnimationComboCollapse({
    super.key,
    required this.combo,
    required this.resultingTile,
    required this.onComplete,
  });

  final Combo combo;
  final VoidCallback onComplete;
  final Tile resultingTile;

  @override
  State<AnimationComboCollapse> createState() => _AnimationComboCollapseState();
}

class _AnimationComboCollapseState extends State<AnimationComboCollapse>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation animationIn;

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(duration: const Duration(milliseconds: 300), vsync: this)
          ..addListener(() {
            setState(() {});
          })
          ..addStatusListener((AnimationStatus status) {
            if (status == AnimationStatus.completed) {
              widget.onComplete();}
          });
    animationIn = CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic);
    _controller.forward(from: 0.0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double destinationX = widget.resultingTile.x!;
    final double destinationY = widget.resultingTile.y!;

    // Tiles are collapsing at the position of the resulting tile
    List<Widget> children = widget.combo.tiles.map((Tile tile) {
      return Positioned(
        left: tile.x! + (1.0 - _controller.value) * (tile.x! - destinationX),
        top: tile.y! + (1.0 - _controller.value) * (destinationY - tile.y!),
        child: Transform.scale(
          scale: 1.0 - _controller.value,
          child: tile.widget,
        ),
      );
    }).toList();

    // Display the resulting tile
    children.add(
      Positioned(
        left: destinationX,
        top: destinationY,
        child: Transform.scale(
          scale: _controller.value,
          child: widget.resultingTile.widget,
        ),
      ),
    );
    return Stack(
      children: children,
    );
  }
}

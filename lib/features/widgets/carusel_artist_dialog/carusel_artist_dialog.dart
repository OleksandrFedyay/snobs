import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:kingfishertom/features/presentation/resources/style/app.colors.dart';

class CarouselArtistDialog extends StatefulWidget {
  const CarouselArtistDialog({
    required this.artists,
    required this.initialIndex,
    required this.onPageChanged,
    super.key,
  });

  final List<Widget> artists;
  final int initialIndex;
  final ValueSetter<int> onPageChanged;

  @override
  State<CarouselArtistDialog> createState() => _CarouselArtistDialogState();
}

class _CarouselArtistDialogState extends State<CarouselArtistDialog> {
  @override
  void initState() {
    super.initState();

    widget.onPageChanged(widget.initialIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: ColoredBox(
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CarouselSlider(
              items: widget.artists,
              options: CarouselOptions(
                enableInfiniteScroll: false,
                viewportFraction: 0.92,
                onPageChanged: (int index, _) => widget.onPageChanged(index),
                height: 2 * MediaQuery.of(context).size.height / 2.8,
                initialPage: widget.initialIndex,
              ),
            ),
            const SizedBox(height: 20),
            _buildBackButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: Navigator.of(context).pop,
      child: Container(
        decoration: BoxDecoration(
          color: lightColorScheme.surfaceContainerHighest,
          border: Border.all(
            color: Colors.white24,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(50),
        ),
        padding: const EdgeInsets.all(12),
        child: Icon(
          Icons.close,
          color: lightColorScheme.tertiary,
          size: 24,
        ),
      ),
    );
  }
}

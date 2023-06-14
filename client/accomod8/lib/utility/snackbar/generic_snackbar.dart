import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class GenericSnackBarWidget extends StatelessWidget {
  final String title;
  final String message;
  final Color barColor;
  final Color symbolColor;
  final String symbol;
  const GenericSnackBarWidget({
    Key? key,
    required this.message,
    required this.title,
    required this.symbol,
    required this.barColor,
    required this.symbolColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          height: 90,
          decoration: BoxDecoration(
            //Color(0xFFC72C41)
            color: barColor,
            borderRadius: const BorderRadius.all(Radius.circular(20)),
          ),
          child: Row(
            children: [
              const SizedBox(
                width: 48,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      message,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
            ),
            child: SvgPicture.asset(
              'client/assets/snackbar_icons/bubbles.svg',
              height: 48,
              width: 40,
              colorFilter: ColorFilter.mode(symbolColor, BlendMode.src),
            ),
          ),
        ),
        Positioned(
          top: -20,
          left: 0,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SvgPicture.asset(
                'client/assets/snackbar_icons/fail.svg',
                height: 40,
              ),
              Positioned(
                top: 10,
                child: SvgPicture.asset(
                  symbol,
                  height: 16,
                  colorFilter:
                      const ColorFilter.mode(Colors.white, BlendMode.src),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
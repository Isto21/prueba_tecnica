// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CustomShimmerEffect extends StatelessWidget {
  final int listTilesCount;
  final double? height;
  final EdgeInsets? padding;
  const CustomShimmerEffect({
    super.key,
    this.height,
    this.padding,
    required this.listTilesCount,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        enabled: true,
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            children: [
              const SizedBox(
                height: 15,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: List.generate(
                  listTilesCount,
                  (index) => Padding(
                    padding: padding ??
                        const EdgeInsets.symmetric(horizontal: 26, vertical: 4),
                    child: SizedBox(
                      width: double.infinity,
                      height: height ?? 46,
                      child: const Card(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}

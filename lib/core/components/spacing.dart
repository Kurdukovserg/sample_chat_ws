import 'package:flutter/material.dart';

import '../../constants/spacings.dart';

class S extends StatelessWidget {
  const S.custom(
      this.space, {
        super.key,
      });

  const S.s0({super.key}) : space = 0.0;

  const S.s1({super.key}) : space = Sp.s1;

  const S.s2({super.key}) : space = Sp.s2;

  const S.s3({super.key}) : space = Sp.s3;

  const S.s4({super.key}) : space = Sp.s4;

  const S.s5({super.key}) : space = Sp.s5;

  const S.s6({super.key}) : space = Sp.s6;

  const S.s7({super.key}) : space = Sp.s7;

  const S.s8({super.key}) : space = Sp.s8;

  const S.s9({super.key}) : space = Sp.s9;

  const S.s16({super.key}) : space = Sp.s16;

  const S.s24({super.key}) : space = Sp.s24;

  final double space;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(dimension: space);
  }
}

class SliverS extends StatelessWidget {
  const SliverS.custom(
      this.space, {
        super.key,
      });

  const SliverS.s1({super.key}) : space = Sp.s1;

  const SliverS.s2({super.key}) : space = Sp.s2;

  const SliverS.s3({super.key}) : space = Sp.s3;

  const SliverS.s4({super.key}) : space = Sp.s4;

  const SliverS.s5({super.key}) : space = Sp.s5;

  const SliverS.s6({super.key}) : space = Sp.s6;

  const SliverS.s7({super.key}) : space = Sp.s7;

  const SliverS.s8({super.key}) : space = Sp.s8;

  const SliverS.s9({super.key}) : space = Sp.s9;

  const SliverS.s16({super.key}) : space = Sp.s16;

  const SliverS.s24({super.key}) : space = Sp.s24;


  final double space;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: S.custom(space),
    );
  }
}
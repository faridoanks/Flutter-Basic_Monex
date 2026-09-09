import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monex/core/network/no_connection_provider.dart';
import 'package:monex/core/network/connection_banner.dart';

class InternetListener extends ConsumerWidget {
  final Widget child;

  const InternetListener({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasInternet = ref.watch(noConnectionProvider);
    return Column(
      children: [
        if (hasInternet == false) const ConnectionBanner(),

        Expanded(child: child),
      ],
    );
  }
}

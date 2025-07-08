import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cine_memo/presentation/widgets/common/error_display.dart';
import 'package:cine_memo/presentation/widgets/common/loading_indicator.dart';

extension AsyncValueUI<T> on AsyncValue<T> {
  Widget toWidget(Widget Function(T data) onData) {
    return when(
      // data가 이미 정확한 타입 T로 추론되므로 형 변환이 필요 없습니다.
      data: onData,
      loading: () => const LoadingIndicator(),
      error: (e, st) => ErrorDisplay(message: e.toString()),
    );
  }
}

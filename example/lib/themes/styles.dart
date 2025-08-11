import 'package:flutter/material.dart';

/// 渐变按钮样式 - 默认
const actionButtonEnabled = LinearGradient(
    colors: [Color(0xFF49B2FF), Color(0xFF005DA0)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight);

/// 渐变按钮样式 - 不可用
const actionButtonDisabled = LinearGradient(
    colors: [Color(0x8049B2FF), Color(0x80005DA0)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight);

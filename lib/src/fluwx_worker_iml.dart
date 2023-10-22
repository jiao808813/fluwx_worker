/*
 * @Author: nanablast.orz@gmail.com
 * @Date: 2023-10-22 15:22:02
 * @LastEditors: nanablast.orz@gmail.com
 * @LastEditTime: 2023-10-22 15:23:23
 * @FilePath: /fluwx_worker/lib/src/fluwx_worker_iml.dart
 * @Description: 
 * 
 * Copyright (c) 2023 by nanablast.orz@gmail.com, All Rights Reserved. 
 */
import 'dart:async';

import 'package:flutter/services.dart';

import 'response_models.dart';

StreamController<WeChatWorkAuthResponse> _responseAuthController =
    new StreamController.broadcast();

/// Response from auth
Stream<WeChatWorkAuthResponse> get responseFromAuth =>
    _responseAuthController.stream;

final MethodChannel _channel = const MethodChannel('fluwx_worker')
  ..setMethodCallHandler(_handler);

Future<dynamic> _handler(MethodCall methodCall) {
  if ("onAuthResponse" == methodCall.method) {
    _responseAuthController
        .add(WeChatWorkAuthResponse.fromMap(methodCall.arguments));
  }

  return Future.value(true);
}

Future register({String? schema, String? corpId, String? agentId}) async {
  return await _channel.invokeMethod('registerApp', {
    'schema': schema,
    'corpId': corpId,
    'agentId': agentId,
  });
}

Future isWeChatInstalled() async {
  return await _channel.invokeMethod("isWeChatInstalled");
}

Future sendAuth(
    {String? schema, String? appId, String? agentId, String? state}) async {
  if (state == null || state.length == 0) {
    state = DateTime.now().millisecondsSinceEpoch.toString();
  }

  return await _channel.invokeMethod('sendAuth',
      {'schema': schema, 'appId': appId, 'agentId': agentId, 'state': state});
}

void dispose() {
  _responseAuthController.close();
}

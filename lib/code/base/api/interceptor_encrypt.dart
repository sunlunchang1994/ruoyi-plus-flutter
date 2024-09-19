import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter_slc_boxes/flutter/slc/common/encrypt_util.dart';
import 'package:flutter_slc_boxes/flutter/slc/common/num_util.dart';
import 'package:flutter_slc_boxes/flutter/slc/common/text_util.dart';
import 'package:flutter_slc_boxes/flutter/slc/network/api_constant.dart';
import 'package:retrofit/http.dart';

import '../api/api_config.dart';

///@Author sunlunchang
///加密拦截器
class EncryptInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    ApiConfig apiConfig = ApiConfig();
    //需要加密且是post或get方法
    dynamic applyEncrypt = options.headers[ApiConfig.KEY_APPLY_ENCRYPT];
    if ((applyEncrypt == true || applyEncrypt == "true") &&
        (options.method == HttpMethod.POST || options.method == HttpMethod.PUT)) {
      //String aesKey = generateRandomString();
      String aesKey = "11111111111111111111111111111111";
      //加密aesKey
      String encryptAes = EncryptUtil.encodeBase64(aesKey);
      dynamic rsaKeyParser = RSAKeyParser().parse(decorationPublicKey(apiConfig.rsaPublicKey));
      final publicKeyEncrypter = Encrypter(RSA(publicKey: rsaKeyParser));
      final encrypted = publicKeyEncrypter.encrypt(encryptAes);
      options.headers[ApiConfig.KEY_ENCRYPT_KEY] = encrypted.base64;

      final aesEncrypter = Encrypter(AES(Key.fromUtf8(aesKey),mode: AESMode.ecb));
      String jsonString = jsonEncode(options.data);
      String dataContent = aesEncrypter.encrypt(jsonString).base64;
      options.data = dataContent;
      //移除无用的header
      options.headers.remove(ApiConfig.KEY_APPLY_ENCRYPT);
    }
    super.onRequest(options, handler);
  }

  ///随机生成32位的字符串
  String generateRandomString() {
    final random = Random();
    final characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    String resultStr = List.generate(32, (index) => characters[random.nextInt(characters.length)]).join();
    return resultStr;
  }

  String decorationPublicKey(String publicKey) {
    String decorationPublicKey = "";
    decorationPublicKey += "-----BEGIN PUBLIC KEY-----";
    decorationPublicKey += "\n";
    decorationPublicKey += publicKey;
    decorationPublicKey += "\n";
    decorationPublicKey += "-----END PUBLIC KEY-----";
    return decorationPublicKey;
  }
}

import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:rezervujme_app/models/auth/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vrouter/vrouter.dart';

class AuthCubit extends Cubit<Auth> {
  AuthCubit() : super(Auth(token: null, user: null));

  Future<void> loadAuth() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var user = prefs.getString('user');
    if (token == null || user == null) return;
    var newState = Auth(token: token, user: User.fromJson(jsonDecode(user)));
    emit(newState);
    if (kDebugMode) {
      print(newState.token);
    }
  }

  Future<void> updateUser() async {
    var data = await Dio().get('${dotenv.get('APP_URL')}/api/v1/auth/info',
        options: Options(headers: {'Authorization': 'Bearer ${state.token}'}));
    var newState = Auth(
        token: state.token, user: User.fromJson(data.data['data']['user']));
    emit(newState);
  }

  Future<void> requestCode(
      BuildContext context, PhoneNumber phoneNumber) async {
    try {
      var doesExist = (await Dio().post(
              '${dotenv.get('APP_URL')}/api/v1/auth/sms/check',
              data: {'phone_number': phoneNumber.phoneNumber}))
          .data['does_exist'] as bool;

      if (doesExist) {
        await Dio().post(
            '${dotenv.get('APP_URL')}/api/v1/auth/sms/login/request',
            data: {'phone_number': phoneNumber.phoneNumber});
        context.vRouter.to('/intro/login/${phoneNumber.phoneNumber}');
      } else {
        await Dio().post(
            '${dotenv.get('APP_URL')}/api/v1/auth/sms/register/request',
            data: {'phone_number': phoneNumber.phoneNumber});
        context.vRouter.to('/intro/register/${phoneNumber.phoneNumber}');
      }
    } catch (err) {
      if (kDebugMode) {
        print(err);
      }
      if (err is DioError) {
        if (err.response?.data['error'] != null) {
          var snackBar = SnackBar(
            content: Text(err.response?.data['error']),
            duration: const Duration(seconds: 1),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        } else {
          var snackBar = const SnackBar(
            content: Text('An unknown error has occurred.'),
            duration: Duration(seconds: 1),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      }
    }
  }

  Future<void> register(BuildContext context, String phoneNumber, String pin,
      String email, String name, String surname) async {
    try {
      var data = await Dio().post(
          '${dotenv.get('APP_URL')}/api/v1/auth/sms/register/register',
          data: {
            "phone_number": phoneNumber.trim(),
            "auth_code": pin.trim(),
            "email": email.trim(),
            "name": name.trim(),
            "surname": surname.trim()
          });
      if (kDebugMode) {
        print(data.data);
      }
      Auth newState = Auth.fromJson(data.data);
      emit(newState);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', state.token ?? '');
      prefs.setString('user', jsonEncode(state.user?.toJson()));
      context.vRouter.to('/tabs');
    } catch (err) {
      if (kDebugMode) {
        print(err);
      }
      if (err is DioError) {
        if (err.response?.data['error'] != null) {
          var snackBar = SnackBar(
            content: Text(err.response?.data['error']),
            duration: const Duration(seconds: 1),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        } else {
          var snackBar = const SnackBar(
            content: Text('An unknown error has occurred.'),
            duration: Duration(seconds: 1),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      }
    }
  }

  Future<void> login(
      BuildContext context, String phoneNumber, String pin) async {
    try {
      var data = await Dio()
          .post('${dotenv.get('APP_URL')}/api/v1/auth/sms/login/login', data: {
        "phone_number": phoneNumber.trim(),
        "auth_code": pin.trim(),
      });
      if (kDebugMode) {
        print(data.data);
      }
      Auth newState = Auth.fromJson(data.data);
      emit(newState);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', state.token ?? '');
      prefs.setString('user', jsonEncode(state.user?.toJson()));
      context.vRouter.to('/tabs');
    } catch (err) {
      if (kDebugMode) {
        print(err);
      }
      if (err is DioError) {
        if (err.response?.data['error'] != null) {
          var snackBar = SnackBar(
            content: Text(err.response?.data['error']),
            duration: const Duration(seconds: 1),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        } else {
          var snackBar = const SnackBar(
            content: Text('An unknown error has occurred.'),
            duration: Duration(seconds: 1),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      }
    }
  }

  bool isLoggedIn() {
    return state.token != null && state.user != null;
  }

  Future<void> logout(BuildContext context) async {
    emit(Auth(token: null, user: null));
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    prefs.remove('user');
    context.vRouter.to('/intro');
    try {
      await Dio().post('${dotenv.get('APP_URL')}/api/v1/auth/invalidate',
          options:
              Options(headers: {'Authorization': 'Bearer ${state.token}'}));
    } catch (err) {
      if (kDebugMode) {
        print(err);
      }
    }
  }
}

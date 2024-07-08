import 'dart:async';

import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sai_track/Installation/model/installation.dart';
import 'package:sai_track/User/model/user.dart';
import 'package:sai_track/User/repository/user_repository.dart';

class UserBloc implements Bloc {
  final userRepository = UserRepository();

  StreamController<User> userSelectedStreamController = BehaviorSubject();
  Stream get userSelectedStream => userSelectedStreamController.stream;
  StreamSink get userSelectedSink => userSelectedStreamController.sink;

  StreamController<Installation> installationSelectedStreamController = BehaviorSubject();
  Stream get installationSelectedStream => installationSelectedStreamController.stream;
  StreamSink get installationSelectedSink => installationSelectedStreamController.sink;

  Future<User> signIn(User user) {
    return userRepository.getUser(user);
  }

  @override
  void dispose() {
    userSelectedStreamController.close();
    installationSelectedStreamController.close();
  }
}

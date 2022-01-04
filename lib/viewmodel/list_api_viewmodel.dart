import 'package:flutter/foundation.dart';
import 'package:sample/model/user_model.dart';
import 'package:sample/repository/local_db_repository.dart';
import 'package:sample/service/list_api_service.dart';

enum LoadingStatus { completed, searching, empty, sucess, error }

class ListApiViewModel with ChangeNotifier {
  LoadingStatus loadingStatus = LoadingStatus.searching;
  List<UserViewModel> user_data = [];
  RepositoryUsers dbUser = new RepositoryUsers();

  Future getUserSummary() async {
    this.loadingStatus = LoadingStatus.searching;
    //notifyListeners();
    List<UserModel> userSummary = await ListApiService().getUserData();

    this.user_data =
        userSummary.map((data) => UserViewModel(model: data)).toList();

    if (this.user_data.isEmpty) {
      this.loadingStatus = LoadingStatus.empty;
    } else if (user_data != null) {
      this.loadingStatus = LoadingStatus.completed;
    } else {
      this.loadingStatus == LoadingStatus.error;
    }

    notifyListeners();
  }

  Future onDelete(int id) async {
    dbUser.deleteUsers(id);
    List<UserModel> userSummary = await ListApiService().getUserData();

    this.user_data =
        userSummary.map((data) => UserViewModel(model: data)).toList();
    notifyListeners();
  }

  Future addUser(String title, String body) async {
    UserModel model = new UserModel(body: body, title: title);
    dbUser.insertUsers(model);
    List<UserModel> userSummary = await ListApiService().getUserData();

    this.user_data =
        userSummary.map((data) => UserViewModel(model: data)).toList();
    notifyListeners();
  }
}

class UserViewModel {
  UserModel _userData;

  UserViewModel({UserModel? model}) : _userData = model!;

  String get title {
    return _userData.title!;
  }

  int get userId {
    return _userData.userId!;
  }

  String get body {
    return _userData.body!;
  }

  int get id {
    return _userData.id!;
  }
}

import 'package:sample/model/user_model.dart';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:sample/repository/local_db_repository.dart';

class ListApiService {
  List<UserModel> _userData = [];
  RepositoryUsers repositoryCliente = RepositoryUsers();
  Future<List<UserModel>> getUserData() async {
    this._userData = await repositoryCliente.getUsers();
    if (_userData.isEmpty) {
      var dio = Dio();

      String url = 'https://jsonplaceholder.typicode.com/posts';
      final response = await dio.get(url);

      if (response.statusCode == 200) {
        Iterable result = response.data;
        _userData = List<UserModel>.from(
            result.map((model) => UserModel.fromJson(model)));
        for (UserModel data in _userData) {
          UserModel model = new UserModel(
              userId: data.id, title: data.title, body: data.body);
          await repositoryCliente.insertUsers(model);
          print('userrs inserted-----------');
        }
        return _userData;
      } else {
        throw Exception("Failled");
      }
    } else {
      print('user data is not emplty---------');
    }
    return _userData;
  }
}

import 'package:dio/dio.dart';
import 'package:shop/models/user_model.dart';
import 'package:shop/models/app_response.dart';
import 'package:shop/repositories/core/endpoints.dart';
import 'package:shop/repositories/user/base_user_repository.dart';
import 'package:shop/utils/utils.dart';

class UserRepository extends BaseUserRepository {
  final Dio _dioClient;

  UserRepository({
    Dio? dioClient,
  }) : _dioClient = dioClient ?? DioClient().instance;

  @override
  Future<AppResponse<List<UserEntity>>> getUsers() async {
    final response = await _dioClient.get(Endpoints.getUsers);

    return AppResponse<List<UserEntity>>.fromJson(
      response.data,
      (dynamic json) {
        if (response.data['success'] && json != null) {
          return (json as List<dynamic>)
              .map((e) => UserEntity.fromJson(e))
              .toList();
        }
        return [];
      },
    );
  }
}
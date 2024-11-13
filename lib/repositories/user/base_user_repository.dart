import 'package:shop/models/models.dart';

abstract class BaseUserRepository {
  Future<AppResponse<List<UserEntity>>> getUsers();
}
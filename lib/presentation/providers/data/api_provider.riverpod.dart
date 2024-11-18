import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prueba_tecnica/data/database/database.dart';
import 'package:prueba_tecnica/data/datasources/api.dart';
import 'package:prueba_tecnica/domain/repositories/local/local_repository.dart';
import 'package:prueba_tecnica/domain/repositories/remote/remote_repository.dart';

final apiProvider = StateProvider<RemoteRepository>((ref) {
  return ApiConsumer.getInstance();
});

final localRepositoryProvider = StateProvider<LocalRepository>((ref) {
  return IsarService();
});

import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:meghana_exam6_june/data/repositories/auth_repository_imp.dart';
import 'package:meghana_exam6_june/data/repositories/photo_repository_imp.dart';
import 'package:meghana_exam6_june/data/repositories/post_repository_imp.dart';
import 'package:meghana_exam6_june/data/repositories/user_repository_imp.dart';
import 'package:meghana_exam6_june/presentation/auth/bloc/auth_bloc.dart';
import 'package:meghana_exam6_june/presentation/camera/bloc/camera_bloc.dart';
import 'package:meghana_exam6_june/presentation/gallery/bloc/gallery_bloc.dart';
import 'package:meghana_exam6_june/presentation/posts/bloc/post_bloc.dart';
import 'package:meghana_exam6_june/presentation/users/bloc/user_bloc.dart';
import '../../data/datasources/auth_datasource.dart';
import '../../data/datasources/photo_datasource.dart';
import '../../data/datasources/post_datasource.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/photo_repository.dart';
import '../../domain/repositories/post_repository.dart';
import '../../domain/usecases/auth_usecases.dart';
import '../../domain/usecases/photo_usecases.dart';
import '../../domain/usecases/post_usecases.dart';


final sl = GetIt.instance;

Future<void> setupDI() async {

  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
  sl.registerLazySingleton(() => FirebaseStorage.instance);

  sl.registerLazySingleton(() {
    final dio = Dio();
    dio.options
      ..connectTimeout = const Duration(seconds: 10)
      ..receiveTimeout = const Duration(seconds: 10);
    return dio;
  });

  sl.registerLazySingleton<AuthDataSource>(() => AuthDataSourceImpl(sl(), sl()));
  sl.registerLazySingleton<PhotoDataSource>(() => PhotoDataSourceImpl(sl()));
  sl.registerLazySingleton<PostDataSource>(() => PostDataSourceImpl(sl()));

  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));
  sl.registerLazySingleton<PhotoRepository>(() => PhotoRepositoryImpl(sl()));
  sl.registerLazySingleton<PostRepository>(() => PostRepositoryImpl(sl()));

  sl.registerLazySingleton(() => SignInUseCase(sl()));
  sl.registerLazySingleton(() => SignUpUseCase(sl()));
  sl.registerLazySingleton(() => SignOutUseCase(sl()));
  sl.registerLazySingleton(() => WatchAuthUseCase(sl()));
  sl.registerLazySingleton(() => UploadPhotoUseCase(sl()));
  sl.registerLazySingleton(() => GetUserPhotosUseCase(sl()));
  sl.registerLazySingleton(() => DeletePhotoUseCase(sl()));
  sl.registerLazySingleton(() => GetPostsUseCase(sl()));
  sl.registerLazySingleton(() => GetPostUseCase(sl()));

  sl.registerFactory(() => AuthBloc(
        signIn: sl(), signUp: sl(), signOut: sl(), watchAuth: sl()));
  sl.registerFactory(() => CameraBloc(upload: sl(), authRepo: sl()));
  sl.registerFactory(() => GalleryBloc(getPhotos: sl(), deletePhoto: sl(), authRepo: sl()));
  sl.registerFactory(() => PostBloc(getPosts: sl()));
sl.registerFactory(() => UsersBloc(sl<UserRepository>()));
sl.registerLazySingleton(() => UserRepository());
}
import 'package:atherio/features/chatbot/data/repositories/chat_repository_impl.dart';
import 'package:atherio/features/chatbot/domain/repository/chat_repository.dart';
import 'package:atherio/features/chatbot/domain/usecases/send_message_usecase.dart';
import 'package:atherio/features/chatbot/presentation/blocs/chat_bloc.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

void setupServiceLocator() {
  // Repositories
  sl.registerLazySingleton<ChatRepository>(() => ChatRepositoryImpl());

  // Use Cases
  sl.registerLazySingleton(() => SendMessageUseCase(sl()));

  // Blocs
  sl.registerFactory(() => ChatBloc(sl()));
}
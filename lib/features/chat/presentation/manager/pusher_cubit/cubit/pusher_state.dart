import 'package:equatable/equatable.dart';
import 'package:elsadeken/features/chat/data/models/pusher_message_model.dart';

abstract class PusherState extends Equatable {
  const PusherState();

  @override
  List<Object?> get props => [];
}

class PusherInitial extends PusherState {}

class PusherLoading extends PusherState {}

class PusherInitialized extends PusherState {}

class PusherSubscribing extends PusherState {}

class PusherSubscribed extends PusherState {}

class PusherUnsubscribing extends PusherState {}

class PusherUnsubscribed extends PusherState {}

class PusherDisconnecting extends PusherState {}

class PusherDisconnected extends PusherState {}

class PusherMessageReceived extends PusherState {
  final PusherMessageModel message;

  const PusherMessageReceived(this.message);

  @override
  List<Object?> get props => [message];
}

class PusherConnectionEstablished extends PusherState {
  final String message;

  const PusherConnectionEstablished(this.message);

  @override
  List<Object?> get props => [message];
}

class PusherConnectionError extends PusherState {
  final String error;

  const PusherConnectionError(this.error);

  @override
  List<Object?> get props => [error];
}

class PusherError extends PusherState {
  final String message;

  const PusherError(this.message);

  @override
  List<Object?> get props => [message];
}

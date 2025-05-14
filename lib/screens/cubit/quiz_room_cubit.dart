import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:queezy/screens/models/room_model.dart';
import 'package:queezy/service/socket_service.dart';

import '../models/queezy_model.dart';

class QuizRoomBloc extends Bloc<QuizRoomEvent, QuizRoomState> {
  final SocketService _socketService;

  QuizRoomBloc(this._socketService) : super(QuizRoomInitial()) {
    on<JoinRoomEvent>(_connectSockets);
    on<UpdateRoomEvent>(_updateRoom);
    on<JoinPlayerEvent>(_joinPlayer);
    on<LeavePlayerEvent>(_leavePlayer);
  }

  void _connectSockets(JoinRoomEvent events, _) {
    _socketService.emit("join_game_room", {
      "roomCode": events.roomCode,
      "playerId": events.playerId,
    });
    _socketService.on("new_player", (data) {
      final player = Player.fromJson(data["player"]);
      add(JoinPlayerEvent(player));
    });
    _socketService.on("left_player", (data) {
      final playerId = data["playerId"];
      add(LeavePlayerEvent(playerId));
    });
  }

  void _updateRoom(UpdateRoomEvent events, Emitter<QuizRoomState> emit) {
    if (events.roomModel is JoinRoomModel) {
      final joinRoomModel = events.roomModel as JoinRoomModel;
      emit(
        QuizRoomUpdateState(
          players: joinRoomModel.players,
          currentPlayer: joinRoomModel.player!,
          roomCode: events.roomModel.code!,
        ),
      );
    } else {
      emit(
        QuizRoomUpdateState(
          players: [events.roomModel.player!],
          currentPlayer: events.roomModel.player!,
          roomCode: events.roomModel.code!,
        ),
      );
    }
  }

  void _joinPlayer(JoinPlayerEvent events, Emitter<QuizRoomState> emit) {
    if (state.players!.any((element) => element.playerId == events.player.playerId)) return;
    final players = [...state.players!, events.player];
    emit(state.copyWith(players: players));
  }

  void _leavePlayer(LeavePlayerEvent events, Emitter<QuizRoomState> emit) {
    if (state is QuizRoomUpdateState) {
      final state = this.state as QuizRoomUpdateState;
      final players =
          state.players!.where((element) => element.playerId != events.playerId).toList();
      emit(state.copyWith(players: players));
    }
  }

  @override
  Future<void> close() {
    if (state is QuizRoomUpdateState) {
      final currentState = state as QuizRoomUpdateState;
      _socketService.emit("leave_game_room", {
        "roomCode": currentState.roomCode,
        "playerId": currentState.currentPlayer?.playerId,
      });
    }

    _socketService.off("new_player");
    _socketService.off("left_player");
    return super.close();
  }
}

sealed class QuizRoomState {
  final List<Player>? players;
  final Player? currentPlayer;
  final String? roomCode;

  QuizRoomState({this.players, this.currentPlayer, this.roomCode});

  QuizRoomState copyWith({List<Player>? players, Player? currentPlayer, String? roomCode}) {
    return QuizRoomUpdateState(
      players: players ?? this.players,
      currentPlayer: currentPlayer ?? this.currentPlayer,
      roomCode: roomCode ?? this.roomCode,
    );
  }
}

class QuizRoomInitial extends QuizRoomState {
  QuizRoomInitial() : super(players: [], currentPlayer: null, roomCode: null);
}

class QuizRoomUpdateState extends QuizRoomState {
  QuizRoomUpdateState({
    required super.players,
    required super.currentPlayer,
    required super.roomCode,
  });
}

sealed class QuizRoomEvent {}

class GameStartedEvent extends QuizRoomEvent {
  final GameSession session;
  GameStartedEvent({required this.session});
}

class JoinPlayerEvent extends QuizRoomEvent {
  final Player player;
  JoinPlayerEvent(this.player);
}

class JoinRoomEvent extends QuizRoomEvent {
  final String roomCode;
  final num playerId;
  JoinRoomEvent(this.roomCode, this.playerId);
}

class LeaveRoomEvent extends QuizRoomEvent {
  final String roomCode;
  final String playerId;
  LeaveRoomEvent({required this.roomCode, required this.playerId});
}

class UpdateRoomEvent extends QuizRoomEvent {
  final RoomModel roomModel;
  UpdateRoomEvent(this.roomModel);
}

class LeavePlayerEvent extends QuizRoomEvent {
  final int playerId;
  LeavePlayerEvent(this.playerId);
}

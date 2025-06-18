extends Node

var ACTION_HANDLERS: Dictionary[WebsocketConstants.EnumActions, Callable] = {
	WebsocketConstants.EnumActions.CONNECT: ActionHandler.connected,
	WebsocketConstants.EnumActions.ROOM_CREATED: ActionHandler.create_room_response,
	WebsocketConstants.EnumActions.PLAYER_LEFT: ActionHandler.player_has_left_broadcast,
	WebsocketConstants.EnumActions.ROOM_DELETED: ActionHandler.room_deleted_broadcast,
	WebsocketConstants.EnumActions.JOINED_ROOM: ActionHandler.join_room_response,
	WebsocketConstants.EnumActions.PLAYER_JOINED: ActionHandler.player_has_joined_broadcast,
	WebsocketConstants.EnumActions.PLAYER_INFO_UPDATED: ActionHandler.player_info_updated_broadcast,
	WebsocketConstants.EnumActions.START_GAME_BROADCAST: ActionHandler.start_game_broadcast,
	WebsocketConstants.EnumActions.TICK_STATE: ActionHandler.update_player_position_broadcast,
	WebsocketConstants.EnumActions.BOMB_DROPPED: ActionHandler.drop_bomb_broadcast,
	WebsocketConstants.EnumActions.POWER_UP_CREATED: ActionHandler.create_power_up_broadcast,
	WebsocketConstants.EnumActions.BOMB_EXPLODED: ActionHandler.bomb_exploded_broadcast,
	WebsocketConstants.EnumActions.REMOVE_POWER_UP: ActionHandler.remove_power_up_broadcast,
	WebsocketConstants.EnumActions.PLAYER_DIED_BROADCAST: ActionHandler.player_died_broadcast,
	WebsocketConstants.EnumActions.GAME_OVER: ActionHandler.game_over_broadcast,
	WebsocketConstants.EnumActions.ERROR: ActionHandler.handle_error,
}

func exec_action(data: String) -> void:
	var payload: Dictionary = JSON.parse_string(data)
	var action = ACTION_HANDLERS.get(int(payload["action"]))
	if action: action.call(payload)

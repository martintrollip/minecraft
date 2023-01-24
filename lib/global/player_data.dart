class PlayerData {
  //health, hunger state, left right

  ComponentMotionState componentMotionState = ComponentMotionState.idle;
}

enum ComponentMotionState {
  walkingLeft,
  walkingRight,
  idle,
  jumping,
}

class SwipeDto {
  const SwipeDto({
    this.daySwipesCount = 0,
    this.lastSwipeTime = 0,
    this.swipesStreak = 0,
  });
  final int lastSwipeTime;
  final int swipesStreak;
  final int daySwipesCount;

  SwipeDto copyWith({
    int? lastSwipeTime,
    int? swipesStreak,
    int? daySwipesCount,
  }) {
    return SwipeDto(
      lastSwipeTime: lastSwipeTime ?? this.lastSwipeTime,
      swipesStreak: swipesStreak ?? this.swipesStreak,
      daySwipesCount: daySwipesCount ?? this.daySwipesCount,
    );
  }
}

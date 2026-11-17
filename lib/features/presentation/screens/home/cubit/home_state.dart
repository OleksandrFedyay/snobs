import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:kingfishertom/core/data/api/models/user/user_model.dart';
import 'package:kingfishertom/core/domain/repositories/use_cases/get_total_genre_subgenres.use_case.dart';

@immutable
class HomeState extends Equatable {
  const HomeState({
    this.subGenre = '',
    this.genresSubgenres = const <GenreSubgenresTotal>[],
    this.user,
    this.genre = '',
    this.libraryGenre = '',
    this.librarySubgenre = '',
    this.genresAndSubgenresRandomItems = const <String>[],
    this.isTrialOrSubscriptionActive = false,
    this.selectedGenreOrSubGenre = '',
    this.selectedRandomGenreDialogue = '',
    this.currentGenreDialogue = '',
    this.isGenreWithAllWord = false,
    this.isOnSetGenreDialogue = false,
    this.isFirstScrollGenreDialogue = true,
  });

  final String subGenre;
  final List<GenreSubgenresTotal> genresSubgenres;
  final UserModel? user;
  final String genre;
  final String librarySubgenre;
  final String libraryGenre;
  final List<String> genresAndSubgenresRandomItems;
  final bool isTrialOrSubscriptionActive;
  final String selectedGenreOrSubGenre;
  final String currentGenreDialogue;
  final bool isOnSetGenreDialogue;
  final bool isFirstScrollGenreDialogue;
  final String selectedRandomGenreDialogue;
  final bool isGenreWithAllWord;

  @override
  List<Object?> get props {
    return <Object?>[
      subGenre,
      genresSubgenres,
      user,
      genre,
      librarySubgenre,
      libraryGenre,
      genresAndSubgenresRandomItems,
      isTrialOrSubscriptionActive,
      selectedGenreOrSubGenre,
      selectedRandomGenreDialogue,
      currentGenreDialogue,
      isGenreWithAllWord,
      isOnSetGenreDialogue,
      isFirstScrollGenreDialogue,
    ];
  }

  HomeState copyWith({
    String? subGenre,
    List<GenreSubgenresTotal>? genresSubgenres,
    UserModel? user,
    String? genre,
    String? librarySubgenre,
    String? libraryGenre,
    List<String>? genresAndSubgenresRandomItems,
    bool? isTrialOrSubscriptionActive,
    String? selectedGenreOrSubGenre,
    String? selectedRandomGenreDialogue,
    String? currentGenreDialogue,
    bool? isGenreWithAllWord,
    bool? isOnSetGenreDialogue,
    bool? isFirstScrollGenreDialogue,
  }) {
    return HomeState(
      subGenre: subGenre ?? this.subGenre,
      genresSubgenres: genresSubgenres ?? this.genresSubgenres,
      user: user ?? this.user,
      genre: genre ?? this.genre,
      librarySubgenre: librarySubgenre ?? this.librarySubgenre,
      libraryGenre: libraryGenre ?? this.libraryGenre,
      genresAndSubgenresRandomItems: genresAndSubgenresRandomItems ?? this.genresAndSubgenresRandomItems,
      isTrialOrSubscriptionActive:
          isTrialOrSubscriptionActive ?? this.isTrialOrSubscriptionActive,
      selectedGenreOrSubGenre:
          selectedGenreOrSubGenre ?? this.selectedGenreOrSubGenre,
      selectedRandomGenreDialogue:
          selectedRandomGenreDialogue ?? this.selectedRandomGenreDialogue,
      currentGenreDialogue: currentGenreDialogue ?? this.currentGenreDialogue,
      isGenreWithAllWord: isGenreWithAllWord ?? this.isGenreWithAllWord,
      isOnSetGenreDialogue: isOnSetGenreDialogue ?? this.isOnSetGenreDialogue,
      isFirstScrollGenreDialogue: isFirstScrollGenreDialogue ?? this.isFirstScrollGenreDialogue,
    );
  }
}

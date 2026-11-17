// ignore_for_file: unnecessary_brace_in_string_interps, no_leading_underscores_for_local_identifiers
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'snobs_app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of SnobsAppLocalizations
/// returned by `SnobsAppLocalizations.of(context)`.
///
/// Applications need to include `SnobsAppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/snobs_app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: SnobsAppLocalizations.localizationsDelegates,
///   supportedLocales: SnobsAppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the SnobsAppLocalizations.supportedLocales
/// property.
abstract class SnobsAppLocalizations {
  SnobsAppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static SnobsAppLocalizations of(BuildContext context) {
    return Localizations.of<SnobsAppLocalizations>(context, SnobsAppLocalizations)!;
  }

  static const LocalizationsDelegate<SnobsAppLocalizations> delegate = _SnobsAppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en')
  ];

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @explore.
  ///
  /// In en, this message translates to:
  /// **'Explore'**
  String get explore;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get somethingWentWrong;

  /// No description provided for @snobs.
  ///
  /// In en, this message translates to:
  /// **'snobs'**
  String get snobs;

  /// No description provided for @enterEmailAddress.
  ///
  /// In en, this message translates to:
  /// **'Enter Email Address'**
  String get enterEmailAddress;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Invalid Email'**
  String get invalidEmail;

  /// No description provided for @finish.
  ///
  /// In en, this message translates to:
  /// **'finish'**
  String get finish;

  /// No description provided for @goBack.
  ///
  /// In en, this message translates to:
  /// **'Go Back'**
  String get goBack;

  /// No description provided for @enterPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter password'**
  String get enterPassword;

  /// No description provided for @createPassword.
  ///
  /// In en, this message translates to:
  /// **'Create password'**
  String get createPassword;

  /// No description provided for @emptyFieldMessage.
  ///
  /// In en, this message translates to:
  /// **'The field cannot be empty'**
  String get emptyFieldMessage;

  /// No description provided for @invalidPassword.
  ///
  /// In en, this message translates to:
  /// **'Invalid password'**
  String get invalidPassword;

  /// No description provided for @enterMobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter Mobile Number'**
  String get enterMobileNumber;

  /// No description provided for @invalidMobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Invalid Mobile Number'**
  String get invalidMobileNumber;

  /// No description provided for @enterCode.
  ///
  /// In en, this message translates to:
  /// **'Enter Code'**
  String get enterCode;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @more.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get more;

  /// No description provided for @here.
  ///
  /// In en, this message translates to:
  /// **'Here'**
  String get here;

  /// No description provided for @noItems.
  ///
  /// In en, this message translates to:
  /// **'No items found'**
  String get noItems;

  /// No description provided for @appVersionCopiedClipboard.
  ///
  /// In en, this message translates to:
  /// **'App version copied to clipboard!'**
  String get appVersionCopiedClipboard;

  /// No description provided for @resendCode30Sec.
  ///
  /// In en, this message translates to:
  /// **'Resend code : {second} sec'**
  String resendCode30Sec(int second);

  /// No description provided for @resendCode.
  ///
  /// In en, this message translates to:
  /// **'Resend Code'**
  String get resendCode;

  /// No description provided for @searchCountry.
  ///
  /// In en, this message translates to:
  /// **'Search country'**
  String get searchCountry;

  /// No description provided for @selectGenre.
  ///
  /// In en, this message translates to:
  /// **'Select Genre'**
  String get selectGenre;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @favorite.
  ///
  /// In en, this message translates to:
  /// **'Favorite'**
  String get favorite;

  /// No description provided for @favorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorites;

  /// No description provided for @myProfile.
  ///
  /// In en, this message translates to:
  /// **'My Profile'**
  String get myProfile;

  /// No description provided for @artist.
  ///
  /// In en, this message translates to:
  /// **'Artist'**
  String get artist;

  /// No description provided for @fans.
  ///
  /// In en, this message translates to:
  /// **'Fans'**
  String get fans;

  /// No description provided for @searchArtists.
  ///
  /// In en, this message translates to:
  /// **'Search Artists'**
  String get searchArtists;

  /// No description provided for @searchCollections.
  ///
  /// In en, this message translates to:
  /// **'Search Collections'**
  String get searchCollections;

  /// No description provided for @changePhoto.
  ///
  /// In en, this message translates to:
  /// **'Change Photo'**
  String get changePhoto;

  /// No description provided for @setupYour.
  ///
  /// In en, this message translates to:
  /// **'Setup Your {name}'**
  String setupYour(String name);

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @verify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verify;

  /// No description provided for @verifyMobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Verify Mobile Number'**
  String get verifyMobileNumber;

  /// No description provided for @weHaveSentDigitCodeTo.
  ///
  /// In en, this message translates to:
  /// **'We have sent a {number} digit Code to'**
  String weHaveSentDigitCodeTo(int number);

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @songs.
  ///
  /// In en, this message translates to:
  /// **'Songs'**
  String get songs;

  /// No description provided for @moreSongs.
  ///
  /// In en, this message translates to:
  /// **'More Songs'**
  String get moreSongs;

  /// No description provided for @collections.
  ///
  /// In en, this message translates to:
  /// **'Collections'**
  String get collections;

  /// No description provided for @allLiked.
  ///
  /// In en, this message translates to:
  /// **'All Liked'**
  String get allLiked;

  /// No description provided for @createNewCustomCollection.
  ///
  /// In en, this message translates to:
  /// **'Create new custom collection'**
  String get createNewCustomCollection;

  /// No description provided for @unlike.
  ///
  /// In en, this message translates to:
  /// **'Unlike'**
  String get unlike;

  /// No description provided for @noGoBack.
  ///
  /// In en, this message translates to:
  /// **'NO, GO BACK'**
  String get noGoBack;

  /// No description provided for @yesUnlike.
  ///
  /// In en, this message translates to:
  /// **'YES, UNLIKE'**
  String get yesUnlike;

  /// No description provided for @thisWillRemove.
  ///
  /// In en, this message translates to:
  /// **'This will remove this artist from all your collections.'**
  String get thisWillRemove;

  /// No description provided for @unlikeArtistFrom.
  ///
  /// In en, this message translates to:
  /// **'Unlike {name}?'**
  String unlikeArtistFrom(String name);

  /// No description provided for @thisWillRemoveArtistFrom.
  ///
  /// In en, this message translates to:
  /// **'Remove {name} from your {list}?'**
  String thisWillRemoveArtistFrom(String name, String list);

  /// No description provided for @nameRemovedFromList.
  ///
  /// In en, this message translates to:
  /// **'{name} removed from {list}'**
  String nameRemovedFromList(String name, String list);

  /// No description provided for @sendFeedback.
  ///
  /// In en, this message translates to:
  /// **'Send feedback'**
  String get sendFeedback;

  /// No description provided for @library.
  ///
  /// In en, this message translates to:
  /// **'Library'**
  String get library;

  /// No description provided for @liked.
  ///
  /// In en, this message translates to:
  /// **'Liked'**
  String get liked;

  /// No description provided for @notLikedYet.
  ///
  /// In en, this message translates to:
  /// **'Not liked yet'**
  String get notLikedYet;

  /// No description provided for @swipe.
  ///
  /// In en, this message translates to:
  /// **'Swipe'**
  String get swipe;

  /// No description provided for @reportAnIssue.
  ///
  /// In en, this message translates to:
  /// **'Report an Issue'**
  String get reportAnIssue;

  /// No description provided for @requestFeature.
  ///
  /// In en, this message translates to:
  /// **'Request a Feature'**
  String get requestFeature;

  /// No description provided for @giveFeedback.
  ///
  /// In en, this message translates to:
  /// **'Give Feedback'**
  String get giveFeedback;

  /// No description provided for @howCanWeHelpYou.
  ///
  /// In en, this message translates to:
  /// **'How can we help you?'**
  String get howCanWeHelpYou;

  /// No description provided for @weWouldLoveToHearYourIdeas.
  ///
  /// In en, this message translates to:
  /// **'We would love to hear your ideas'**
  String get weWouldLoveToHearYourIdeas;

  /// No description provided for @weWouldLoveToKnowWhatYouThink.
  ///
  /// In en, this message translates to:
  /// **'We would love to know what you think of the app'**
  String get weWouldLoveToKnowWhatYouThink;

  /// No description provided for @writeYourIssuesHere.
  ///
  /// In en, this message translates to:
  /// **'Write your issues here...'**
  String get writeYourIssuesHere;

  /// No description provided for @shareYourThoughtsHere.
  ///
  /// In en, this message translates to:
  /// **'Share your thoughts here...'**
  String get shareYourThoughtsHere;

  /// No description provided for @shareYouFeedbackHere.
  ///
  /// In en, this message translates to:
  /// **'Share you feedback here...'**
  String get shareYouFeedbackHere;

  /// No description provided for @thankYouForFeedback.
  ///
  /// In en, this message translates to:
  /// **'Thank you for your feedback! We are working hard to improve our app and will review ASAP'**
  String get thankYouForFeedback;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @thankYouForSharing.
  ///
  /// In en, this message translates to:
  /// **'Thank you for sharing!'**
  String get thankYouForSharing;

  /// No description provided for @thankYouForSharingFeedback.
  ///
  /// In en, this message translates to:
  /// **'Thank you for sharing your feedback with us!'**
  String get thankYouForSharingFeedback;

  /// No description provided for @rateUsOnStore.
  ///
  /// In en, this message translates to:
  /// **'Rate us on {store} Store'**
  String rateUsOnStore(String store);

  /// No description provided for @ifYouLoveApp.
  ///
  /// In en, this message translates to:
  /// **'If you love our app, please take a moment to rate it in the {store} Store'**
  String ifYouLoveApp(String store);

  /// No description provided for @rateUs.
  ///
  /// In en, this message translates to:
  /// **'Rate us'**
  String get rateUs;

  /// No description provided for @deleteCollect.
  ///
  /// In en, this message translates to:
  /// **'Delete ‘{collect}’?'**
  String deleteCollect(String collect);

  /// No description provided for @deletingCollectionDoesNot.
  ///
  /// In en, this message translates to:
  /// **'Deleting a collection does not remove liked artists from your library'**
  String get deletingCollectionDoesNot;

  /// No description provided for @yesDelete.
  ///
  /// In en, this message translates to:
  /// **'Yes, Delete'**
  String get yesDelete;

  /// No description provided for @sortBy.
  ///
  /// In en, this message translates to:
  /// **'Sort by'**
  String get sortBy;

  /// No description provided for @sortByAz.
  ///
  /// In en, this message translates to:
  /// **'Sort by A-Z'**
  String get sortByAz;

  /// No description provided for @sortByDateAdded.
  ///
  /// In en, this message translates to:
  /// **'Sort by Date Added'**
  String get sortByDateAdded;

  /// No description provided for @likedArtists.
  ///
  /// In en, this message translates to:
  /// **'Liked Artists'**
  String get likedArtists;

  /// No description provided for @evaluateArtists.
  ///
  /// In en, this message translates to:
  /// **'Evaluate {amount} Artists'**
  String evaluateArtists(int amount);

  /// No description provided for @facebook.
  ///
  /// In en, this message translates to:
  /// **'Facebook'**
  String get facebook;

  /// No description provided for @instagram.
  ///
  /// In en, this message translates to:
  /// **'Instagram'**
  String get instagram;

  /// No description provided for @snapchat.
  ///
  /// In en, this message translates to:
  /// **'Snapchat'**
  String get snapchat;

  /// No description provided for @others.
  ///
  /// In en, this message translates to:
  /// **'Others'**
  String get others;

  /// No description provided for @subgenres.
  ///
  /// In en, this message translates to:
  /// **'Subgenres'**
  String get subgenres;

  /// No description provided for @whatNeedsUpdating.
  ///
  /// In en, this message translates to:
  /// **'What needs updating?'**
  String get whatNeedsUpdating;

  /// No description provided for @artistName.
  ///
  /// In en, this message translates to:
  /// **'Artist Name'**
  String get artistName;

  /// No description provided for @artistImage.
  ///
  /// In en, this message translates to:
  /// **'Artist Image'**
  String get artistImage;

  /// No description provided for @bio.
  ///
  /// In en, this message translates to:
  /// **'Bio'**
  String get bio;

  /// No description provided for @genreSubgenre.
  ///
  /// In en, this message translates to:
  /// **'Genre / Subgenre'**
  String get genreSubgenre;

  /// No description provided for @pleaseProvideDetailsHere.
  ///
  /// In en, this message translates to:
  /// **'Please provide details here...'**
  String get pleaseProvideDetailsHere;

  /// No description provided for @wakeup.
  ///
  /// In en, this message translates to:
  /// **'Wakeup'**
  String get wakeup;

  /// No description provided for @workout.
  ///
  /// In en, this message translates to:
  /// **'Workout'**
  String get workout;

  /// No description provided for @travel.
  ///
  /// In en, this message translates to:
  /// **'Travel'**
  String get travel;

  /// No description provided for @focus.
  ///
  /// In en, this message translates to:
  /// **'Focus'**
  String get focus;

  /// No description provided for @party.
  ///
  /// In en, this message translates to:
  /// **'Party'**
  String get party;

  /// No description provided for @relax.
  ///
  /// In en, this message translates to:
  /// **'Relax'**
  String get relax;

  /// No description provided for @searchArtistsCollectionsInLibrary.
  ///
  /// In en, this message translates to:
  /// **'Search for Artists or Collections in your library'**
  String get searchArtistsCollectionsInLibrary;

  /// No description provided for @checkoutLater.
  ///
  /// In en, this message translates to:
  /// **'Checkout Later'**
  String get checkoutLater;

  /// No description provided for @oldPassword.
  ///
  /// In en, this message translates to:
  /// **'Old password'**
  String get oldPassword;

  /// No description provided for @youveSwipedTimes.
  ///
  /// In en, this message translates to:
  /// **'You’ve swiped {number} times in {genre}. Swipe {amount} more times to earn this badge.'**
  String youveSwipedTimes(int amount, int number, String genre);

  /// No description provided for @startSwiping.
  ///
  /// In en, this message translates to:
  /// **'Start Swiping'**
  String get startSwiping;

  /// No description provided for @noArtistsLeft.
  ///
  /// In en, this message translates to:
  /// **'No {genre} Artists Left'**
  String noArtistsLeft(String genre);

  /// No description provided for @switchGenreToContinueExploring.
  ///
  /// In en, this message translates to:
  /// **'Switch Genre to continue exploring'**
  String get switchGenreToContinueExploring;

  /// No description provided for @switchGenre.
  ///
  /// In en, this message translates to:
  /// **'Switch Genre'**
  String get switchGenre;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logOut;

  /// No description provided for @checkoutMyCollection.
  ///
  /// In en, this message translates to:
  /// **'Checkout my collection of top artists in {collect} on Snobs App'**
  String checkoutMyCollection(String collect);

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming Soon'**
  String get comingSoon;

  /// No description provided for @newWord.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get newWord;

  /// No description provided for @hot.
  ///
  /// In en, this message translates to:
  /// **'Hot'**
  String get hot;

  /// No description provided for @emerging.
  ///
  /// In en, this message translates to:
  /// **'Emerging'**
  String get emerging;

  /// No description provided for @termsConditions.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get termsConditions;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccount;

  /// No description provided for @noInternetConnection.
  ///
  /// In en, this message translates to:
  /// **'No Internet connection'**
  String get noInternetConnection;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @rename.
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get rename;

  /// No description provided for @earnBadges.
  ///
  /// In en, this message translates to:
  /// **'Earn Badges'**
  String get earnBadges;

  /// No description provided for @swipe100timesInAnySubgenreToEarn.
  ///
  /// In en, this message translates to:
  /// **'Swipe 100 times in any subgenre to earn a badge. Once earned, they will show here.'**
  String get swipe100timesInAnySubgenreToEarn;

  /// No description provided for @subscriptions.
  ///
  /// In en, this message translates to:
  /// **'Subscriptions'**
  String get subscriptions;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @support.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get support;

  /// No description provided for @areYouSureYouWantToDeleteYourAccount.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete your account?'**
  String get areYouSureYouWantToDeleteYourAccount;

  /// No description provided for @thisActionCannotBeUndone.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone'**
  String get thisActionCannotBeUndone;

  /// No description provided for @getRealTimeNotificationsAndAlerts.
  ///
  /// In en, this message translates to:
  /// **'Get real time notifications and alerts'**
  String get getRealTimeNotificationsAndAlerts;

  /// No description provided for @turnOff.
  ///
  /// In en, this message translates to:
  /// **'Turn OFF'**
  String get turnOff;

  /// No description provided for @turnOn.
  ///
  /// In en, this message translates to:
  /// **'Turn On'**
  String get turnOn;

  /// No description provided for @allSubgenres.
  ///
  /// In en, this message translates to:
  /// **'All Subgenres'**
  String get allSubgenres;

  /// No description provided for @addSubgenre.
  ///
  /// In en, this message translates to:
  /// **'Add a subgenre'**
  String get addSubgenre;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @wouldYouLikeToAdd.
  ///
  /// In en, this message translates to:
  /// **'Would you like to add {genre} to {artist} in your account?'**
  String wouldYouLikeToAdd(String artist, String genre);

  /// No description provided for @wouldYouLikeToRemove.
  ///
  /// In en, this message translates to:
  /// **'Would you like to remove {genre} from {artist} in your account?'**
  String wouldYouLikeToRemove(String artist, String genre);

  /// No description provided for @thankYou.
  ///
  /// In en, this message translates to:
  /// **'Thank You'**
  String get thankYou;

  /// No description provided for @willIncludedInYourCollection.
  ///
  /// In en, this message translates to:
  /// **'{artist} will be included in your {genre} collection if added to your library'**
  String willIncludedInYourCollection(String artist, String genre);

  /// No description provided for @level.
  ///
  /// In en, this message translates to:
  /// **'Level'**
  String get level;

  /// No description provided for @swipes.
  ///
  /// In en, this message translates to:
  /// **'Swipes'**
  String get swipes;

  /// No description provided for @levelUpAt.
  ///
  /// In en, this message translates to:
  /// **'Level Up at'**
  String get levelUpAt;

  /// No description provided for @levelUpIn.
  ///
  /// In en, this message translates to:
  /// **'Level up in'**
  String get levelUpIn;

  /// No description provided for @snobsPremium.
  ///
  /// In en, this message translates to:
  /// **'Snobs Premium'**
  String get snobsPremium;

  /// No description provided for @niceWork.
  ///
  /// In en, this message translates to:
  /// **'Nice Work!'**
  String get niceWork;

  /// No description provided for @youHaveReachedLevelFor.
  ///
  /// In en, this message translates to:
  /// **'You\'ve reached\nLevel {level} for {genre}!'**
  String youHaveReachedLevelFor(int level, String genre);

  /// No description provided for @exploreMoreArtistsToReachLevel.
  ///
  /// In en, this message translates to:
  /// **'Explore {amount} {genre} Artists to Reach Level {level}'**
  String exploreMoreArtistsToReachLevel(int level, int amount, String genre);

  /// No description provided for @completeYourProfile.
  ///
  /// In en, this message translates to:
  /// **'Complete your profile'**
  String get completeYourProfile;

  /// No description provided for @lastName.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get lastName;

  /// No description provided for @details.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get details;

  /// No description provided for @fullSongRadio.
  ///
  /// In en, this message translates to:
  /// **'Full Song Radio'**
  String get fullSongRadio;

  /// No description provided for @goBeyond30SecondSongPreviews.
  ///
  /// In en, this message translates to:
  /// **'Go Beyond 30 Second Song Previews'**
  String get goBeyond30SecondSongPreviews;

  /// No description provided for @claimYourFreeTrial.
  ///
  /// In en, this message translates to:
  /// **'Claim your free trial'**
  String get claimYourFreeTrial;

  /// No description provided for @limitedTimeOfferClaimNow.
  ///
  /// In en, this message translates to:
  /// **'Limited time offer, Claim now'**
  String get limitedTimeOfferClaimNow;

  /// No description provided for @subscriptionAvailableForJust.
  ///
  /// In en, this message translates to:
  /// **'Subscription available for just \$7.99'**
  String get subscriptionAvailableForJust;

  /// No description provided for @subscriptionTrailDetailsGoogle.
  ///
  /// In en, this message translates to:
  /// **'30-day free trial. After the trial, \$7.99/month. Subscription renews automatically unless canceled before the trial ends. Cancel anytime through Google Play settings. A subscription is not required to use the app but is needed for premium features.'**
  String get subscriptionTrailDetailsGoogle;

  /// No description provided for @subscriptionPremiumDetailsGoogle.
  ///
  /// In en, this message translates to:
  /// **'\$7.99/month. Subscription renews automatically unless canceled before the trial ends. Cancel anytime through Google Play settings. A subscription is not required to use the app but is needed for premium features.'**
  String get subscriptionPremiumDetailsGoogle;

  /// No description provided for @noCreditCardRequired.
  ///
  /// In en, this message translates to:
  /// **'No Credit Card Required'**
  String get noCreditCardRequired;

  /// No description provided for @startdayFreeTrial.
  ///
  /// In en, this message translates to:
  /// **'Start {amount} day free trial'**
  String startdayFreeTrial(int amount);

  /// No description provided for @subscribe.
  ///
  /// In en, this message translates to:
  /// **'Subscribe'**
  String get subscribe;

  /// No description provided for @only799.
  ///
  /// In en, this message translates to:
  /// **'Only \$7.99'**
  String get only799;

  /// No description provided for @rebelation.
  ///
  /// In en, this message translates to:
  /// **'Rebelation'**
  String get rebelation;

  /// No description provided for @rebelationIsOurFullSongRadio.
  ///
  /// In en, this message translates to:
  /// **'Rebelation is our full song radio streaming partner and is the brains behind our full song radio.'**
  String get rebelationIsOurFullSongRadio;

  /// No description provided for @rebelationPlayerGetsToKnow.
  ///
  /// In en, this message translates to:
  /// **'The Rebelation player gets to know you as you listen to create the perfect balance of familiar and new songs.'**
  String get rebelationPlayerGetsToKnow;

  /// No description provided for @zipCode.
  ///
  /// In en, this message translates to:
  /// **'Zip Code'**
  String get zipCode;

  /// No description provided for @zipCodeShouldContainFiveDigits.
  ///
  /// In en, this message translates to:
  /// **'Zip code should contain five digits'**
  String get zipCodeShouldContainFiveDigits;

  /// No description provided for @limitedOffer.
  ///
  /// In en, this message translates to:
  /// **'Limited Offer'**
  String get limitedOffer;

  /// No description provided for @getDayFreeTrial.
  ///
  /// In en, this message translates to:
  /// **'Get {amount} Day Free Trial'**
  String getDayFreeTrial(int amount);

  /// No description provided for @startTrial.
  ///
  /// In en, this message translates to:
  /// **'Start Trial'**
  String get startTrial;

  /// No description provided for @startPremium.
  ///
  /// In en, this message translates to:
  /// **'Start Premium'**
  String get startPremium;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @daysLeft.
  ///
  /// In en, this message translates to:
  /// **'{amount} days left'**
  String daysLeft(int amount);

  /// No description provided for @continueTitle.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueTitle;

  /// No description provided for @areYouSureYouWantToCancel.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel '**
  String get areYouSureYouWantToCancel;

  /// No description provided for @premium.
  ///
  /// In en, this message translates to:
  /// **'Premium'**
  String get premium;

  /// No description provided for @subscription.
  ///
  /// In en, this message translates to:
  /// **'subscription'**
  String get subscription;

  /// No description provided for @yesCancelSubscription.
  ///
  /// In en, this message translates to:
  /// **'Yes, Cancel Subscription'**
  String get yesCancelSubscription;

  /// No description provided for @youWillLoseAndFullSong.
  ///
  /// In en, this message translates to:
  /// **'You will lose full song playback'**
  String get youWillLoseAndFullSong;

  /// No description provided for @getMorePremiumForFree.
  ///
  /// In en, this message translates to:
  /// **'Get More Premium for Free'**
  String get getMorePremiumForFree;

  /// No description provided for @cancelAnytimeBeforeAndYouWontBeCharged.
  ///
  /// In en, this message translates to:
  /// **'Cancel anytime before {date} and you won\'t be charged, then \$7.95 per month'**
  String cancelAnytimeBeforeAndYouWontBeCharged(String date);

  /// No description provided for @extendYourTrial.
  ///
  /// In en, this message translates to:
  /// **'Extend your trial'**
  String get extendYourTrial;

  /// No description provided for @enjoyYourExtendedTrial.
  ///
  /// In en, this message translates to:
  /// **'Enjoy your Extended Trial'**
  String get enjoyYourExtendedTrial;

  /// No description provided for @renews.
  ///
  /// In en, this message translates to:
  /// **'Renews'**
  String get renews;

  /// No description provided for @me.
  ///
  /// In en, this message translates to:
  /// **'Me'**
  String get me;

  /// No description provided for @moreOptions.
  ///
  /// In en, this message translates to:
  /// **'more options'**
  String get moreOptions;

  /// No description provided for @continueWithApple.
  ///
  /// In en, this message translates to:
  /// **'Continue with Apple'**
  String get continueWithApple;

  /// No description provided for @continueWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get continueWithGoogle;

  /// No description provided for @continueWithEmail.
  ///
  /// In en, this message translates to:
  /// **'Continue with email'**
  String get continueWithEmail;

  /// No description provided for @continueWithSms.
  ///
  /// In en, this message translates to:
  /// **'Continue with sms'**
  String get continueWithSms;

  /// No description provided for @enterEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter Email'**
  String get enterEmail;

  /// No description provided for @startRadio.
  ///
  /// In en, this message translates to:
  /// **'Start Radio'**
  String get startRadio;

  /// No description provided for @noLikedArtist.
  ///
  /// In en, this message translates to:
  /// **'No liked artists. Would you like to explore'**
  String get noLikedArtist;

  /// No description provided for @requestSubgenre.
  ///
  /// In en, this message translates to:
  /// **'Request Subgenre'**
  String get requestSubgenre;

  /// No description provided for @pleaseShareDetailsOfSubgenre.
  ///
  /// In en, this message translates to:
  /// **'Please share the details of subgenre here.'**
  String get pleaseShareDetailsOfSubgenre;

  /// No description provided for @writeSubgenreNameHere.
  ///
  /// In en, this message translates to:
  /// **'Write subgenre name here...'**
  String get writeSubgenreNameHere;

  /// No description provided for @write2ExampleArtistNamesHere.
  ///
  /// In en, this message translates to:
  /// **'Write 2+ example artist names here...'**
  String get write2ExampleArtistNamesHere;

  /// No description provided for @badgeUpdate.
  ///
  /// In en, this message translates to:
  /// **'Badge Update'**
  String get badgeUpdate;

  /// No description provided for @continueSwiping.
  ///
  /// In en, this message translates to:
  /// **'continue swiping'**
  String get continueSwiping;

  /// No description provided for @tapToListenToPreviews.
  ///
  /// In en, this message translates to:
  /// **'Tap to listen to previews'**
  String get tapToListenToPreviews;

  /// No description provided for @yourSavedArtistsAreGroupedByCollection.
  ///
  /// In en, this message translates to:
  /// **'Your saved artists are grouped by collection. Tap to see full list'**
  String get yourSavedArtistsAreGroupedByCollection;

  /// No description provided for @tapOnAnyArtistToView.
  ///
  /// In en, this message translates to:
  /// **'Tap on any artist to view information and preview more songs'**
  String get tapOnAnyArtistToView;

  /// No description provided for @tapOnThisIconToAddRemove.
  ///
  /// In en, this message translates to:
  /// **'Tap on this icon to add or remove artist from your collections'**
  String get tapOnThisIconToAddRemove;

  /// No description provided for @getSnobsPremium.
  ///
  /// In en, this message translates to:
  /// **'Get Snobs Premium'**
  String get getSnobsPremium;

  /// No description provided for @weAreAnInclusiveCommunityOfMusicEnthusiasts.
  ///
  /// In en, this message translates to:
  /// **'We are an inclusive community of music enthusiasts'**
  String get weAreAnInclusiveCommunityOfMusicEnthusiasts;

  /// No description provided for @weAreGladYouAreJoiningUs.
  ///
  /// In en, this message translates to:
  /// **'We are glad you are joining us!'**
  String get weAreGladYouAreJoiningUs;

  /// No description provided for @whatShouldWeCallYou.
  ///
  /// In en, this message translates to:
  /// **'What should we call you?'**
  String get whatShouldWeCallYou;

  /// No description provided for @enterYourName.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get enterYourName;

  /// No description provided for @whatGenreWouldYouLikeToExploreFirst.
  ///
  /// In en, this message translates to:
  /// **'What genre would you like to explore first?'**
  String get whatGenreWouldYouLikeToExploreFirst;

  /// No description provided for @hi.
  ///
  /// In en, this message translates to:
  /// **'Hi'**
  String get hi;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @exploring.
  ///
  /// In en, this message translates to:
  /// **'EXPLORING'**
  String get exploring;

  /// No description provided for @random.
  ///
  /// In en, this message translates to:
  /// **'Random'**
  String get random;

  /// No description provided for @pressAndHoldToSelect.
  ///
  /// In en, this message translates to:
  /// **'Press and hold to select and move artists'**
  String get pressAndHoldToSelect;

  /// No description provided for @selectALL.
  ///
  /// In en, this message translates to:
  /// **'Select ALL'**
  String get selectALL;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @swipeAll.
  ///
  /// In en, this message translates to:
  /// **'Swipe all'**
  String get swipeAll;

  /// No description provided for @exploredSubgenres.
  ///
  /// In en, this message translates to:
  /// **'Explored Subgenres'**
  String get exploredSubgenres;

  /// No description provided for @unexploredSubgenres.
  ///
  /// In en, this message translates to:
  /// **'Unexplored Subgenres'**
  String get unexploredSubgenres;

  /// No description provided for @selectUnexploredSubgenre.
  ///
  /// In en, this message translates to:
  /// **'Select an unexplored subgenre'**
  String get selectUnexploredSubgenre;

  /// No description provided for @noExploredSubgenres.
  ///
  /// In en, this message translates to:
  /// **'No Explored {genre} Subgenres'**
  String noExploredSubgenres(String genre);

  /// No description provided for @congratsExploredAllSubgenres.
  ///
  /// In en, this message translates to:
  /// **'Congrats you have explored all available subgenres'**
  String get congratsExploredAllSubgenres;

  /// No description provided for @noUnexploredSubgenres.
  ///
  /// In en, this message translates to:
  /// **'No Unexplored {genre} Subgenres'**
  String noUnexploredSubgenres(String genre);

  /// No description provided for @unlockedSubgenres.
  ///
  /// In en, this message translates to:
  /// **'Unlocked Subgenres ({amount})'**
  String unlockedSubgenres(int amount);

  /// No description provided for @unlockSubgenresUsingKeys.
  ///
  /// In en, this message translates to:
  /// **'Unlock Subgenres using keys'**
  String get unlockSubgenresUsingKeys;

  /// No description provided for @amountArtists.
  ///
  /// In en, this message translates to:
  /// **'{amount} artists '**
  String amountArtists(Object amount);

  /// No description provided for @willBeUpdated.
  ///
  /// In en, this message translates to:
  /// **'will be updated!'**
  String get willBeUpdated;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @artists.
  ///
  /// In en, this message translates to:
  /// **'Artists'**
  String get artists;

  /// No description provided for @showingResults.
  ///
  /// In en, this message translates to:
  /// **'Showing {amount} results'**
  String showingResults(int amount);

  /// No description provided for @myLiked.
  ///
  /// In en, this message translates to:
  /// **'My Liked'**
  String get myLiked;

  /// No description provided for @globalCharts.
  ///
  /// In en, this message translates to:
  /// **'Global Charts'**
  String get globalCharts;

  /// No description provided for @likedSongs.
  ///
  /// In en, this message translates to:
  /// **'Liked Songs'**
  String get likedSongs;

  /// No description provided for @artistsCharts.
  ///
  /// In en, this message translates to:
  /// **'Artists Charts'**
  String get artistsCharts;

  /// No description provided for @songsCharts.
  ///
  /// In en, this message translates to:
  /// **'Songs Charts'**
  String get songsCharts;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @artistWillBeAddedTo.
  ///
  /// In en, this message translates to:
  /// **'Artist will be added to'**
  String get artistWillBeAddedTo;

  /// No description provided for @addToMore.
  ///
  /// In en, this message translates to:
  /// **'Add to more'**
  String get addToMore;

  /// No description provided for @myCollections.
  ///
  /// In en, this message translates to:
  /// **'My Collections'**
  String get myCollections;

  /// No description provided for @createCustom.
  ///
  /// In en, this message translates to:
  /// **'Create Custom'**
  String get createCustom;

  /// No description provided for @createCollection.
  ///
  /// In en, this message translates to:
  /// **'Create Collection'**
  String get createCollection;

  /// No description provided for @artistPreview.
  ///
  /// In en, this message translates to:
  /// **'Artist Preview'**
  String get artistPreview;

  /// No description provided for @songPreview.
  ///
  /// In en, this message translates to:
  /// **'Song Preview'**
  String get songPreview;

  /// No description provided for @topSongs.
  ///
  /// In en, this message translates to:
  /// **'Top Songs'**
  String get topSongs;

  /// No description provided for @previouslyPlayedRadios.
  ///
  /// In en, this message translates to:
  /// **'Previously Played Radios'**
  String get previouslyPlayedRadios;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @followers.
  ///
  /// In en, this message translates to:
  /// **'Followers'**
  String get followers;

  /// No description provided for @following.
  ///
  /// In en, this message translates to:
  /// **'Following'**
  String get following;

  /// No description provided for @quest.
  ///
  /// In en, this message translates to:
  /// **'Quest'**
  String get quest;

  /// No description provided for @genreLevels.
  ///
  /// In en, this message translates to:
  /// **'Genre Levels'**
  String get genreLevels;

  /// No description provided for @badges.
  ///
  /// In en, this message translates to:
  /// **'Badges'**
  String get badges;

  /// No description provided for @radio.
  ///
  /// In en, this message translates to:
  /// **'Radio'**
  String get radio;

  /// No description provided for @ofLabel.
  ///
  /// In en, this message translates to:
  /// **'of'**
  String get ofLabel;

  /// No description provided for @xp.
  ///
  /// In en, this message translates to:
  /// **'XP'**
  String get xp;

  /// No description provided for @haveMoreInfo.
  ///
  /// In en, this message translates to:
  /// **'Have more info on this artist? Share it with us '**
  String get haveMoreInfo;

  /// No description provided for @completeObjectivesToEarnXP.
  ///
  /// In en, this message translates to:
  /// **'Complete Objectives to Earn XP'**
  String get completeObjectivesToEarnXP;

  /// No description provided for @claimed.
  ///
  /// In en, this message translates to:
  /// **'Claimed'**
  String get claimed;

  /// No description provided for @fullSongAdFreeExperience.
  ///
  /// In en, this message translates to:
  /// **'Full song, Ad free experience'**
  String get fullSongAdFreeExperience;

  /// No description provided for @shufflePlayAnyCollection.
  ///
  /// In en, this message translates to:
  /// **'Shuffle Play Any Collection'**
  String get shufflePlayAnyCollection;

  /// No description provided for @youNowHaveAccessToSnobsPremium.
  ///
  /// In en, this message translates to:
  /// **'You now have access to Snobs Premium'**
  String get youNowHaveAccessToSnobsPremium;

  /// No description provided for @tapAny.
  ///
  /// In en, this message translates to:
  /// **'Tap any'**
  String get tapAny;

  /// No description provided for @toStartListening.
  ///
  /// In en, this message translates to:
  /// **'to start listening'**
  String get toStartListening;

  /// No description provided for @undoLastSwipe.
  ///
  /// In en, this message translates to:
  /// **'Undo Last Swipe'**
  String get undoLastSwipe;

  /// No description provided for @music.
  ///
  /// In en, this message translates to:
  /// **'Music'**
  String get music;

  /// No description provided for @nextRank.
  ///
  /// In en, this message translates to:
  /// **'Next Rank'**
  String get nextRank;

  /// No description provided for @newRankAchieved.
  ///
  /// In en, this message translates to:
  /// **'New Rank Achieved'**
  String get newRankAchieved;

  /// No description provided for @unlockGenre.
  ///
  /// In en, this message translates to:
  /// **'Unlock {genre}'**
  String unlockGenre(String genre);

  /// No description provided for @noKeysLeft.
  ///
  /// In en, this message translates to:
  /// **'No Keys Left'**
  String get noKeysLeft;

  /// No description provided for @earnKeysByAchievingNewLevelIn.
  ///
  /// In en, this message translates to:
  /// **'Earn keys by achieving a new level in any genre'**
  String get earnKeysByAchievingNewLevelIn;

  /// No description provided for @noSubgenresUnlocked.
  ///
  /// In en, this message translates to:
  /// **'No Subgenres Unlocked'**
  String get noSubgenresUnlocked;

  /// No description provided for @useKeysToUnlockYourFavoriteSubgenres.
  ///
  /// In en, this message translates to:
  /// **'Use keys to unlock your favorite subgenres'**
  String get useKeysToUnlockYourFavoriteSubgenres;

  /// No description provided for @getPremium.
  ///
  /// In en, this message translates to:
  /// **'Get Premium'**
  String get getPremium;

  /// No description provided for @addPasswordToCreateNewAccount.
  ///
  /// In en, this message translates to:
  /// **'Add Password to Create New Account'**
  String get addPasswordToCreateNewAccount;

  /// No description provided for @weWillReviewASAP.
  ///
  /// In en, this message translates to:
  /// **'We will review ASAP'**
  String get weWillReviewASAP;

  /// No description provided for @featureRequest.
  ///
  /// In en, this message translates to:
  /// **'Feature Request'**
  String get featureRequest;

  /// No description provided for @reportIssue.
  ///
  /// In en, this message translates to:
  /// **'Report Issue'**
  String get reportIssue;

  /// No description provided for @artistIssue.
  ///
  /// In en, this message translates to:
  /// **'Artist Issue'**
  String get artistIssue;

  /// No description provided for @missingArtist.
  ///
  /// In en, this message translates to:
  /// **'Missing Artist'**
  String get missingArtist;

  /// No description provided for @subgenreRequest.
  ///
  /// In en, this message translates to:
  /// **'Subgenre Request'**
  String get subgenreRequest;

  /// No description provided for @pleaseShareDetailsYourIssue.
  ///
  /// In en, this message translates to:
  /// **'Please share the details of your issue here...'**
  String get pleaseShareDetailsYourIssue;

  /// No description provided for @reportFeature.
  ///
  /// In en, this message translates to:
  /// **'Report a Feature'**
  String get reportFeature;

  /// No description provided for @pleaseShareYourIdeaHere.
  ///
  /// In en, this message translates to:
  /// **'Please share your idea here...'**
  String get pleaseShareYourIdeaHere;

  /// No description provided for @pleaseShareWhatNeedsUpdating.
  ///
  /// In en, this message translates to:
  /// **'Please share what needs updating: bio, photos, songs etc.'**
  String get pleaseShareWhatNeedsUpdating;

  /// No description provided for @shareURLToArtistsMusicPage.
  ///
  /// In en, this message translates to:
  /// **'Share URL to Artist’s Music page (Spotify link preferred)'**
  String get shareURLToArtistsMusicPage;

  /// No description provided for @yourEmail.
  ///
  /// In en, this message translates to:
  /// **'Your Email'**
  String get yourEmail;

  /// No description provided for @pleaseShareHowWeCanHelpHere.
  ///
  /// In en, this message translates to:
  /// **'Please share how we can help here..'**
  String get pleaseShareHowWeCanHelpHere;

  /// No description provided for @enterYourEmailToContinue.
  ///
  /// In en, this message translates to:
  /// **'Enter your email to continue'**
  String get enterYourEmailToContinue;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @feedback.
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get feedback;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOut;

  /// No description provided for @swipe10xInSubgenres.
  ///
  /// In en, this message translates to:
  /// **'Swipe 10x in {amount} more subgenres'**
  String swipe10xInSubgenres(int amount);

  /// No description provided for @swipeMoreTimes.
  ///
  /// In en, this message translates to:
  /// **'Swipe {amount} more times'**
  String swipeMoreTimes(int amount);

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'forgot password'**
  String get forgotPassword;

  /// No description provided for @awesome.
  ///
  /// In en, this message translates to:
  /// **'Awesome'**
  String get awesome;

  /// No description provided for @newStreakStarted.
  ///
  /// In en, this message translates to:
  /// **'New Streak Started!'**
  String get newStreakStarted;

  /// No description provided for @dayStreak.
  ///
  /// In en, this message translates to:
  /// **'{amount} Day Streak!'**
  String dayStreak(int amount);

  /// No description provided for @countsHowConsecutiveDaysYou.
  ///
  /// In en, this message translates to:
  /// **' counts how consecutive days you have explored music with Snobs'**
  String get countsHowConsecutiveDaysYou;

  /// No description provided for @streak.
  ///
  /// In en, this message translates to:
  /// **'Streak'**
  String get streak;

  /// No description provided for @a.
  ///
  /// In en, this message translates to:
  /// **'A '**
  String get a;

  /// No description provided for @tags.
  ///
  /// In en, this message translates to:
  /// **'Tags'**
  String get tags;

  /// No description provided for @shuffleRadio.
  ///
  /// In en, this message translates to:
  /// **'Shuffle Radio'**
  String get shuffleRadio;

  /// No description provided for @listenAgain.
  ///
  /// In en, this message translates to:
  /// **'Listen Again'**
  String get listenAgain;

  /// No description provided for @ad.
  ///
  /// In en, this message translates to:
  /// **'Ad'**
  String get ad;

  /// No description provided for @visitSwipePageToExploreArtists.
  ///
  /// In en, this message translates to:
  /// **'Visit Swipe page to explore artists'**
  String get visitSwipePageToExploreArtists;

  /// No description provided for @noLikedArtists.
  ///
  /// In en, this message translates to:
  /// **'No Liked {subgenre} Artists'**
  String noLikedArtists(String subgenre);

  /// No description provided for @exploreArtists.
  ///
  /// In en, this message translates to:
  /// **'Explore Artists'**
  String get exploreArtists;

  /// No description provided for @myLikedArtists.
  ///
  /// In en, this message translates to:
  /// **'My Liked Artists'**
  String get myLikedArtists;

  /// No description provided for @myLikedSongs.
  ///
  /// In en, this message translates to:
  /// **'My Liked Songs'**
  String get myLikedSongs;

  /// No description provided for @noteSearchCaseSensitiveWeRecommend.
  ///
  /// In en, this message translates to:
  /// **'NOTE: Search is case sensitive. We recommend using uppercase first letter in most cases\nEx: Led Zeppelin'**
  String get noteSearchCaseSensitiveWeRecommend;

  /// No description provided for @areWeMissingArtist.
  ///
  /// In en, this message translates to:
  /// **'Are we missing an artist?'**
  String get areWeMissingArtist;

  /// No description provided for @letUsKnowAndWeWillLookIntoIt.
  ///
  /// In en, this message translates to:
  /// **'Let us know and we will look into it'**
  String get letUsKnowAndWeWillLookIntoIt;

  /// No description provided for @visitArtistPagesToLikeSongs.
  ///
  /// In en, this message translates to:
  /// **'Visit Artist pages to like songs'**
  String get visitArtistPagesToLikeSongs;

  /// No description provided for @visitSwipePageExploreArtists.
  ///
  /// In en, this message translates to:
  /// **'Visit Swipe page to explore artists'**
  String get visitSwipePageExploreArtists;

  /// No description provided for @wouldYouLikeExplore.
  ///
  /// In en, this message translates to:
  /// **'Would you like to explore {subgenre}'**
  String wouldYouLikeExplore(String subgenre);

  /// No description provided for @noLikedSongs.
  ///
  /// In en, this message translates to:
  /// **'No Liked {subgenre} Songs'**
  String noLikedSongs(String subgenre);

  /// No description provided for @viewPriceAmazon.
  ///
  /// In en, this message translates to:
  /// **'View Price on Amazon'**
  String get viewPriceAmazon;

  /// No description provided for @currentRank.
  ///
  /// In en, this message translates to:
  /// **'Current Rank'**
  String get currentRank;

  /// No description provided for @toLevelUp.
  ///
  /// In en, this message translates to:
  /// **'to level up'**
  String get toLevelUp;

  /// No description provided for @yesSwitchSubgenre.
  ///
  /// In en, this message translates to:
  /// **'Yes, switch subgenre'**
  String get yesSwitchSubgenre;

  /// No description provided for @youTapped.
  ///
  /// In en, this message translates to:
  /// **'You tapped'**
  String get youTapped;

  /// No description provided for @whatWouldYouLikeDo.
  ///
  /// In en, this message translates to:
  /// **'What would you like to do?'**
  String get whatWouldYouLikeDo;

  /// No description provided for @viewMyCollections.
  ///
  /// In en, this message translates to:
  /// **'View my Collection'**
  String get viewMyCollections;

  /// No description provided for @removeSubgenreTag.
  ///
  /// In en, this message translates to:
  /// **'Remove Subgenre Tag'**
  String get removeSubgenreTag;

  /// No description provided for @previews.
  ///
  /// In en, this message translates to:
  /// **'Previews'**
  String get previews;

  /// No description provided for @playing.
  ///
  /// In en, this message translates to:
  /// **'Playing'**
  String get playing;

  /// No description provided for @suggestedRadio.
  ///
  /// In en, this message translates to:
  /// **'Suggested Radio'**
  String get suggestedRadio;

  /// No description provided for @writeArtistNameHere.
  ///
  /// In en, this message translates to:
  /// **'Write artist name here...'**
  String get writeArtistNameHere;

  /// No description provided for @snobsForArtists.
  ///
  /// In en, this message translates to:
  /// **'Snobs For Artists'**
  String get snobsForArtists;

  /// No description provided for @getYourMusicHeard.
  ///
  /// In en, this message translates to:
  /// **'Get Your Music Heard'**
  String get getYourMusicHeard;

  /// No description provided for @ourCommunityOfNewExplorers.
  ///
  /// In en, this message translates to:
  /// **'Our community of new explorers are hungry for new music.'**
  String get ourCommunityOfNewExplorers;

  /// No description provided for @claimYourArtistProfileToSeeHowMany.
  ///
  /// In en, this message translates to:
  /// **'Claim your artist profile to see how many people swipe right on your music.'**
  String get claimYourArtistProfileToSeeHowMany;

  /// No description provided for @setUpYourFreeAccount.
  ///
  /// In en, this message translates to:
  /// **'Set up your free account'**
  String get setUpYourFreeAccount;

  /// No description provided for @noResult.
  ///
  /// In en, this message translates to:
  /// **'No Result'**
  String get noResult;

  /// No description provided for @nativeAdDesc.
  ///
  /// In en, this message translates to:
  /// **'Ads help keep Snobs free and awesome for everyone!\n\nThanks for supporting us by swiping, exploring, and discovering.'**
  String get nativeAdDesc;

  /// No description provided for @nativeAdPremium.
  ///
  /// In en, this message translates to:
  /// **'To disable ads, tap here to sign up for a Snobs Premium Account.'**
  String get nativeAdPremium;

  /// No description provided for @keepExploring.
  ///
  /// In en, this message translates to:
  /// **'Keep exploring and liking new artists and songs to see them here!'**
  String get keepExploring;

  /// No description provided for @premiumCardContent.
  ///
  /// In en, this message translates to:
  /// **'You can now play full songs with a Snobs Premium Trial Membership.\n\nTap the radio icon on any collection to shuffle play songs by your collected artists.\n\nYou can even play unexplored subgenres, radio will shuffle the top 25 artists.\n\nFree trial is available for a limited time, try it now and cancel anytime within 30 days and you won\'t be charged.\n\nWe built this especially for people who love exploring new music.\n\nWe hope you enjoy it!\n\n-Tom from Snobs'**
  String get premiumCardContent;
}

class _SnobsAppLocalizationsDelegate extends LocalizationsDelegate<SnobsAppLocalizations> {
  const _SnobsAppLocalizationsDelegate();

  @override
  Future<SnobsAppLocalizations> load(Locale locale) {
    return SynchronousFuture<SnobsAppLocalizations>(lookupSnobsAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_SnobsAppLocalizationsDelegate old) => false;
}

SnobsAppLocalizations lookupSnobsAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return SnobsAppLocalizationsEn();
  }

  throw FlutterError(
    'SnobsAppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}

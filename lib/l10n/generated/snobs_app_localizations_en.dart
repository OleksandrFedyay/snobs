// ignore_for_file: unnecessary_brace_in_string_interps, no_leading_underscores_for_local_identifiers

import 'snobs_app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class SnobsAppLocalizationsEn extends SnobsAppLocalizations {
  SnobsAppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get next => 'Next';

  @override
  String get explore => 'Explore';

  @override
  String get somethingWentWrong => 'Something went wrong';

  @override
  String get snobs => 'snobs';

  @override
  String get enterEmailAddress => 'Enter Email Address';

  @override
  String get invalidEmail => 'Invalid Email';

  @override
  String get finish => 'finish';

  @override
  String get goBack => 'Go Back';

  @override
  String get enterPassword => 'Enter password';

  @override
  String get createPassword => 'Create password';

  @override
  String get emptyFieldMessage => 'The field cannot be empty';

  @override
  String get invalidPassword => 'Invalid password';

  @override
  String get enterMobileNumber => 'Enter Mobile Number';

  @override
  String get invalidMobileNumber => 'Invalid Mobile Number';

  @override
  String get enterCode => 'Enter Code';

  @override
  String get submit => 'Submit';

  @override
  String get more => 'More';

  @override
  String get here => 'Here';

  @override
  String get noItems => 'No items found';

  @override
  String get appVersionCopiedClipboard => 'App version copied to clipboard!';

  @override
  String resendCode30Sec(int second) {
    return 'Resend code : $second sec';
  }

  @override
  String get resendCode => 'Resend Code';

  @override
  String get searchCountry => 'Search country';

  @override
  String get selectGenre => 'Select Genre';

  @override
  String get about => 'About';

  @override
  String get favorite => 'Favorite';

  @override
  String get favorites => 'Favorites';

  @override
  String get myProfile => 'My Profile';

  @override
  String get artist => 'Artist';

  @override
  String get fans => 'Fans';

  @override
  String get searchArtists => 'Search Artists';

  @override
  String get searchCollections => 'Search Collections';

  @override
  String get changePhoto => 'Change Photo';

  @override
  String setupYour(String name) {
    return 'Setup Your $name';
  }

  @override
  String get password => 'Password';

  @override
  String get email => 'Email';

  @override
  String get name => 'Name';

  @override
  String get save => 'Save';

  @override
  String get verify => 'Verify';

  @override
  String get verifyMobileNumber => 'Verify Mobile Number';

  @override
  String weHaveSentDigitCodeTo(int number) {
    return 'We have sent a $number digit Code to';
  }

  @override
  String get done => 'Done';

  @override
  String get cancel => 'Cancel';

  @override
  String get songs => 'Songs';

  @override
  String get moreSongs => 'More Songs';

  @override
  String get collections => 'Collections';

  @override
  String get allLiked => 'All Liked';

  @override
  String get createNewCustomCollection => 'Create new custom collection';

  @override
  String get unlike => 'Unlike';

  @override
  String get noGoBack => 'NO, GO BACK';

  @override
  String get yesUnlike => 'YES, UNLIKE';

  @override
  String get thisWillRemove => 'This will remove this artist from all your collections.';

  @override
  String unlikeArtistFrom(String name) {
    return 'Unlike $name?';
  }

  @override
  String thisWillRemoveArtistFrom(String name, String list) {
    return 'Remove $name from your $list?';
  }

  @override
  String nameRemovedFromList(String name, String list) {
    return '$name removed from $list';
  }

  @override
  String get sendFeedback => 'Send feedback';

  @override
  String get library => 'Library';

  @override
  String get liked => 'Liked';

  @override
  String get notLikedYet => 'Not liked yet';

  @override
  String get swipe => 'Swipe';

  @override
  String get reportAnIssue => 'Report an Issue';

  @override
  String get requestFeature => 'Request a Feature';

  @override
  String get giveFeedback => 'Give Feedback';

  @override
  String get howCanWeHelpYou => 'How can we help you?';

  @override
  String get weWouldLoveToHearYourIdeas => 'We would love to hear your ideas';

  @override
  String get weWouldLoveToKnowWhatYouThink => 'We would love to know what you think of the app';

  @override
  String get writeYourIssuesHere => 'Write your issues here...';

  @override
  String get shareYourThoughtsHere => 'Share your thoughts here...';

  @override
  String get shareYouFeedbackHere => 'Share you feedback here...';

  @override
  String get thankYouForFeedback => 'Thank you for your feedback! We are working hard to improve our app and will review ASAP';

  @override
  String get close => 'Close';

  @override
  String get thankYouForSharing => 'Thank you for sharing!';

  @override
  String get thankYouForSharingFeedback => 'Thank you for sharing your feedback with us!';

  @override
  String rateUsOnStore(String store) {
    return 'Rate us on $store Store';
  }

  @override
  String ifYouLoveApp(String store) {
    return 'If you love our app, please take a moment to rate it in the $store Store';
  }

  @override
  String get rateUs => 'Rate us';

  @override
  String deleteCollect(String collect) {
    return 'Delete ‘$collect’?';
  }

  @override
  String get deletingCollectionDoesNot => 'Deleting a collection does not remove liked artists from your library';

  @override
  String get yesDelete => 'Yes, Delete';

  @override
  String get sortBy => 'Sort by';

  @override
  String get sortByAz => 'Sort by A-Z';

  @override
  String get sortByDateAdded => 'Sort by Date Added';

  @override
  String get likedArtists => 'Liked Artists';

  @override
  String evaluateArtists(int amount) {
    return 'Evaluate $amount Artists';
  }

  @override
  String get facebook => 'Facebook';

  @override
  String get instagram => 'Instagram';

  @override
  String get snapchat => 'Snapchat';

  @override
  String get others => 'Others';

  @override
  String get subgenres => 'Subgenres';

  @override
  String get whatNeedsUpdating => 'What needs updating?';

  @override
  String get artistName => 'Artist Name';

  @override
  String get artistImage => 'Artist Image';

  @override
  String get bio => 'Bio';

  @override
  String get genreSubgenre => 'Genre / Subgenre';

  @override
  String get pleaseProvideDetailsHere => 'Please provide details here...';

  @override
  String get wakeup => 'Wakeup';

  @override
  String get workout => 'Workout';

  @override
  String get travel => 'Travel';

  @override
  String get focus => 'Focus';

  @override
  String get party => 'Party';

  @override
  String get relax => 'Relax';

  @override
  String get searchArtistsCollectionsInLibrary => 'Search for Artists or Collections in your library';

  @override
  String get checkoutLater => 'Checkout Later';

  @override
  String get oldPassword => 'Old password';

  @override
  String youveSwipedTimes(int amount, int number, String genre) {
    return 'You’ve swiped $number times in $genre. Swipe $amount more times to earn this badge.';
  }

  @override
  String get startSwiping => 'Start Swiping';

  @override
  String noArtistsLeft(String genre) {
    return 'No $genre Artists Left';
  }

  @override
  String get switchGenreToContinueExploring => 'Switch Genre to continue exploring';

  @override
  String get switchGenre => 'Switch Genre';

  @override
  String get skip => 'Skip';

  @override
  String get logOut => 'Log out';

  @override
  String checkoutMyCollection(String collect) {
    return 'Checkout my collection of top artists in $collect on Snobs App';
  }

  @override
  String get comingSoon => 'Coming Soon';

  @override
  String get newWord => 'New';

  @override
  String get hot => 'Hot';

  @override
  String get emerging => 'Emerging';

  @override
  String get termsConditions => 'Terms & Conditions';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get deleteAccount => 'Delete Account';

  @override
  String get noInternetConnection => 'No Internet connection';

  @override
  String get delete => 'Delete';

  @override
  String get share => 'Share';

  @override
  String get rename => 'Rename';

  @override
  String get earnBadges => 'Earn Badges';

  @override
  String get swipe100timesInAnySubgenreToEarn => 'Swipe 100 times in any subgenre to earn a badge. Once earned, they will show here.';

  @override
  String get subscriptions => 'Subscriptions';

  @override
  String get notifications => 'Notifications';

  @override
  String get support => 'Support';

  @override
  String get areYouSureYouWantToDeleteYourAccount => 'Are you sure you want to delete your account?';

  @override
  String get thisActionCannotBeUndone => 'This action cannot be undone';

  @override
  String get getRealTimeNotificationsAndAlerts => 'Get real time notifications and alerts';

  @override
  String get turnOff => 'Turn OFF';

  @override
  String get turnOn => 'Turn On';

  @override
  String get allSubgenres => 'All Subgenres';

  @override
  String get addSubgenre => 'Add a subgenre';

  @override
  String get confirm => 'Confirm';

  @override
  String wouldYouLikeToAdd(String artist, String genre) {
    return 'Would you like to add $genre to $artist in your account?';
  }

  @override
  String wouldYouLikeToRemove(String artist, String genre) {
    return 'Would you like to remove $genre from $artist in your account?';
  }

  @override
  String get thankYou => 'Thank You';

  @override
  String willIncludedInYourCollection(String artist, String genre) {
    return '$artist will be included in your $genre collection if added to your library';
  }

  @override
  String get level => 'Level';

  @override
  String get swipes => 'Swipes';

  @override
  String get levelUpAt => 'Level Up at';

  @override
  String get levelUpIn => 'Level up in';

  @override
  String get snobsPremium => 'Snobs Premium';

  @override
  String get niceWork => 'Nice Work!';

  @override
  String youHaveReachedLevelFor(int level, String genre) {
    return 'You\'ve reached\nLevel $level for $genre!';
  }

  @override
  String exploreMoreArtistsToReachLevel(int level, int amount, String genre) {
    return 'Explore $amount $genre Artists to Reach Level $level';
  }

  @override
  String get completeYourProfile => 'Complete your profile';

  @override
  String get lastName => 'Last Name';

  @override
  String get details => 'Details';

  @override
  String get fullSongRadio => 'Full Song Radio';

  @override
  String get goBeyond30SecondSongPreviews => 'Go Beyond 30 Second Song Previews';

  @override
  String get claimYourFreeTrial => 'Claim your free trial';

  @override
  String get limitedTimeOfferClaimNow => 'Limited time offer, Claim now';

  @override
  String get subscriptionAvailableForJust => 'Subscription available for just \$7.99';

  @override
  String get subscriptionTrailDetailsGoogle => '30-day free trial. After the trial, \$7.99/month. Subscription renews automatically unless canceled before the trial ends. Cancel anytime through Google Play settings. A subscription is not required to use the app but is needed for premium features.';

  @override
  String get subscriptionPremiumDetailsGoogle => '\$7.99/month. Subscription renews automatically unless canceled before the trial ends. Cancel anytime through Google Play settings. A subscription is not required to use the app but is needed for premium features.';

  @override
  String get noCreditCardRequired => 'No Credit Card Required';

  @override
  String startdayFreeTrial(int amount) {
    return 'Start $amount day free trial';
  }

  @override
  String get subscribe => 'Subscribe';

  @override
  String get only799 => 'Only \$7.99';

  @override
  String get rebelation => 'Rebelation';

  @override
  String get rebelationIsOurFullSongRadio => 'Rebelation is our full song radio streaming partner and is the brains behind our full song radio.';

  @override
  String get rebelationPlayerGetsToKnow => 'The Rebelation player gets to know you as you listen to create the perfect balance of familiar and new songs.';

  @override
  String get zipCode => 'Zip Code';

  @override
  String get zipCodeShouldContainFiveDigits => 'Zip code should contain five digits';

  @override
  String get limitedOffer => 'Limited Offer';

  @override
  String getDayFreeTrial(int amount) {
    return 'Get $amount Day Free Trial';
  }

  @override
  String get startTrial => 'Start Trial';

  @override
  String get startPremium => 'Start Premium';

  @override
  String get active => 'Active';

  @override
  String daysLeft(int amount) {
    return '$amount days left';
  }

  @override
  String get continueTitle => 'Continue';

  @override
  String get areYouSureYouWantToCancel => 'Are you sure you want to cancel ';

  @override
  String get premium => 'Premium';

  @override
  String get subscription => 'subscription';

  @override
  String get yesCancelSubscription => 'Yes, Cancel Subscription';

  @override
  String get youWillLoseAndFullSong => 'You will lose full song playback';

  @override
  String get getMorePremiumForFree => 'Get More Premium for Free';

  @override
  String cancelAnytimeBeforeAndYouWontBeCharged(String date) {
    return 'Cancel anytime before $date and you won\'t be charged, then \$7.95 per month';
  }

  @override
  String get extendYourTrial => 'Extend your trial';

  @override
  String get enjoyYourExtendedTrial => 'Enjoy your Extended Trial';

  @override
  String get renews => 'Renews';

  @override
  String get me => 'Me';

  @override
  String get moreOptions => 'more options';

  @override
  String get continueWithApple => 'Continue with Apple';

  @override
  String get continueWithGoogle => 'Continue with Google';

  @override
  String get continueWithEmail => 'Continue with email';

  @override
  String get continueWithSms => 'Continue with sms';

  @override
  String get enterEmail => 'Enter Email';

  @override
  String get startRadio => 'Start Radio';

  @override
  String get noLikedArtist => 'No liked artists. Would you like to explore';

  @override
  String get requestSubgenre => 'Request Subgenre';

  @override
  String get pleaseShareDetailsOfSubgenre => 'Please share the details of subgenre here.';

  @override
  String get writeSubgenreNameHere => 'Write subgenre name here...';

  @override
  String get write2ExampleArtistNamesHere => 'Write 2+ example artist names here...';

  @override
  String get badgeUpdate => 'Badge Update';

  @override
  String get continueSwiping => 'continue swiping';

  @override
  String get tapToListenToPreviews => 'Tap to listen to previews';

  @override
  String get yourSavedArtistsAreGroupedByCollection => 'Your saved artists are grouped by collection. Tap to see full list';

  @override
  String get tapOnAnyArtistToView => 'Tap on any artist to view information and preview more songs';

  @override
  String get tapOnThisIconToAddRemove => 'Tap on this icon to add or remove artist from your collections';

  @override
  String get getSnobsPremium => 'Get Snobs Premium';

  @override
  String get weAreAnInclusiveCommunityOfMusicEnthusiasts => 'We are an inclusive community of music enthusiasts';

  @override
  String get weAreGladYouAreJoiningUs => 'We are glad you are joining us!';

  @override
  String get whatShouldWeCallYou => 'What should we call you?';

  @override
  String get enterYourName => 'Enter your name';

  @override
  String get whatGenreWouldYouLikeToExploreFirst => 'What genre would you like to explore first?';

  @override
  String get hi => 'Hi';

  @override
  String get all => 'All';

  @override
  String get exploring => 'EXPLORING';

  @override
  String get random => 'Random';

  @override
  String get pressAndHoldToSelect => 'Press and hold to select and move artists';

  @override
  String get selectALL => 'Select ALL';

  @override
  String get remove => 'Remove';

  @override
  String get swipeAll => 'Swipe all';

  @override
  String get exploredSubgenres => 'Explored Subgenres';

  @override
  String get unexploredSubgenres => 'Unexplored Subgenres';

  @override
  String get selectUnexploredSubgenre => 'Select an unexplored subgenre';

  @override
  String noExploredSubgenres(String genre) {
    return 'No Explored $genre Subgenres';
  }

  @override
  String get congratsExploredAllSubgenres => 'Congrats you have explored all available subgenres';

  @override
  String noUnexploredSubgenres(String genre) {
    return 'No Unexplored $genre Subgenres';
  }

  @override
  String unlockedSubgenres(int amount) {
    return 'Unlocked Subgenres ($amount)';
  }

  @override
  String get unlockSubgenresUsingKeys => 'Unlock Subgenres using keys';

  @override
  String amountArtists(Object amount) {
    return '$amount artists ';
  }

  @override
  String get willBeUpdated => 'will be updated!';

  @override
  String get search => 'Search';

  @override
  String get artists => 'Artists';

  @override
  String showingResults(int amount) {
    return 'Showing $amount results';
  }

  @override
  String get myLiked => 'My Liked';

  @override
  String get globalCharts => 'Global Charts';

  @override
  String get likedSongs => 'Liked Songs';

  @override
  String get artistsCharts => 'Artists Charts';

  @override
  String get songsCharts => 'Songs Charts';

  @override
  String get profile => 'Profile';

  @override
  String get artistWillBeAddedTo => 'Artist will be added to';

  @override
  String get addToMore => 'Add to more';

  @override
  String get myCollections => 'My Collections';

  @override
  String get createCustom => 'Create Custom';

  @override
  String get createCollection => 'Create Collection';

  @override
  String get artistPreview => 'Artist Preview';

  @override
  String get songPreview => 'Song Preview';

  @override
  String get topSongs => 'Top Songs';

  @override
  String get previouslyPlayedRadios => 'Previously Played Radios';

  @override
  String get add => 'Add';

  @override
  String get followers => 'Followers';

  @override
  String get following => 'Following';

  @override
  String get quest => 'Quest';

  @override
  String get genreLevels => 'Genre Levels';

  @override
  String get badges => 'Badges';

  @override
  String get radio => 'Radio';

  @override
  String get ofLabel => 'of';

  @override
  String get xp => 'XP';

  @override
  String get haveMoreInfo => 'Have more info on this artist? Share it with us ';

  @override
  String get completeObjectivesToEarnXP => 'Complete Objectives to Earn XP';

  @override
  String get claimed => 'Claimed';

  @override
  String get fullSongAdFreeExperience => 'Full song, Ad free experience';

  @override
  String get shufflePlayAnyCollection => 'Shuffle Play Any Collection';

  @override
  String get youNowHaveAccessToSnobsPremium => 'You now have access to Snobs Premium';

  @override
  String get tapAny => 'Tap any';

  @override
  String get toStartListening => 'to start listening';

  @override
  String get undoLastSwipe => 'Undo Last Swipe';

  @override
  String get music => 'Music';

  @override
  String get nextRank => 'Next Rank';

  @override
  String get newRankAchieved => 'New Rank Achieved';

  @override
  String unlockGenre(String genre) {
    return 'Unlock $genre';
  }

  @override
  String get noKeysLeft => 'No Keys Left';

  @override
  String get earnKeysByAchievingNewLevelIn => 'Earn keys by achieving a new level in any genre';

  @override
  String get noSubgenresUnlocked => 'No Subgenres Unlocked';

  @override
  String get useKeysToUnlockYourFavoriteSubgenres => 'Use keys to unlock your favorite subgenres';

  @override
  String get getPremium => 'Get Premium';

  @override
  String get addPasswordToCreateNewAccount => 'Add Password to Create New Account';

  @override
  String get weWillReviewASAP => 'We will review ASAP';

  @override
  String get featureRequest => 'Feature Request';

  @override
  String get reportIssue => 'Report Issue';

  @override
  String get artistIssue => 'Artist Issue';

  @override
  String get missingArtist => 'Missing Artist';

  @override
  String get subgenreRequest => 'Subgenre Request';

  @override
  String get pleaseShareDetailsYourIssue => 'Please share the details of your issue here...';

  @override
  String get reportFeature => 'Report a Feature';

  @override
  String get pleaseShareYourIdeaHere => 'Please share your idea here...';

  @override
  String get pleaseShareWhatNeedsUpdating => 'Please share what needs updating: bio, photos, songs etc.';

  @override
  String get shareURLToArtistsMusicPage => 'Share URL to Artist’s Music page (Spotify link preferred)';

  @override
  String get yourEmail => 'Your Email';

  @override
  String get pleaseShareHowWeCanHelpHere => 'Please share how we can help here..';

  @override
  String get enterYourEmailToContinue => 'Enter your email to continue';

  @override
  String get settings => 'Settings';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get feedback => 'Feedback';

  @override
  String get signOut => 'Sign Out';

  @override
  String swipe10xInSubgenres(int amount) {
    return 'Swipe 10x in $amount more subgenres';
  }

  @override
  String swipeMoreTimes(int amount) {
    return 'Swipe $amount more times';
  }

  @override
  String get forgotPassword => 'forgot password';

  @override
  String get awesome => 'Awesome';

  @override
  String get newStreakStarted => 'New Streak Started!';

  @override
  String dayStreak(int amount) {
    return '$amount Day Streak!';
  }

  @override
  String get countsHowConsecutiveDaysYou => ' counts how consecutive days you have explored music with Snobs';

  @override
  String get streak => 'Streak';

  @override
  String get a => 'A ';

  @override
  String get tags => 'Tags';

  @override
  String get shuffleRadio => 'Shuffle Radio';

  @override
  String get listenAgain => 'Listen Again';

  @override
  String get ad => 'Ad';

  @override
  String get visitSwipePageToExploreArtists => 'Visit Swipe page to explore artists';

  @override
  String noLikedArtists(String subgenre) {
    return 'No Liked $subgenre Artists';
  }

  @override
  String get exploreArtists => 'Explore Artists';

  @override
  String get myLikedArtists => 'My Liked Artists';

  @override
  String get myLikedSongs => 'My Liked Songs';

  @override
  String get noteSearchCaseSensitiveWeRecommend => 'NOTE: Search is case sensitive. We recommend using uppercase first letter in most cases\nEx: Led Zeppelin';

  @override
  String get areWeMissingArtist => 'Are we missing an artist?';

  @override
  String get letUsKnowAndWeWillLookIntoIt => 'Let us know and we will look into it';

  @override
  String get visitArtistPagesToLikeSongs => 'Visit Artist pages to like songs';

  @override
  String get visitSwipePageExploreArtists => 'Visit Swipe page to explore artists';

  @override
  String wouldYouLikeExplore(String subgenre) {
    return 'Would you like to explore $subgenre';
  }

  @override
  String noLikedSongs(String subgenre) {
    return 'No Liked $subgenre Songs';
  }

  @override
  String get viewPriceAmazon => 'View Price on Amazon';

  @override
  String get currentRank => 'Current Rank';

  @override
  String get toLevelUp => 'to level up';

  @override
  String get yesSwitchSubgenre => 'Yes, switch subgenre';

  @override
  String get youTapped => 'You tapped';

  @override
  String get whatWouldYouLikeDo => 'What would you like to do?';

  @override
  String get viewMyCollections => 'View my Collection';

  @override
  String get removeSubgenreTag => 'Remove Subgenre Tag';

  @override
  String get previews => 'Previews';

  @override
  String get playing => 'Playing';

  @override
  String get suggestedRadio => 'Suggested Radio';

  @override
  String get writeArtistNameHere => 'Write artist name here...';

  @override
  String get snobsForArtists => 'Snobs For Artists';

  @override
  String get getYourMusicHeard => 'Get Your Music Heard';

  @override
  String get ourCommunityOfNewExplorers => 'Our community of new explorers are hungry for new music.';

  @override
  String get claimYourArtistProfileToSeeHowMany => 'Claim your artist profile to see how many people swipe right on your music.';

  @override
  String get setUpYourFreeAccount => 'Set up your free account';

  @override
  String get noResult => 'No Result';

  @override
  String get nativeAdDesc => 'Ads help keep Snobs free and awesome for everyone!\n\nThanks for supporting us by swiping, exploring, and discovering.';

  @override
  String get nativeAdPremium => 'To disable ads, tap here to sign up for a Snobs Premium Account.';

  @override
  String get keepExploring => 'Keep exploring and liking new artists and songs to see them here!';

  @override
  String get premiumCardContent => 'You can now play full songs with a Snobs Premium Trial Membership.\n\nTap the radio icon on any collection to shuffle play songs by your collected artists.\n\nYou can even play unexplored subgenres, radio will shuffle the top 25 artists.\n\nFree trial is available for a limited time, try it now and cancel anytime within 30 days and you won\'t be charged.\n\nWe built this especially for people who love exploring new music.\n\nWe hope you enjoy it!\n\n-Tom from Snobs';
}

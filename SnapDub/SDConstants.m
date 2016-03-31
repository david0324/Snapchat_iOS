//
//  DubConstants.m
//  SnapDub
//
//  Created by Xun_Cai on 2015-04-29.
//
//

#import "SDConstants.h"

@implementation SDConstants

//============ User Default Key Saving Loading =========================
NSString* const kUserDefault_SDFilesNeedeToBeUploaded_SaveSoundList = @"SDFilesNeedeToBeUploaded_soundlist";
NSString* const kUserDefault_SDFilesNeedeToBeUploaded_SaveVideoList = @"SDFilesNeedeToBeUploaded_videolist";
NSString* const kUserDefault_SDFilesNeedeToBeUploaded_SaveSoundboardsList = @"SDFilesNeedeToBeUploaded_soundboardslist";
NSString* const kUserDefault_SDFilesNeedeToBeUploaded_SaveSoundAndSoundboard = @"SDFilesNeedeToBeUploaded_soundAndSoundboard";



//=================Parse Key ========================================

NSString* const kSDCreatedAt = @"createdAt";
NSString* const kSDObjectId = @"objectId";
NSString* const kSDOrderValue = @"orderValue";
NSString* const kSDOfflineFileName = @"offlineFileName";
NSString* const kSDOfflineId = @"offlineId";

//=================Stat ========================================
NSString* const kSDPlayCountKey = @"playCount";
NSString* const kSDLikeCountKey = @"likeCount";
NSString* const kSDRedubCountKey = @"redubCount";
NSString* const kSDSharedCountKey = @"sharedCount";
NSString* const kSDOrderValueKey = @"orderValue";

//=========================== User =======================================

NSString* const kSDUserNameKey = @"username";
NSString* const kSDUserNumFollowKey = @"numFollow";
NSString* const kSDUserNumLikeKey = @"numLike";
NSString* const kSDUserNumShareKey = @"numShare";
NSString* const kSDUserNumVideoPlayCountKey = @"numVideoPlayedCount";
NSString* const kSDUserNumSoundPlayCountKey = @"numSoundPlayedCount";
NSString* const kSDUserProfileNameKey = @"profileName";
NSString* const kSDUserProfileImageKey = @"profileImage";
NSString* const kSDUserProfileImageBackupKey = @"Profile";
NSString* const kSDUserProfileImageBackupKey2 = @"avatarUser";


//=========================== UserActivity ================================
NSString* const kSDUserActivityClassName = @"UserActivity";
NSString* const kSDUserActivityFromUserRefKey = @"fromUserRef";
NSString* const kSDUserActivityToUserRefKey = @"toUserRef";
NSString* const kSDUserActivityActivityTypeKey = @"activitytype";
NSString* const kSDUserActivityDubSoundRefKey = @"dubSoundDataRef";
NSString* const kSDUserActivityDubVideoRefKey = @"dubVideoRef";
NSString* const kSDUserActivityDubSoundBoardRef = @"dubSoundBoardRef";

NSString* const kSDUserActivityActivityTypeFollowAUserValue = @"FOLLOW_A_USER";
NSString* const kSDUserActivityActivityTypeFollowADubSoundBoardValue = @"FOLLOW_A_DUBSOUNDBOARD";
NSString* const kSDUserActivityActivityTypeLikeADubSoundValue = @"LIKE_A_DUBSOUND";
NSString* const kSDUserActivityActivityTypeLikeADubVideoValue = @"LIKE_A_DUBVIDEO";
NSString* const kSDUserActivityActivityTypePostADubVideoValue = @"POST_A_DUBVIDEO";
NSString* const kSDUserActivityActivityTypeREDUBADubVideoValue = @"REDUB_A_DUBVIDEO";
NSString* const kSDUserActivityActivityTypePostADubSoundValue = @"POST_A_DUBSOUND";
NSString* const kSDUserActivityActivityTypeREDUBADubSoundValue = @"REDUB_A_DUBSOUND";
NSString* const kSDUserActivityActivityTypePostADubSoundboardValue = @"POST_A_DUBSOUNDBOARD";
NSString* const kSDUserActivityActivityTypePostACommentValue = @"POST_A_COMMENT";

//=========================== DubSound ====================================
NSString* const kSDDubSoundClassName = @"SoundData";
NSString* const kSDDubSoundSoundFileKey = @"soundFile";
NSString* const kSDDubSoundSoundNameKey = @"soundName";
NSString* const kSDDubSoundDurationKey = @"duration";
NSString* const kSDDubSoundSoundLanguageKey = @"soundLanguage";
NSString* const kSDDubSoundTagsKey = @"tags";
NSString* const kSDDubSoundCreatorKey = @"userRef";
NSString* const kSDDubSoundScoreKey = @"score";
NSString* const kSDDubSoundPlayCountKey = @"playCount";
NSString* const kSDDubSoundLikeCountKey = @"likeCount";
NSString* const kSDDubSoundProblemReportedCountKey = @"problemReportedCount";
NSString* const kSDDubSoundCategoryRefKey = @"categoryRef";
NSString* const kSDDubSoundIsEditing = @"isEditing";

NSString* const kSDDubSoundSoundLanguageEnglishValue = @"ENGLISH";
NSString* const kSDDubSoundSoundLanguageSpanishValue = @"SPANISH";

//=========================== DubVideo ====================================
NSString* const kSDDubVideoClassName = @"DubVideo";
NSString* const kSDDubVideoVideoNameKey = @"videoName";
NSString* const kSDDubVideoDurationKey = @"duration";
NSString* const kSDDubVideoVideoFileKey = @"videoFile";
NSString* const kSDDubVideoDescriptionKey = @"description";
NSString* const kSDDubVideoCreatorKey = @"creator";
NSString* const kSDDubVideoLinkedSoundRefKey = @"soundDataRef";
NSString* const kSDDubVideoPlayCountKey = @"playCount";
NSString* const kSDDubVideoLikeCountKey = @"likeCount";
NSString* const kSDDubVideoCommentCountKey = @"commentCount";
NSString* const kSDDubVideoShareCountKey = @"shareCount";
NSString* const kSDDubVideoProblemReportedCountKey = @"problemReportedCount";
NSString* const kSDDubVideoCategoryRefKey = @"categoryRef";
NSString* const kSDDubVideoCategoryHiddenKey = @"hidden";

//=========================== DubSoundBaord ================================
NSString* const kSDDubSoundboardClassName = @"DubSoundBoard";
NSString* const kSDDubSoundboardSoundboardNameKey = @"soundBaordName";
NSString* const kSDDubSoundboardCoverImageKey = @"coverImage";
NSString* const kSDDubSoundboardChosenPresetImageName = @"chosenPresetImageName";
NSString* const kSDDubSoundboardCreatorKey = @"creator";
NSString* const kSDDubSoundboardNumFollowingKey = @"numFollowing";
NSString* const kSDDubSoundboardNumPlayKey = @"numPlay";

//=========================== DubUserToDubSoundboard ======================
NSString* const kSDDubUserToDubSoundboardMapClassName = @"DubUserToDubSoundBoardMap";
NSString* const kSDDubUserToDubSoundboardMapCreatorKey = @"creator";
NSString* const kSDDubUserToDubSoundboardMapDubSoundboardRefKey = @"dubSoundBoardRef";

//=========================== DubSoundToDubSoundBoardMap ======================
NSString* const kSDDubSoundToDubSoundBoardMapClassName = @"DubSoundToDubSoundBoardMap";
NSString* const kSDDubSoundToDubSoundBoardMapDubSoundboardRefKey = @"dubSoundBoardRef";
NSString* const kSDDubSoundToDubSoundBoardMapDubSoundRefKey = @"dubSound_SoundDataRef";

//=========================== DubUserToDubSoundMap ============================
NSString* const kSDDubUserToDubSoundMapClassName = @"DubUserToDubSoundMap";
NSString* const kSDDubUserToDubSoundMapCreatorKey = @"creator";
NSString* const kSDDubUserToDubSoundMapDubSoundRefKey = @"dubSoundRef";

//=========================== DubUserToDubVideoMap ============================
NSString* const kSDDubUserToDubVideoClassName = @"DubUserToDubVideoMap";
NSString* const kSDDubUserToDubVideoCreatorKey = @"creator";
NSString* const kSDDubUserToDubVideoDubVideoRefKey = @"dubVideoRef";

//=========================== FeaturedDubVideo ============================
NSString* const kSDFeaturedDubVideoClassName = @"FeaturedVideos";
NSString* const kSDFeaturedDubVideoDubVideoRefKey = @"dubVideoRef";
NSString* const kSDFeaturedDubVideoOrderValueKey = @"orderValue";
NSString* const kSDFeaturedDubVideoCategoryRefKey = @"categoryRef";

//=========================== FeaturedDubSound ============================
NSString* const kSDFeaturedDubSoundClassName = @"FeaturedSounds";
NSString* const kSDFeaturedDubSoundDubSoundRefKey = @"dubSound_SoundDataRef";
NSString* const kSDFeaturedDubSoundDubCategoryRefKey = @"categoryRef";
NSString* const kSDFeaturedDubSoundOrderValueKey = @"orderValue";

//=========================== FeaturedDubSoundBoard ============================
NSString* const kSDFeaturedDubSoundboardClassName = @"FeatureDubSoundBoard";
NSString* const kSDFeaturedDubSoundboardDubSoundboardRefKey = @"dubSoundBoardRef";
NSString* const kSDFeaturedDubSoundboardOrderValueKey = @"orderValue";

//=========================== Comment ============================
NSString* const kSDCommentClassName = @"Comment";
NSString* const kSDCommentFromUserRefKey = @"fromUserRef";
NSString* const kSDCommentDubVideoRefKey = @"dubVideoRef";
NSString* const kSDCommentDubSoundBoardRefKey = @"dubSoundBoardRef";
NSString* const kSDCommentCommentKey = @"comment";

//=========================== Category ============================
NSString* const kSDCategoryClassName = @"DubCategory";
NSString* const kSDCategoryNameKey = @"categoryName";
NSString* const kSDCategoryIconImageFileKey = @"iconImageFile";

//=========================== Featured ============================
NSString* const kSDFeaturedSoundClassName = @"FeaturedSounds";
NSString* const kSDFeaturedSoundDubSoundRefKey = @"dubSound_SoundDataRef";

NSString* const kSDFeaturedSoundboardClassName = @"FeaturedSoundboards";
NSString* const kSDFeaturedSoundboardDubSoundboardRefKey = @"dubSoundboardRef";

//=========================== Top Contents ============================
NSString* const kSDTopDubSoundsClassName = @"TopDubSounds";
NSString* const kSDTopDubSoundsDubSoundRefKey = @"dubSound_SoundDataRef";
NSString* const kSDTopDubSoundsCategoryKey = @"categoryRef";


NSString* const kSDTopDubSoundboardsClassName = @"TopDubSoundboards";
NSString* const kSDTopDubSoundboardsSoundboardRefKey = @"dubSoundboardRef";

NSString* const kSDTopDubVideosClassName = @"TopDubVideo";
NSString* const kSDTopDubVideosCategoryKey = @"categoryRef";
NSString* const kSDTopDubVideosVideoRef = @"dubVideoRef";


//=========================== Top Contents ============================
NSString* const kSDEventUserSoundsCollectionUpdated = @"userSoundsCollectionUpdated";






//=========================== Evants ===================================
NSString* const EVENT_SOUNDBOARD_CREATED = @"EVENT_SOUNDBOARD_CREATED";
NSString* const EVENT_SOUND_CREATED = @"EVENT_SOUND_CREATED";
NSString* const EVENT_SOUND_FAV_CHANGED = @"EVENT_SOUND_FAV_CHANGED";

NSString* const EVENT_STOP_PLAYING = @"EVENT_STOP_PLAYING";

NSString* const EVENT_SOUND_FINISH_PLAYING = @"EVENT_SOUND_FINISH_PLAYING";

@end

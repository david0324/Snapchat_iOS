//
//  DubConstants.h
//  SnapDub
//
//  Created by Xun_Cai on 2015-04-29.
//
//

#import <Foundation/Foundation.h>

@interface SDConstants : NSObject

//============ User Default Key Saving Loading =========================
extern NSString* const kUserDefault_SDFilesNeedeToBeUploaded_SaveSoundList;
extern NSString* const kUserDefault_SDFilesNeedeToBeUploaded_SaveVideoList;
extern NSString* const kUserDefault_SDFilesNeedeToBeUploaded_SaveSoundboardsList;
extern NSString* const kUserDefault_SDFilesNeedeToBeUploaded_SaveSoundAndSoundboard;

//=================Parse Key ========================================
extern NSString* const kSDCreatedAt;
extern NSString* const kSDObjectId;
extern NSString* const kSDOfflineFileName;
extern NSString* const kSDOfflineId;
extern NSString* const kSDOrderValue;

//=================Stat ========================================
extern NSString* const kSDPlayCountKey;
extern NSString* const kSDLikeCountKey;
extern NSString* const kSDRedubCountKey;
extern NSString* const kSDSharedCountKey;
extern NSString* const kSDOrderValueKey;

//=========================== User =======================================

extern NSString* const kSDUserNameKey;
extern NSString* const kSDUserNumFollowKey;
extern NSString* const kSDUserNumLikeKey;
extern NSString* const kSDUserNumShareKey;
extern NSString* const kSDUserNumVideoPlayCountKey;
extern NSString* const kSDUserNumSoundPlayCountKey;
extern NSString* const kSDUserProfileNameKey;
extern NSString* const kSDUserProfileImageKey;
extern NSString* const kSDUserProfileImageBackupKey;
extern NSString* const kSDUserProfileImageBackupKey2;
//=========================== UserActivity ================================
extern NSString* const kSDUserActivityClassName;
extern NSString* const kSDUserActivityFromUserRefKey;
extern NSString* const kSDUserActivityToUserRefKey;
extern NSString* const kSDUserActivityActivityTypeKey;
extern NSString* const kSDUserActivityDubSoundRefKey;
extern NSString* const kSDUserActivityDubVideoRefKey;
extern NSString* const kSDUserActivityDubSoundBoardRef;

extern NSString* const kSDUserActivityActivityTypeFollowAUserValue;
extern NSString* const kSDUserActivityActivityTypeFollowADubSoundBoardValue;
extern NSString* const kSDUserActivityActivityTypeLikeADubSoundValue;
extern NSString* const kSDUserActivityActivityTypeLikeADubVideoValue;
extern NSString* const kSDUserActivityActivityTypePostADubVideoValue;
extern NSString* const kSDUserActivityActivityTypeREDUBADubVideoValue;
extern NSString* const kSDUserActivityActivityTypePostADubSoundValue;
extern NSString* const kSDUserActivityActivityTypeREDUBADubSoundValue;
extern NSString* const kSDUserActivityActivityTypePostADubSoundboardValue;
extern NSString* const kSDUserActivityActivityTypePostACommentValue;

//=========================== DubSound ====================================
extern NSString* const kSDDubSoundClassName;
extern NSString* const kSDDubSoundSoundFileKey;
extern NSString* const kSDDubSoundSoundNameKey;
extern NSString* const kSDDubSoundDurationKey;
extern NSString* const kSDDubSoundSoundLanguageKey;
extern NSString* const kSDDubSoundTagsKey;
extern NSString* const kSDDubSoundCreatorKey;
extern NSString* const kSDDubSoundScoreKey;
extern NSString* const kSDDubSoundPlayCountKey;
extern NSString* const kSDDubSoundLikeCountKey;
extern NSString* const kSDDubSoundProblemReportedCountKey;
extern NSString* const kSDDubSoundCategoryRefKey;
extern NSString* const kSDDubSoundIsEditing;

extern NSString* const kSDDubSoundSoundLanguageEnglishValue;
extern NSString* const kSDDubSoundSoundLanguageSpanishValue;

//=========================== DubVideo ====================================
extern NSString* const kSDDubVideoClassName;
extern NSString* const kSDDubVideoVideoNameKey;
extern NSString* const kSDDubVideoDurationKey;
extern NSString* const kSDDubVideoVideoFileKey;
extern NSString* const kSDDubVideoDescriptionKey;
extern NSString* const kSDDubVideoCreatorKey;
extern NSString* const kSDDubVideoLinkedSoundRefKey;
extern NSString* const kSDDubVideoPlayCountKey;
extern NSString* const kSDDubVideoLikeCountKey;
extern NSString* const kSDDubVideoShareCountKey;
extern NSString* const kSDDubVideoProblemReportedCountKey;
extern NSString* const kSDDubVideoCategoryRefKey;
extern NSString* const kSDDubVideoCategoryHiddenKey;
extern NSString* const kSDDubVideoCommentCountKey;

//=========================== DubSoundBaord ================================
extern NSString* const kSDDubSoundboardClassName;
extern NSString* const kSDDubSoundboardSoundboardNameKey;
extern NSString* const kSDDubSoundboardCoverImageKey;
extern NSString* const kSDDubSoundboardChosenPresetImageName;
extern NSString* const kSDDubSoundboardCreatorKey;
extern NSString* const kSDDubSoundboardNumFollowingKey;
extern NSString* const kSDDubSoundboardNumPlayKey;

//=========================== DubUserToDubSoundboard ======================
extern NSString* const kSDDubUserToDubSoundboardMapClassName;
extern NSString* const kSDDubUserToDubSoundboardMapCreatorKey;
extern NSString* const kSDDubUserToDubSoundboardMapDubSoundboardRefKey;

//=========================== DubSoundToDubSoundBoardMap ======================
extern NSString* const kSDDubSoundToDubSoundBoardMapClassName;
extern NSString* const kSDDubSoundToDubSoundBoardMapDubSoundboardRefKey;
extern NSString* const kSDDubSoundToDubSoundBoardMapDubSoundRefKey;

//=========================== DubUserToDubSoundMap ============================
extern NSString* const kSDDubUserToDubSoundMapClassName;
extern NSString* const kSDDubUserToDubSoundMapCreatorKey;
extern NSString* const kSDDubUserToDubSoundMapDubSoundRefKey;

//=========================== DubUserToDubVideoMap ============================
extern NSString* const kSDDubUserToDubVideoClassName;
extern NSString* const kSDDubUserToDubVideoCreatorKey;
extern NSString* const kSDDubUserToDubVideoDubVideoRefKey;

//=========================== FeaturedDubVideo ============================
extern NSString* const kSDFeaturedDubVideoClassName;
extern NSString* const kSDFeaturedDubVideoDubVideoRefKey;
extern NSString* const kSDFeaturedDubVideoOrderValueKey;
extern NSString* const kSDFeaturedDubVideoCategoryRefKey;

//=========================== FeaturedDubSound ============================
extern NSString* const kSDFeaturedDubSoundClassName;
extern NSString* const kSDFeaturedDubSoundDubSoundRefKey;
extern NSString* const kSDFeaturedDubSoundDubCategoryRefKey;
extern NSString* const kSDFeaturedDubSoundOrderValueKey;
//=========================== FeaturedDubSoundBoard ============================
extern NSString* const kSDFeaturedDubSoundboardClassName;
extern NSString* const kSDFeaturedDubSoundboardDubSoundboardRefKey;
extern NSString* const kSDFeaturedDubSoundboardOrderValueKey;

//=========================== Comment ============================
extern NSString* const kSDCommentClassName;
extern NSString* const kSDCommentFromUserRefKey;
extern NSString* const kSDCommentDubVideoRefKey;
extern NSString* const kSDCommentDubSoundBoardRefKey;
extern NSString* const kSDCommentCommentKey;

//=========================== Category ============================
extern NSString* const kSDCategoryClassName;
extern NSString* const kSDCategoryNameKey;
extern NSString* const kSDCategoryIconImageFileKey;

//=========================== Featured ============================
extern NSString* const kSDFeaturedSoundClassName;
extern NSString* const kSDFeaturedSoundDubSoundRefKey;

extern NSString* const kSDFeaturedSoundboardClassName;
extern NSString* const kSDFeaturedSoundboardDubSoundboardRefKey;

//=========================== Top Contents ============================
extern NSString* const kSDTopDubSoundsClassName;
extern NSString* const kSDTopDubSoundsDubSoundRefKey;
extern NSString* const kSDTopDubSoundsCategoryKey;

extern NSString* const kSDTopDubSoundboardsClassName;
extern NSString* const kSDTopDubSoundboardsSoundboardRefKey;

extern NSString* const kSDTopDubVideosClassName;
extern NSString* const kSDTopDubVideosCategoryKey;
extern NSString* const kSDTopDubVideosVideoRef;


//=========================== Top Contents ============================
extern NSString* const kSDEventUserSoundsCollectionUpdated;

//=========================== Evants ===================================
extern NSString* const EVENT_SOUNDBOARD_CREATED;
extern NSString* const EVENT_SOUND_CREATED;
extern NSString* const EVENT_SOUND_FAV_CHANGED;
extern NSString* const EVENT_STOP_PLAYING;
extern NSString* const EVENT_SOUND_FINISH_PLAYING;
@end

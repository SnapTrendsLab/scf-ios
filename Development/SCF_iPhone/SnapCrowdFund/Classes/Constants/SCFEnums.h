//
//  SCFEnums.h
//  SnapCrowdFund
//
//  Created by Sajil on 5/23/13.
//  Copyright (c) 2013 snaptrendslab. All rights reserved.
//

typedef enum
{
	eHTTPResoponseOK = 200,
	eHTTPResoponseCreated = 201,
	eHTTPResoponseEmpty	= 204,
	eHTTPResoponseMovedTemporarily = 302,
	eHTTPResoponseBadRequest = 400,
	eHTTPResoponseUnAuthorized = 401,
	eHTTPResoponseForbidden = 403,
	eHTTPResoponseNotFound = 404,
	eHTTPResoponseConflictOrDuplicate = 409,
	eHTTPResoponseGone = 410,
	eHTTPResoponseInternalError = 500,
	eHTTPResoponseInvalidParameter = 501,
	eHTTPResoponseInvalidSession = 503,
	eHTTPResponseInvalidChannel = 504,
	eHTTPResponseInvalidLocation = 505,
	eHTTPResponseNoDataFound = 506,
	
	eHTTPResponseDeviceAlreadyRegistered = 510,
	eHTTPResponseUserAlreadyRegistered = 511,
	eHTTPResponseInvalidUsernameOrPassword = 512,
	eHTTPResponseInvalidUser = 513,
	eHTTPResponseTransactionID = 514,
	eHTTPResponseInvalidFileType = 515,
	eHTTPResponseFileSizeExceeded = 516,
	eHTTPResponseTextIsTooLong = 517,
	eHTTPResponseInvalidPostID = 518,
	eHTTPResponseUserAlreadyFollowing = 519,
	eHTTPResponseInvalidBlogger = 520,
	eHTTPResponseUserNotFollowingBlogger = 522,
	eHTTPResponseInvalidMSISDN = 523,
	eHTTPResponseInvalidPassword = 524,
	eHTTPResponseYouAreNotAllowedToFollowThisBlogger = 525,
	eHTTPResponseWrongAuthenticationDetails = 532
}SCFHTTPResponseStatusCode;


typedef enum {
    eSCFActivityWaiting,
    eSCFActivityFunded,
    eSCFActivityClosed,
}SCFActivityStatus;

typedef enum {
    eSCFActivityCrowd,
    eSCFActivityGroup,
    eSCFActivityPersonal,
}SCFActivityType;

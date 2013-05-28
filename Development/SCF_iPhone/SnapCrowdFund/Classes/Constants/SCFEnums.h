//
//  SCFEnums.h
//  SnapCrowdFund
//
//  Created by Sajil on 5/23/13.
//  Copyright (c) 2013 snaptrendslab. All rights reserved.
//


typedef enum  
{
    eSessionExpired                         = 105,
	eLoginQuery                             =2000,
	eSignUpquery                            =2001,
	eLogoutQuery                            =2002,
	echangeProfilephotoQuery                =2003,
	edisplayuserProfilequery                =2005,
	eEditprofilequery                       =2006,
	eaddcontactQuery                        =2007,
	eAcceptContactQuery                     =2008,
	eRejectContactQuery                     =2009,
	eUpdateUserStausQuery                   =2010,
	eCheckUserNameAvaibilityQuery           =2011,
	eForgotpasswordQuery                    =2012,
	euploadPhotoQuery                       =2013,
	
    eDeleteContactQuery                     =2014,
	eSearchwinkuserQuery                    =2015,
	
    eSearchChatuserQuery                    =2016,
	eSendWiinkQuery                         =2017,
	eDeleteUserQuery                        =2018,
	eGetUserChatHistoryQuery				=2019,
	eGetUserChatsQuery                      =2020,
	eWiinkLikeQuery                         =2027,
	eUserProfileQuery                       =2028,
    eDeleteUserWiinkQuery                   =2029,
    
    eGetFriendsListQuery                    =2030,
    eGetContactRequestsQuery                =2031,
    eGetFollowersListQuery                  =2032,
    eGetFollowingListQuery                  =2033,
    eSendFollowQuery                        =2034,
    eChangePasswordQuery                    =2035,
    eSendFlagForReviewQuery                 =2036,
    eSendBlockUserQuery                     =2037,
    eSendUnblockUserQuery                   =2038,
        
    eGetLoopChatQuery                       =2039,
    eSendShareToChatQuery                   =2040,
    eSendShareToLoopQuery                   =2041,
    eSendShareToStreamQuery                 =2042,
    
    eGetLoopsOnCategoriesQuery              =2043,
    eGetMyCategoriesQuery                   =2044,
    eGetMySubCategoriesForSelectCategory    =2045,
    
    eGetMyLoopsQuery                        =2046,
    eGetLoopDetailsQuery                    =2047,
    eCreateLoopQuery                        =2048,
    
    eSendAddCategoryQuery                   =2049,
    eSendAddContactInLoopQuery              =2050,
    eSendFavouriteLoopsQuery                =2051,
    
    eSendDeleteLoopQuery                    =2052,
    eSendDeleteCategoryQuery                =2053,
    eSendDeleteContactsInLoopQuery          =2054,
    eAcceptLoopQuery                        =2055,
    eRejectLoopQuery                        =2056,
    
    eGetFriendLoopsQuery                    =2057,
    eSendEditLoopQuery                      =2058,
    eSendUnFollowQuery                      =2059,
	
    
    eGetMyLoopChatsQuery                    =2070,
    eGetFriendLoopChatsQuery                =2071,
    eDeleteLoopConversation                 =2072,
    eDeleteUserWiinkLoopQuery               =2073,
    eUpdateContactDetails                   = 2074,
    eUpdateEmailStatusOfContacts            = 2075,
    eInviteContactsWithEmail                = 2076,
    eWiinkBombViewed                        = 2077,
    eWiinkBombDurationExplode               = 2078,
    eUpdateDeviceTokenQuery                 =2080,
    eSendUnFavouriteLoopsQuery              =2081,
    eSendMakeWiinkPrivateQuery              =2082,
    
    eSendUserIsOnlineQuery                  =2083,
    eSendUserIsOfflineQuery                 =2084,
    
    // F3-F4 API's Starting from Here
    
    eCreateBoardQuery                       =2090,
    eGetAllBoardsQuery                      =2091,
    eDeleteBoardsQuery                      =2092,
    eSendPinWiinkQuery                      =2093,
    eSendUnpinWiinkQuery                    =2094,
    eGetWiinksInBoardsQuery                 =2095,
    eGetMyBoardsQuery                       =2096,
    eSearchAllBoardsQuery                   =2097,
    eSearchMyBoradsQuery                    =2098,
    
    eSendFavouriteUserQuery                 =2100,
    eSendUnFavouriteUserQuery               =2101,
    eGetFavouriteUsersListQuery             =2102,
    
    eGetWiinkBombsListQuery                 =2120,
    eSendDeleteWiinkFromStreamQuery         =2121,
    eSendReWiinkQuery                       =2122,
    eSendUnrewiinkQuery                     =2123,
    eGetStreamsListQuery                    =2124,
    eGetMyWiinksListQuery                   =2125,
    eGetRecentWiinksQuery                   =2126,
    eGetPublicLoopsListQuery                =2127,
    eGetFavouriteWiinksListQuery            =2128,
    eSendShareToSocialNetworkQuery          =2129,
    eGetMyFollowingWiinksListQuery          =2130,
    eGetPopularWiinksQuery                  =2131,
    eGetFriendsWiinksListQuery              =2132,
    eGetFeaturedUserQuery                   =2133,


    eSendWiinkCommentQuery                  =2140,
    eGetWiinkCommentsListQuery              =2141,
    eSendFavouriteWiinkQuery                =2142,
    eSendUnFavouriteWiinkQuery              =2143,
    eLikeUserProfileQuery                   =2144,
    eSendPrivateChatQuery                   =2145,
    eGetUnreadlistQuery                     =2146,
    
    eUpdateUserLocationQuery                =2150,
    eUpdateAuthTokenQuery                   =2151,
    
    eSearchAllWiinksQuery                   =2160,
    eSearchMyWiinksQuery                    =2161,
    eSearchFollowingWiinksQuery             =2162,
    eSearchFavouriteWiinksQuery             =2163,
    eSearchDynamiteWiinksQuery              =2164,
    eSearchPopularWiinksQuery               =2165,
    eSearchPublicLoopsQuery                 =2166,
    eGetSuggestedFriendsListQuery           =2167,
    
    eGetSocialFriendsApiQuery               =2168,
    eGetSocialFriendsForInviteApiQuery      =2169,
    eInviteSocialContactsQuery              =2170,
    eSendShareQuery                         =2171,

    
    eSendWiinkSharingQuery                  =2172,
    eSearchFriendsWiinksQuery               =2173,
    eSearchFeaturedUserQuery                =2174,

    // ************ Settings API's ************** //
    
    eGetUserSettings                        =2180,
    eSendPrivacySettings                    =2181,
    eSendBombSettings                       =2182,
    eSendNotificationSettings               =2183,
    eSendAutoShareSettings                  =2184,
    eSendCommonSettings                     =2185,
    eGetWiinkLikesQuery                     =2186,
    eGetRewiinksQuery                       =2187,
    eGetSocialWiinkLikesQuery               =2188,
    eGetSocialRewiinksQuery                 =2189,
    eGetSocialCommentWiinksQuery            =2190,
    
    
    eGetLikesListOfWiinkQuery               =2300,
    eGetRewiinksListOfWiinkQuery            =2301,
    eSendFlagVideoQuery                     =2302,
    eSearchIndividualChatQuery              =2303,
    eSearchLoopChatQuery                    =2304,

    eSearchFollowingBoardsQuery              =2305,
    eGetFollowingBoardsQuery                 =2306,
    
    eSendFollowBoardQuery                    =2307,
    eSendUnfollowBoardQuery                  =2308,
    
    eGetMySubCategoriesForEditCategory       =2309,

    eSendWiinkUsFeedback                     =2310,
    eResendActivationLinkQuery               =2311,

}eHOWebRequestType;

typedef enum
{
	efacebook_LoginQuery                    =3000,
	efacebook_Getprofiledeatils             =3001,
    efacebook_AskLoginCredencials           =3002,
	etwitter_LoginQuery                     =3003,
	etwitter_Getprofiledeatils              =3004,
    etwitter_AskLoginCredencials            =3005,
    egoogle_LoginAndGetUserInfo             =3006,
	
}eSocialnetworkRequestType;

typedef enum  
{
	eMethodNotSupported			=10001,


}eHOWebResponseErrorCodeType;


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
}eHTTPResponseStatusCode;

typedef enum
{
    eAuthentication_OK = 200,
    eAuthentication_Failed = 100,
    eAuthentication_DeleteLoop = 101
}eAPIAuthenticationStatusCode ;



typedef enum
{
    eLogintype=100,
    eGetprofileInfo,
    eAskLoginCredencials //FIXME why this state need to be informed to view controllers?
} eSocialnetworkQuerytype;



typedef enum
{
    eShareToLoop            = 6001,
    eShareToChat            = 6002,
    eShareToStream          = 6003,
    eShareToTwitter         = 6004,
    eShareToFacebook        = 6005,
    eShareToGoogle          = 6006,
    eShareToMixi            = 6007,
    eShareToWeibo           = 6008
    
}WIShareToType;


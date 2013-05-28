//
//  SCFSocialUser.h
//  SnapCrowdFund
//
//  Created by Sajil on 5/23/13.
//  Copyright (c) 2013 snaptrendslab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCFSocialUser : NSObject

@property (nonatomic, copy) NSString *screenName;
@property (nonatomic, copy) NSString *socialID;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *firstname;
@property (nonatomic, copy) NSString *lastname;
@property (nonatomic, copy) NSString *birthday;
@property (nonatomic, copy) NSString *gender;


@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *location;
@property (nonatomic, copy) NSString *description;

@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *profileImageUrl;
@property (nonatomic, copy) NSString *profileLargeImageUrl;
@property (nonatomic, copy) NSString *domain;


@property (nonatomic, strong) NSString  *accessToken;
@property (nonatomic, strong) NSString  *accessSecret;
@property (nonatomic, strong) NSDate    *expiryDate;


- (void)removeTheUserInfo;

- (void)saveToUserDefaultsWithKey:(NSString *)iKey;
- (void)loadFromUserDefaultsWithKey:(NSString *)iKey;
- (void)clearTheUserDefaultsWithKey:(NSString *)iKey;

@end

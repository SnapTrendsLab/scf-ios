//
//  SCFSocialUser.m
//  SnapCrowdFund
//
//  Created by Sajil on 5/23/13.
//  Copyright (c) 2013 snaptrendslab. All rights reserved.
//

#import "SCFSocialUser.h"

@implementation SCFSocialUser

- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.screenName forKey:@"wiscreenName"];
    [encoder encodeObject:self.socialID forKey:@"wisocialID"];
    [encoder encodeObject:self.email forKey:@"wiemail"];
    [encoder encodeObject:self.firstname forKey:@"wifirstname"];
    [encoder encodeObject:self.lastname forKey:@"wilastname"];
    [encoder encodeObject:self.birthday forKey:@"wibirthday"];
    [encoder encodeObject:self.gender forKey:@"wigender"];
    [encoder encodeObject:self.province forKey:@"wiprovince"];
    [encoder encodeObject:self.city forKey:@"wicity"];
    [encoder encodeObject:self.location forKey:@"wilocation"];
    [encoder encodeObject:self.description forKey:@"widescription"];
    [encoder encodeObject:self.url forKey:@"wiurl"];
    [encoder encodeObject:self.profileImageUrl forKey:@"wiprofileImageUrl"];
    [encoder encodeObject:self.profileLargeImageUrl forKey:@"wiprofileLargeImageUrl"];
    [encoder encodeObject:self.domain forKey:@"widomain"];
    
    [encoder encodeObject:self.accessToken forKey:@"wiaccessToken"];
    [encoder encodeObject:self.accessSecret forKey:@"wiaccessSecret"];
    [encoder encodeObject:self.expiryDate forKey:@"wiexpiryDate"];


}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        
        self.screenName = [decoder decodeObjectForKey:@"wiscreenName"];
        self.socialID = [decoder decodeObjectForKey:@"wisocialID"];
        self.email = [decoder decodeObjectForKey:@"wiemail"];
        self.firstname = [decoder decodeObjectForKey:@"wifirstname"];
        self.lastname = [decoder decodeObjectForKey:@"wilastname"];
        self.birthday = [decoder decodeObjectForKey:@"wibirthday"];
        self.gender = [decoder decodeObjectForKey:@"wigender"];
        self.province = [decoder decodeObjectForKey:@"wiprovince"];
        self.city = [decoder decodeObjectForKey:@"wicity"];
        self.location = [decoder decodeObjectForKey:@"wilocation"];
        self.description = [decoder decodeObjectForKey:@"widescription"];
        self.url = [decoder decodeObjectForKey:@"wiurl"];
        self.profileImageUrl = [decoder decodeObjectForKey:@"wiprofileImageUrl"];
        self.profileLargeImageUrl = [decoder decodeObjectForKey:@"wiprofileLargeImageUrl"];
        self.domain = [decoder decodeObjectForKey:@"widomain"];
                
        self.accessToken = [decoder decodeObjectForKey:@"wiaccessToken"];
        self.accessSecret = [decoder decodeObjectForKey:@"wiaccessSecret"];
        self.expiryDate = [decoder decodeObjectForKey:@"wiexpiryDate"];
    }

    return self;
}

- (void)removeTheUserInfo
{
    self.screenName = nil;
    self.socialID = nil;
    self.email = nil;
    self.firstname = nil;
    self.lastname = nil;
    self.birthday = nil;
    self.gender = nil;
    self.province = nil;
    self.city = nil;
    self.location = nil;
    self.description = nil;
    self.url = nil;
    self.profileImageUrl = nil;
    self.profileLargeImageUrl = nil;
    self.domain = nil;
    
    self.accessToken = nil;
    self.accessSecret = nil;
    self.expiryDate = nil;

}

- (void)saveToUserDefaultsWithKey:(NSString *)iKey
{
    NSUserDefaults *the_userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSData *myEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:self];

    [the_userDefaults setObject:myEncodedObject forKey:iKey];
    [the_userDefaults synchronize];
}

- (void)clearTheUserDefaultsWithKey:(NSString *)iKey
{
    NSUserDefaults *the_userDefaults = [NSUserDefaults standardUserDefaults];
    if ([the_userDefaults objectForKey:iKey]) {
        [the_userDefaults removeObjectForKey:iKey];
        [the_userDefaults synchronize];
    }
}

- (void)loadFromUserDefaultsWithKey:(NSString *)iKey
{
    NSUserDefaults *the_userDefaults = [NSUserDefaults standardUserDefaults];

    if ([the_userDefaults objectForKey:iKey]) {
        
        NSData *myEncodedObject = [the_userDefaults objectForKey:iKey];
        SCFSocialUser * newInfo = (SCFSocialUser *)[NSKeyedUnarchiver unarchiveObjectWithData: myEncodedObject];
        
        self.screenName = newInfo.screenName;
        self.socialID = newInfo.socialID;
        self.email = newInfo.email;
        self.firstname = newInfo.firstname;
        self.lastname = newInfo.lastname;
        self.birthday = newInfo.birthday;
        self.gender = newInfo.gender;
        self.province = newInfo.province;
        self.city = newInfo.city;
        self.location = newInfo.location;
        self.description = newInfo.description;
        self.url = newInfo.url;
        self.profileImageUrl = newInfo.profileImageUrl;
        self.profileLargeImageUrl = newInfo.profileLargeImageUrl;
        self.domain = newInfo.domain;
        
        self.accessToken = newInfo.accessToken;
        self.accessSecret = newInfo.accessSecret;
        self.expiryDate = newInfo.expiryDate;
    }
}

@end

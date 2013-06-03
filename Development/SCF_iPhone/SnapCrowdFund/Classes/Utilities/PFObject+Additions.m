//
//  PFObject+Additions.m
//  SnapCrowdFund
//
//  Created by Sajil on 6/2/13.
//  Copyright (c) 2013 snaptrendslab. All rights reserved.
//

#import "PFObject+Additions.h"
#import "StringConstants.h"

@implementation PFObject (Additions)

#pragma mark - PFuser Addition -

- (NSString *)userFirstName
{
    return [self objectForKey:kUserFirstName];
}

- (NSString *)userLastName
{
    return [self objectForKey:kUserLastName];
}

- (PFFile *)userImageFile
{
    return [self objectForKey:kUserPic];
}

- (BOOL )userConnectedCC
{
    return [[self objectForKey:@"iCCConected"] boolValue];
}

- (BOOL )userConnectedBankAcc
{
    return [[self objectForKey:@"iBankConected"] boolValue];
}

- (void)setUserFirstName:(NSString *)iUserFName
{
    [self setObject:iUserFName forKey:kUserFirstName];
}

- (void)setUserLastName:(NSString *)iUserLName
{
    [self setObject:iUserLName forKey:kUserLastName];
}

- (void)setUserImageFile:(PFFile *)iUserImageFile
{
    [self setObject:iUserImageFile forKey:kUserPic];
}

- (void)setUserConnectedCC:(BOOL )iConnected
{
    [self setObject:[NSNumber numberWithBool:iConnected] forKey:@"iCCConected"];
}

- (void)setUserConnectedBankAcc:(BOOL )iConnected{
    [self setObject:[NSNumber numberWithBool:iConnected] forKey:@"iBankConected"];
}

#pragma mark - 

@end

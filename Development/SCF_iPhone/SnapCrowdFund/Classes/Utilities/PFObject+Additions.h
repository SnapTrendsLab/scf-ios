//
//  PFObject+Additions.h
//  SnapCrowdFund
//
//  Created by Sajil on 6/2/13.
//  Copyright (c) 2013 snaptrendslab. All rights reserved.
//

#import <Parse/Parse.h>

@interface PFObject (Additions)

// Addition for PFUser
- (NSString *)userFirstName;
- (NSString *)userLastName;
- (PFFile *)userImageFile;
- (BOOL )userConnectedCC;
- (BOOL )userConnectedBankAcc;

- (void)setUserFirstName:(NSString *)iUserFName;
- (void)setUserLastName:(NSString *)iUserLName;
- (void)setUserImageFile:(PFFile *)iUserImageFile;
- (void)setUserConnectedCC:(BOOL )iConnected;
- (void)setUserConnectedBankAcc:(BOOL )iConnected;


@end

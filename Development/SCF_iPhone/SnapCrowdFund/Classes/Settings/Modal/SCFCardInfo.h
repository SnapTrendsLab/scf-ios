//
//  SCFCardInfo.h
//  SnapCrowdFund
//
//  Created by Sajil on 6/1/13.
//  Copyright (c) 2013 snaptrendslab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCFCardInfo : NSObject

@property (nonatomic, copy) NSString *ccNumber;
@property (nonatomic, copy) NSString *ccExpDate;
@property (nonatomic, copy) NSString *ccCVV;
@property (nonatomic, copy) NSString *zipCode;

@end



#import <Foundation/Foundation.h>

#if TARGET_OS_EMBEDDED
typedef NSDate NSCalendarDate;
#endif

extern NSString *kChineseYear;
extern NSString *kZodiacSignKey;
extern NSString *kZodiacStoneKey;

@interface NSDate(NSDateAddtions)

+ (id)dateWithYear:(NSInteger)year month:(NSUInteger)month day:(NSUInteger)day hour:(NSUInteger)hour minute:(NSUInteger)minute second:(NSUInteger)second timeZone:(NSTimeZone *)aTimeZone;
+ (NSInteger)remainingDaysForDate: (NSDate *)inDate;
+ (NSDate *)convertStringToDateFormat:(NSString *)the_time;
- (NSInteger)yearOfCommonEra;
- (NSInteger)monthOfYear;
- (NSInteger)dayOfMonth;
- (NSInteger)dayOfWeek;
- (NSInteger)numberofDaysIncurrentMonth;
- (NSInteger)hourOfDay;
- (NSInteger)minuteOfHour;
- (NSInteger)secondOfMinute;
- (NSDate *)dateByAddingYears:(NSInteger)year months:(NSInteger)month days:(NSInteger)day hours:(NSInteger)hour minutes:(NSInteger)minute seconds:(NSInteger)second;
- (NSInteger)diffrenceIndates:(NSDate*)withDate;
- (NSString *) isEqualToDateIgnoringTime: (NSDate *) aDate;//abhishek

#pragma mark-
#pragma mark 

+ (NSString *) stringFromDateForDB: (NSDate *)inDate;
+ (NSDate *) dateFromString: (NSString *)inDateString;
+ (NSString *) shortStyleDateStringFromDate: (NSDate *)inDate shouldTimePrecede: (BOOL)shouldTimePrecede;
+ (NSString *) shortStyleDateStringFromDateString: (NSString *)inDateString;
+ (NSString*) getLocalTimeFromdateString:(NSString*)inStr withTimeZone:(NSTimeZone*)inTimezone withFormat:(NSString*)inStr;
+ (NSString*)getLocalTimeFromdateString:(NSString*)indateStr withTimeZone:(NSTimeZone*)inTimezone 
							withFormat:(NSString*)informatStr withOutputFormat:(NSString*)reqFormat;
+ (NSString*) getTimeDiffrenceFromtime:(NSString*)inFromtime WithtoTime:(NSString*)inTotime withFormat:(NSString*)inFrmt;
+ (NSString *)getMediumStyleDateStringFromString:(NSString*)indateStr withTimeZone:(NSTimeZone*)inTimezone withFormat:(NSString*)informatStr 
								withOutputFormat:(NSString*)reqFormat;
+ (NSDate*) todayDate;

//+ (NSString *)getDayOfWeekFromDate:(NSDate *)theDate;

+ (NSComparisonResult)compareDateString:(NSString *)iFromDateString withDateString:(NSString *)iToDateString ofFormat:(NSString *)iDateFormat;

+ (NSString *)getFormattedCountDownTimerStringForSeconds:(NSInteger)iSecondsLeft;
+ (NSTimeInterval)getTimeDifferenceForDateString:(NSString *)iDateString withFormat:(NSString *)iStringFormat withRefDate:(NSDate *)iRefDate;

@end

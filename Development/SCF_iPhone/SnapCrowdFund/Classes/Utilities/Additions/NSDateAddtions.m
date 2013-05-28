

#import "NSDateAddtions.h"


@implementation NSDate(NSDateAddtions)

#define DATE_OFFSET 730486	/* Number of days from January 1, 1
to January 1, 2001 */
#define DATE_COMPONENTS (NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekCalendarUnit |  NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekdayCalendarUnit | NSWeekdayOrdinalCalendarUnit)
#define CURRENT_CALENDAR [NSCalendar currentCalendar]

NSString *kChineseYear = @"ChineseYear";
NSString *kZodiacSignKey = @"Sign";
NSString *kZodiacStoneKey = @"Stone";

static NSDateFormatter * gStringFromDateFrormatterForDB = nil;
static NSDateFormatter * gStringFromDateFrormatterForDisplay = nil;
static NSDateFormatter * gTimeFormatter = nil;	
static NSDateFormatter * gDateOnlyFormatter = nil;
static NSDateFormatter *sDateFormatterForTimeDifference = nil;


- (NSString *) isEqualToDateIgnoringTime: (NSDate *) aDate
{
	NSDateComponents *components1 = [CURRENT_CALENDAR
									 components:DATE_COMPONENTS fromDate:[NSDate date]];
	NSDateComponents *components2 = [CURRENT_CALENDAR
									 components:DATE_COMPONENTS fromDate:aDate];
	
	if (([components1 year] == [components2 year]) &&
		([components1 month] == [components2 month])) {
		
		if (([components1 day] == [components2 day])) {
			return @"Today";
		}
		else if(([components1 day] == [components2 day]-1)){
			return @"Tomorrow";
		}
	}
	return nil;
}

////////////////////////////
-(NSInteger)monthOfYear
{
	NSCalendar *calender = [NSCalendar currentCalendar];
	unsigned unitFlags =  NSMonthCalendarUnit;
	NSDateComponents *monthYearDateComp = [calender components:unitFlags fromDate:self];
	return [monthYearDateComp month];
	
}

- (NSInteger)yearOfCommonEra
{
	NSCalendar *calender = [NSCalendar currentCalendar];
	unsigned unitFlags =  NSYearCalendarUnit;
	NSDateComponents *monthYearDateComp = [calender components:unitFlags fromDate:self];
	return [monthYearDateComp year];
}

- (NSInteger)dayOfMonth
{
	NSCalendar *calender = [NSCalendar currentCalendar];
	unsigned unitFlags =  NSDayCalendarUnit;
	NSDateComponents *monthYearDateComp = [calender components:unitFlags fromDate:self];
	return [monthYearDateComp day];
}

- (NSInteger)dayOfWeek
{
	NSCalendar *calender = [NSCalendar currentCalendar];
	unsigned unitFlags =  NSWeekdayCalendarUnit;
	NSDateComponents *monthYearDateComp = [calender components:unitFlags fromDate:self];
	return [monthYearDateComp weekday]-1;
}

- (NSInteger)numberofDaysIncurrentMonth
{
	NSDate *today = self; //Get a date object for today's date
	NSCalendar *c = [NSCalendar currentCalendar];
	NSRange days = [c rangeOfUnit:NSDayCalendarUnit 
						   inUnit:NSMonthCalendarUnit 
						  forDate:today];
	return days.length;
}

- (NSInteger)hourOfDay
{
	NSCalendar *calender = [NSCalendar currentCalendar];
	unsigned unitFlags =  NSHourCalendarUnit;
	NSDateComponents *monthYearDateComp = [calender components:unitFlags fromDate:self];
	return [monthYearDateComp hour];
}

- (NSInteger)minuteOfHour
{
	NSCalendar *calender = [NSCalendar currentCalendar];
	unsigned unitFlags =  NSMinuteCalendarUnit;
	NSDateComponents *monthYearDateComp = [calender components:unitFlags fromDate:self];
	return [monthYearDateComp minute];
}

- (NSInteger)secondOfMinute
{
	NSCalendar *calender = [NSCalendar currentCalendar];
	unsigned unitFlags =  NSSecondCalendarUnit;
	NSDateComponents *monthYearDateComp = [calender components:unitFlags fromDate:self];
	return [monthYearDateComp second];
}


+ (id)dateWithYear:(NSInteger)year month:(NSUInteger)month day:(NSUInteger)day hour:(NSUInteger)hour minute:(NSUInteger)minute second:(NSUInteger)second timeZone:(NSTimeZone *)aTimeZone
{
//NSDate 
	NSCalendar *currentCalender = [NSCalendar currentCalendar];
	[currentCalender setTimeZone:aTimeZone];
	NSDateComponents *dateComps = [[NSDateComponents alloc] init];
	[dateComps setYear:year];
	[dateComps setMonth:month];
	[dateComps setDay:day];
	[dateComps setHour:hour];
	[dateComps setMinute:minute];
	[dateComps setSecond:second];
	NSDate *dateOBj = [currentCalender dateFromComponents:dateComps];
	[dateComps release];
	return dateOBj;
}

- (NSDate *)dateByAddingYears:(NSInteger)year months:(NSInteger)month days:(NSInteger)day hours:(NSInteger)hour minutes:(NSInteger)minute seconds:(NSInteger)second
{
	NSDateComponents *dateComps = [[NSDateComponents alloc] init];
	[dateComps setYear:year];
	[dateComps setMonth:month];
	[dateComps setDay:day];
	[dateComps setHour:hour];
	[dateComps setMinute:minute];
	[dateComps setSecond:second];
	NSCalendar *currentCalender = [NSCalendar currentCalendar];
    
	NSDate *dateOBj = [currentCalender dateByAddingComponents:dateComps toDate:self options:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit];
    
	[dateComps release];
	return dateOBj;
}


+ (NSInteger) remainingDaysForDate: (NSDate *)inDate
{
	NSDate* currentDate = [NSDate date];
	
	NSDate* dateOffset = [NSDate dateWithYear: [inDate yearOfCommonEra]
										month: [inDate monthOfYear]
										  day: [inDate dayOfMonth] 
										 hour: [currentDate hourOfDay] 
									   minute: [currentDate minuteOfHour] 
									   second: [currentDate secondOfMinute] 
									 timeZone: nil];
	CFAbsoluteTime at1,at2;
//	NSDate *birthDay = [dateOffset dateByAddingYears:([currentDate yearOfCommonEra]-[dateOffset yearOfCommonEra]) months:0 days:0 hours:0 minutes:0 seconds:0];
	at1 = [dateOffset timeIntervalSinceReferenceDate];
	at2 = [currentDate timeIntervalSinceReferenceDate];
	CFGregorianUnits units = CFAbsoluteTimeGetDifferenceAsGregorianUnits(at1, at2, NULL, (kCFGregorianUnitsDays|kCFGregorianUnitsHours|kCFGregorianUnitsMinutes));
	if(units.hours == 23 && units.minutes == 59)
		units.days++;

	return units.days;
}


- (NSInteger)diffrenceIndates:(NSDate*)withDate
{
	CFAbsoluteTime at1,at2;
	NSDate *birthDay = [self dateByAddingYears:([withDate yearOfCommonEra]-[self yearOfCommonEra]) months:0 days:0 hours:0 minutes:0 seconds:0];
	at1 = [birthDay timeIntervalSinceReferenceDate];
	at2 = [withDate timeIntervalSinceReferenceDate];
	CFGregorianUnits units = CFAbsoluteTimeGetDifferenceAsGregorianUnits(at1, at2, NULL, (kCFGregorianUnitsDays|kCFGregorianUnitsHours|kCFGregorianUnitsMinutes));
	if(units.hours == 23 && units.minutes == 59)
		units.days++;
	if( units.days < 0)
	{
		birthDay = [birthDay dateByAddingYears:1 months:0 days:0 hours:0 minutes:0 seconds:0];
		at1 = [birthDay timeIntervalSinceReferenceDate];
		units = CFAbsoluteTimeGetDifferenceAsGregorianUnits(at1, at2, NULL, (kCFGregorianUnitsDays|kCFGregorianUnitsHours|kCFGregorianUnitsMinutes));
		if(units.hours == 23 && units.minutes == 59)
			units.days++;
	}

	return units.days;
}


#pragma mark-

+ (NSString *) stringFromDateForDB: (NSDate *)inDate
{
	if(!gStringFromDateFrormatterForDB)
	{
		gStringFromDateFrormatterForDB = [[NSDateFormatter alloc] init];
		[gStringFromDateFrormatterForDB setFormatterBehavior: NSDateFormatterBehavior10_4];
		[gStringFromDateFrormatterForDB setDateStyle:	NSDateFormatterLongStyle];
		[gStringFromDateFrormatterForDB setTimeStyle: NSDateFormatterLongStyle];
		[gStringFromDateFrormatterForDB setLocale: [NSLocale currentLocale]];
	}

	return [gStringFromDateFrormatterForDB stringFromDate: inDate];
}


+ (NSDate *) dateFromString: (NSString *)inDateString
{
	if(!gStringFromDateFrormatterForDB)
	{
		gStringFromDateFrormatterForDB = [[NSDateFormatter alloc] init];
		[gStringFromDateFrormatterForDB setFormatterBehavior: NSDateFormatterBehavior10_4];
		[gStringFromDateFrormatterForDB setDateStyle: NSDateFormatterLongStyle];
		[gStringFromDateFrormatterForDB setTimeStyle: NSDateFormatterLongStyle];
		[gStringFromDateFrormatterForDB setLocale: [NSLocale currentLocale]];
	}
	
	return [gStringFromDateFrormatterForDB dateFromString: inDateString];
}

+ (NSString *) shortStyleDateStringFromDate: (NSDate *)inDate shouldTimePrecede: (BOOL)shouldTimePrecede
{
	if(!gDateOnlyFormatter)
	{
		gDateOnlyFormatter = [[NSDateFormatter alloc] init];
		[gDateOnlyFormatter setFormatterBehavior: NSDateFormatterBehavior10_4];
		[gDateOnlyFormatter setDateStyle: NSDateFormatterMediumStyle];
		[gDateOnlyFormatter setTimeStyle: NSDateFormatterNoStyle];
 		[gDateOnlyFormatter setLocale: [NSLocale currentLocale]];
	}
	
	if(!gTimeFormatter)
	{
		gTimeFormatter = [[NSDateFormatter alloc] init];
		[gTimeFormatter setFormatterBehavior: NSDateFormatterBehavior10_4];
		[gTimeFormatter setDateStyle: NSDateFormatterNoStyle];		
		[gTimeFormatter setTimeStyle: NSDateFormatterShortStyle];
		[gTimeFormatter setLocale: [NSLocale currentLocale]];
	}
	
	NSString * dateString = nil;

	if(shouldTimePrecede)
		dateString = [NSString stringWithFormat: @"%@  %@", [gTimeFormatter stringFromDate: inDate], [gDateOnlyFormatter stringFromDate: inDate]];
	else
		dateString = [NSString stringWithFormat: @"%@  %@", [gDateOnlyFormatter stringFromDate: inDate], [gTimeFormatter stringFromDate: inDate]];
			
	return dateString;
}


+ (NSString *) shortStyleDateStringFromDateString: (NSString *)inDateString
{
	if(!gStringFromDateFrormatterForDisplay)
	{
		gStringFromDateFrormatterForDisplay = [[NSDateFormatter alloc] init];
		[gStringFromDateFrormatterForDisplay setFormatterBehavior: NSDateFormatterBehavior10_4];
		[gStringFromDateFrormatterForDisplay setDateStyle: NSDateFormatterMediumStyle];
		[gStringFromDateFrormatterForDisplay setTimeStyle: NSDateFormatterShortStyle];
		[gStringFromDateFrormatterForDisplay setLocale: [NSLocale currentLocale]];
	}
	
	return [gStringFromDateFrormatterForDisplay stringFromDate: [NSDate dateFromString: inDateString]];
}

+(NSString*)getLocalTimeFromdateString:(NSString*)indateStr withTimeZone:(NSTimeZone*)inTimezone withFormat:(NSString*)informatStr
{
	NSString *the_retStr = nil;
	NSDateFormatter *the_formatter = [[NSDateFormatter alloc] init];
	if(informatStr!=nil)
		[the_formatter setDateFormat:informatStr];
	
	if(inTimezone!=nil)
		[the_formatter setTimeZone:inTimezone];
	
	if(indateStr)
	{
		NSDate *the_date =[the_formatter dateFromString:indateStr];
		if(the_date==nil)
		{
			NSArray *array = [indateStr componentsSeparatedByString:@"."];
			if(array==nil)
			{
				the_date =[the_formatter dateFromString:indateStr];
			}
			else 
			{
				the_date =[the_formatter dateFromString:[array objectAtIndex:0]];
			}
		}
		[the_formatter setTimeZone:[NSTimeZone systemTimeZone]];
		[the_formatter setDateFormat:@"h:mma"];
		the_retStr = [[the_formatter stringFromDate:the_date] lowercaseString];

	}
    [the_formatter release];

	return 	the_retStr;
}


+(NSString*)getLocalTimeFromdateString:(NSString*)indateStr withTimeZone:(NSTimeZone*)inTimezone withFormat:(NSString*)informatStr 
					  withOutputFormat:(NSString*)reqFormat
{
	NSString *the_retStr = nil;
	NSDateFormatter *the_formatter = [[NSDateFormatter alloc] init];
	if(informatStr!=nil)
		[the_formatter setDateFormat:informatStr];
	
	if(inTimezone!=nil)
		[the_formatter setTimeZone:inTimezone];
	
	if(indateStr)
	{
		NSDate *the_date =[the_formatter dateFromString:indateStr];
		if(the_date==nil)
		{
			NSArray *array = [indateStr componentsSeparatedByString:@"."];
			if(array==nil)
			{
				the_date =[the_formatter dateFromString:indateStr];
			}
			else 
			{
				the_date =[the_formatter dateFromString:[array objectAtIndex:0]];
			}
		}
		
		[the_formatter setTimeZone:[NSTimeZone systemTimeZone]];
		[the_formatter setDateFormat:reqFormat];
		the_retStr = [[the_formatter stringFromDate:the_date] lowercaseString];
	}
    
    [the_formatter release];
	return 	the_retStr;
}

+(NSString*) getTimeDiffrenceFromtime:(NSString*)inFromtime WithtoTime:(NSString*)inTotime withFormat:(NSString*)inFrmt
{
	
	NSString *timeDiffString = nil;
    
    if (nil == sDateFormatterForTimeDifference)
    {
        sDateFormatterForTimeDifference = [[NSDateFormatter alloc] init];
    }
    
	if(inFrmt== nil)
        inFrmt = @"yyyy-MM-dd HH:mm:ss";
    
    [sDateFormatterForTimeDifference setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];

    if (inTotime == nil) {
        [sDateFormatterForTimeDifference setDateFormat:inFrmt];
        inTotime = [sDateFormatterForTimeDifference stringFromDate:[NSDate date]];
    }
    
    [sDateFormatterForTimeDifference setDateFormat:inFrmt];
    
	NSDate *toTime = [sDateFormatterForTimeDifference dateFromString:inTotime];
	NSDate *fromTime = [sDateFormatterForTimeDifference dateFromString:inFromtime];
	
	NSTimeInterval interval = [toTime timeIntervalSinceDate:fromTime];
	
	NSInteger days = interval / 60 / 60/ 24;
	
	if (days > 0)
	{
        if (days > 30) {
            [sDateFormatterForTimeDifference setTimeZone:[NSTimeZone systemTimeZone]];
            [sDateFormatterForTimeDifference setDateFormat:@"MMM dd, yyyy"];
            timeDiffString = [sDateFormatterForTimeDifference stringFromDate:fromTime];
            
        }
		else if (days == 1)
		{
			timeDiffString = [NSString stringWithFormat:@"%d Day Ago",days];
		}
		else
		{
			timeDiffString = [NSString stringWithFormat:@"%d Days Ago",days];
		}
	}
	
	else 
	{
        NSInteger seconds = ((int) interval)%60;

		NSInteger hours = (int)interval/(60*60);
		interval = (int)interval%(60*60);
		NSInteger minutes = interval/60;
		
		if (hours >0 && minutes >0) 
		{
			timeDiffString = [NSString stringWithFormat:@"%dh %dm Ago",hours,minutes];
		}
		
		else if(hours >0 )
		{
            if (hours == 1) {
                timeDiffString = [NSString stringWithFormat:@"%d Hour Ago",hours];
            }
            else
            {
                timeDiffString = [NSString stringWithFormat:@"%d Hours Ago",hours];
            }
		}
		
		else if (minutes >0)
		{
            if (minutes == 1) {
                timeDiffString = [NSString stringWithFormat:@"%d Minute Ago",minutes];
            }
            else
            {
                timeDiffString = [NSString stringWithFormat:@"%d Minutes Ago",minutes];
            }
		}
        else if (seconds >0)
		{
			timeDiffString = [NSString stringWithFormat:@"%d Seconds Ago",seconds];
		}
	}
    
	if (interval == 0 && days!=0) {
		timeDiffString = [NSString stringWithFormat:@"%dh Ago",days];
	}
	if(timeDiffString==nil)
        timeDiffString = @"Just now";

    return timeDiffString;
}

+ (NSString *)getFormattedCountDownTimerStringForSeconds:(NSInteger)iSecondsLeft
{
    NSString *retString = nil;
    
    if(iSecondsLeft == 0)
        return @"1 min";
    
	NSInteger days = iSecondsLeft / 60 / 60/ 24;
    if (days > 0)
	{
        if (days > 30) {
            [sDateFormatterForTimeDifference setTimeZone:[NSTimeZone systemTimeZone]];
            [sDateFormatterForTimeDifference setDateFormat:@"MMM dd, yyyy"];
            retString = [sDateFormatterForTimeDifference stringFromDate:[NSDate dateWithTimeIntervalSinceNow:iSecondsLeft]];
        }
		else if (days == 1)
		{
			retString = [NSString stringWithFormat:@"%d day",days];
		}
		else
		{
			retString = [NSString stringWithFormat:@"%d days",days];
		}
	}
    else{
        
		NSInteger hours = (int)iSecondsLeft/(60*60);
		iSecondsLeft = (int)iSecondsLeft%(60*60);
		NSInteger minutes = iSecondsLeft/60;
		
		if (hours >0 && minutes >0)
		{
            if (minutes == 1)
            {
                if (hours == 1) {
                    retString = [NSString stringWithFormat:@"%dhr %dmin",hours,minutes];
                }
                else
                    retString = [NSString stringWithFormat:@"%dhrs %dmin",hours,minutes];
            }
            else
            {
                if (hours == 1) {
                    retString = [NSString stringWithFormat:@"%dhr %dmins",hours,minutes];
                }
                else
                    retString = [NSString stringWithFormat:@"%dhrs %dmins",hours,minutes];
            }
		}
		
		else if(hours >0 )
		{
            if (hours == 1) {
                retString = [NSString stringWithFormat:@"%d hour",hours];
            }
            else
            {
                retString = [NSString stringWithFormat:@"%d hours",hours];
            }
		}
		
		else if (minutes >0)
		{
            if (minutes == 1) {
                retString = [NSString stringWithFormat:@"%d min",minutes];
            }
            else
            {
                retString = [NSString stringWithFormat:@"%d mins",minutes];
            }
		}
        else{
            retString = [NSString stringWithFormat:@"1 min"];
        }
    }
    
    if (iSecondsLeft == 0 && days!=0) {
		retString = [NSString stringWithFormat:@"%dh",days];
	}
    
    return retString;
}

+(NSDate *)convertStringToDateFormat:(NSString *)the_time {
	
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
	[formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
	
	NSDate *date = [formatter dateFromString:the_time];
	[formatter release];
	return date;
}

// returns the time difference in minutes with the current date
+ (NSTimeInterval)getTimeDifferenceForDateString:(NSString *)iDateString withFormat:(NSString *)iStringFormat withRefDate:(NSDate *)iRefDate
{
    NSTimeInterval retVal = 0;
    
    if (iDateString == nil) {
        return retVal;
    }

    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    
    if (iStringFormat)
        [df setDateFormat:iStringFormat];

    NSDate *serverDate = [df dateFromString:iDateString];
    [df release];
    
    if (!serverDate) {
        return retVal;
    }
      
    // will return the difference in seconds
    retVal = [serverDate timeIntervalSinceDate:(iRefDate != nil ? iRefDate:[NSDate date])];
    
    // difference in minutes
    retVal/= 60;
    
    return retVal;
}


//Abhishek
//Medium style date string
//e.g: Aug 23, 2011

+ (NSString *)getMediumStyleDateStringFromString:(NSString*)indateStr withTimeZone:(NSTimeZone*)inTimezone withFormat:(NSString*)informatStr 
								withOutputFormat:(NSString*)reqFormat
{
	NSString *the_retStr = nil;
	NSDateFormatter *the_formatter = [[NSDateFormatter alloc] init];
	if(informatStr!=nil)
		[the_formatter setDateFormat:informatStr];
	
	if(inTimezone!=nil)
		[the_formatter setTimeZone:inTimezone];
	
	if(indateStr)
	{
		NSDate *the_date =[the_formatter dateFromString:indateStr];
		if(the_date==nil)
		{
			NSArray *array = [indateStr componentsSeparatedByString:@"."];
			if(array==nil)
			{
				the_date =[the_formatter dateFromString:indateStr];
			}
			else 
			{
				the_date =[the_formatter dateFromString:[array objectAtIndex:0]];
			}
		}
		
		[the_formatter setTimeZone:[NSTimeZone systemTimeZone]];
		[the_formatter setDateFormat:reqFormat];
		
		
		the_retStr = [[NSDate date] isEqualToDateIgnoringTime:the_date];
		
		if(the_retStr==nil)
		{
			the_retStr = [[the_formatter stringFromDate:the_date] lowercaseString];
		}
	}
    [the_formatter release];

	return 	the_retStr;
}

+ (NSDate*) todayDate
{
	// The date in your source timezone (eg. EST)
	NSDate* sourceDate = [NSDate date];
	
	NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
	NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];
	
	NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:sourceDate];
	NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:sourceDate];
	NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
	
	NSDate* destinationDate = [NSDate dateWithTimeInterval:interval sinceDate:sourceDate];
	return destinationDate;
}

+ (NSComparisonResult)compareDateString:(NSString *)iFromDateString withDateString:(NSString *)iToDateString ofFormat:(NSString *)iDateFormat
{
    [sDateFormatterForTimeDifference setDateFormat:iDateFormat];
    NSDate *fromdate = [sDateFormatterForTimeDifference dateFromString:iFromDateString];
    NSDate *toDate = [sDateFormatterForTimeDifference dateFromString:iToDateString];

    
    return [fromdate compare:toDate];
}

//Abhishek
//e.g: Wednesday

/*
+ (NSString *)getDayOfWeekFromDate:(NSDate *)theDate {
	
	NSString * weekdayString = [theDate descriptionWithCalendarFormat:@"%A" timeZone:nil locale:[[NSUserDefaults standardUserDefaults] dictionaryRepresentation]];
	NSLog(@"Day of the week: %@", weekdayString);
	return weekdayString;
}
*/
@end

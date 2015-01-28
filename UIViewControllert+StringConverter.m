//
//  NSString+StringConverter.m
//  Library_Book_Tracker
//
//  Created by Alex Cevallos on 1/20/15.
//  Copyright (c) 2015 AlexCevallos. All rights reserved.
//

#import "UIViewController+StringConverter.h"
@implementation UIViewController (StringConverter)


-(NSString *)methodFormatsDateString:(NSString *)stringToFormat{
    NSDateFormatter *dateSetsFormat = [[NSDateFormatter alloc] init];
    
    //Grabs user's time zone
    NSTimeZone *timeZoneLocal = [NSTimeZone systemTimeZone];
    [dateSetsFormat setTimeZone:timeZoneLocal];

    //Set to the API's date feed
    [dateSetsFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *dateConvertedFromString = [dateSetsFormat dateFromString:stringToFormat];
    
    NSTimeInterval timeIntervalSecondsFrom = [[NSTimeZone systemTimeZone] secondsFromGMT];
    NSTimeInterval timeIntervalLocal = [dateConvertedFromString timeIntervalSinceReferenceDate] + timeIntervalSecondsFrom;
    
    NSDate *localCurrentDate = [NSDate dateWithTimeIntervalSinceReferenceDate:timeIntervalLocal];
    
    //Set to the format we want to show
    [dateSetsFormat setDateFormat:@"h:mma (M/d/yyyy)"];
    
    return [dateSetsFormat stringFromDate:localCurrentDate];
}

-(NSAttributedString *)methodConvertToFormattedString:(NSString *)stringName sizeOfString:(float)floatSizeOfText{
    
    
    UIFont *font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:floatSizeOfText];
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:stringName attributes:@{NSFontAttributeName: font}];
    
    return attributedString;
    
}

@end

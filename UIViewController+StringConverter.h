//
//  NSString+StringConverter.h
//  Library_Book_Tracker
//
//  Created by Alex Cevallos on 1/20/15.
//  Copyright (c) 2015 AlexCevallos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIViewController (StringConverter)

//Converts the string date into 
-(NSString *)methodFormatsDateString:(NSString *)stringToFormat;


//Returns the value if it is not nil. If there is no value, returns a string indicating so
-(NSAttributedString *)methodConvertToFormattedString:(NSString *)stringName sizeOfString:(float)floatSizeOfText;



@end

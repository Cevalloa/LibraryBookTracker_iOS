//
//  NSString+StringConverter.m
//  Library_Book_Tracker
//
//  Created by Alex Cevallos on 1/20/15.
//  Copyright (c) 2015 AlexCevallos. All rights reserved.
//

#import "NSObject+StringConverter.h"
@implementation NSObject (StringConverter)

-(NSAttributedString *)methodConvertToFormattedString:(NSString *)stringName sizeOfString:(float)floatSizeOfText{
    
    
    UIFont *font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:floatSizeOfText];
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:stringName attributes:@{NSFontAttributeName: font}];
    
    return attributedString;
    
}

@end

//
//  NSDictionary+RemovesNilValues.m
//  Library_Book_Tracker
//
//  Created by Alex Cevallos on 1/24/15.
//  Copyright (c) 2015 AlexCevallos. All rights reserved.
//

#import "NSDictionary+RemovesNilValues.h"

@implementation NSDictionary (RemovesNilValues)

-(NSString *)methodCheckIfKeyNil:(NSString *)key{
    id value = self[key];
    
    if(value == [NSNull null]){
        return [NSString stringWithFormat:@"-No %@", key];
    }
    
    return value;
}

@end

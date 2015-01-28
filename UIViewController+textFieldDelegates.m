//
//  UIViewController+textFieldDelegates.m
//  Library_Book_Tracker
//
//  Created by Alex Cevallos on 1/28/15.
//  Copyright (c) 2015 AlexCevallos. All rights reserved.
//

#import "UIViewController+textFieldDelegates.h"

#define CHECKS_IF_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define CHECKS_IPHONE_4_OR_SMALLER (CHECKS_IF_IPHONE && SCREEN_HEIGHT < 568.0)

@implementation UIViewController (delegates)

#pragma mark - UITextField Delegate Methods
//When the textfield keyboard's return button is pressed, the keyboard is removed
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return false;
}

//If the keyboard appears on the "Categories" textfield, move the screen to make space
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    //Fixes issue with categories not appearing on 3.5" devices
    if (CHECKS_IPHONE_4_OR_SMALLER) {
        if([textField.placeholder isEqualToString:@"Categories"]){
            
            CGRect viewSize = [[UIScreen mainScreen] bounds];
            //Moves the frame up to see categories better
            [textField.superview setFrame:CGRectMake(viewSize.origin.x, viewSize.origin.y -40, viewSize.size.width, viewSize.size.height)];
        }
    }
}

//Moves the keyboard back up if the keyboard is on the "categories" textfield
-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    //Fixes issue with categories not appearing on 3.5" devices
    if (CHECKS_IPHONE_4_OR_SMALLER){
        if([textField.placeholder isEqualToString:@"Categories"]){
            
            CGRect viewSize = [[UIScreen mainScreen] bounds];
            //Moves the frame down after categories is done editing
            [textField.superview setFrame:CGRectMake(viewSize.origin.x, viewSize.origin.y +40, viewSize.size.width, viewSize.size.height)];
            
        }
    }
}


@end

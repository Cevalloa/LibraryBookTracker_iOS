//
//  AddBookViewController.m
//  Library_Book_Tracker
//
//  Created by Alex Cevallos on 1/20/15.
//  Copyright (c) 2015 AlexCevallos. All rights reserved.
//

#import "AddBookViewController.h"

@interface AddBookViewController ()


@end

@implementation AddBookViewController

#pragma mark - View Controller Lifecycle Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Goes over every subview, sets all UITextFields to "self" as the delegate
    for (UIView *sub in self.view.subviews){
        if ([sub isKindOfClass:[UITextField class]]){
            //Casting to use UITextField methods
            ((UITextField *)sub).delegate = self;
        }
    }
    
}

#pragma mark - UITextField Delegate Methods
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return false;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{

    //Fixes issue with categories not appearing on 3.5" devices
    if([textField.placeholder isEqualToString:@"Categories"]){
        CGRect viewSize = self.view.frame;
        //Moves the frame up to see categories better
        [self.view setFrame:CGRectMake(viewSize.origin.x, viewSize.origin.y -50, viewSize.size.width, viewSize.size.height)];
    
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    //Fixes issue with categories not appearing on 3.5" devices
    if([textField.placeholder isEqualToString:@"Categories"]){
        CGRect viewSize = self.view.frame;
        //Moves the frame down after categories is done editing
        [self.view setFrame:CGRectMake(viewSize.origin.x, viewSize.origin.y +50, viewSize.size.width, viewSize.size.height)];
        
    }
}



#pragma mark - IBAction Methods
- (IBAction)barButtonItemDone:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)buttonBookSubmit:(id)sender {
    
    //Makes sure title and author aren't empty before proceeding
    if(self.textFieldBookTitle.text.length == 0 && self.textFieldBookAuthor.text.length == 0){
        UIAlertView *alertViewMissingFields = [[UIAlertView alloc] initWithTitle:@"Woops!" message:@"Please fill out the book's title & author"  delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        
        [alertViewMissingFields show];
    }else{
        NSLog(@"Acceptable");
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
}



@end

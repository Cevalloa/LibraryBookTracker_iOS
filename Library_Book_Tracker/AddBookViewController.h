//
//  AddBookViewController.h
//  Library_Book_Tracker
//
//  Created by Alex Cevallos on 1/20/15.
//  Copyright (c) 2015 AlexCevallos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddBookViewController : UIViewController <UITextFieldDelegate>

#pragma mark - IBOutlet Properties
@property (weak, nonatomic) IBOutlet UITextField *textFieldBookTitle;
@property (weak, nonatomic) IBOutlet UITextField *textFieldBookAuthor;
@property (weak, nonatomic) IBOutlet UITextField *textFieldBookPublisher;
@property (weak, nonatomic) IBOutlet UITextField *textFieldBookCategories;

#pragma mark - IBAction Methods
- (IBAction)barButtonItemDone:(id)sender;
- (IBAction)buttonBookSubmit:(id)sender;

@end

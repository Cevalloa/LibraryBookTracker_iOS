//
//  EditBookViewController.h
//  Library_Book_Tracker
//
//  Created by Alex Cevallos on 1/23/15.
//  Copyright (c) 2015 AlexCevallos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditBookViewController : UIViewController

@property (nonatomic) NSDictionary *dictionaryBookInformationToEdit;

#pragma mark - IBOutlet properties
@property (weak, nonatomic) IBOutlet UITextField *textFieldBookTitle;
@property (weak, nonatomic) IBOutlet UITextField *textFieldBookAuthor;
@property (weak, nonatomic) IBOutlet UITextField *textFieldBookPublisher;
@property (weak, nonatomic) IBOutlet UITextField *textFieldBookTags;


@end

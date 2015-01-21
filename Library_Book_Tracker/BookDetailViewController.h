//
//  BookDetailViewController.h
//  Library_Book_Tracker
//
//  Created by Alex Cevallos on 1/20/15.
//  Copyright (c) 2015 AlexCevallos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookDetailViewController : UIViewController

@property (nonatomic) NSDictionary *dictionaryBookInformation;

#pragma mark IBOutlet Properties
@property (weak, nonatomic) IBOutlet UILabel *labelBookTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelBookAuthor;
@property (weak, nonatomic) IBOutlet UILabel *labelBookPublisher;
@property (weak, nonatomic) IBOutlet UILabel *labelBookTags;
@property (weak, nonatomic) IBOutlet UILabel *labelBookLatestCheckout;

#pragma mark IBAction Methods
- (IBAction)buttonBookCheckout:(id)sender;


@end

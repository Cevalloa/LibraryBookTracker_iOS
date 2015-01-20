//
//  BookDetailViewController.h
//  Library_Book_Tracker
//
//  Created by Alex Cevallos on 1/20/15.
//  Copyright (c) 2015 AlexCevallos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *labelBookTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelBookAuthor;
@property (weak, nonatomic) IBOutlet UILabel *labelBookPublisher;
@property (weak, nonatomic) IBOutlet UILabel *labelBookTags;
@property (weak, nonatomic) IBOutlet UILabel *labelBookLatestCheckout;

- (IBAction)buttonBookCheckout:(id)sender;


@end
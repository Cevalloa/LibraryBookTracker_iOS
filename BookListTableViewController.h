//
//  BookListTableViewController.h
//  Library_Book_Tracker
//
//  Created by Alex Cevallos on 1/20/15.
//  Copyright (c) 2015 AlexCevallos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookListTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>

#pragma mark - IBAction Methods
- (IBAction)barButtonItemAddBook:(id)sender;
- (IBAction)barButtonItemDeleteAll:(id)sender;


@end

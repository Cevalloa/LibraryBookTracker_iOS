//
//  AddBookViewController.m
//  Library_Book_Tracker
//
//  Created by Alex Cevallos on 1/20/15.
//  Copyright (c) 2015 AlexCevallos. All rights reserved.
//

#import "AddBookViewController.h"
#import "UIViewController+StringConverter.h"
#import "UIViewController+textFieldDelegates.h"

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

#pragma mark - IBAction Methods
- (IBAction)barButtonItemDone:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

//Submits a new book to the database, but only if the title & author field aren't empty
- (IBAction)buttonBookSubmit:(id)sender {
    
    //Makes sure title and author aren't empty before proceeding
    if(self.textFieldBookTitle.text.length == 0 && self.textFieldBookAuthor.text.length == 0){
        UIAlertView *alertViewMissingFields = [[UIAlertView alloc] initWithTitle:@"Woops!" message:@"Please fill out the book's title & author"  delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        
        [alertViewMissingFields show];
    }else{
        
        NSDictionary *dictionaryBookEntry = @{@"author": self.textFieldBookAuthor.text,
                                              @"categories": self.textFieldBookCategories.text,
                                              @"title": self.textFieldBookTitle.text,
                                              @"publisher" :self.textFieldBookPublisher.text,
                                              @"lastCheckedOutBy" : [NSNull null]};
        NSLog(@"Acceptable %@", dictionaryBookEntry);

        [self methodPost:dictionaryBookEntry];
    }
    
}


#pragma mark - API Connectivity Methods
//Adds a new book to the database
-(void)methodPost:(NSDictionary *)dictionaryToPost{
    //Obtains API string to POST a new book (key created in Screen 1)
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *stringBookPost = [NSString stringWithFormat:@"%@/books/", [userDefaults objectForKey:@"stringUrlForApi"] ];
    
    NSURL *urlBookPost = [NSURL URLWithString:stringBookPost];
    
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:urlBookPost];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [request setHTTPMethod:@"POST"];
    //Converts the dicitonary into JSON
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:dictionaryToPost options:kNilOptions error:&error];
    [request setHTTPBody:data];
    
    if (!error){
        NSURLSessionDataTask *uploadTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            
            if (error == nil){
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertView *alertAddedBook = [[UIAlertView alloc] initWithTitle:@"Successful!" message:@"Added the book!"  delegate:nil cancelButtonTitle:@"Okay!" otherButtonTitles:nil];
                    
                    [alertAddedBook show];
                    [self dismissViewControllerAnimated:YES completion:nil];
                });
                // Do something
                
            }
            //Uncomment For debuging purposes to see returned values
            //                        NSLog(@"The data is.. %@", data);
            //                        NSLog(@"The response is.. %@", response);
            //                        NSLog(@"The error is.. %@", error);
            
        }];
        
        [uploadTask resume];
    }
    
    
}



@end

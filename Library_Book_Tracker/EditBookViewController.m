//
//  EditBookViewController.m
//  Library_Book_Tracker
//
//  Created by Alex Cevallos on 1/23/15.
//  Copyright (c) 2015 AlexCevallos. All rights reserved.
//

#import "EditBookViewController.h"
#import "NSDictionary+RemovesNilValues.h"

@implementation EditBookViewController

#pragma mark - View Controller Lifecycle Methods
-(void)viewDidLoad{
    [super viewDidLoad];
    
    //methodCheckIfKeyNil is from "NSDictionary+RemovesNilValues"
    self.textFieldBookTitle.text = [self.dictionaryBookInformationToEdit methodCheckIfKeyNil:@"title"];
    self.textFieldBookAuthor.text = [self.dictionaryBookInformationToEdit methodCheckIfKeyNil:@"author"];
    self.textFieldBookPublisher.text = [self.dictionaryBookInformationToEdit methodCheckIfKeyNil:@"publisher"];
    self.textFieldBookTags.text = [self.dictionaryBookInformationToEdit methodCheckIfKeyNil:@"categories"];
}

#pragma mark - IBAction Methods
- (IBAction)barButtomItemAcce:(id)sender {
    
    //Checks if the user has edited any part of the fields
    BOOL booleanChecksIfInformationNew = ![self.textFieldBookTitle.text isEqualToString:[self.dictionaryBookInformationToEdit methodCheckIfKeyNil:@"title"]] ||
                        ![self.textFieldBookAuthor.text isEqualToString:[self.dictionaryBookInformationToEdit methodCheckIfKeyNil:@"author"]] ||
                        ![self.textFieldBookPublisher.text isEqualToString:[self.dictionaryBookInformationToEdit valueForKey:@"publisher"]] ||
                        ![self.textFieldBookTags.text isEqualToString:[self.dictionaryBookInformationToEdit methodCheckIfKeyNil:@"categories"]];
    
    
    if (booleanChecksIfInformationNew){
        [self methodUpdate:@{@"author" : self.textFieldBookAuthor.text,
                             @"categories": self.textFieldBookTags.text,
                             @"title" : self.textFieldBookTitle.text,
                             @"publisher" : self.textFieldBookPublisher.text}];
    }else{
        NSLog (@"false!");
    }
    

}

#pragma mark - Connectivity Methods
-(void)methodUpdate:(NSDictionary *)dictionaryToUpdatePost{
    
    //Obtains APi string for which book to manipulate
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *stringOfBookToUpdate = [NSString stringWithFormat:@"%@%@", [userDefaults objectForKey:@"stringUrlForApi"], [self.dictionaryBookInformationToEdit methodCheckIfKeyNil:@"url"]];
    
    NSURL *urlBookID = [NSURL URLWithString:stringOfBookToUpdate];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:urlBookID];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

    [request setHTTPMethod:@"PUT"];
    
    NSError *error = nil;
    //Converts the dictionary into JSON
    NSData *data = [NSJSONSerialization dataWithJSONObject:dictionaryToUpdatePost options:kNilOptions error:&error];
    [request setHTTPBody:data];
    
    if (!error){
        NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request fromData:data completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (error == nil){
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertView *alertViewUpdatedBook = [[UIAlertView alloc] initWithTitle:@"Successful!" message:@"Added The Book!" delegate:nil cancelButtonTitle:@"Okay!" otherButtonTitles:nil];
                    
                    [alertViewUpdatedBook show];
                    [self.navigationController popToRootViewControllerAnimated:YES];
                });
            }
        }];
        
        [uploadTask resume];
    }
    
    
}
@end

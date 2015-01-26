//
//  BookDetailViewController.m
//  Library_Book_Tracker
//
//  Created by Alex Cevallos on 1/20/15.
//  Copyright (c) 2015 AlexCevallos. All rights reserved.
//

#import "BookDetailViewController.h"
#import "EditBookViewController.h"
#import "NSDictionary+RemovesNilValues.h"

@interface BookDetailViewController () <UIAlertViewDelegate>{
    NSString *stringBookID;
}

@end

@implementation BookDetailViewController

#pragma mark - View Controller Lifecycle Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.labelBookTitle.text = [self.dictionaryBookInformation methodCheckIfKeyNil:@"title"];
    
    self.labelBookAuthor.text = [self.dictionaryBookInformation methodCheckIfKeyNil:@"author"];
    
    self.labelBookPublisher.text = [self.dictionaryBookInformation methodCheckIfKeyNil:@"publisher"];
    
    self.labelBookTags.text = [self.dictionaryBookInformation methodCheckIfKeyNil:@"categories"];
    
    //Checks if lastCheckedOutBy empty (if true, tells user there is nothing there)
    NSString *stringFullCheckOut = [NSString stringWithFormat:@"Last Checked Out:%@",[self.dictionaryBookInformation methodCheckIfKeyNil:@"lastCheckedOutBy"]];
    
    //Reminder: methodCheckIfKeyNil returns -No [DictionaryKey] if value == null
    if ([@"Last Checked Out:-No lastCheckedOutBy" isEqualToString:stringFullCheckOut]){
        
        self.labelBookLatestCheckout.text = @"No Checkouts Yet";
    }else{
        self.labelBookLatestCheckout.text = [NSString stringWithFormat:@"%@ At %@",stringFullCheckOut, [self.dictionaryBookInformation methodCheckIfKeyNil:@"lastCheckedOut"]];
    }
    
    //For the URL Of The actual book
    stringBookID = [NSString stringWithFormat:@"%@", self.dictionaryBookInformation[@"url"]];

}

#pragma mark - UIAlertView Delegate Methods
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    //For updating book:ButtonIndex 0 = Cancel, ButtonIndex 1 = Accept
    if ([alertView.title isEqualToString:@"Preparing Checkout"] && buttonIndex == 1){
        [self methodPut:[alertView textFieldAtIndex:0].text];
    
    //For deleting book
    }else if ([alertView.title isEqualToString:@"Are you sure?"] && buttonIndex == 1){
        [self methodDelete];
    }
}

#pragma mark - Storyboard Segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"segueToEditBook"]){
        [segue.destinationViewController setDictionaryBookInformationToEdit:sender];
    }
    
}

#pragma mark - IBAction Methods
- (IBAction)barButtonItemCancel:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)barButtonItemShare:(id)sender {
}

//Asks User For Name To Checkout Book
- (IBAction)buttonBookCheckout:(id)sender {
    //For iOS 8 and up please use UIAlertController
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Preparing Checkout" message:@"What is your name?"
                                                       delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Accept", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    
    [alertView show];
    
}

- (IBAction)buttonBookUpdate:(id)sender {
    [self performSegueWithIdentifier:@"segueToEditBook" sender:self.dictionaryBookInformation];
}

- (IBAction)buttonBookDelete:(id)sender {
    UIAlertView *alertViewBookDelete = [[UIAlertView alloc] initWithTitle:@"Are you sure?" message:@"Do you want to permanently delete this book?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes", nil];
    
    //Reminder the delegate triggers events based on the UIAlertViewTitle
    [alertViewBookDelete show];
}

#pragma mark - Connectivity Methods
-(void)methodPut:(NSString *)stringNameOfPersonCheckingOut{
    
    //Obtains API string for which Book to manipulate
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *stringFullUrlWithBookID = [NSString stringWithFormat:@"%@%@",[userDefaults objectForKey:@"stringUrlForApi"], stringBookID];
    NSURL *urlBookID = [NSURL URLWithString:stringFullUrlWithBookID];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:urlBookID];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    request.HTTPMethod = @"PUT";
    
    NSDictionary *dictionaryToPut = @{@"lastCheckedOutBy" : stringNameOfPersonCheckingOut};
    
    //Convert dictionary into JSON
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:dictionaryToPut options:kNilOptions error:&error];
    
    if (!error){
        NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request fromData:data completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            
            NSLog(@"%@", error);
            if (error == nil){
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Successful!" message:@"Thanks for checking the book out!" delegate:nil cancelButtonTitle:@"Okay!" otherButtonTitles:nil];
                    [alertView show];
                    [self.navigationController popToRootViewControllerAnimated:YES];
                });
                
            }
            
            //Uncomment For debuging purposes to see returned values
            //            NSLog(@"The data is.. %@", data);
            //            NSLog(@"The response is.. %@", response);
            //            NSLog(@"The error is.. %@", error);
        }];
        
        [uploadTask resume];
    }
    
}

-(void)methodDelete{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *stringFullUrlWithBookID = [NSString stringWithFormat:@"%@%@",[userDefaults objectForKey:@"stringUrlForApi"], stringBookID];
    NSURL *urlBookID = [NSURL URLWithString:stringFullUrlWithBookID];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:urlBookID];
    request.HTTPMethod = @"DELETE";
    
    //Deletes the book from the swag library
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSLog(@"The meta data response is %@", response);
        
        if (error == nil){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController popToRootViewControllerAnimated:YES];
            });
        }
    }];
    
    [task resume];
    
}

@end

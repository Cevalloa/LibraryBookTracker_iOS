//
//  BookDetailViewController.m
//  Library_Book_Tracker
//
//  Created by Alex Cevallos on 1/20/15.
//  Copyright (c) 2015 AlexCevallos. All rights reserved.
//

#import <Social/Social.h>
#import "BookDetailViewController.h"
#import "EditBookViewController.h"
#import "NSDictionary+RemovesNilValues.h"
#import "UIViewController+StringConverter.h"

@interface BookDetailViewController () <UIAlertViewDelegate>{
    //Used to store the URL of the current book
    NSString *stringBookID;
    
    //Used to store the entire book's information in one string
    NSString *stringBookAllInformation;
}

@end

@implementation BookDetailViewController

#pragma mark - View Controller Lifecycle Methods
//Sets labels, sets book URL, and sets all book information in one string
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    //methodConvertToFormatedString -> turns into formatted string
    //methodCheckIfKey Nil -> Checks if key nil (returns string regardless)
    //Font color is changed in storyboard
    self.labelBookTitle.attributedText = [self methodConvertToFormattedString:[self.dictionaryBookInformation methodCheckIfKeyNil:@"title"] sizeOfString:18.0f];
    
    //Rest of labels text/color/size are changable in storyboards
    self.labelBookAuthor.text = [NSString stringWithFormat:@"By:\t%@",[self.dictionaryBookInformation methodCheckIfKeyNil:@"author"]];
    
    self.labelBookPublisher.text = [NSString stringWithFormat:@"Publisher:\t%@",[self.dictionaryBookInformation methodCheckIfKeyNil:@"publisher"]];
    
    self.labelBookTags.text = [NSString stringWithFormat:@"Tags:\t%@", [self.dictionaryBookInformation methodCheckIfKeyNil:@"categories"]];
    
    //Checks if lastCheckedOutBy empty (if true, tells user there is nothing there)
    NSString *stringFullCheckOut = [NSString stringWithFormat:@"Checked Out: %@",[self.dictionaryBookInformation methodCheckIfKeyNil:@"lastCheckedOutBy"]];
    
    //Reminder: methodCheckIfKeyNil returns -No [DictionaryKey] if value == null
    if ([@"Checked Out: -No lastCheckedOutBy" isEqualToString:stringFullCheckOut]){
        
        self.labelBookLatestCheckout.text = @"No Checkouts Yet";
    }else{
        
        //Don't need methodCheckIfKeyNil, because already checked if lastCheckedOut was nil
        self.labelBookLatestCheckout.text = [NSString stringWithFormat:@"%@ At %@",stringFullCheckOut, [self methodFormatsDateString:self.dictionaryBookInformation[@"lastCheckedOut"]]];
    }
    
    //For the URL Of The actual book
    stringBookID = [NSString stringWithFormat:@"%@", self.dictionaryBookInformation[@"url"]];
    
    //Used to store all book information to one string (to send to social media)
    stringBookAllInformation  = [NSString stringWithFormat:@"Check this swag library book!\n\n%@\n%@\n%@\n%@\n%@",
                                 self.labelBookTitle.attributedText.string,
                                 self.labelBookAuthor.text,
                                 self.labelBookPublisher.text,
                                 self.labelBookTags.text,
                                 self.labelBookLatestCheckout.text];
    
    //Gives the border size & color around the book information
    self.viewForBookInformation.layer.borderColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1.0].CGColor;
    self.viewForBookInformation.layer.borderWidth = 2.0f;

}

#pragma mark - UIAlertView Delegate Methods
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    //For updating book:
    //ButtonIndex 0 = Cancel, ButtonIndex 1 = Accept
    if ([alertView.title isEqualToString:@"Preparing Checkout"] && buttonIndex == 1){
        [self methodPut:[alertView textFieldAtIndex:0].text];
    
    //To run code deleting current book
    }else if ([alertView.title isEqualToString:@"Are you sure?"] && buttonIndex == 1){
        [self methodDelete];
        
    //To send book information to twitter
    }else if([alertView.title isEqualToString:@"Share this book?"] && buttonIndex == 1){
        [self methodSendToTwitter];
        
    //To send book information to facebook
    }else if([alertView.title isEqualToString:@"Share this book?"] && buttonIndex == 2){
        [self methodSendToFacebook];
    }
}

#pragma mark - Storyboard Segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"segueToEditBook"]){
        [segue.destinationViewController setDictionaryBookInformationToEdit:sender];
    }
    
}

#pragma mark - IBAction Methods
//Removes current detail view
- (IBAction)barButtonItemCancel:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

//Asks user which social media to share current book on
- (IBAction)barButtonItemShare:(id)sender {
    UIAlertView *alertViewSendToSocialMedia = [[UIAlertView alloc] initWithTitle:@"Share this book?" message:@"Which social media platform would you like to share this book on?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Twitter", @"Facebook", nil];
    [alertViewSendToSocialMedia show];
    
}

//Asks User For Name To Checkout Book
- (IBAction)buttonBookCheckout:(id)sender {
    //For iOS 8 and up please use UIAlertController
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Preparing Checkout"
                                                        message:@"What is your name?"
                                                       delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Accept", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alertView show];
    
}

//Activates button to update person's checkout
- (IBAction)buttonBookUpdate:(id)sender {
    [self performSegueWithIdentifier:@"segueToEditBook" sender:self.dictionaryBookInformation];
}

- (IBAction)buttonBookDelete:(id)sender {
    UIAlertView *alertViewBookDelete = [[UIAlertView alloc] initWithTitle:@"Are you sure?" message:@"Do you want to permanently delete this book?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes", nil];
    
    //Reminder the delegate triggers events based on the UIAlertViewTitle
    [alertViewBookDelete show];
}

#pragma mark - Social Media Connectivity Methods
-(void)methodSendToTwitter{
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]){
        SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        
        [tweetSheet setInitialText:stringBookAllInformation];
        [self presentViewController:tweetSheet animated:YES completion:nil];
    }
}

-(void)methodSendToFacebook{
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]){
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        [controller setInitialText:stringBookAllInformation];
        [self presentViewController:controller animated:YES completion:Nil];
    }
}

#pragma mark - API Connectivity Methods
//Updates book's latest checkout
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

//Deletes current book
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

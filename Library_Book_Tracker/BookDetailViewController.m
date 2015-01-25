//
//  BookDetailViewController.m
//  Library_Book_Tracker
//
//  Created by Alex Cevallos on 1/20/15.
//  Copyright (c) 2015 AlexCevallos. All rights reserved.
//

#import "BookDetailViewController.h"
#import "EditBookViewController.h"

@interface BookDetailViewController () <UIAlertViewDelegate>{
    NSString *stringBookID;
}

@end

@implementation BookDetailViewController

#pragma mark - View Controller Lifecycle Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    id stringBookTitle = self.dictionaryBookInformation[@"title"];
    id stringBookAuthor = self.dictionaryBookInformation[@"author"];
    id stringBookPublisher = self.dictionaryBookInformation[@"publisher"];
    id stringBookTags = self.dictionaryBookInformation[@"categories"];
    id stringBookLatestCheckout = self.dictionaryBookInformation[@"lastCheckedOut"];
    id stringBookLatestCheckoutBy = self.dictionaryBookInformation[@"lastCheckedOutBy"];
    
    //Brings in passed dictionary, and parses it to the IBOutlets (if they aren't empty)
    if ([stringBookTitle isKindOfClass:[NSNull class]]){
        self.labelBookTitle.text = @"-No Title";
    }else{
        self.labelBookTitle.text = stringBookTitle;
    }
    
    if([stringBookAuthor isKindOfClass:[NSNull class]]){
        self.labelBookAuthor.text = @"-No Author-";
    }else{
        self.labelBookAuthor.text = stringBookAuthor;
    }
    
    if([stringBookPublisher isKindOfClass:[NSNull class]]){
        self.labelBookPublisher.text = @"-No Publisher-";
    }else{
        self.labelBookPublisher.text = [NSString stringWithFormat:@"Publisher: %@", stringBookPublisher];
    }
    
    if([stringBookTags isKindOfClass:[NSNull class]]){
        self.labelBookTags.text = @"-No Tags-";
    }else{
        self.labelBookTags.text = [NSString stringWithFormat:@"Tags: %@,", stringBookTags];
    }
    
    if([stringBookLatestCheckout isKindOfClass:[NSNull class]] &&
       [stringBookLatestCheckoutBy isKindOfClass:[NSNull class]]){
      self.labelBookLatestCheckout.text = @"-No Checkouts";
    }else{
        self.labelBookLatestCheckout.text = [NSString stringWithFormat:@"Last Checked Out:%@ At %@", stringBookLatestCheckoutBy, stringBookLatestCheckout];

    }
    
    //For the URL Of The actual book
    stringBookID = [NSString stringWithFormat:@"%@", self.dictionaryBookInformation[@"url"]];


}

#pragma mark - UIAlertView Delegate Methods
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    //ButtonIndex 0 = Cancel, ButtonIndex 1 = Accept

    [self methodPut:[alertView textFieldAtIndex:0].text];
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


@end

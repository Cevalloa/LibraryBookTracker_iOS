//
//  BookListTableViewController.m
//  Library_Book_Tracker
//
//  Created by Alex Cevallos on 1/20/15.
//  Copyright (c) 2015 AlexCevallos. All rights reserved.
//

#import "BookListTableViewController.h"
#import "UIViewController+StringConverter.h"
#import "NSDictionary+RemovesNilValues.h"
#import "BookDetailViewController.h"

@interface BookListTableViewController ()
@property (nonatomic) NSArray *arrayOfBookList;

@end

@implementation BookListTableViewController

#pragma mark - View Controller Lifecycle Methods

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    

    [self methodInitialGet];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.arrayOfBookList count];
}

#pragma mark - Table view delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    NSString *stringTitleOfBook = [self.arrayOfBookList[indexPath.row] methodCheckIfKeyNil:@"title"];
    NSString *stringAuthorOfBook = [self.arrayOfBookList[indexPath.row] methodCheckIfKeyNil:@"author"];
    
    
    //methodConverToFormattedString is from a category. Method is used to format strings
    cell.textLabel.attributedText = [self methodConvertToFormattedString:stringTitleOfBook sizeOfString:15.0f];
    cell.detailTextLabel.attributedText = [self methodConvertToFormattedString:stringAuthorOfBook sizeOfString:12.0f];
    
    //-Used to debug at what time this method receives the information. (Useful for debugging multithreading)
        //NSLog(@"%@", self.arrayOfBookList[indexPath.row]);
        //NSLog(@"Within cell for row the count is %lu", (unsigned long)[self.arrayOfBookList count]);

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //Passes the dictionary at the index dependent on the selected row
    [self performSegueWithIdentifier:@"segueToBookDetail" sender:self.arrayOfBookList[indexPath.row]];
}

#pragma mark - UIAlertView Delegate Methods
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    //For confirming deleting all books: ButtonIndex 0 = Cancel, 1 = Accept
    if(buttonIndex == 1){
        [self methodDeleteAll];
    }
}

#pragma mark - Storyboard Segue 
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"segueToBookDetail"]){
        [segue.destinationViewController setDictionaryBookInformation:sender];
    }
}

#pragma mark - IBAction Methods
- (IBAction)barButtonItemAddBook:(id)sender {
    [self performSegueWithIdentifier:@"segueModalAddBook" sender:nil];
}

//Asks for confirmation if user wants to delete all books
- (IBAction)barButtonItemDeleteAll:(id)sender {
    UIAlertView *alertViewConfirmDeleteAll = [[UIAlertView alloc] initWithTitle:@"Are you sure?" message:@"You are about to delete all of the books.. there is no going back!" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"I am sure!", nil];
    [alertViewConfirmDeleteAll show];
}


#pragma mark - API Connectivity Methods
//Gets all books to fill the tableview
-(void)methodInitialGet {
    
    //Change the URL string here to change throughout the app
    NSString *urlString = [[NSString alloc] initWithFormat:@"http://prolific-interview.herokuapp.com/54be6ef246c2c2000866aa4d"];
    
    
    //Set up universal URL for API Connection (if it does not match the stringUrl)
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([[userDefaults stringForKey:@"stringUrlForApi"] isEqualToString:urlString]) {
        NSLog(@"urlForApi is empty");
        [userDefaults setObject:urlString forKey:@"stringUrlForApi"];
    }
    
    NSString *stringBookPost = [NSString stringWithFormat:@"%@/books", [userDefaults objectForKey:@"stringUrlForApi"] ];
    
    NSURL *url = [[NSURL alloc] initWithString:stringBookPost];

    NSURLSession *session = [NSURLSession sharedSession];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"GET";
    
    //Retrieves books from Swag Library
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        //If there are no errors, proceed!
        if(error == nil){
            NSArray *arrayToBeSorted = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            
            //Used to sort incomming books, alphabetically by title
            NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES];
            
            //Returns alphabetically sorted array to array used for tableview
            self.arrayOfBookList = [arrayToBeSorted sortedArrayUsingDescriptors:@[sort]];
            
            //Debugging To see what JSON Api feed returns
                NSLog(@"The returned JSON data in NSDictionary form is %@", self.arrayOfBookList);
                NSLog(@"The meta data response is %@", response);
                NSLog(@"total count %lu", (unsigned long)[self.arrayOfBookList count]);
            
            
            //Reminder you can't call UI elements on the back threads
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.tableView reloadData];
            });
        }
        
    }];
    
    [task resume];
    
}

//Called to delete all the books in the API
-(void)methodDeleteAll{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *stringBookDeleteAll = [NSString stringWithFormat:@"%@/clean",[userDefaults objectForKey:@"stringUrlForApi"]];
    NSURL *urlBookDeleteAll = [NSURL URLWithString:stringBookDeleteAll];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:urlBookDeleteAll];
    [request setHTTPMethod:@"DELETE"];
    
    //Deletes all the books!
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            NSLog(@"The meta data response is %@", response);

        if(error == nil){
            dispatch_async(dispatch_get_main_queue(), ^{
                
            
                UIAlertView *alertViewBooksDeleted = [[UIAlertView alloc] initWithTitle:@"All gone!" message:@"All books have been deleted!" delegate:nil cancelButtonTitle:@"Sounds good!" otherButtonTitles: nil];
                
                [alertViewBooksDeleted show];
                [self methodInitialGet];
            });
        
        }
        
        
    
    }];
    
    [task resume];
    
}



@end

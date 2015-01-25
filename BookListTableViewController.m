//
//  BookListTableViewController.m
//  Library_Book_Tracker
//
//  Created by Alex Cevallos on 1/20/15.
//  Copyright (c) 2015 AlexCevallos. All rights reserved.
//

#import "BookListTableViewController.h"
#import "NSObject+StringConverter.h"
#import "BookDetailViewController.h"

@interface BookListTableViewController ()
@property (nonatomic) NSArray *arrayOfBookList;

@end

@implementation BookListTableViewController

#pragma mark - View Controller Lifecycle Methods

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    NSLog(@"View will appear is called");
    [self connect];
}

#pragma mark - API Connectivity Methods
-(void)connect {
    
    //Change the URL string here to change throughout the app
    NSString *urlString = [[NSString alloc] initWithFormat:@"http://prolific-interview.herokuapp.com/54be6ef246c2c2000866aa4d"];
    
    
    //Set up universal URL for API Connection (if it does not match the stringUrl)
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults stringForKey:@"stringUrlForApi"] != urlString) {
        NSLog(@"urlForApi is empty");
        [userDefaults setObject:urlString forKey:@"stringUrlForApi"];
    }
    
    //Adds books to the end of the API String
   // NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@/books",[userDefaults objectForKey:@"stringUrlForApi"]]];
    
    NSString *stringBookPost = [NSString stringWithFormat:@"%@/books", [userDefaults objectForKey:@"stringUrlForApi"] ];
    
    NSURL *url = [[NSURL alloc] initWithString:stringBookPost];
    
    
    
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"GET";
    
    //Retrieves books from Swag Library
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
            self.arrayOfBookList = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            
    //Debugging To see what JSON Api feed returns
            NSLog(@"The returned JSON data in NSDictionary form is %@", self.arrayOfBookList);
            NSLog(@"The meta data response is %@", response);
            NSLog(@"total count %lu", (unsigned long)[self.arrayOfBookList count]);
            
            
            //Reminder you can't call UI elements on the back threads
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.tableView reloadData];
            });
        
    }];
    
    [task resume];
    
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
    
    id stringTitleOfBook = self.arrayOfBookList[indexPath.row][@"title"];
    id stringAuthorOfBook = self.arrayOfBookList[indexPath.row][@"author"];
    
    //Reminder.. cellForRow throws NSNull exception if tableviewcell text is null
    if([stringTitleOfBook isKindOfClass:[NSNull class]]){
        stringTitleOfBook = @"-No Title";
    }
    
    if([stringAuthorOfBook isKindOfClass:[NSNull class]]){
        stringAuthorOfBook = @"-No Author-";
    }
    
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

@end

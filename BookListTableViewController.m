//
//  BookListTableViewController.m
//  Library_Book_Tracker
//
//  Created by Alex Cevallos on 1/20/15.
//  Copyright (c) 2015 AlexCevallos. All rights reserved.
//

#import "BookListTableViewController.h"
#import "NSObject+StringConverter.h"
@interface BookListTableViewController ()
@property (nonatomic) NSArray *arrayOfBookList;

@end

@implementation BookListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    [self connect];
}

-(void)connect {
    NSURLSession *session = [NSURLSession sharedSession];
    NSString *urlString = [[NSString alloc] initWithFormat:@"http://prolific-interview.herokuapp.com/54be6ef246c2c2000866aa4d/books"];
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"GET";
    
    //Retrieves books from Swag Library
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.arrayOfBookList = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            NSLog(@"The returned JSON data in NSDictionary form is %@", self.arrayOfBookList);
            NSLog(@"The meta data response is %@", response);
            NSLog(@"total count %lu", (unsigned long)[self.arrayOfBookList count]);
            
            //Reminder you can't call UI elements on the back threads
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];

    //-Used to debug at what time this method receives the information. (Useful for debugging multithreading)
    //NSLog(@"%@", self.arrayOfBookList[indexPath.row]);
    //NSLog(@"Within cell for row the count is %lu", (unsigned long)[self.arrayOfBookList count]);
    
    NSString *stringTitleOfBook = self.arrayOfBookList[indexPath.row][@"title"];
    
    NSString *stringAuthorOfBook = self.arrayOfBookList[indexPath.row][@"author"];
    
    //methodConverToFormattedString is from a category. Method is used to format strings
    cell.textLabel.attributedText = [self methodConvertToFormattedString:stringTitleOfBook sizeOfString:15.0f];
    cell.detailTextLabel.attributedText = [self methodConvertToFormattedString:stringAuthorOfBook sizeOfString:12.0f];

    return cell;
    
    
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

//
//  BookDetailViewController.m
//  Library_Book_Tracker
//
//  Created by Alex Cevallos on 1/20/15.
//  Copyright (c) 2015 AlexCevallos. All rights reserved.
//

#import "BookDetailViewController.h"

@interface BookDetailViewController ()

@end

@implementation BookDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.labelBookTitle.text = self.dictionaryBookInformation[@"title"];
    self.labelBookAuthor.text = self.dictionaryBookInformation[@"author"];
    
    if (self.dictionaryBookInformation[@"publisher"] == nil) {
        self.labelBookPublisher.text = [NSString stringWithFormat:@"- No Publisher Listed! -"];
    }else{
        self.labelBookPublisher.text = [NSString stringWithFormat:@"Publisher: %@", self.dictionaryBookInformation[@"publisher"]];
    }
    
    self.labelBookTags.text = [NSString stringWithFormat:@"Tags: %@,", self.dictionaryBookInformation[@"categories"]];
    self.labelBookLatestCheckout.text = [NSString stringWithFormat:@"Last Checked Out:\n%@ At %@",
                                         self.dictionaryBookInformation[@"lastCheckedOut"],
                                         self.dictionaryBookInformation[@"lastCheckedOut"]];
    


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)buttonBookCheckout:(id)sender {
}
@end

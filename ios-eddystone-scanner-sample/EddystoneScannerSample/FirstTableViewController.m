//
//  FirstTableViewController.m
//  EddystoneScannerSample
//
//  Created by ShaoTongkai on 7/26/16.
//  Copyright © 2016 Google, Inc. All rights reserved.
//

#import "FirstTableViewController.h"
#import "FirstTableViewCell.h"
#import "FirstDetailViewController.h"

@interface FirstTableViewController ()


@end

@implementation FirstTableViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self.searchBar setDelegate:self];
    
    _matchingItems = [[NSMutableArray alloc] init];
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)shouldAutorotate {
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return UIInterfaceOrientationMaskAll;
    else
        return UIInterfaceOrientationMaskAllButUpsideDown;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"showDetail"]) {
        NSLog(@"showDetail");
        _detailViewController = (FirstDetailViewController*)[segue destinationViewController];
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.matchingItems count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _detailViewController.item = [_matchingItems objectAtIndex:indexPath.row];
    
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)anIndexPath {
    
    FirstTableViewCell * cell = (FirstTableViewCell *)[aTableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    
    cell.title.text = [self.matchingItems objectAtIndex:anIndexPath.row][@"title"];
    
    NSURL * url = [NSURL URLWithString: [self.matchingItems objectAtIndex:anIndexPath.row][@"image"]];
    
    
    NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData *_Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            UIImage *image = [UIImage imageWithData:data];
            if(image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    // code here
                    [cell.image setImage:image];
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    // code here
                    UIImage *defaultImage = [UIImage imageNamed:@"default.png"];
                    [cell.image setImage:image];
                });
            }
        }
        if (error) {
            NSLog(@"ERROR, %@", error);
        }
    }];
    [task resume];
    
    
    return cell;
}

#pragma mark - UISearchBarDelegate

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar {
    self.searchBar.text = @"";
    [searchBar resignFirstResponder];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:NO animated:YES];
}


- (void)startSearch:(NSString *)searchString {

    NSString *myString = @"http://ec2-52-87-235-234.compute-1.amazonaws.com:8080/searchProducts?Keywords=";
    
    myString = [myString stringByAppendingString:searchString];
    
    myString = [myString stringByAppendingString:@"&SearchIndex="];
    
    int rateLevel = self.searchBar.selectedScopeButtonIndex;
    
    if (rateLevel == 0) {
        myString = [myString stringByAppendingString:@"All"];
    } else if (rateLevel == 1) {
        myString = [myString stringByAppendingString:@"Books"];
    } else if (rateLevel == 2) {
        myString = [myString stringByAppendingString:@"Electronics"];
    } else if (rateLevel == 3) {
        myString = [myString stringByAppendingString:@"GourmetFood"];
    } else {
        myString = [myString stringByAppendingString:@"Apparel"];
    }
    
    NSLog(@"Data = %@",myString);
    
    NSString *newString = [myString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: self delegateQueue: [NSOperationQueue mainQueue]];
    
    NSURL * url = [NSURL URLWithString:newString];
    
    NSURLSessionDataTask * dataTask = [defaultSession dataTaskWithURL:url
                                                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                        if(error == nil)
                                                        {
                                                            NSString * text = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
                                                            //NSLog(@"Data = %@",text);
                                                            
                                                            NSError *e = nil;
                                                            NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &e];
                                                            
                                                            if (!jsonArray) {
                                                                NSLog(@"Error parsing JSON: %@", e);
                                                            } else {
                                                                
                                                                [_matchingItems removeAllObjects];
                                                                
                                                                for(NSDictionary *item in jsonArray) {
                                                                    //NSLog(@"Item: %@", item);
                                                                    [_matchingItems addObject:item];
                                                                }
                                                                
                                                                NSLog(@"Item: %lu",  (unsigned long)[self.matchingItems count]);
                                                                
                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                    
                                                                    [self.tableView reloadData];
                                                                });
                                                            }
                                                            
                                                            
                                                        } else {
                                                            NSLog(@"error!!!!!!!!!!!!!!!");
                                                        }
                                                        
                                                    }];
    
    [dataTask resume];

}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    

    [self startSearch:self.searchBar.text];
}

-(void)searchBar:(UISearchBar *)bar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope
{
    [self startSearch:self.searchBar.text];
}





@end

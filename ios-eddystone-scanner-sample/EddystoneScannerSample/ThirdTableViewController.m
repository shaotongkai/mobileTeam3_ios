//
//  ThirdTableViewController.m
//  EddystoneScannerSample
//
//  Created by Robert Pattinson on 16/8/1.
//  Copyright © 2016年 Google, Inc. All rights reserved.
//

#import "ThirdTableViewController.h"
#import "FirstDetailViewController.h"
#import "ThirdTableViewCell.h"

@interface ThirdTableViewController ()

@end

@implementation ThirdTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    _matchingItems = [[NSMutableArray alloc] init];
    
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"ATTENTION"
                              message:@"PLZ add the product to shopping list by the first search function"
                              delegate:self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
    dispatch_async(dispatch_get_main_queue(), ^{
        // code here
        [alertView show];
    });
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidAppear:(BOOL)animated {
    
    
    NSString *newString = @"http://ec2-52-87-235-234.compute-1.amazonaws.com:8080/shoppingLists?user_id=";
    
    newString = [newString stringByAppendingString:@"hardcodeHere"];
    
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

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    _detailViewController.whichView = @"no";
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)anIndexPath {
    
    ThirdTableViewCell * cell = (ThirdTableViewCell *)[aTableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    
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


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSString * ASIN = [self.matchingItems objectAtIndex:indexPath.row][@"ASIN"];
        
        
        
        ///////////////////POST////////////
        NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
        
        NSURL * url = [NSURL URLWithString:@"http://ec2-52-87-235-234.compute-1.amazonaws.com:8080/editShoppingList"];
        NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
        NSString * params =@"op=RM_ITEM";
        //            NSString * pad = @"&";
        NSString * userId = @"hardcodeHere";
        params = [params stringByAppendingString:@"&user_id="];
        params = [params stringByAppendingString:userId];
        params = [params stringByAppendingString:@"&shoppinglist_id="];
        params = [params stringByAppendingString:userId];
        params = [params stringByAppendingString:@"&ASIN="];
        params = [params stringByAppendingString:ASIN];
        [urlRequest setHTTPMethod:@"POST"];
        [urlRequest setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSURLSessionDataTask * dataTask =[defaultSession dataTaskWithRequest:urlRequest
                                                           completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                               NSLog(@"Response:%@ %@\n", response, error);
                                                               if(error == nil)
                                                               {
                                                                   UIAlertView *alertView = [[UIAlertView alloc]
                                                                                             initWithTitle:@"Success"
                                                                                             message:@"delete an item from list"
                                                                                             delegate:self
                                                                                             cancelButtonTitle:@"OK"
                                                                                             otherButtonTitles:nil];
                                                                   dispatch_async(dispatch_get_main_queue(), ^{
                                                                       // code here
                                                                       [alertView show];
                                                                       [self.matchingItems removeObject:[self.matchingItems objectAtIndex:indexPath.row]];
                                                                       [self.tableView reloadData];
                                                                       
                                                                   });
                                                               }
                                                               
                                                           }];
        [dataTask resume];

        
    }
}

@end

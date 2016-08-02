//
//  ForthTableViewController.m
//  EddystoneScannerSample
//
//  Created by Robert Pattinson on 16/8/1.
//  Copyright © 2016年 Google, Inc. All rights reserved.
//

#import "ForthTableViewController.h"
#import "AddViewController.h"
#import "ForthDetailViewController.h"

@interface ForthTableViewController ()

@end

@implementation ForthTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    _matchingItems = [[NSMutableArray alloc] init];
    
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemAdd target: self action: @selector(showNewView)];
    
     self.navigationItem.rightBarButtonItem = addButton;
    
    
}


- (void)viewDidAppear:(BOOL)animated {
    
    
    NSString *newString = @"http://ec2-52-87-235-234.compute-1.amazonaws.com:8080/coupons?user_id=";
    
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



-(void)showNewView
{
    if(self.coolViewController == nil)
    {
        //NewViewController *coolViewController = [[NewViewController alloc] init];
        AddViewController *coolViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"addScreen"];
        self.coolViewController = coolViewController;
    }
    
    
    [self.navigationController pushViewController:self.coolViewController animated:YES];
    
}


#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"showDetail"]) {
        NSLog(@"showDetail");
        _detailViewController = (ForthDetailViewController*)[segue destinationViewController];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _detailViewController.item = [_matchingItems objectAtIndex:indexPath.row];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.matchingItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.textLabel.text =[self.matchingItems objectAtIndex:indexPath.row][@"coupon_id"];
    cell.detailTextLabel.text =[self.matchingItems objectAtIndex:indexPath.row][@"expire_date"];
    
    
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSString * coupon_id = [self.matchingItems objectAtIndex:indexPath.row][@"coupon_id"];
        NSString * user_id = [self.matchingItems objectAtIndex:indexPath.row][@"user_id"];
        
        
        
        ///////////////////POST////////////
        NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
        
        NSURL * url = [NSURL URLWithString:@"http://ec2-52-87-235-234.compute-1.amazonaws.com:8080/editCoupon"];
        NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
        NSString * params =@"op=RM_ITEM";
        //            NSString * pad = @"&";
        NSString * userId = @"hardcodeHere";
        params = [params stringByAppendingString:@"&user_id="];
        params = [params stringByAppendingString:userId];
        params = [params stringByAppendingString:@"&coupon_id="];
        params = [params stringByAppendingString:coupon_id];
        [urlRequest setHTTPMethod:@"POST"];
        [urlRequest setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSURLSessionDataTask * dataTask =[defaultSession dataTaskWithRequest:urlRequest
                                                           completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                               NSLog(@"Response:%@ %@\n", response, error);
                                                               if(error == nil)
                                                               {
                                                                   UIAlertView *alertView = [[UIAlertView alloc]
                                                                                             initWithTitle:@"Success"
                                                                                             message:@"delete a coupon from list"
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



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

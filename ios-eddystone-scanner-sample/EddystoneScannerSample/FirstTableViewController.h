//
//  FirstTableViewController.h
//  EddystoneScannerSample
//
//  Created by ShaoTongkai on 7/26/16.
//  Copyright © 2016 Google, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FirstDetailViewController;

@interface FirstTableViewController : UITableViewController <UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) FirstDetailViewController *detailViewController;

@property (nonatomic, strong) NSArray *items;

@end

//
//  ThirdTableViewController.h
//  EddystoneScannerSample
//
//  Created by Robert Pattinson on 16/8/1.
//  Copyright © 2016年 Google, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FirstDetailViewController;

@interface ThirdTableViewController : UITableViewController

@property (nonatomic, strong) NSMutableArray * matchingItems;

@property (strong, nonatomic) FirstDetailViewController *detailViewController;

@property (nonatomic, strong) NSArray *items;

@end

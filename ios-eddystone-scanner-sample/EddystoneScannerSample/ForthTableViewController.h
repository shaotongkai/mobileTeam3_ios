//
//  ForthTableViewController.h
//  EddystoneScannerSample
//
//  Created by Robert Pattinson on 16/8/1.
//  Copyright © 2016年 Google, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ForthDetailViewController;

@class AddViewController;

@interface ForthTableViewController : UITableViewController

@property (strong, nonatomic) AddViewController *coolViewController;

@property (strong, nonatomic) ForthDetailViewController *detailViewController;

@property (nonatomic, strong) NSMutableArray * matchingItems;

@end

//
//  FirstDetailViewController.h
//  EddystoneScannerSample
//
//  Created by ShaoTongkai on 7/26/16.
//  Copyright © 2016 Google, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ViewController;

@interface FirstDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *itemTitle;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UIWebView *web1;
@property (weak, nonatomic) IBOutlet UIWebView *web2;

@property (strong, nonatomic) ViewController *coolViewController;

@property (nonatomic, strong) NSDictionary *item;

@property (nonatomic, strong) NSString *ASIN;

@property (nonatomic, strong) UIImage * product;

@property (nonatomic, strong) NSString *section;

@property (nonatomic, strong) NSString *whichView;
@property (weak, nonatomic) IBOutlet UIButton *shooop;
@property (weak, nonatomic) IBOutlet UILabel *cuooo;

@property (weak, nonatomic) IBOutlet UIButton *navigation;
- (IBAction)navi:(id)sender;
- (IBAction)addS:(id)sender;

@end

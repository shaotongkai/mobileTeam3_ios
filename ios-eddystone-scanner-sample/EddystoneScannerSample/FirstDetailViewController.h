//
//  FirstDetailViewController.h
//  EddystoneScannerSample
//
//  Created by ShaoTongkai on 7/26/16.
//  Copyright © 2016 Google, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *itemTitle;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UIWebView *web1;
@property (weak, nonatomic) IBOutlet UIWebView *web2;

@property (nonatomic, strong) NSDictionary *item;

@property (nonatomic, strong) NSString *ASIN;


@end

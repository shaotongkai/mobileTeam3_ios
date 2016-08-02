//
//  ForthDetailViewController.h
//  EddystoneScannerSample
//
//  Created by Robert Pattinson on 16/8/1.
//  Copyright © 2016年 Google, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ForthDetailViewController : UIViewController
@property (nonatomic, strong) NSDictionary *item;

@property (weak, nonatomic) IBOutlet UILabel *description_detail;
@property (weak, nonatomic) IBOutlet UILabel *expire_data;

@property (weak, nonatomic) IBOutlet UILabel *coupon_id;
@end

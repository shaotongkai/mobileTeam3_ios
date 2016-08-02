//
//  AddViewController.h
//  EddystoneScannerSample
//
//  Created by Robert Pattinson on 16/8/1.
//  Copyright © 2016年 Google, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AddViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *coupon_id;
@property (weak, nonatomic) IBOutlet UITextField *descrition_detail;
- (IBAction)save:(id)sender;
@property (weak, nonatomic) IBOutlet UIDatePicker *timePicker;

@end

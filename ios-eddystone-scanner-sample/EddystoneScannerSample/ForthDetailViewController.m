//
//  ForthDetailViewController.m
//  EddystoneScannerSample
//
//  Created by Robert Pattinson on 16/8/1.
//  Copyright © 2016年 Google, Inc. All rights reserved.
//

#import "ForthDetailViewController.h"

@interface ForthDetailViewController ()

@end

@implementation ForthDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"%@",_item[@"coupon_id"]);
    _coupon_id.text = _item[@"coupon_id"];
    _expire_data.text = _item[@"expire_date"];
    _description_detail.text = _item[@"description"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

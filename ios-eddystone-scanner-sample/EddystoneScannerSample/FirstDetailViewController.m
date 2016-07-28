//
//  FirstDetailViewController.m
//  EddystoneScannerSample
//
//  Created by ShaoTongkai on 7/26/16.
//  Copyright © 2016 Google, Inc. All rights reserved.
//

#import "FirstDetailViewController.h"

@interface FirstDetailViewController ()

@end

@implementation FirstDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _itemTitle.text = _item[@"title"];
    _price.text = _item[@"price"];
    _ASIN = _item[@"ASIN"];
    
    
    
    NSURL * url = [NSURL URLWithString: _item[@"image"]];
    
    
    NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData *_Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            UIImage *image = [UIImage imageWithData:data];
            if(image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    // code here
                    [_image setImage:image];
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    // code here
                    UIImage *defaultImage = [UIImage imageNamed:@"default.png"];
                    [_image setImage:image];
                });
            }
        }
        if (error) {
            NSLog(@"ERROR, %@", error);
        }
    }];
    [task resume];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

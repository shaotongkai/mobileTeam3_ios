//
//  FirstDetailViewController.m
//  EddystoneScannerSample
//
//  Created by ShaoTongkai on 7/26/16.
//  Copyright © 2016 Google, Inc. All rights reserved.
//

#import "FirstDetailViewController.h"

#define kVerySmallValue (0.000001)

@interface FirstDetailViewController ()

@end

@implementation FirstDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _itemTitle.text = _item[@"title"];
    
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
    
    
    [_web1 loadHTMLString:_item[@"description"] baseURL:nil];
    
    [_web2 loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_item[@"customReview"]]]];
    
    NSString *thisString = @"http://ec2-52-87-235-234.compute-1.amazonaws.com:8080/getProductLoc?ASIN=";
    
    thisString = [thisString stringByAppendingString:_ASIN];

    
    NSString *newString = [thisString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: self delegateQueue: [NSOperationQueue mainQueue]];
    
    NSURL * urlThis = [NSURL URLWithString:newString];
    
    NSURLSessionDataTask * dataTask = [defaultSession dataTaskWithURL:urlThis
                                                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                        if(error == nil)
                                                        {
                                                            NSString * text = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
                                                            NSLog(@"Data = %@",text);
                                                            
                                                            NSError *e = nil;
                                                            NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &e];
                                                            
                                                            double xVal= [jsonObject[@"x"] doubleValue];
                                                            
                                                            if(fabsf(xVal + 1) < kVerySmallValue) {
                                                                NSString *myPrice = @"price: ";
                                                                _price.text = [myPrice stringByAppendingString:_item[@"price"]];
                                                                _label3.text = @"Not in store";
                                                                
                                                            } else {
                                                                _label3.text = @"In store";
                                                                _price.text = jsonObject[@"price"];
                                                            }
                                                            
                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                
                                                            });
                                                            
                                                        } else {
                                                            NSLog(@"error!!!!!!!!!!!!!!!");
                                                        }
                                                        
                                                    }];
    
    [dataTask resume];
    
    
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

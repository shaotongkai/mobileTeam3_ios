// Copyright 2015 Google Inc. All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#import "ViewController.h"

#import "ESSBeaconScanner.h"

@interface ViewController () <ESSBeaconScannerDelegate> {
  ESSBeaconScanner *_scanner;
}

@end

@implementation ViewController

NSInteger *rssiA = 0;
NSInteger *rssiB = 0;
NSInteger *rssiC = 0;




- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.
    ///////////////////POST////////////
        NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
        NSURL * url = [NSURL URLWithString:@"http://ec2-52-87-235-234.compute-1.amazonaws.com:8080/navigation"];
        NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
        NSString * params =@"rssiA=-70&txPowerA=0&rssiB=-61&txPowerB=0&rssiC=-63&txPowerC=0";
        [urlRequest setHTTPMethod:@"POST"];
        [urlRequest setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    
        NSURLSessionDataTask * dataTask =[defaultSession dataTaskWithRequest:urlRequest
                                                           completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                               NSLog(@"Response:%@ %@\n", response, error);
                                                               if(error == nil)
                                                               {
                                                                   NSString * text = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
                                                                   NSLog(@"Data = %@",text);
                                                               }
    
                                                           }];
        [dataTask resume];

}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  _scanner = [[ESSBeaconScanner alloc] init];
  _scanner.delegate = self;
  [_scanner startScanning];
    
    
}

- (void)viewDidDisappear:(BOOL)animated {
  [super viewDidDisappear:animated];
  [_scanner stopScanning];
  _scanner = nil;
}


- (void)beaconScanner:(ESSBeaconScanner *)scanner
        didFindBeacon:(id)beaconInfo {
    
  //NSLog(@"I Saw an Eddystone!: %@", beaconInfo);
    
    NSString *be = [NSString stringWithFormat:@"%@", beaconInfo];;
    
    NSRange preID = [be rangeOfString:@"=<"];
    NSRange postID = [be rangeOfString:@">,"];
    
    NSString *ID = [be substringWithRange:NSMakeRange(preID.location + preID.length, postID.location - preID.location - preID.length)];
    NSLog(@"%@", ID);
    
    NSRange preRange = [be rangeOfString:@"RSSI:"];
    NSInteger preIdx = preRange.location + preRange.length;
    
    NSRange postRange = [be rangeOfString:@", txPower:"];
    NSInteger postIdx = postRange.location;
    
    NSString *RSSI = [be substringWithRange:NSMakeRange(preIdx + 1, postIdx - preIdx - 1)];
    NSLog(@"%@", RSSI);
    
    NSString *txPower = [be substringWithRange:NSMakeRange(postRange.location + postRange.length + 1, 1)];
    NSLog(@"%@", txPower);

}

- (void)beaconScanner:(ESSBeaconScanner *)scanner didUpdateBeacon:(id)beaconInfo {
 
    
  NSLog(@"I Updated an Eddystone!: %@", beaconInfo);
    
//    NSString *be = [NSString stringWithFormat:@"%@", beaconInfo];;
//    
//    NSRange preID = [be rangeOfString:@"=<"];
//    NSRange postID = [be rangeOfString:@">,"];
//    
//    NSString *ID = [be substringWithRange:NSMakeRange(preID.location + preID.length, postID.location - preID.location - preID.length)];
//    NSLog(@"%@", ID);
//    
//    NSRange preRange = [be rangeOfString:@"RSSI:"];
//    NSInteger preIdx = preRange.location + preRange.length;
//    
//    NSRange postRange = [be rangeOfString:@", txPower:"];
//    NSInteger postIdx = postRange.location;
//    
//    NSString *RSSI = [be substringWithRange:NSMakeRange(preIdx + 1, postIdx - preIdx - 1)];
//    NSLog(@"%@", RSSI);
//    
//    NSString *txPower = [be substringWithRange:NSMakeRange(postRange.location + postRange.length + 1, 1)];
//    NSLog(@"%@", txPower);
    
    /////////////////////POST////////////
//    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
//    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
//    
//    NSURL * url = [NSURL URLWithString:@"http://ec2-54-175-211-238.compute-1.amazonaws.com:8080/login"];
//    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
//    NSString * params =@"username=admin&password=password";
//    [urlRequest setHTTPMethod:@"POST"];
//    [urlRequest setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    NSURLSessionDataTask * dataTask =[defaultSession dataTaskWithRequest:urlRequest
//                                                       completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//                                                           NSLog(@"Response:%@ %@\n", response, error);
//                                                           if(error == nil)
//                                                           {
//                                                               NSString * text = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
//                                                               NSLog(@"Data = %@",text);
//                                                           }
//                                                           
//                                                       }];
//    [dataTask resume];
    
//    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
//    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: self delegateQueue: [NSOperationQueue mainQueue]];
//    
//    NSURL * url = [NSURL URLWithString:@"http://ec2-52-87-235-234.compute-1.amazonaws.com:8080/beaconList"];
//    
//    NSURLSessionDataTask * dataTask = [defaultSession dataTaskWithURL:url
//                                                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//                                                        if(error == nil)
//                                                        {
//                                                            NSString * text = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
//                                                            NSLog(@"Data = %@",text);
//                                                        }
//                                                        
//                                                    }];
//    
//    [dataTask resume];
    
}


- (void)beaconScanner:(ESSBeaconScanner *)scanner didFindURL:(NSURL *)url {
  NSLog(@"I Saw a URL!: %@", url);
}

@end

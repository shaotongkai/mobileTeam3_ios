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

int rssiA = 0;
int rssiB = 0;
int rssiC = 0;

NSString *txPowerA;
NSString *txPowerB;
NSString *txPowerC;

NSString *xA;
NSString *yA;
NSString *xB;
NSString *yB;
NSString *xC;
NSString *yC;
NSString *idA;
NSString *idB;
NSString *idC;

NSString *x;
NSString *y;

int countA = 0;
int countB = 0;
int countC = 0;





- (void)viewDidLoad {
  [super viewDidLoad];
    
    
    _dataA = [[NSMutableArray alloc] init];
    _dataB = [[NSMutableArray alloc] init];
    _dataC = [[NSMutableArray alloc] init];
  // Do any additional setup after loading the view, typically from a nib.
    ///////////////////POST////////////
//        NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
//        NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
//    
//        NSURL * url = [NSURL URLWithString:@"http://ec2-52-87-235-234.compute-1.amazonaws.com:8080/navigation"];
//        NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
//        NSString * params =@"rssiA=-70&txPowerA=0&rssiB=-61&txPowerB=0&rssiC=-63&txPowerC=0";
//        [urlRequest setHTTPMethod:@"POST"];
//        [urlRequest setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
//    
//        NSURLSessionDataTask * dataTask =[defaultSession dataTaskWithRequest:urlRequest
//                                                           completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//                                                               NSLog(@"Response:%@ %@\n", response, error);
//                                                               if(error == nil)
//                                                               {
//                                                                   NSString * text = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
//                                                                   NSLog(@"Data = %@",text);
//                                                               }
//    
//                                                           }];
//        [dataTask resume];
    
    
    //get beaconlist
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: self delegateQueue: [NSOperationQueue mainQueue]];
    
    NSURL * url = [NSURL URLWithString:@"http://ec2-52-87-235-234.compute-1.amazonaws.com:8080/beaconList"];
    
    NSURLSessionDataTask * dataTask = [defaultSession dataTaskWithURL:url
                                                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                        NSDictionary *jsonObject=[NSJSONSerialization
                                                                                  JSONObjectWithData:data
                                                                                  options:NSJSONReadingMutableLeaves
                                                                                  error:nil];
                                                        //NSLog(@"jsonObject is %@",jsonObject);
                                                        xA = jsonObject[@"xA"];
                                                        yA = jsonObject[@"yA"];
                                                        xB = jsonObject[@"xB"];
                                                        yB = jsonObject[@"yB"];
                                                        xC = jsonObject[@"xC"];
                                                        yC = jsonObject[@"yC"];
                                                        idA = jsonObject[@"idA"];
                                                        idB = jsonObject[@"idB"];
                                                        idC = jsonObject[@"idC"];
                                                        if(error == nil)
                                                        {
                                                            NSString * text = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
                                                            //NSLog(@"Data = %@",text);
                                                        } else {
                                                            NSLog(@"error happen");
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

- (CGPoint)getCoordinateWithBeaconA:(CGPoint)a beaconB:(CGPoint)b beaconC:(CGPoint)c distanceA:(CGFloat)dA distanceB:(CGFloat)dB distanceC:(CGFloat)dC {
    CGFloat W, Z, x, y, y2;
    W = dA*dA - dB*dB - a.x*a.x - a.y*a.y + b.x*b.x + b.y*b.y;
    Z = dB*dB - dC*dC - b.x*b.x - b.y*b.y + c.x*c.x + c.y*c.y;
    
    x = (W*(c.y-b.y) - Z*(b.y-a.y)) / (2 * ((b.x-a.x)*(c.y-b.y) - (c.x-b.x)*(b.y-a.y)));
    y = (W - 2*x*(b.x-a.x)) / (2*(b.y-a.y));
    //y2 is a second measure of y to mitigate errors
    y2 = (Z - 2*x*(c.x-b.x)) / (2*(c.y-b.y));
    
    y = (y + y2) / 2;
    return CGPointMake(x, y);
}


- (void)beaconScanner:(ESSBeaconScanner *)scanner
        didFindBeacon:(id)beaconInfo {
    
//    NSLog(@" FIND ");
    
  //NSLog(@"I Saw an Eddystone!: %@", beaconInfo);
    
    NSString *be = [NSString stringWithFormat:@"%@", beaconInfo];;
    
    NSRange preID = [be rangeOfString:@"=<"];
    NSRange postID = [be rangeOfString:@">,"];
    
    NSString *ID = [be substringWithRange:NSMakeRange(preID.location + preID.length, postID.location - preID.location - preID.length)];
    //NSLog(@"%@", ID);
    
    
    NSRange preRange = [be rangeOfString:@"RSSI:"];
    NSInteger preIdx = preRange.location + preRange.length;
    
    NSRange postRange = [be rangeOfString:@", txPower:"];
    NSInteger postIdx = postRange.location;
    
    NSString *RSSI = [be substringWithRange:NSMakeRange(preIdx + 1, postIdx - preIdx - 1)];
    //NSLog(@"%@", RSSI);
    
    NSString *txPower = [be substringWithRange:NSMakeRange(postRange.location + postRange.length + 1, 1)];
    //NSLog(@"%@", txPower);
    
    if (idA != nil && xA != nil && yA != nil) {
        if ([ID isEqualToString:idA]) {
            //NSLog(@"%@", RSSI);
            NSNumber *temp = [NSNumber numberWithInt:[RSSI intValue]];
            [_dataA addObject:temp];
            txPowerA = txPower;
            
        } else if ([ID isEqualToString:idB]) {
            NSNumber *temp = [NSNumber numberWithInt:[RSSI intValue]];
            [_dataB addObject:temp];
            txPowerB = txPower;
            
        } else if ([ID isEqualToString:idC]) {
            NSNumber *temp = [NSNumber numberWithInt:[RSSI intValue]];
            [_dataC addObject:temp];
            txPowerC = txPower;
        }
    }
    

}

- (void)beaconScanner:(ESSBeaconScanner *)scanner didUpdateBeacon:(id)beaconInfo {
 
    
//    NSLog(@" UPDATE ");
    
  //NSLog(@"I Updated an Eddystone!: %@", beaconInfo);
    
//    
//    NSLog(@"xA is %@",xA);
//    NSLog(@"yA is %@",yA);
//    NSLog(@"xB is %@",xB);
//    NSLog(@"yB is %@",yB);
//    NSLog(@"xC is %@",xC);
//    NSLog(@"yC is %@",yC);
    
    NSString *be = [NSString stringWithFormat:@"%@", beaconInfo];;
    
    NSRange preID = [be rangeOfString:@"=<"];
    NSRange postID = [be rangeOfString:@">,"];
    
    NSString *ID = [be substringWithRange:NSMakeRange(preID.location + preID.length, postID.location - preID.location - preID.length)];
    //NSLog(@"%@", ID);
    
    NSRange preRange = [be rangeOfString:@"RSSI:"];
    NSInteger preIdx = preRange.location + preRange.length;
    
    NSRange postRange = [be rangeOfString:@", txPower:"];
    NSInteger postIdx = postRange.location;
    
    NSString *RSSI = [be substringWithRange:NSMakeRange(preIdx + 1, postIdx - preIdx - 1)];
    //NSLog(@"%@", RSSI);
    
    NSString *txPower = [be substringWithRange:NSMakeRange(postRange.location + postRange.length + 1, 1)];
    //NSLog(@"%@", txPower);
    
    
    if (idA != nil && xA != nil && yA != nil) {
        if ([ID isEqualToString:idA]) {
            //NSLog(@" RSSI: %@", RSSI);
            NSNumber *tempA = [NSNumber numberWithInt:[RSSI intValue]];
            //NSLog(@"temp : %@",tempA);
            [_dataA addObject:tempA];
            //NSLog(@"data a count");
            //NSLog(@"%lu", (unsigned long)[self.dataA count]);
            txPowerA = txPower;
            
        } else if ([ID isEqualToString:idB]) {
            NSNumber *tempB = [NSNumber numberWithInt:[RSSI intValue]];
            [_dataB addObject:tempB];
            //NSLog(@"%@",tempB);
            //NSLog(@"data b count");
            //NSLog(@"%lu", (unsigned long)[self.dataB count]);
            txPowerB = txPower;
            
        } else if ([ID isEqualToString:idC]) {
            NSNumber *tempC = [NSNumber numberWithInt:[RSSI intValue]];
            [_dataC addObject:tempC];
            //NSLog(@"%@",tempC);
            //NSLog(@"data c count");
            //NSLog(@"%lu", (unsigned long)[self.dataC count]);
            txPowerC = txPower;
        }
    }

    

        
        if (countA > 45) {
            
            countA = 0;
            countB = 0;
            countC = 0;
            
            NSSortDescriptor *lowTohigh = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:YES];
            NSLog(@"%lu", (unsigned long)_dataA.count);
            NSLog(@"%lu", (unsigned long)_dataB.count);
            NSLog(@"%lu", (unsigned long)_dataC.count);
            [_dataA sortUsingDescriptors:[NSArray arrayWithObject:lowTohigh]];
            [_dataB sortUsingDescriptors:[NSArray arrayWithObject:lowTohigh]];
            [_dataC sortUsingDescriptors:[NSArray arrayWithObject:lowTohigh]];
            unsigned long lengthA = _dataA.count;
            unsigned long lengthB = _dataB.count;
            unsigned long lengthC = _dataC.count;

            
            NSString *sA = [[_dataA objectAtIndex:lengthA / 2] stringValue];
            NSString *sB = [[_dataB objectAtIndex:lengthB / 2] stringValue];
            NSString *sC = [[_dataC objectAtIndex:lengthC / 2] stringValue];
            
//            rssiA = 0;
//            rssiB = 0;
//            rssiC = 0;
            NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
            NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
            
            NSURL * url = [NSURL URLWithString:@"http://ec2-52-87-235-234.compute-1.amazonaws.com:8080/navigation"];
            NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
            
            
            
            NSString * params = [NSString stringWithFormat:@"rssiA=%@&txPowerA=%@&rssiB=%@&txPowerB=%@&rssiC=%@&txPowerC=%@",sA,txPowerA,sB,txPowerB,sC,txPowerC];
            NSLog(@"%@", params);
            [urlRequest setHTTPMethod:@"POST"];
            [urlRequest setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
            
            NSURLSessionDataTask * dataTask =[defaultSession dataTaskWithRequest:urlRequest
                                                               completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                                   //NSLog(@"Response:%@ %@\n", response, error);
                                                                   NSDictionary *jsonObject=[NSJSONSerialization
                                                                                             JSONObjectWithData:data
                                                                                             options:NSJSONReadingMutableLeaves
                                                                                             error:nil];
                                                                   //NSLog(@"jsonObject is %@",jsonObject);
                                                                   x = jsonObject[@"x"];
                                                                   y = jsonObject[@"y"];
                                                                   NSLog(@"x is %@", x);
                                                                   NSLog(@"y is %@", y);
                                                                   if(error == nil)
                                                                   {
                                                                       NSString * text = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
                                                                       //NSLog(@"Data = %@",text);
                                                                   }
                                                                   
                                                               }];
            [dataTask resume];
            
        } else if ([ID isEqualToString:idA]) {
            countA++;
        } else if ([ID isEqualToString:idB]) {
            countA++;
        } else if ([ID isEqualToString:idC]) {
            countA++;
        }


    
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
//    
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
//                                                        } else {
//                                                            NSLog(@"sdcasvas");
//                                                        }
//                                                        
//                                                    }];
//    
//    [dataTask resume];
    
}


- (void)beaconScanner:(ESSBeaconScanner *)scanner didFindURL:(NSURL *)url {
  //NSLog(@"I Saw a URL!: %@", url);
}

@end

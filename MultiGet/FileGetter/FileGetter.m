//
//  FileGetter.cpp
//  MultiGet
//
//  Created by Clive on 12/03/2018.
//  Copyright © 2018 World Class Apps Limited. All rights reserved.
//

#include "FileGetter.h"

static FileGetter *singleton;

@implementation FileGetter

+ (FileGetter *)sharedInstance
{
    if (singleton == nil)
    {
        singleton = [[FileGetter alloc] init];
    }
    return singleton;
}

- (id)init
{
    self = [super init];
    return self;
}

-(void)testGet1MB
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://73361de1.bwtest-aws.pravala.com/384MB.jar"]];
    [request setValue:@"bytes=0-1024"   forHTTPHeaderField:@"Range"];
    
     NSURLSessionDataTask *dataTask =  [[NSURLSession sharedSession] dataTaskWithRequest:request
               completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
     {
         if (error) {
            NSLog(@"Download Error:%@",error.description);
         }
         if (data) {
             NSLog(@"Downloaded %@",data);
         }
     }];
    
    [dataTask resume];
}



@end

//
//  ChunkGetter.m
//  MultiGet
//
//  Created by Clive on 13/03/2018.
//  Copyright © 2018 World Class Apps Limited. All rights reserved.
//

#include "ChunkGetter.h"
NSData* storedData;

-(void)initWithRange:(NSString*)range fromURL:(NSURL*)url usingChunkNumber:(NSInteger)chunkNumber replyingTo:(ChunkCompletionHandler)completionHandler
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setValue:range   forHTTPHeaderField:@"Range"];
    
    NSURLSessionDataTask *dataTask =  [[NSURLSession sharedSession] dataTaskWithRequest:request
                                                                      completionHandler:^(NSData *data,
                                                                                          NSURLResponse *response,
                                                                                          NSError *error)
                                        {
                                            if (error) {
                                                NSLog(@"Download Error:%@",error.description);
                                               if(completionHandler)
                                                   completionHandler(false, chunkNumber);
                                            }
                                            if (data) {
                                                NSLog(@"Downloaded %@",data);
                                               if(completionHandler)
                                                   completionHandler(true, chunkNumber);
                                            }
                                        }];
    
    [dataTask resume];
}

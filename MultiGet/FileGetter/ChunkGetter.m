//
//  ChunkGetter.m
//  MultiGet
//
//  Created by Clive on 13/03/2018.
//  Copyright © 2018 World Class Apps Limited. All rights reserved.
//

#include "ChunkGetter.h"

@implementation ChunkGetter
NSData* _storedData;
NSURL* _url;
NSInteger _chunkNumber;
NSString* _range; //NOTE: range needs to be in format "bytes=0-1023"

-(id)initWithRange:(NSString*)range fromURL:(NSURL*)url usingChunkNumber:(NSInteger)chunkNumber
{
    self = [super init];
    
    //Store information for getting chunk
    _url = url;
    _chunkNumber = chunkNumber;
    _range = range;
    
    return self;
}

-(void) requestChunk:(ChunkCompletionHandler)completionHandler
{
    //Set the storedData to nil, to ensure no old data is stored
    //TODO Remove storedData file aswell.
    _storedData = nil;
    
    //SETUP Request
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:_url];
    [request setValue:_range   forHTTPHeaderField:@"Range"];
    
    //Send Request using the NSURL Session
    NSURLSessionDataTask *dataTask =  [[NSURLSession sharedSession] dataTaskWithRequest:request
                                                                      completionHandler:^(NSData *data,
                                                                                          NSURLResponse *response,
                                                                                          NSError *error)
                                       {
                                           //Check if there is an error and report back.
                                           if (error)
                                           {
                                               //TODO - If Error, Pass Response/Error Message back to User Interface for display to user.
                                               NSLog(@"Download Error:%@",error.description);
                                               if(completionHandler) // do nothing if the CompletionHandler is not alive
                                               {
                                                   completionHandler(false, _chunkNumber);
                                               }
                                           }
                                           else if (data)
                                           {
                                               NSLog(@"Downloaded %@",data);
                                               if(completionHandler) // do nothing if the CompletionHandler is not alive
                                               {
                                                   _storedData = data;
                                                   completionHandler(true, _chunkNumber);
                                               }
                                           }
                                       }];
    
    [dataTask resume];
}

-(NSData*) getData
{
    //if the stored data is in memory return it.
    if(_storedData)
        return _storedData;
    
    //TODO if not in memory, open temp data file and return data from file
    //Return nil if file does not exist or no data exists.
    return nil;
}

@end

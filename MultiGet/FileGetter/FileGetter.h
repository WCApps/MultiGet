//
//  FileGetter.h
//  MultiGet
//
//  Created by Clive on 12/03/2018.
//  Copyright © 2018 World Class Apps Limited. All rights reserved.
//
// OBJECT PURPOSE - Handles main functions for splitting chunks to be collected as well as concatenating them
// NOTE: I Created this as a Singleton to keep alive with the information, but have realised that this could
// be dangerous as other functions could ask a for a file to be downloaded. This should later not be a singleton.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^FileGetterCompletionHandler)(BOOL success);

@interface FileGetter : NSObject 

+ (FileGetter *) sharedInstance;

-(void)requestFileFromUrl:(NSURL*)url withNoOfChunks:(NSInteger)noOfChunks sizeOfChunk:(NSInteger)chunkSize replyTo:(FileGetterCompletionHandler)completionHandler;
-(NSData*) getCombinedData;
-(NSURL*) getDatafileURL;

@end

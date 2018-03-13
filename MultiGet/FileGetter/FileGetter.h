//
//  FileGetter.h
//  MultiGet
//
//  Created by Clive on 12/03/2018.
//  Copyright © 2018 World Class Apps Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^FileGetterCompletionHandler)(BOOL success);

@interface FileGetter : NSObject 

+ (FileGetter *) sharedInstance;

-(void)requestFileFromUrl:(NSURL*)url withNoOfChunks:(NSInteger)noOfChunks sizeOfChunk:(NSInteger)chunkSize replyTo:(FileGetterCompletionHandler)completionHandler;
-(NSData*) getCombinedData;
-(NSURL*) getDatafileURL;

@end

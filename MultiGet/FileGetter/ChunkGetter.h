//
//  ChunkGetter.hpp
//  MultiGet
//
//  Created by Clive on 13/03/2018.
//  Copyright © 2018 World Class Apps Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^ChunkCompletionHandler)(BOOL success, NSInteger chunkNumber);

@interface ChunkGetter : NSObject

//NOTE: range needs to be in format "bytes=0-1023"
-(id)initWithRange:(NSString*)range fromURL:(NSURL*)url usingChunkNumber:(NSInteger)chunkNumber;
-(void) requestChunk:(ChunkCompletionHandler)completionHandler;
-(NSData*) getData;

@end

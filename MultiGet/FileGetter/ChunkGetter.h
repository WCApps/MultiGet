//
//  ChunkGetter.hpp
//  MultiGet
//
//  Created by Clive on 13/03/2018.
//  Copyright © 2018 World Class Apps Limited. All rights reserved.
//
// OBJECT PURPOSE - Handles download of a chunk. Keeps information stored incase re-request is needed.
// FUTURE - if there are memory issues, this object can handle saving / retreiving chunks from a file. (Not written yet)

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//NOTE: chunkNumber currently not used, but maybe used in future if different algorithm for combining chunks is used.
typedef void (^ChunkCompletionHandler)(BOOL success, NSInteger chunkNumber);

@interface ChunkGetter : NSObject

//NOTE: range needs to be in format "bytes=0-1023"
-(id)initWithRange:(NSString*)range fromURL:(NSURL*)url usingChunkNumber:(NSInteger)chunkNumber;
-(void) requestChunk:(ChunkCompletionHandler)completionHandler;
-(NSData*) getData;

@end

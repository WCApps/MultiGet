//
//  CommonGetter.h
//  MultiGet
//
//  Created by Clive on 13/03/2018.
//  Copyright © 2018 World Class Apps Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonGetter : NSObject {}

+ (NSString*) getRangeStringFrom:(NSInteger)byteStartNumber with:(NSInteger)byteEndNumber;

//TODO - put FILE Funcitons in on Common Object.
+ (NSURL*) getFullDirectory:(NSString*) newDirectoryName;
+ (BOOL) removeFileAt:(NSURL*) fullFileURL;

@end

//
//  CommonGetter.m
//  MultiGet
//
//  Created by Clive on 13/03/2018.
//  Copyright © 2018 World Class Apps Limited. All rights reserved.
//

#include "CommonGetter.h"

@implementation CommonGetter

+ (NSString*) getRangeStringFrom:(NSInteger)byteStartNumber with:(NSInteger)byteEndNumber
{
    //Common way to set the range, so it can be only changed in one place.
    //NOTE: range needs to be in format "bytes=0-1023"
    return [NSString stringWithFormat:@"bytes=%ld-%ld",(long)byteStartNumber,(long)byteEndNumber];
}

+(NSURL*) getFullDirectory:(NSString*) newDirectoryName
{
    NSURL*    dirPath = nil;
    
        NSString* bundleID = [[NSBundle mainBundle] bundleIdentifier];
        NSFileManager*fm = [NSFileManager defaultManager];
        
        // Find the application support directory in the home directory.
        NSArray* appSupportDir = [fm URLsForDirectory:NSApplicationSupportDirectory
                                            inDomains:NSUserDomainMask];
        if ([appSupportDir count] > 0)
        {
            // Append the bundle ID to the URL for the
            // Application Support directory
            dirPath = [[appSupportDir objectAtIndex:0] URLByAppendingPathComponent:bundleID];
            
            //add the new directory name to the path
            dirPath = [dirPath URLByAppendingPathComponent:newDirectoryName];
            
            // If the directory does not exist, this method creates it.
            NSError*    theError = nil;
            if (![fm createDirectoryAtURL:dirPath withIntermediateDirectories:YES
                               attributes:nil error:&theError])
            {
                // Handle the error.
                return nil;
            }
        }
    return dirPath;
}

+ (BOOL) removeFileAt:(NSURL*) fullFileURL
{
    NSFileManager*fm = [NSFileManager defaultManager];
    
    //TODO - check if file is not removed and take action
    return [fm removeItemAtURL:fullFileURL error:nil];
}

@end

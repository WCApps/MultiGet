//
//  FileGetter.h
//  MultiGet
//
//  Created by Clive on 12/03/2018.
//  Copyright © 2018 World Class Apps Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FileGetter : NSObject 

+ (FileGetter *) sharedInstance;

-(void)testGet1MB;

@end

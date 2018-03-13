//
//  FileGetter.m
//  MultiGet
//
//  Created by Clive on 12/03/2018.
//  Copyright © 2018 World Class Apps Limited. All rights reserved.
//

#include "FileGetter.h"
#include "ChunkGetter.h"
#include "CommonGetter.h"

//TODO - Set/Get Directory for datafile, currently set as
static NSString* _defaultDirectoryName = @"NewFileDir";
static NSString* _defaultDataFileName= @"Data.dat";

static FileGetter *singleton;

@implementation FileGetter
{
    NSMutableData* _storedDataFile;
    NSMutableArray* _chunkGetterArray;
    NSUInteger _noOfChunksCompleted;
    NSURL* _fullDataFileURL;
}


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
    
    //TODO Check directory is created and handle if needed.
    //TODO Workout what the directory names should be.
    NSURL* fileStorageDirectory = [CommonGetter getFullDirectory:_defaultDirectoryName];
    _fullDataFileURL = [fileStorageDirectory URLByAppendingPathComponent:_defaultDataFileName];
    return self;
}

-(void)requestFileFromUrl:(NSURL*)url withNoOfChunks:(NSInteger)noOfChunks sizeOfChunk:(NSInteger)chunkSize replyTo:(FileGetterCompletionHandler)completionHandler
{
    [self setupFileGetterForNewRequest];
    
    for(int i=0;i < noOfChunks;i++)
    {
        //set range string calculated from the number and size of chunks
        NSString* rangeString = [CommonGetter getRangeStringFrom:(chunkSize * i) with:((chunkSize * i)+chunkSize-1)];
        
        //create the chunkGetter
        ChunkGetter* chunkGetter = [[ChunkGetter alloc] initWithRange:rangeString fromURL:url usingChunkNumber:i];
        
        //Store chunkGetter
        [_chunkGetterArray addObject:chunkGetter];
        
        //Set the request in motion
        [chunkGetter requestChunk:^(BOOL success, NSInteger chunkNumber) {
                 if(success)
                 {
                    _noOfChunksCompleted++;
                    if(_noOfChunksCompleted == noOfChunks)
                     {
                        //then build the file and send succes to CompletionHandler
                        [self buildDataFileFromChunks];
         
                        // Add combined daat to a file
                        [_storedDataFile writeToFile:[_fullDataFileURL path] atomically:YES];
         
                         if(completionHandler) //check completionHandler is still alive
                             completionHandler(true); //SUCCESS
                     }
                 }
                 else
                 {
                    //TODO - re-request the Chunk - but need some what to measure how many times this is requested
                    //and what to do when there is an issue.
                    // CURRENT decision is to return failure if a chunk fails.
                    if(completionHandler) //check completionHandler is still alive
                        completionHandler(false); //FAILURE - report back a problem.
                 }
         }];
    }
}

-(void) setupFileGetterForNewRequest
{
    //setup for new file request
    //reset needed variables and arrays.
    //delete any existing file.
    
    [CommonGetter removeFileAt:_fullDataFileURL];
    _noOfChunksCompleted = 0;
    _storedDataFile = nil;

    if(!_chunkGetterArray)
    {
        //initialise array
        _chunkGetterArray = [[NSMutableArray alloc] init];
    }
    else
    {
        //remove all objects
        [_chunkGetterArray removeAllObjects];
    }
}

-(void) buildDataFileFromChunks
{
    for(int i=0;i < [_chunkGetterArray count]; i++)
    {
        ChunkGetter* currentChunk = [_chunkGetterArray objectAtIndex:i]; // get the ChunkGetter from array
        NSData* dataToCombine = [currentChunk getData]; //Get the data that chunk getter is holding
        
        if(dataToCombine)
        {
            if(i == 0)
                _storedDataFile= [ dataToCombine mutableCopy];
            else
                //if there is data, then combine it
                [_storedDataFile appendData:dataToCombine];
        }
        else
        {
            //if there is no data, something has gone wrong.
            //Make datafile nil and stop looping
            _storedDataFile = nil;
            break;
        }
    }
}

-(NSData*) getCombinedData
{
    return _storedDataFile;
}
        
-(NSURL*) getDatafileURL
{
    return _fullDataFileURL;
}



@end

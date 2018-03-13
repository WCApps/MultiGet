//
//  ViewController.m
//  MultiGet
//
//  Created by Clive on 12/03/2018.
//  Copyright © 2018 World Class Apps Limited. All rights reserved.
//

#import "ViewController.h"
#import "FileGetter.h"

//TODO Add Default Values Somewhere
//Or get from server
static NSString* _defaultFileURL = @"http://73361de1.bwtest-aws.pravala.com/384MB.jar";
static NSString* _defaultFileChunks = @"4";
static NSString* _defaultFileSize = @"1000000";

@interface ViewController ()
//Text inputs for file get.
@property (weak, nonatomic) IBOutlet UITextField *url_TF;
@property (weak, nonatomic) IBOutlet UITextField *noOfChunks_TF;
@property (weak, nonatomic) IBOutlet UITextField *sizeOfChunks_TF;
@property (weak, nonatomic) IBOutlet UIButton *getFileButton; //for enabling/disabling when downloading

//Action when "Get File" Button pressed
- (IBAction)GetFile:(UIButton *)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //Setup Interface with Defaults.
    _url_TF.text = _defaultFileURL;
    _noOfChunks_TF.text = _defaultFileChunks;
    
    // Chunks size currently in Bytes - This so that if fractions of MiB is selected,
    // then do not have to check that any bites are missed when doing division.
    _sizeOfChunks_TF.text = _defaultFileSize;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //TODO Add Tap Event, to close keyboard.
    //Needed for closing number keyboard on Non-iPads.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)GetFile:(UIButton *)sender {
    
    //TODO - Check input, Values are integers and within range, as well as check URL exists.
    //Currently no check made.
    
    [self lockInterfaceForDownload]; // So download button cannot be pressed twice
    
    //Set request with information added in the TextFields
    [[FileGetter sharedInstance] requestFileFromUrl:[NSURL URLWithString:_url_TF.text] withNoOfChunks:[_noOfChunks_TF.text integerValue] sizeOfChunk:[_sizeOfChunks_TF.text integerValue] replyTo:^(BOOL success)
     {
         //Check success of download
         if (success)
         {
             //Debug output the data and quick way to find the file
             NSLog(@"CONCATENATED DATA:\n%@",[[FileGetter sharedInstance] getCombinedData]);
             NSLog(@"FILE URL:\n%@",[[[FileGetter sharedInstance] getDatafileURL] path]);
             
             //interface changes to be completed on main thread
             [self performSelectorOnMainThread:@selector(downloadSuccess) withObject:nil waitUntilDone:YES];
         }
         else
         {
            //Show Error to user
            //interface changes to be completed on main thread
            [self performSelectorOnMainThread:@selector(errorWithDownloadMessage) withObject:nil waitUntilDone:YES];
         }
     }];
}

#pragma Success/Error Handler

-(void)downloadSuccess
{
    //TODO - Get message strings from Localisation Strings
    NSString* successMessage = [NSString stringWithFormat:@"Please find file at:\n\n%@",
                                [[[FileGetter sharedInstance] getDatafileURL] path]];
    
    
    UIAlertController * view=   [UIAlertController
                                 alertControllerWithTitle:@"SUCCESS"
                                 message:successMessage
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleCancel
                         handler:^(UIAlertAction * action)
                         {
                             [self unlockInterface];
                         }];
    
    [view addAction:ok];
    
    [self presentViewController:view animated:YES completion:nil];
}

-(void)errorWithDownloadMessage
{
    //TODO - Get message strings from Localisation Strings
    UIAlertController * view=   [UIAlertController
                                 alertControllerWithTitle:@"Error"
                                 message:@"Something went wrong with download."
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleCancel
                         handler:^(UIAlertAction * action)
                         {
                             [self unlockInterface];
                         }];
    
    [view addAction:ok];
    
    [self presentViewController:view animated:YES completion:nil];
}

#pragma Modal Functions for (un)locking interface
-(void) lockInterfaceForDownload
{
    //TODO - Add ModalView and ActivityIndicator to lock interface in separate common file.
    //Currently Just disable button to stop double press
    _getFileButton.enabled = false;
}

-(void) unlockInterface
{
    //TODO - remove ModalView and ActivityIndicator. Enable button
    _getFileButton.enabled = true;
}

#pragma TextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    //To close the keyboard when pressing return.
    //TODO - does not work with number keyboard and needs Tap Gesture to close keyboard
    [textField resignFirstResponder];
    return YES;
}
@end

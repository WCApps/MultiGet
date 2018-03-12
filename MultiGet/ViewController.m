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
#define DEFAULT_FILE_URL @"http://73361de1.bwtest-aws.pravala.com/384MB.jar"
#define DEFAULT_FILE_CHUNKS @"4"
#define DEFAULT_BYTE_SIZE @"1024"

@interface ViewController ()
//Text inputs for file get.
@property (weak, nonatomic) IBOutlet UITextField *url_TF;
@property (weak, nonatomic) IBOutlet UITextField *noOfChunks_TF;
@property (weak, nonatomic) IBOutlet UITextField *sizeOfChunks_TF;


//Action when "Get File" Button pressed
- (IBAction)GetFile:(UIButton *)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //Setup Interface with Defaults.
    _url_TF.text = DEFAULT_FILE_URL;
    _noOfChunks_TF.text = DEFAULT_FILE_CHUNKS;
    _sizeOfChunks_TF.text = DEFAULT_BYTE_SIZE;
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
    [[FileGetter sharedInstance] testGet1MB];
}

#pragma TextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    //To close the keyboard when pressing return.
    [textField resignFirstResponder];
    return YES;
}
@end

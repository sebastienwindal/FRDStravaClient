//
//  UploadViewController.m
//  FRDStravaClientDemo
//
//  Created by Sebastien Windal on 6/9/14.
//  Copyright (c) 2014 Sebastien Windal. All rights reserved.
//

#import "UploadViewController.h"
#import "FRDStravaClient+Upload.h"

@interface UploadViewController ()

@property (nonatomic) BOOL isUploading;


@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *uploadButtons;

@property (weak, nonatomic) IBOutlet UITextView *statusTextView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@property (nonatomic) NSInteger uploadId;

@property (weak, nonatomic) IBOutlet UIButton *checkUploadButton;

@end

@implementation UploadViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.isUploading = NO;
    self.uploadId = NSNotFound;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)uploadTCXGZAction:(id)sender
{
    NSString *urlPath = [[NSBundle mainBundle] pathForResource:@"FitnessHistoryDetail" ofType:@"tcx.gz"];
    NSURL *url = [NSURL fileURLWithPath:urlPath];
    
    [self uploadURL:url dataType:kUploadDataTypeTCXGZ name:@"TCX GZ test"];
}


- (IBAction)uploadTCXAction:(id)sender
{
    NSString *urlPath = [[NSBundle mainBundle] pathForResource:@"FitnessHistoryDetail" ofType:@"tcx"];
    NSURL *url = [NSURL fileURLWithPath:urlPath];
    
    [self uploadURL:url dataType:kUploadDataTypeTCX name:@"TCX test"];
}

- (IBAction)uploadGPXAction:(id)sender
{
    NSString *urlPath = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"gpx"];
    NSURL *url = [NSURL fileURLWithPath:urlPath];
    
    [self uploadURL:url dataType:kUploadDataTypeGPX name:@"GPX test"];
}

- (IBAction)uploadGPXGZAction:(id)sender
{
    NSString *urlPath = [[NSBundle mainBundle] pathForResource:@"3gaps" ofType:@"gpx.gz"];
    NSURL *url = [NSURL fileURLWithPath:urlPath];
    
    [self uploadURL:url dataType:kUploadDataTypeGPXGZ name:@"GPX GZ test"];
}

-(void) uploadURL:(NSURL *)url dataType:(kUploadDataType)dataType name:(NSString *)name
{
    self.isUploading = YES;
    self.statusTextView.text = @"";
    self.uploadId = NSNotFound;
    [[FRDStravaClient sharedInstance] uploadActivity:url
                                                name:name
                                        activityType:kActivityTypeRide
                                            dataType:dataType
                                             private:NO
                                             success:^(StravaActivityUploadStatus *uploadStatus) {
                                                 self.isUploading = NO;
                                                 self.statusTextView.text = [uploadStatus debugDescription];
                                                 self.uploadId = uploadStatus.id;
                                             }
                                             failure:^(NSError *error) {
                                                 self.isUploading = NO;
                                                 UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Failed"
                                                                                              message:error.localizedDescription
                                                                                             delegate:nil
                                                                                    cancelButtonTitle:@"Ok"
                                                                                    otherButtonTitles: nil];
                                                 [av show];
                                             }];

}

- (IBAction)checkUploadAction:(id)sender
{
    self.isUploading = YES;
    [[FRDStravaClient sharedInstance] checkStatusOfUpload:self.uploadId
                                                  success:^(StravaActivityUploadStatus *uploadStatus) {
                                                      self.isUploading = NO;
                                                      self.statusTextView.text = [uploadStatus debugDescription];
                                                  }
                                                  failure:^(NSError *error) {
                                                      self.isUploading = NO;
                                                      UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Failed"
                                                                                                   message:error.localizedDescription
                                                                                                  delegate:nil
                                                                                         cancelButtonTitle:@"Ok"
                                                                                         otherButtonTitles: nil];
                                                      [av show];
                                                  }];
}

-(void) setIsUploading:(BOOL)isUploading
{
    _isUploading = isUploading;
    
    if (isUploading) {
        [self.spinner startAnimating];
    } else {
        [self.spinner stopAnimating];
    }
    
    [self.uploadButtons enumerateObjectsUsingBlock:^(UIButton * obj, NSUInteger idx, BOOL *stop) {
        obj.hidden = isUploading;
    }];
    self.statusTextView.hidden = isUploading;
}

-(void) setUploadId:(NSInteger)uploadId
{
    _uploadId = uploadId;
    
    self.checkUploadButton.hidden = uploadId == NSNotFound;
    
    [self.checkUploadButton setTitle:[NSString stringWithFormat:@"Check status for:%ld", (long)uploadId] forState:UIControlStateNormal];
}

@end

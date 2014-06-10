//
//  GearViewController.m
//  FRDStravaClientDemo
//
//  Created by Sebastien Windal on 5/17/14.
//  Copyright (c) 2014 Sebastien Windal. All rights reserved.
//

#import "GearViewController.h"
#import "FRDStravaClientImports.h"


@interface GearViewController ()

@property (weak, nonatomic) IBOutlet UITextView *rawTextView;

@end

@implementation GearViewController

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
    
    [[FRDStravaClient sharedInstance] fetchGearWithId:self.gearId
                                              success:^(StravaGear *gear) {
                                                  self.rawTextView.text = gear.description;
                                              }
                                              failure:^(NSError *error) {
                                                  self.rawTextView.text = error.localizedDescription;
                                              }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

//
//  ActivityPhotoCollectionViewController.m
//  FRDStravaClientDemo
//
//  Created by Sebastien Windal on 5/24/14.
//  Copyright (c) 2014 Sebastien Windal. All rights reserved.
//

#import "ActivityPhotoTableViewController.h"
#import "FRDStravaClient+Activity.h"
#import "StravaActivityPhoto.h"

@interface ActivityPhotoTableViewController ()

@property (nonatomic, strong) NSArray *photos;

@end

@implementation ActivityPhotoTableViewController

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
    
    [[FRDStravaClient sharedInstance] fetchPhotosForActivity:self.activityId
                                                     success:^(NSArray *photos) {
                                                         self.photos = photos;
                                                         [self.tableView reloadData];
                                                     }
                                                     failure:^(NSError *error) {
                                                         UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"ERROR"
                                                                                                      message:error.localizedDescription
                                                                                                     delegate:nil
                                                                                            cancelButtonTitle:@"Close"
                                                                                            otherButtonTitles: nil];
                                                         
                                                         [av show];
                                                     }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.photos count];
}


-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"photoCell"];
    
    StravaActivityPhoto *photo = self.photos[indexPath.row];
    
    cell.textLabel.text = photo.caption;
    cell.detailTextLabel.text = photo.ref;
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    StravaActivityPhoto *photo = self.photos[indexPath.row];
    NSURL *url = [NSURL URLWithString:photo.ref];
    
    [[UIApplication sharedApplication] openURL:url];
}

@end

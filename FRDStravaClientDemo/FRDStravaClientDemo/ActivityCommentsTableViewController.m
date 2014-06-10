//
//  ActivityCommentsTableViewController.m
//  FRDStravaClientDemo
//
//  Created by Sebastien Windal on 5/28/14.
//  Copyright (c) 2014 Sebastien Windal. All rights reserved.
//

#import "ActivityCommentsTableViewController.h"
#import "FRDStravaClientImports.h"


@interface ActivityCommentsTableViewController ()

@property (nonatomic, strong) NSArray *comments;

@property (nonatomic) NSInteger pageIndex;


@end

@implementation ActivityCommentsTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.pageIndex = 1;
    self.comments = @[];
    [self fetchNextPage];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void) fetchNextPage
{
    [self showSpinner];
    
    [[FRDStravaClient sharedInstance] fetchCommentsForActivity:self.activityId
                                                      markdown:FALSE
                                                      pageSize:5
                                                     pageIndex:self.pageIndex
                                                       success:^(NSArray *comments) {
                                                           self.pageIndex ++;
                                                           [self showMoreButton];
                                                           self.comments = [self.comments arrayByAddingObjectsFromArray:comments];
                                                           [self.tableView reloadData];
                                                           
                                                       }
                                                       failure:^(NSError *error) {
                                                           [self showMoreButton];
                                                           UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"FAILED"
                                                                                                        message:error.localizedDescription
                                                                                                       delegate:nil
                                                                                              cancelButtonTitle:@"Close"
                                                                                              otherButtonTitles:nil];
                                                           [av show];
                                                       }];
 
}

-(void) showMoreButton
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"more"
                                                                              style:UIBarButtonItemStyleBordered
                                                                             target:self
                                                                             action:@selector(fetchNextPage)];
}

-(void) showSpinner
{
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    [activityIndicator startAnimating];
    UIBarButtonItem *activityItem = [[UIBarButtonItem alloc] initWithCustomView:activityIndicator];
    self.navigationItem.rightBarButtonItem = activityItem;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.comments count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"commentCell" forIndexPath:indexPath];
    
    StravaActivityComment *comment = self.comments[indexPath.row];
    
    cell.textLabel.text = comment.text;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@", comment.athlete.firstName, comment.athlete.lastName];
    
    return cell;
}

@end

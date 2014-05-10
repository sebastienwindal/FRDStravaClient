//
//  AuthViewController.h
//  FRDStravaClient
//
//  Created by Sebastien Windal on 4/18/14.
//  Copyright (c) 2014 Sebastien Windal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AuthViewController : UIViewController

-(void) exchangeToken:(NSString *)code;
-(void) showAuthFailedWithError:(NSString *)error;


@end

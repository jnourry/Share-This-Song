//
//  sharethissongAppDelegate.h
//  Share This Song
//
//  Created by Jocelyn Nourry on 30/10/11.
//  Copyright (c) 2011 Personal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBConnect.h"               // Facebook
#import "Reachability.h"


@interface sharethissongAppDelegate : UIResponder <UIApplicationDelegate, 
                                                    FBSessionDelegate,
                                                    FBRequestDelegate>
    {
    Facebook *facebook;    // Facebook
    }

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) Facebook *facebook;  // Facebook

- (void) launchFacebook;
- (BOOL)connected ;


@end



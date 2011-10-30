//
//  sharethissongMainViewController.h
//  Share This Song
//
//  Created by Jocelyn Nourry on 30/10/11.
//  Copyright (c) 2011 Personal. All rights reserved.
//

#import "sharethissongFlipsideViewController.h"

@interface sharethissongMainViewController : UIViewController <sharethissongFlipsideViewControllerDelegate, UIPopoverControllerDelegate>

@property (strong, nonatomic) UIPopoverController *flipsidePopoverController;

@end

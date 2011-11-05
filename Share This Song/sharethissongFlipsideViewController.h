//
//  sharethissongFlipsideViewController.h
//  Share This Song
//
//  Created by Jocelyn Nourry on 30/10/11.
//  Copyright (c) 2011 Personal. All rights reserved.
//

#import <UIKit/UIKit.h>

@class sharethissongFlipsideViewController;

@protocol sharethissongFlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(sharethissongFlipsideViewController *)controller;
@end

@interface sharethissongFlipsideViewController : UIViewController
{
    IBOutlet UILabel *monLabel;
}

@property (weak, nonatomic) IBOutlet id <sharethissongFlipsideViewControllerDelegate> delegate;

- (IBAction)done:(id)sender;
@property (nonatomic, retain) UILabel *monLabel;


@end

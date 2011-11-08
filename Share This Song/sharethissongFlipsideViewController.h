//
//  sharethissongFlipsideViewController.h
//  Share This Song
//
//  Created by Jocelyn Nourry on 30/10/11.
//  Copyright (c) 2011 Personal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


@class sharethissongFlipsideViewController;

@protocol sharethissongFlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(sharethissongFlipsideViewController *)controller;
@end

@interface sharethissongFlipsideViewController : UIViewController
{
    IBOutlet UILabel *monLabel;
    IBOutlet UILabel *instructionsLabel;
    IBOutlet UITextView *monTextView;

}

@property (weak, nonatomic) IBOutlet id <sharethissongFlipsideViewControllerDelegate> delegate;

- (IBAction)done:(id)sender;
@property (nonatomic, retain) UILabel *monLabel;
@property (nonatomic, retain) UILabel *instructionsLabel;
@property (nonatomic, retain) UITextView *monTextView;


@end

//
//  sharethissongFlipsideViewController.m
//  Share This Song
//
//  Created by Jocelyn Nourry on 30/10/11.
//  Copyright (c) 2011 Personal. All rights reserved.
//

#import "sharethissongFlipsideViewController.h"

@implementation sharethissongFlipsideViewController

@synthesize delegate = delegate;
@synthesize monLabel;

- (void)awakeFromNib
{
    self.contentSizeForViewInPopover = CGSizeMake(320.0, 480.0);
    [super awakeFromNib];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.backBarButtonItem.title = NSLocalizedString(@"Done", @"");
    self.navigationItem.title = NSLocalizedString(@"Infos", @"");    // ne marche pas :(
    
    monLabel.text = NSLocalizedString(@"Made by J. NOURRY", @"");

	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.title = NSLocalizedString(@"Infos", @"");    

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationItem.title = NSLocalizedString(@"Infos", @"");    

}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    /*if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }*/
    // Si c'est un iPhone : portrait, si c'est un iPad : paysage 
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        if (interfaceOrientation == UIDeviceOrientationPortrait)
            return YES;
        else
            return NO;
    }
    else
    {
        if (interfaceOrientation == UIDeviceOrientationPortrait)
            return NO;
        else
            return YES;
    }
}

#pragma mark - Actions

- (IBAction)done:(id)sender
{
    NSLog(@"done %@",sender);
    [self.delegate flipsideViewControllerDidFinish:self];
}

@end

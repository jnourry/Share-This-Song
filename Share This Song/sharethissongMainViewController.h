//
//  sharethissongMainViewController.h
//  Share This Song
//
//  Created by Jocelyn Nourry on 30/10/11.
//  Copyright (c) 2011 Personal. All rights reserved.
//

#import "sharethissongFlipsideViewController.h"
#import <MediaPlayer/MediaPlayer.h> // Access iPod
#import "ASIHTTPRequest.h"
#import "JSON.h"
#import <QuartzCore/QuartzCore.h>

#define kiPhoneWidth 320
#define kiPhoneHeight 480

#define kiPadWidth 768
#define kiPadHeight 1024


@class MainViewController;


@interface sharethissongMainViewController : UIViewController <sharethissongFlipsideViewControllerDelegate, 
                                                                UIPopoverControllerDelegate,
                                                                ASIHTTPRequestDelegate>
    {
    IBOutlet UIImageView *artworkImageView;
        
    IBOutlet UILabel *Songlabel;
    IBOutlet UILabel *Artistlabel;        
    IBOutlet UILabel *Albumlabel;
    IBOutlet UILabel *fbOnOfflabel;
    IBOutlet UILabel *progressionlabel;

        
    IBOutlet UIButton *shareButton;    
    IBOutlet UIButton *facebookButton;    

    MPMusicPlayerController *musicPlayer;
    
    NSString *artworkURL;
    NSString *iTunesSongURL;
        
    UILabel *tempLabel;
        
    NSTimer *timer;

    }

@property (strong, nonatomic) UIPopoverController *flipsidePopoverController;
@property (nonatomic, retain) MPMusicPlayerController *musicPlayer;

//UI elements
@property (nonatomic, retain) UILabel *Songlabel;
@property (nonatomic, retain) UILabel *Artistlabel;
@property (nonatomic, retain) UILabel *Albumlabel;
@property (nonatomic, retain) UILabel *fbOnOfflabel;
@property (nonatomic, retain) UILabel *progressionlabel;
@property (nonatomic, retain) UIImageView *artworkImageView;

@property (nonatomic, retain) UIButton *shareButton;
@property (nonatomic, retain) UIButton *facebookButton;



- (IBAction)sharingRequest:(id)sender;
- (IBAction)facebookAction:(id)sender;


- (void) registerMediaPlayerNotifications;
- (void) updateSongPlayed;
- (void) searchImages;
- (void) postToFacebook;
- (void) updateFacebookLogo;

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

@end

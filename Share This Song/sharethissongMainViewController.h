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

@interface sharethissongMainViewController : UIViewController <sharethissongFlipsideViewControllerDelegate, 
                                                                UIPopoverControllerDelegate,
                                                                ASIHTTPRequestDelegate>
    {
    IBOutlet UIImageView *artworkImageView;
        
    IBOutlet UILabel *Songlabel;
    IBOutlet UILabel *Artistlabel;        
    IBOutlet UILabel *Albumlabel;
        
    IBOutlet UIButton *shareButton;    
    MPMusicPlayerController *musicPlayer;
    
    NSString *artworkURL;
    NSString *iTunesSongURL;


    }

@property (strong, nonatomic) UIPopoverController *flipsidePopoverController;
@property (nonatomic, retain) MPMusicPlayerController *musicPlayer;

//UI elements
@property (nonatomic, retain) UILabel *Songlabel;
@property (nonatomic, retain) UILabel *Artistlabel;
@property (nonatomic, retain) UILabel *Albumlabel;
@property (nonatomic, retain) UIImageView *artworkImageView;


@property (nonatomic, retain) UIButton *shareButton;




- (IBAction)sharingRequest:(id)sender;

- (void) registerMediaPlayerNotifications;
- (void) updateSongPlayed;
- (void) searchImages;
- (void) postToFacebook;
- (void) afficherFacebookLogo;


@end

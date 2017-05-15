//
//  ViewController.h
//  MediaInfoTest
//
//  Created by DeGi on 2017. 4. 25..
//  Copyright © 2017년 DeGi. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property IBOutlet UITableView* tableSongs;

@property IBOutlet UIImageView* imgNowPlaying;
@property IBOutlet UILabel* lbNowPlaying;
@property IBOutlet UIVisualEffectView* viewNowPlaying;


@end


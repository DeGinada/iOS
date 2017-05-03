//
//  SongDetailViewController.h
//  MediaInfoTest
//
//  Created by DeGi on 2017. 4. 27..
//  Copyright © 2017년 DeGi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MPMediaQuery.h>

@interface SongDetailViewController : UIViewController {
    IBOutlet UIImageView* imgArtwork;
    IBOutlet UITextView* txArtist;
    IBOutlet UITextView* txTitle;
}

@property(nonatomic, retain) MPMediaItem* m_songDetail;

@end

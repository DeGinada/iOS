//
//  CustomTabBarViewController.h
//  MusicAppTest
//
//  Created by DeGi on 2017. 6. 9..
//  Copyright © 2017년 DeGi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface CustomTabBarViewController : UITabBarController

@property (nonatomic, readwrite) BOOL isHiddenPlayer;

- (void) setMiniPlayer;

- (void) closeBackground;
- (void) goAlbumDetail:(MPMediaItemCollection*)album;

@end

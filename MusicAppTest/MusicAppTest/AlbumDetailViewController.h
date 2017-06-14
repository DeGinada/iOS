//
//  AlbumDetailViewController.h
//  MusicAppTest
//
//  Created by DeGi on 2017. 6. 4..
//  Copyright © 2017년 DeGi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface AlbumDetailViewController : UIViewController 

@property (nonatomic, readwrite) MPMediaItemCollection* arAlbum;

- (void) adjustTableView;

@end

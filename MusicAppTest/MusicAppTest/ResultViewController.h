//
//  ResultViewController.h
//  MusicAppTest
//
//  Created by DeGi on 2017. 5. 19..
//  Copyright © 2017년 DeGi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface ResultViewController : UITableViewController

// [170525] 검색 결과를 담아둘 정보 array
//@property (nonatomic, readwrite) MPMediaItemCollection* arArtist;
//@property (nonatomic, readwrite) MPMediaItemCollection* arAlbum;
@property (nonatomic, readwrite) MPMediaQuery* arArtist;
@property (nonatomic, readwrite) MPMediaQuery* arAlbum;
@property (nonatomic, readwrite) NSArray* arSong;

- (void) adjustTableView;

@end

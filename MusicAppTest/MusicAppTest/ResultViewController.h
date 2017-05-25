//
//  ResultViewController.h
//  MusicAppTest
//
//  Created by Sora Yeo on 2017. 5. 19..
//  Copyright © 2017년 DeGi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResultViewController : UITableViewController

// [170525] 검색 결과를 담아둘 정보 array
@property (nonatomic, readwrite) NSArray* arArtist;
@property (nonatomic, readwrite) NSArray* arAlbum;
@property (nonatomic, readwrite) NSArray* arSong;

@end

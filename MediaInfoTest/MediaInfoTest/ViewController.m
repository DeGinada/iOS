//
//  ViewController.m
//  MediaInfoTest
//
//  Created by DeGi on 2017. 4. 25..
//  Copyright © 2017년 DeGi. All rights reserved.
//

#import "ViewController.h"
#import <MediaPlayer/MPMediaQuery.h>
#import <MediaPlayer/MPMediaPlaylist.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// [170425] 유저가 만든 플레이리스트 가져오기
- (void) getPlaylist {
    
    MPMediaQuery* myPlaylistQuery = [MPMediaQuery playlistsQuery];
    NSArray* arPlaylist = [myPlaylistQuery collections];
    for (MPMediaPlaylist* playlist in arPlaylist) {
        
        // 플레이리스트 이름.
        NSLog(@"%@", [playlist valueForProperty:MPMediaPlaylistPropertyName]);
        
        // 플레이리스트에 있는 음악을 가져온다
        NSArray* arSongs = [playlist items];
        for (MPMediaItem* song in arSongs) {
            
            // 노래 제목
            NSLog(@"\t\t%@", [song valueForProperty:MPMediaItemPropertyTitle]);
        }
    }
}


// [170425] 유저 디바이스에 있는 곡 목록 가져오기
- (void) getSongs {
    
    MPMediaQuery* mySongsQuery = [MPMediaQuery songsQuery];
    NSArray* arSongs = [mySongsQuery items];
    for (MPMediaItem* song in arSongs) {
        
        // 노래 제목
        NSLog(@"\t\t%@", [song valueForProperty:MPMediaItemPropertyTitle]);
    }
    
    NSLog(@"total - %ld songs", [arSongs count]);
    /*
    // enumerateObjectsUsingBlock 테스트
    [[mySongsQuery items] enumerateObjectsUsingBlock:^(MPMediaItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"\t\t%@", [obj valueForProperty:MPMediaItemPropertyTitle]);
    }]; */
    
}


// [170425] 아티스트 이름별로 그룹핑하기
- (void) groupSongsbyArtist {
    
    /*
    // 팟캐스트가 포함됨
    MPMediaQuery* mediaQuery = [[MPMediaQuery alloc] init];
    [mediaQuery setGroupingType:MPMediaGroupingArtist];
    NSArray* arArtist = [mediaQuery collections];
    for (MPMediaItemCollection* entity in arArtist) {
        
        NSLog(@"\t%@", [[[entity items] objectAtIndex:0] valueForProperty:MPMediaItemPropertyArtist]);
        
        NSArray* arSongs = [entity items];
        for (MPMediaItem* song in arSongs) {
            NSLog(@"\t\t%@", [song valueForProperty:MPMediaItemPropertyTitle]);
        }
    } */
    
    MPMediaQuery* artistQuery = [MPMediaQuery artistsQuery];
    NSArray* arArtist = [artistQuery collections];
    for (MPMediaItemCollection* entity in arArtist) {
        
        NSLog(@"\t%@", [[[entity items] objectAtIndex:0] valueForProperty:MPMediaItemPropertyArtist]);
        
        NSArray* arSongs = [entity items];
        for (MPMediaItem* song in arSongs) {
            NSLog(@"\t\t%@", [song valueForProperty:MPMediaItemPropertyTitle]);
        }
    }
    
}

@end

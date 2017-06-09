//
//  CustomTabBarViewController.m
//  MusicAppTest
//
//  Created by Sora Yeo on 2017. 6. 9..
//  Copyright © 2017년 DeGi. All rights reserved.
//

#import "CustomTabBarViewController.h"
#import <MediaPlayer/MediaPlayer.h>

@interface CustomTabBarViewController ()

@property (nonatomic, readwrite) UIView* viewPlayer;


@end

@implementation CustomTabBarViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    // 재생 관련 값 가져오기
    if ( ([[MPMusicPlayerController systemMusicPlayer] playbackState] == MPMusicPlaybackStatePlaying) ||
        ([[MPMusicPlayerController systemMusicPlayer] playbackState] == MPMusicPlaybackStatePaused) ){
        self.isHiddenPlayer = NO;
        
        [self setMiniPlayer];
    } else {
        self.isHiddenPlayer = YES;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



- (void) setMiniPlayer {
    

    self.viewPlayer = [[UIView alloc] initWithFrame:CGRectMake(0, self.tabBar.frame.origin.y-64, self.view.frame.size.width, 64)];
    [self.viewPlayer setBackgroundColor:[UIColor lightGrayColor]];
    [self.view addSubview:self.viewPlayer];
    [self.view bringSubviewToFront:self.viewPlayer];
    
}

@end

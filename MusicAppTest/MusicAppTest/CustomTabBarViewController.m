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



//- (UIVisualEffectView*) setMiniPlayer {
- (void) setMiniPlayer {

    

//    self.viewPlayer = [[UIView alloc] initWithFrame:CGRectMake(0, self.tabBar.frame.origin.y-0.3-64, self.view.frame.size.width, 64)];
//    [self.viewPlayer setBackgroundColor:[UIColor clearColor]];
//    [self.view addSubview:self.viewPlayer];
//    [self.view bringSubviewToFront:self.viewPlayer];
    
    
    // visual effect view 밑에서 밝기 조정할 뷰
    UIView* viewTemp = [[UIView alloc] initWithFrame:CGRectMake(0, self.tabBar.frame.origin.y-64, self.view.frame.size.width, 64)];
    [viewTemp setBackgroundColor:[UIColor lightGrayColor]];
    viewTemp.alpha = 0.4;
    [self.view addSubview:viewTemp];
//    [self.view bringSubviewToFront:viewTemp];
    
    UIVisualEffectView* viewEffect = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight]];
    viewEffect.frame = CGRectMake(0, self.tabBar.frame.origin.y-64, self.view.frame.size.width, 64);
    [self.view addSubview:viewEffect];
    [self.view bringSubviewToFront:viewEffect];

    CALayer* layerBottom = [CALayer layer];
    layerBottom.frame = CGRectMake(0, 64-0.3, viewEffect.frame.size.width, 0.3);
    layerBottom.backgroundColor = [UIColor lightGrayColor].CGColor;
    [viewEffect.layer addSublayer:layerBottom];

}

@end

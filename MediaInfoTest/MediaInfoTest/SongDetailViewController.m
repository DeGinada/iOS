//
//  SongDetailViewController.m
//  MediaInfoTest
//
//  Created by DeGi on 2017. 4. 27..
//  Copyright © 2017년 DeGi. All rights reserved.
//

#import "SongDetailViewController.h"
#import <MediaPlayer/MediaPlayer.h>


@interface SongDetailViewController ()

@end

@implementation SongDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"SongDetailViewController - viewDidLoad");
    
    [self showDetailInfo];
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


// [170427] 노래 검색하기
- (IBAction) searchSong:(id)sender {
    
    // [170428] UTF8로 인코딩 해서 주소를 넘겨줘야함.
    NSMutableString* searchUrl = [NSMutableString stringWithString:@"http://www.google.com/search?q="];
    [searchUrl appendString:txTitle.text];
    NSCharacterSet *allowedCharacterSet = [NSCharacterSet URLQueryAllowedCharacterSet];
    [self openScheme:[searchUrl stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacterSet]];
    
}

// [170427] 가수 검색하기
- (IBAction) searchArtist:(id)sender {
    
    // 잘못된 코드 -> 가수나 노래가 일어, 한국어인 경우 url 이상.
    //[self openScheme:[NSString stringWithFormat:@"http://www.google.com/search?q=%@", txArtist.text]];
    
    // [170428] UTF8로 인코딩 해서 주소를 넘겨줘야함.
    NSMutableString* searchUrl = [NSMutableString stringWithString:@"http://www.google.com/search?q="];
    [searchUrl appendString:txArtist.text];
    NSCharacterSet *allowedCharacterSet = [NSCharacterSet URLQueryAllowedCharacterSet];
    [self openScheme:[searchUrl stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacterSet]];
}


- (void) openScheme:(NSString *)scheme {
    UIApplication *application = [UIApplication sharedApplication];
    NSURL *URL = [NSURL URLWithString:scheme];
    NSDictionary *options = @{UIApplicationOpenURLOptionUniversalLinksOnly : @YES};
    
    if ([application respondsToSelector:@selector(openURL:options:completionHandler:)]) {
        [application openURL:URL options:@{}
           completionHandler:^(BOOL success) {
               NSLog(@"Open %@: %d",scheme,success);
           }];
    } else {
        BOOL success = [application openURL:URL];
        NSLog(@"Open %@: %d",scheme,success);
    }
}


// [170427] 이전 화면에서 넘겨받은 data를 보여준다.
- (void) showDetailInfo {
    
    // artwork 이미지 가져올때 사이즈는 artwork 크기로 가져와야 안 깨지는 것 같다. 이 이전엔 사이즈를 직접 지정하니 다 깨짐..
    MPMediaItemArtwork* artwork = [self.m_songDetail valueForProperty:MPMediaItemPropertyArtwork];
    UIImage* imgTemp = [artwork imageWithSize:artwork.bounds.size];
    [imgArtwork setContentMode:UIViewContentModeScaleToFill];
    [imgArtwork setImage:imgTemp];
    imgArtwork.layer.masksToBounds = YES;
    imgArtwork.layer.cornerRadius = 15.0;
    
    
    txArtist.text = [self.m_songDetail valueForProperty:MPMediaItemPropertyArtist];
    txTitle.text = [self.m_songDetail valueForProperty:MPMediaItemPropertyTitle];
    
    
    // [170429] 현재 플레이 중인 노래인 경우 text 컬러 넣기
    // 현재 플레이 중일 경우, MPMediaItem정보를 가져온다.(내부 음악 앱이기때문에 systemMusicPlayer, 아닌 경우는 applicationMusicPlayer)
    if ([[MPMusicPlayerController systemMusicPlayer] playbackState] == MPMusicPlaybackStatePlaying) {
        MPMusicPlayerController* mpController = [MPMusicPlayerController systemMusicPlayer];
        MPMediaItem* nowPlaying = mpController.nowPlayingItem;
        if ([nowPlaying isEqual:self.m_songDetail]) {
            [txArtist setTextColor:[UIColor purpleColor]];
            [txTitle setTextColor:[UIColor purpleColor]];
            [txArtist setFont:[UIFont boldSystemFontOfSize:15.0f]];
            [txTitle setFont:[UIFont boldSystemFontOfSize:15.0f]];
        }
    }
    
    
}



// [170429] 해당 음악 정보를 공유한다.
- (IBAction) shareSongInfo:(id)sender {
    
    UIImage* image = imgArtwork.image;
    NSString* string = @"";
    // 현재 재생 중이냐 아니냐에 따라 공유 메세지 나누기
    if ([[MPMusicPlayerController systemMusicPlayer] playbackState] == MPMusicPlaybackStatePlaying) {
        MPMusicPlayerController* mpController = [MPMusicPlayerController systemMusicPlayer];
        MPMediaItem* nowPlaying = mpController.nowPlayingItem;
        if ([nowPlaying isEqual:self.m_songDetail]) {
            string = [NSString stringWithFormat:@"%@ - %@\n#nowplaying #np", txArtist.text, txTitle.text];
        } else {
            string = [NSString stringWithFormat:@"%@ - %@", txArtist.text, txTitle.text];
        }
    } else {
        string = [NSString stringWithFormat:@"%@ - %@", txArtist.text, txTitle.text];
    }
    NSArray* activityItems;
    // 이미지가 없는 경우 에러 방지를 위해 스트링 값만 넘겨준다.
    if (image) {
        activityItems = @[image, string];
    } else {
        activityItems = @[string];
    }
    
    UIActivityViewController *activityViewControntroller = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    activityViewControntroller.excludedActivityTypes = @[];
    // 아이패드인 경우에 대한 예외처리
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        activityViewControntroller.popoverPresentationController.sourceView = self.view;
        activityViewControntroller.popoverPresentationController.sourceRect = CGRectMake(self.view.bounds.size.width/2, self.view.bounds.size.height/4, 0, 0);
    }
    [self presentViewController:activityViewControntroller animated:true completion:nil];
    
}


// [170429] 현재 보고 있는 노래 재생하기. 재생 중인 곡이면 처음부터 다시 재생
- (IBAction) playSong:(id)sender {
    
    MPMusicPlayerController* mpController = [MPMusicPlayerController systemMusicPlayer];
    MPMediaItem* nowPlaying = mpController.nowPlayingItem;
    if ([nowPlaying isEqual:self.m_songDetail]) {
        [mpController skipToBeginning];
    } else {
        [mpController setNowPlayingItem:self.m_songDetail];
    }
    
    [self showDetailInfo];
}

@end

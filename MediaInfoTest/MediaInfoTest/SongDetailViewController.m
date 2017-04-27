//
//  SongDetailViewController.m
//  MediaInfoTest
//
//  Created by Sora Yeo on 2017. 4. 27..
//  Copyright © 2017년 DeGi. All rights reserved.
//

#import "SongDetailViewController.h"


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
    
    [self openScheme:[NSString stringWithFormat:@"https://www.google.com/search?q=%@", txTitle.text]];
    
}

// [170427] 가수 검색하기
- (IBAction) searchArtist:(id)sender {
    [self openScheme:[NSString stringWithFormat:@"https://www.google.com/search?q=%@", txArtist.text]];
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
    
    txArtist.text = [self.m_songDetail valueForProperty:MPMediaItemPropertyArtist];
    txTitle.text = [self.m_songDetail valueForProperty:MPMediaItemPropertyTitle];
    
}


- (void) textFieldDidBeginEditing:(UITextField *)textField {
    
    [textField endEditing:YES];
}

@end

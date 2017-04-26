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
#import "SongTableViewCell.h"

@interface ViewController ()

@end

@implementation ViewController
{
    NSArray* m_arSongs;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    // 음악 정보 가져오기
    m_arSongs = [self getSongList];
    
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


// [170426] 셀 선택시 열리는 뷰에서 돌아오는 코드
- (IBAction) exitFromSecondViewController:(UIStoryboardSegue *)segue {
    
}


#pragma mark - DATA
// [170426] 디바이스에 있는 song 정보를 가져온다.
- (NSArray*) getSongList {
    
    MPMediaQuery* mediaQuery = [MPMediaQuery songsQuery];
    NSArray* arSongs = [mediaQuery items];
    
    return arSongs;
}


#pragma mark - TABLE_VIEW

// [170426] 셀에 곡 정보를 띄어줌 (이미지, 제목, 가수)
- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString* identifier = @"Cell";
    SongTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[SongTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    // cell 정보 띄어주기
    // 현재 cell 형태는 subtitle, title에 artist, subtitle에 song title, image에 아트웍 넣기
    [cell.textLabel setText:[[m_arSongs objectAtIndex:indexPath.row] valueForProperty:MPMediaItemPropertyArtist]];
    [cell.textLabel setFont:[UIFont systemFontOfSize:13]];
    [cell.detailTextLabel setText:[[m_arSongs objectAtIndex:indexPath.row] valueForProperty:MPMediaItemPropertyTitle]];
    [cell.detailTextLabel setFont:[UIFont systemFontOfSize:15]];
    cell.detailTextLabel.numberOfLines = 0;
    
    MPMediaItemArtwork* artwork = [[m_arSongs objectAtIndex:indexPath.row] valueForProperty:MPMediaItemPropertyArtwork];
    UIImage* imgArtwork = [artwork imageWithSize:cell.imageView.image.size];
//    if (nil == imgArtwork) {
//        CGSize size = ((MPMediaItemArtwork*)[[m_arSongs objectAtIndex:indexPath.row] valueForProperty:MPMediaItemPropertyArtwork]).bounds.size;
//        if ( 0 < size.width && 0 < size.height) {
//            imgArtwork = [artwork imageWithSize:size];
//        }
//    }
    [cell.imageView setImage:imgArtwork];
    
    // 이미지 사이즈 변경
    CGSize itemSize = CGSizeMake(tableView.rowHeight-2, tableView.rowHeight-2);
    UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
    CGRect imageRect = CGRectMake(1.0, 1.0, itemSize.width, itemSize.height);
    [cell.imageView.image drawInRect:imageRect];
    cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return cell;
}


// [170426] 리스트 수 지정
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
 
    return m_arSongs.count;
}




@end

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
#import "SongDetailViewController.h"

@interface ViewController ()

@end

@implementation ViewController
{
    NSArray* g_arSongs;
    MPMediaItem* g_selSong;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // 음악 정보 가져오기
    g_arSongs = [self getSongList];
    
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
// [170510] 아티스트별로 sorting된 노래를 리턴한다.
- (NSArray*) getGroupSongsbyArtist {
    
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
    
    NSMutableArray* arSongList = [[NSMutableArray alloc] init];
    for (MPMediaItemCollection* entity in arArtist) {
        
        NSLog(@"\t%@", [[[entity items] objectAtIndex:0] valueForProperty:MPMediaItemPropertyArtist]);
        
        NSArray* arSongs = [entity items];
        for (MPMediaItem* song in arSongs) {
            NSLog(@"\t\t%@", [song valueForProperty:MPMediaItemPropertyTitle]);
            [arSongList addObject:song];
        }
    }
    
    return arSongList;
    
}


// [170426] 셀 선택시 열리는 뷰에서 돌아오는 코드
- (IBAction) exitFromSecondViewController:(UIStoryboardSegue *)segue {
    
}


// [170427] 셀 선택으로 뷰이동 시, 데이터 넘기기
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([[segue identifier] isEqualToString:@"segShowDetail"]) {
        SongDetailViewController* vcSongDetail = [segue destinationViewController];
        vcSongDetail.m_songDetail = g_selSong;
    }
}


#pragma mark - DATA
// [170426] 디바이스에 있는 song 정보를 가져온다.
- (NSArray*) getSongList {
    
    // 단순하게 song list를 가져옴
//    MPMediaQuery* mediaQuery = [MPMediaQuery songsQuery];
//    NSArray* arSongs = [mediaQuery items];
    
    // [170510] 음악앱 보관함 노래 방식으로 sorting -> 아티스트별로 보여줌
    NSArray* arSongs = [self getGroupSongsbyArtist];
    
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
    
    
    /*
    // cell 정보 띄어주기 (cell subtitle 포맷)
    // 현재 cell 형태는 subtitle, title에 artist, subtitle에 song title, image에 아트웍 넣기
    [cell.textLabel setText:[[g_arSongs objectAtIndex:indexPath.row] valueForProperty:MPMediaItemPropertyArtist]];
    [cell.textLabel setFont:[UIFont systemFontOfSize:13]];
    [cell.detailTextLabel setText:[[g_arSongs objectAtIndex:indexPath.row] valueForProperty:MPMediaItemPropertyTitle]];
    [cell.detailTextLabel setFont:[UIFont systemFontOfSize:15]];
    cell.detailTextLabel.numberOfLines = 0;
    
    
    MPMediaItemArtwork* artwork = [[g_arSongs objectAtIndex:indexPath.row] valueForProperty:MPMediaItemPropertyArtwork];
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
    */
    
    
    // [170429] cell subtitle 형식으로 썼었던 걸 textview로 바꿔보기 -> 실패
    //[cell setTextViewText:[[g_arSongs objectAtIndex:indexPath.row] valueForProperty:MPMediaItemPropertyArtist] x:cell.imageView.bounds.origin.x*2+cell.imageView.bounds.size.width width:cell.frame.size.width-(cell.imageView.bounds.origin.x*3)-cell.imageView.bounds.size.width];
//    [cell.textView setBounds:cell.textLabel.bounds];
//    cell.textView.contentMode = cell.textLabel.contentMode;
//    [cell setTextViewText:[[g_arSongs objectAtIndex:indexPath.row] valueForProperty:MPMediaItemPropertyArtist] frame:cell.textLabel.frame];
    
    
    // [170430] cell custom 으로 변경
    // cell에 내용도 선택할 수 있게 하고 싶어 textview로 바꿨으나 user interaction 때문에 cell 선택에 문제가 생김.
    [cell.textView setText:[[g_arSongs objectAtIndex:indexPath.row] valueForProperty:MPMediaItemPropertyArtist]];
    [cell.detailTextView setText:[[g_arSongs objectAtIndex:indexPath.row] valueForProperty:MPMediaItemPropertyTitle]];

    
    MPMediaItemArtwork* artwork = [[g_arSongs objectAtIndex:indexPath.row] valueForProperty:MPMediaItemPropertyArtwork];
    UIImage* imgArtwork = [artwork imageWithSize:cell.imgView.image.size];
    if (imgArtwork) {
        [cell.imgView setImage:imgArtwork];
    }
    
    // [170430] 텍스트에 따라 textview 위치와 크기를 재설정한다.
    [cell adjustContentPosition];
    
    
    return cell;
}


// [170426] 리스트 수 지정
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
 
    return g_arSongs.count;
}


// [170427] tableviewcell will select 
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"willSelectRowAtIndexPath");
    
    // viewcontroller에 넘겨줄 데이터를 정의한다.
    g_selSong = [g_arSongs objectAtIndex:indexPath.row];
//    [self performSegueWithIdentifier:@"segShowDetail" sender:nil];
    
    return indexPath;
}

// [170427] tableviewcell did select (현재 상황에서 view 이동 후 호출)
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"didSelectRowAtIndexPath");
}





@end

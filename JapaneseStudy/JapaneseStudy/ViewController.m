//
//  ViewController.m
//  JapaneseStudy
//
//  Created by DeGi on 2017. 5. 1..
//  Copyright © 2017년 DeGi. All rights reserved.
//

#import "ViewController.h"

#import "MatchViewController.h"
#import "MeaningViewController.h"
#import "WordTableViewController.h"

@interface ViewController ()

@end

@implementation ViewController {
    NSMutableDictionary* g_dicWord;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self setWordDictionary];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// [170501] 메인으로 돌아오는 코드
- (IBAction) exitFromSecondViewController:(UIStoryboardSegue *)segue {
    
    
    NSLog(@"back from : %@", [segue.sourceViewController class]);
    
    // [170506] 바뀐 정보를 돌려준다 -> 이 부분 안되니까 확인 필요
    // [170507] 점수 시스템이 적용된 vc에서 돌아오는 경우, dictionary 다시 세팅
    if ([[segue.sourceViewController class] isSubclassOfClass:[MatchViewController class]] ||
        [[segue.sourceViewController class] isSubclassOfClass:[MeaningViewController class]]) {
        
        [self setWordDictionary];
    }
}


// [170506] 점수 시스템이 필요한 view에 점보 넘겨주기
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"segMatch"]) {
        MatchViewController* vcMatch = [segue destinationViewController];
        vcMatch.m_dicWord = [NSMutableDictionary dictionaryWithDictionary:g_dicWord];
    } else if ([[segue identifier] isEqualToString:@"segMeaning"]) {
        MeaningViewController* vcMeaning = [segue destinationViewController];
        vcMeaning.m_dicWord = [NSMutableDictionary dictionaryWithDictionary:g_dicWord];
    } else if ([[segue identifier] isEqualToString:@"segWordTable"]) {
        WordTableViewController* vcWordTable = [segue destinationViewController];
        vcWordTable.m_dicWord = [NSDictionary dictionaryWithDictionary:g_dicWord];
    }
}


// [170506] 점수 시스템을 위한 세팅 ( 0점 이하는 자주 틀리는 단어 표시, 10점 이상은 확실히 아는 단어 표시)
- (void) setWordDictionary {
    
    // 로컬에 저장된 단어 점수 목록 가져오기
    g_dicWord = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"WORD_POINT"]];
    
    NSURL *documentsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    documentsURL = [documentsURL URLByAppendingPathComponent:@"word.xml"];
    
    NSArray* arWords = [NSArray arrayWithContentsOfURL:documentsURL];
    
    if (!arWords) {
        arWords = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"word" ofType:@"xml"]];
    }
    
    // 로컬에 정보가 있을 경우
    if (g_dicWord) {
        
        // 현재 파일에 등록된 정보 수와 점수 목록 정보 수가 같지 않은 경우, 단어 추가
        if (arWords.count != g_dicWord.count) {
            
            NSUInteger nIndex = g_dicWord.count;
            
            while (nIndex < arWords.count) {
                [g_dicWord setObject:@"0" forKey:[[arWords objectAtIndex:nIndex] objectForKey:@"jp"]];
                
                nIndex++;
            }
            
            // 로컬에 저장해두기
            [[NSUserDefaults standardUserDefaults] setObject:g_dicWord forKey:@"WORD_POINT"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    } else {
        // 이 경우는 처음인 경우니까 모든 정보를 다 저장함. 초기 점수는 0
        for (NSDictionary* dic in arWords) {
            [g_dicWord setObject:@"0" forKey:[dic objectForKey:@"jp"]];
        }
        
        // 로컬에 저장해두기
        [[NSUserDefaults standardUserDefaults] setObject:g_dicWord forKey:@"WORD_POINT"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}


// [170508] word file을 다운로드해서 로컬에 저장
- (IBAction) downloadWordfile:(id)sender {
    
    [self placeGetRequest:@"action" withHandler:^(NSData *data, NSURLResponse *response, NSError *error) {

        NSURL *documentsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        documentsURL = [documentsURL URLByAppendingPathComponent:@"word.xml"];
        
        [data writeToURL:documentsURL atomically:YES];
        
        
        // [170508] word table에 보여줄 정보도 변경해야함. -> 추후에
        //[self setWordDictionary];
        
        // [170509] 기존 WORD_POINT 정보를 변경
        [self mergeWordPoint];
    }];

}


// [170508] 파일 다운로드
- (void)placeGetRequest:(NSString *)action withHandler:(void (^)(NSData *data, NSURLResponse *response, NSError *error))ourBlock {

    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://deginada.tistory.com/attachment/cfile25.uf@24442B3A5911CF1812FE55.xml"]];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:ourBlock] resume];
}


// [170509] 다운받은 word.xml 파일일 경우, 기존 WORD_POINT 변경
- (void) mergeWordPoint {
    
    // 기존 정보 가져오기
    NSMutableDictionary* dicOrigin = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"WORD_POINT"]];
    
    // 다운 받은 정보 가져오기
    NSURL *documentsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    documentsURL = [documentsURL URLByAppendingPathComponent:@"word.xml"];
    
    NSArray* arWords = [NSArray arrayWithContentsOfURL:documentsURL];
    NSInteger nCount = 0;
    
    for (NSDictionary* dic in arWords) {
        
        NSString* strKey = [dic objectForKey:@"jp"];
        
        if (!dicOrigin[strKey]) {
            nCount++;
            [dicOrigin setObject:@"0" forKey:strKey];
        }
    }
    
    NSLog(@"addded word - %ld", nCount);
    
    // 로컬에 저장해두기
    [[NSUserDefaults standardUserDefaults] setObject:dicOrigin forKey:@"WORD_POINT"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    // 혹시 모르니 dictionary 재세팅
    [self setWordDictionary];
    
}
@end

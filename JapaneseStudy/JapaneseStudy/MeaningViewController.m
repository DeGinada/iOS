//
//  MeaningViewController.m
//  JapaneseStudy
//
//  Created by DeGi on 2017. 5. 4..
//  Copyright © 2017년 DeGi. All rights reserved.
//

#import "MeaningViewController.h"

@interface MeaningViewController ()

@end

@implementation MeaningViewController {
    NSArray* g_arWords;
    NSInteger g_nWordIndex;
    NSInteger g_nCorrectCount;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // [170507] 정답 관련 이미지 숨기기
    [self.imgO setHidden:YES];
    [self.imgX setHidden:YES];
    
    g_nWordIndex = 0;
    g_nCorrectCount = 0;
    [self setWordArray];
    [self showMatchWord];
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


// [170504] word.plist에서 단어를 가져와 g_arWords에 세팅한다.
- (void) setWordArray {
    
    // word.plist가져오기
    NSURL *documentsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    documentsURL = [documentsURL URLByAppendingPathComponent:@"word.xml"];
    
    g_arWords = [NSArray arrayWithContentsOfURL:documentsURL];
    
    if (!g_arWords) {
        g_arWords = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"word" ofType:@"xml"]];
    }
    
}

// [170504] 문제 화면을 보여준다
- (void) showMatchWord {
    
    g_nWordIndex = arc4random() % g_arWords.count;
    
    // 문제인 단어 뜻 보여주기
    [self.lbMeaning setText:[[g_arWords objectAtIndex:g_nWordIndex] objectForKey:@"jp"]];
    
    
    // answer에 값 세팅하기
    NSArray* arAnswer = [self suffleAnswer:[[g_arWords objectAtIndex:g_nWordIndex] objectForKey:@"kr"]];
    
    [self.btnAnswer1 setTitle:[arAnswer objectAtIndex:0] forState:UIControlStateNormal];
    [self.btnAnswer1 setTitleColor:self.btnAnswer1.backgroundColor forState:UIControlStateHighlighted];
    [self.btnAnswer2 setTitle:[arAnswer objectAtIndex:1] forState:UIControlStateNormal];
    [self.btnAnswer2 setTitleColor:self.btnAnswer2.backgroundColor forState:UIControlStateHighlighted];
    [self.btnAnswer3 setTitle:[arAnswer objectAtIndex:2] forState:UIControlStateNormal];
    [self.btnAnswer3 setTitleColor:self.btnAnswer3.backgroundColor forState:UIControlStateHighlighted];
    [self.btnAnswer4 setTitle:[arAnswer objectAtIndex:3] forState:UIControlStateNormal];
    [self.btnAnswer4 setTitleColor:self.btnAnswer4.backgroundColor forState:UIControlStateHighlighted];
}

// [170504] 답을 섞어서 준다.
- (NSArray*) suffleAnswer:(NSString*)answer {
    
    NSMutableArray* arAnswer = [[NSMutableArray alloc] initWithObjects:@"", @"", @"", @"", nil];
    
    NSInteger count = 0;
    NSInteger numAnswer = arc4random() % 4;
    [arAnswer replaceObjectAtIndex:numAnswer withObject:answer];
    
    while (count < 4) {
        
        if (count != numAnswer) {
            
            NSInteger index = arc4random() % g_arWords.count;
            NSString* strWord = [[g_arWords objectAtIndex:index] objectForKey:@"kr"];
            BOOL isExist = false;
            
            for (NSString* str in arAnswer) {
                if ([strWord isEqualToString:str]) {
                    isExist = true;
                }
            }
            
            if (!isExist) {
                [arAnswer replaceObjectAtIndex:count withObject:strWord];
                count++;
            }
        } else {
            count++;
        }
    }
    
    return arAnswer;
}


// [170504] 누른 답이 맞는 지 확인한다.
- (IBAction) checkToCorrectAnswer:(id)sender {
    
    UIButton* btnSel = (UIButton*)sender;
    NSString* strSelAnswer = [btnSel titleForState:UIControlStateNormal];
    
    NSString* strAnswer = [[g_arWords objectAtIndex:g_nWordIndex] objectForKey:@"jp"];
    
    if ([strSelAnswer isEqualToString:[[g_arWords objectAtIndex:g_nWordIndex] objectForKey:@"kr"]]) {
        
        // 정답일 경우, count label 값을 늘려준다.
        g_nCorrectCount++;
        
        // [170506] 점수 시스템
        NSInteger nPoint = [[self.m_dicWord objectForKey:strAnswer] integerValue];
        nPoint = nPoint + 2;
        [self.m_dicWord setObject:[NSString stringWithFormat:@"%ld", nPoint] forKey:strAnswer];
        
        
        // [170506] 혹시 모르니 로컬에 저장
        [[NSUserDefaults standardUserDefaults] setObject:self.m_dicWord forKey:@"WORD_POINT"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        // [170507] 맞았다는 이미지 보여주기
        [self.imgO setHidden:NO];
    } else {
        
        // [170506] 점수 시스템
        NSInteger nPoint = [[self.m_dicWord objectForKey:strAnswer] integerValue];
        nPoint = nPoint - 2;
        [self.m_dicWord setObject:[NSString stringWithFormat:@"%ld", nPoint] forKey:strAnswer];
        
        
        // [170506] 혹시 모르니 로컬에 저장
        [[NSUserDefaults standardUserDefaults] setObject:self.m_dicWord forKey:@"WORD_POINT"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        // [170507] 틀렸다는 이미지 보여주기
        [self.imgX setHidden:NO];

    }
    
    // [170507] 정답 화면에 딜레이 주기(정답 잠깐 보여준 후 문제 세팅) 500ms -> 0.5s
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 500 * NSEC_PER_MSEC), dispatch_get_main_queue(), ^{
        [self.imgO setHidden:YES];
        [self.imgX setHidden:YES];
        
        [self.lbCount setText:[NSString stringWithFormat:@"정답 : %ld", g_nCorrectCount]];
        
        [self showMatchWord];
    });
    
    
}

@end

//
//  MatchViewController.m
//  JapaneseStudy
//
//  Created by DeGi on 2017. 5. 2..
//  Copyright © 2017년 DeGi. All rights reserved.
//

#import "MatchViewController.h"

@interface MatchViewController ()

@end

@implementation MatchViewController {
    NSArray* g_arWords;
    NSInteger g_nCount;
    NSInteger g_nCorrectCount;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    g_nCount = 0;
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


// [170502] word.plist에서 단어를 가져와 g_arWords에 세팅한다.
- (void) setWordArray {
    
    // word.plist가져오기
    g_arWords = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"word" ofType:@"plist"]];
    
}

// [170502] 문제 화면을 보여준다
- (void) showMatchWord {
    
    // 문제인 단어 뜻 보여주기
    [self.lbMeaning setText:[[g_arWords objectAtIndex:g_nCount] objectForKey:@"kr"]];
    
    
    // answer에 값 세팅하기
    NSArray* arAnswer = [self suffleAnswer:[[g_arWords objectAtIndex:g_nCount] objectForKey:@"jp"]];
    
    [self.btnAnswer1 setTitle:[arAnswer objectAtIndex:0] forState:UIControlStateNormal];
    [self.btnAnswer1 setTitleColor:self.btnAnswer1.backgroundColor forState:UIControlStateHighlighted];
    [self.btnAnswer2 setTitle:[arAnswer objectAtIndex:1] forState:UIControlStateNormal];
    [self.btnAnswer2 setTitleColor:self.btnAnswer2.backgroundColor forState:UIControlStateHighlighted];
    [self.btnAnswer3 setTitle:[arAnswer objectAtIndex:2] forState:UIControlStateNormal];
    [self.btnAnswer3 setTitleColor:self.btnAnswer3.backgroundColor forState:UIControlStateHighlighted];
    [self.btnAnswer4 setTitle:[arAnswer objectAtIndex:3] forState:UIControlStateNormal];
    [self.btnAnswer4 setTitleColor:self.btnAnswer4.backgroundColor forState:UIControlStateHighlighted];
    
}


// [170502] 답을 섞어서 준다.
- (NSArray*) suffleAnswer:(NSString*)answer {
    
    NSMutableArray* arAnswer = [[NSMutableArray alloc] initWithObjects:@"", @"", @"", @"", nil];
    
    NSInteger count = 0;
    NSInteger numAnswer = arc4random() % 4;
    [arAnswer replaceObjectAtIndex:numAnswer withObject:answer];
    
    while (count < 4) {
        
        if (count != numAnswer) {
            
            NSInteger index = arc4random() % g_arWords.count;
            NSString* strWord = [[g_arWords objectAtIndex:index] objectForKey:@"jp"];
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


// [170502] 누른 답이 맞는 지 확인한다. (tag 1001-1, 1002-2, 1003-3, 1004-4)
- (IBAction) checkToCorrectAnswer:(id)sender {
    
    UIButton* btnSel = (UIButton*)sender;
    NSString* strSelAnswer = [btnSel titleForState:UIControlStateNormal];
    
    if ([strSelAnswer isEqualToString:[[g_arWords objectAtIndex:g_nCount] objectForKey:@"jp"]]) {
        
        // 정답일 경우, count label 값을 늘려준다.
        g_nCorrectCount++;
        [self.lbCount setText:[NSString stringWithFormat:@"정답 : %ld", g_nCorrectCount]];
    }
    

    if (g_nCount < (g_arWords.count-1)) {
        g_nCount++;
        [self showMatchWord];
    } else {
        [self.btnAnswer1 setEnabled:NO];
        [self.btnAnswer2 setEnabled:NO];
        [self.btnAnswer3 setEnabled:NO];
        [self.btnAnswer4 setEnabled:NO];
    }
    
}


@end

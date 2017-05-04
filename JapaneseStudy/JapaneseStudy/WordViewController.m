//
//  WordViewController.m
//  JapaneseStudy
//
//  Created by DeGi on 2017. 5. 1..
//  Copyright © 2017년 DeGi. All rights reserved.
//

#import "WordViewController.h"

@interface WordViewController ()

@end

@implementation WordViewController {
    NSArray* g_arWords;
//    NSInteger g_nCount;
    NSInteger g_nWordIndex;
    NSInteger g_nAnswerCount;
    
    NSMutableString* g_strAnswer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    g_strAnswer = [[NSMutableString alloc] init];
    [self setWordArray];
    
    [self showWord];
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


// [170501] word.plist에서 단어를 가져와 g_arWords에 세팅한다.
- (void) setWordArray {
    
    // word.plist가져오기
    g_arWords = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"word" ofType:@"plist"]];

}

// [170501] 단어를 가져와 화면에 보여준다
- (void) showWord {
    
    g_nWordIndex = arc4random() % g_arWords.count;
    
    // 단어의 뜻 보여주기
    [self.lbMeaning setText:[[g_arWords objectAtIndex:g_nWordIndex] objectForKey:@"kr"]];
    
    // viewAnswer에 답 공간 만들기
    const CGFloat answerWidth = 40;
    const CGFloat answerSpace = 3;
    NSInteger nCountJP = [[[g_arWords objectAtIndex:g_nWordIndex] objectForKey:@"jp"] length];
    CGFloat answerX = (self.viewAnswer.frame.size.width-((nCountJP*answerWidth)+((nCountJP-1)*answerSpace)))/2;
    
    for (int i = 0; i < nCountJP; i++) {
        
        UILabel* lbTemp = [[UILabel alloc] initWithFrame:CGRectMake(answerX+(i*(answerWidth+answerSpace)), 30, answerWidth, answerWidth)];
        [lbTemp setBackgroundColor:[UIColor lightGrayColor]];
        [lbTemp setFont:[UIFont boldSystemFontOfSize:25.0f]];
        [lbTemp setTextColor:[UIColor blackColor]];
        [lbTemp setTextAlignment:NSTextAlignmentCenter];
        [lbTemp setText:@""];
        [lbTemp setTag:i+1];
        [self.viewAnswer addSubview:lbTemp];
//        [g_arAnswer arrayByAddingObject:lbTemp];
    }
    
    g_nAnswerCount = 0;
    [g_strAnswer setString:@""];
    
    NSString* strQuiz = [self suffleCharcter:[[g_arWords objectAtIndex:g_nWordIndex] objectForKey:@"jp"]];
    
    // viewCharacter에 답용 버튼 만들기
    const CGFloat characterWidth = 60;
    const CGFloat characterSpace = 10;
    
    for (int i = 0; i < nCountJP; i++) {
        UIButton* btnTemp = [[UIButton alloc] initWithFrame:CGRectMake((((i>4) ? (i-4) : i)*(characterWidth+characterSpace)), ((i>4) ? 80 : 0), characterWidth, characterWidth)];
        [btnTemp setTitle:[strQuiz substringWithRange:NSMakeRange(i, 1)] forState:UIControlStateNormal];
        [btnTemp setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnTemp setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
        [btnTemp.titleLabel setFont:[UIFont boldSystemFontOfSize:32.0]];
        [btnTemp setBackgroundColor:[UIColor blueColor]];
        [btnTemp addTarget:self action:@selector(processCharacter:) forControlEvents:UIControlEventTouchUpInside];
        btnTemp.layer.cornerRadius = 6.0;
        [self.viewCharacter addSubview:btnTemp];
    }
    
    
    
}


// [170501] 버튼으로 띄우기 위해 글자를 섞어서 넘겨준다
- (NSString*) suffleCharcter:(NSString*)word {
    
    NSMutableString *str1 = [[NSMutableString alloc]initWithString:word];
    NSMutableString *str2 = [[NSMutableString alloc] init];
    while ([str1 length] > 0) {
        int i = arc4random() % [str1 length];
        NSRange range = NSMakeRange(i,1);
        NSString *sub = [str1 substringWithRange:range];
        [str2 appendString:sub];
        [str1 replaceOccurrencesOfString:sub withString:@"" options:NSCaseInsensitiveSearch range:range];
    }
    
    return str2;
}


// [170501] 글자 버튼이 눌릴 경우, 처리된다.
- (void) processCharacter:(UIButton*)button {
    [((UILabel*)[self.viewAnswer viewWithTag:g_nAnswerCount+1]) setText:[button titleForState:UIControlStateNormal]];
    
    if (g_nAnswerCount < [[[g_arWords objectAtIndex:g_nWordIndex] objectForKey:@"jp"] length]) {
        g_nAnswerCount++;
        [g_strAnswer appendString:[button titleForState:UIControlStateNormal]];
        
        if ([g_strAnswer isEqualToString:[[g_arWords objectAtIndex:g_nWordIndex] objectForKey:@"jp"]]) {
            NSLog(@"정답입니다");
            
            // 정답일 경우, 모든 항목 clear하고 다음 문제로!
//            g_nCount++;
//            
//            if (g_nCount >= [g_arWords count]) {
//                NSLog(@"끝");
//            } else {
//                [self.viewAnswer.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
//                [self.viewCharacter.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
//                
//                [self showWord];
//            }
            // 랜덤 방식으로 변경
            [self.viewAnswer.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [self.viewCharacter.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            
            [self showWord];
        
        } else {
            NSLog(@"오답입니다 %@", g_strAnswer);
        }
    }
}


// [170501] back 버튼 처리 (글자 지우기)
- (IBAction) clearCharacter:(id)sender {
    
    if (g_nAnswerCount > 0) {
        [((UILabel*)[self.viewAnswer viewWithTag:g_nAnswerCount]) setText:@""];
        
        g_nAnswerCount--;
        [g_strAnswer deleteCharactersInRange:NSMakeRange([g_strAnswer length]-1, 1)];
    }
}


@end

//
//  CharacterViewController.m
//  JapaneseStudy
//
//  Created by DeGi on 2017. 5. 3..
//  Copyright © 2017년 DeGi. All rights reserved.
//

#import "CharacterViewController.h"

@interface CharacterViewController ()

@end

@implementation CharacterViewController {
    NSArray* g_arCharacters;
    NSInteger g_nNowIndex;
    NSInteger g_nCorrectCount;
    BOOL g_isHiragana;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    g_nCorrectCount = 0;
    // 라운드 넣기
//    self.lbKatakana.layer.cornerRadius = 20;
    self.btnAnswer1.layer.cornerRadius = 6;
    self.btnAnswer2.layer.cornerRadius = 6;
    self.btnAnswer3.layer.cornerRadius = 6;
    self.btnAnswer4.layer.cornerRadius = 6;
    
    [self setCharacterArray];
    [self showCharacter];
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


// [170503] character.plist에서 단어를 가져와 g_arCharacters에 세팅한다.
- (void) setCharacterArray {
    
    // word.plist가져오기
    g_arCharacters = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"character" ofType:@"plist"]];
    
}


// [170503] 가타카나 문제 화면을 보여준다
- (void) showCharacter {
    
    g_nNowIndex = arc4random() % g_arCharacters.count;
    
    // 문제가 될 가타카나를 보여준다
    [self.lbKatakana setText:[[g_arCharacters objectAtIndex:g_nNowIndex] objectForKey:@"ka"]];
    
    // 보기 세팅하기
    if ((arc4random() % 2) == 0) {
        g_isHiragana = YES;
    } else {
        g_isHiragana = NO;
    }
    NSArray* arAnswer = [self suffleAnswer];
    
    [self.btnAnswer1 setTitle:[arAnswer objectAtIndex:0] forState:UIControlStateNormal];
    [self.btnAnswer1 setTitleColor:self.btnAnswer1.backgroundColor forState:UIControlStateHighlighted];
    [self.btnAnswer2 setTitle:[arAnswer objectAtIndex:1] forState:UIControlStateNormal];
    [self.btnAnswer2 setTitleColor:self.btnAnswer2.backgroundColor forState:UIControlStateHighlighted];
    [self.btnAnswer3 setTitle:[arAnswer objectAtIndex:2] forState:UIControlStateNormal];
    [self.btnAnswer3 setTitleColor:self.btnAnswer3.backgroundColor forState:UIControlStateHighlighted];
    [self.btnAnswer4 setTitle:[arAnswer objectAtIndex:3] forState:UIControlStateNormal];
    [self.btnAnswer4 setTitleColor:self.btnAnswer4.backgroundColor forState:UIControlStateHighlighted];
    
}


// [170503] 답을 섞어서 준다. g_isHiragana가 YES이면 보기는 히라가나, NO이면 발음기호
- (NSArray*) suffleAnswer {
    
    NSMutableArray* arAnswer = [[NSMutableArray alloc] initWithObjects:@"", @"", @"", @"", nil];
    
    NSInteger count = 0;
    NSInteger numAnswer = arc4random() % 4;
    if (g_isHiragana) {
        [arAnswer replaceObjectAtIndex:numAnswer withObject:[[g_arCharacters objectAtIndex:g_nNowIndex] objectForKey:@"hi"]];
    } else {
        [arAnswer replaceObjectAtIndex:numAnswer withObject:[[g_arCharacters objectAtIndex:g_nNowIndex] objectForKey:@"en"]];
    }
    
    
    while (count < 4) {
        
        if (count != numAnswer) {
            
            NSInteger index = arc4random() % g_arCharacters.count;
            NSString* strWord = @"";
            if (g_isHiragana) {
                strWord = [[g_arCharacters objectAtIndex:index] objectForKey:@"hi"];
            } else {
                strWord = [[g_arCharacters objectAtIndex:index] objectForKey:@"en"];
            }
            
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


// [170503] 누른 답이 맞는 지 확인한다.
- (IBAction) checkToCorrectAnswer:(id)sender {
    
    
    UIButton* btnSel = (UIButton*)sender;
    NSString* strSelAnswer = [btnSel titleForState:UIControlStateNormal];
    
    NSString* strCorrectAnswer = @"";
    if (g_isHiragana) {
        strCorrectAnswer = [[g_arCharacters objectAtIndex:g_nNowIndex] objectForKey:@"hi"];
    } else {
        strCorrectAnswer = [[g_arCharacters objectAtIndex:g_nNowIndex] objectForKey:@"en"];
    }
    
    if ([strSelAnswer isEqualToString:strCorrectAnswer]) {
        // 정답일 겨우
        g_nCorrectCount++;
        [self.lbCount setText:[NSString stringWithFormat:@"정답 : %ld", g_nCorrectCount]];
    }
    
//    g_nNowIndex = arc4random() % g_arCharacters.count;
    [self showCharacter];
}


@end

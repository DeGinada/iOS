//
//  GameViewController.m
//  SeoulKoreanQuiz
//
//  Created by DeGi on 2017. 6. 23..
//  Copyright © 2017년 DeGi. All rights reserved.
//

#import "GameViewController.h"

#define API_URL         @"http://openAPI.seoul.go.kr:8088/sample/xml/KoreanAnswerInfo/1/5/"

#define BTN_NORMAL      [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:0.9]
#define BTN_CORRECT     [UIColor colorWithRed:0.0/255.0 green:64.0/255.0 blue:128.0/255.0 alpha:0.9]
#define BTN_INCORRECT   [UIColor colorWithRed:128.0/255.0 green:0.0/255.0 blue:64.0/255.0 alpha:0.9]

@interface GameViewController ()

@property (nonatomic, readwrite) NSInteger nQuizYear;
@property (nonatomic, readwrite) NSInteger nQuizMonth;
@property (nonatomic, readwrite) NSInteger nQuizDay;

@property IBOutlet UILabel* lbQuizDate;
@property IBOutlet UILabel* lbQuiz;
@property IBOutlet UIButton* btnAnswer1;
@property IBOutlet UIButton* btnAnswer2;
@property IBOutlet UIButton* btnAnswer3;
@property IBOutlet UIButton* btnAnswer4;
@property IBOutlet UIView* viewLine;
@property IBOutlet UILabel* lbNotice;

@end

@implementation GameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.btnAnswer1.layer.cornerRadius = 8;
    self.btnAnswer2.layer.cornerRadius = 8;
    self.btnAnswer3.layer.cornerRadius = 8;
    self.btnAnswer4.layer.cornerRadius = 8;
    
    
    // 최근에 푼 문제 날짜 정보 가져오기
    NSString* strCurrent = [[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentDateKey"];
    if (strCurrent.length == 0) {
        self.nQuizYear = 2012;
        self.nQuizMonth = 6;
        self.nQuizDay = 25;
        
        strCurrent = [NSString stringWithFormat:@"%ld%02ld%02ld", self.nQuizYear, self.nQuizMonth, self.nQuizDay];
        [[NSUserDefaults standardUserDefaults] setObject:strCurrent forKey:@"CurrentDateKey"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        self.nQuizYear = [[strCurrent substringWithRange:NSMakeRange(0, 4)] integerValue];
        self.nQuizMonth = [[strCurrent substringWithRange:NSMakeRange(4, 2)] integerValue];
        self.nQuizDay = [[strCurrent substringWithRange:NSMakeRange(6, 2)] integerValue];
    }
    
    
    // 퀴즈 정보 가져오기
    [self getQuizInfomation];
    
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


- (void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setHidden:NO];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setTintColor:[UIColor darkGrayColor]];
    
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init]
                                      forBarPosition:UIBarPositionAny
                                          barMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
}


- (void) viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    // 차이가 뭘까? viewWillAppear에서 바꾸면 안바뀌는데 여기서는 정상적으로 바뀜
    [self.navigationController.navigationBar.backItem setTitle:@"Main"];
}



#pragma mark - QUIZ


- (void) getQuizInfomation {
    
    
    NSString* strCurrent = [NSString stringWithFormat:@"%ld%02ld%02ld", self.nQuizYear, self.nQuizMonth, self.nQuizDay];
    
    // 정보 가져오는 동안 공지만 오픈, 나머진 숨김
    [self.lbQuizDate setHidden:YES];
    [self.lbQuiz setHidden:YES];
    [self.btnAnswer1 setHidden:YES];
    [self.btnAnswer2 setHidden:YES];
    [self.btnAnswer3 setHidden:YES];
    [self.btnAnswer4 setHidden:YES];
    [self.viewLine setHidden:YES];
    [self.lbNotice setHidden:NO];
    
    // 퀴즈 정보 가져오기
    [self placeGetRequest:strCurrent WithHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        
        NSXMLParser* parser = [[NSXMLParser alloc] initWithData:data];
        parser.delegate = self;
        if ([parser parse])  {
            NSLog(@"%@", dicQuizInfo);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([[dicQuizInfo objectForKey:@"Result"] isEqualToString:@"INFO-000"]) {
                    
                    // 정보 제대로 가져오면 공지 숨기고, 나머지는 다 오픈
                    [self.lbQuizDate setHidden:NO];
                    [self.lbQuiz setHidden:NO];
                    [self.btnAnswer1 setHidden:NO];
                    [self.btnAnswer2 setHidden:NO];
                    [self.btnAnswer3 setHidden:NO];
                    [self.btnAnswer4 setHidden:NO];
                    [self.viewLine setHidden:NO];
                    [self.lbNotice setHidden:YES];
                    
                    [self.lbQuizDate setText:[NSString stringWithFormat:@"%ld.%02ld.%02ld\tQ.%@", self.nQuizYear, self.nQuizMonth, self.nQuizDay, [dicQuizInfo objectForKey:@"QuizNum"]]];
                    [self.lbQuiz setText:[dicQuizInfo objectForKey:@"Quiz"]];
                    [self.btnAnswer1 setTitle:[[[dicQuizInfo objectForKey:@"Answers"] objectAtIndex:0] objectForKey:@"Answer"] forState:UIControlStateNormal];
                    [self.btnAnswer2 setTitle:[[[dicQuizInfo objectForKey:@"Answers"] objectAtIndex:1] objectForKey:@"Answer"] forState:UIControlStateNormal];
                    [self.btnAnswer3 setTitle:[[[dicQuizInfo objectForKey:@"Answers"] objectAtIndex:2] objectForKey:@"Answer"] forState:UIControlStateNormal];
                    [self.btnAnswer4 setTitle:[[[dicQuizInfo objectForKey:@"Answers"] objectAtIndex:3] objectForKey:@"Answer"] forState:UIControlStateNormal];
                } else if ([[dicQuizInfo objectForKey:@"Result"] isEqualToString:@"INFO-200"]) {
                    
                    // 문제가 없는 경우는 문제값 바꿔서 재요청
                    // 문제 번호가 되는 날짜 바꾸기
                    [self countQuizDate];
                    [self getQuizInfomation];
                    
                    
                } else {
                    
                    // 그 외에 에러의 경우 공지 보여주고, 메인 화면
                    [self.lbNotice setText:[NSString stringWithFormat:@"Error\t%@\n메인으로 돌아가주세요.", [dicQuizInfo objectForKey:@"Result"]]];
                }
            });
            
        }
        
    }];
}


- (IBAction) checkAnswer:(id)sender {
    
    
    UIButton* btnSelected = sender;
    
    if (btnSelected.tag == [[dicQuizInfo objectForKey:@"Correct"] intValue]) {
        // 정답이면 선택한 버튼 색 파랗게
        [btnSelected setBackgroundColor:BTN_CORRECT];
        [btnSelected setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    } else {
        // 틀리면 선택한 버튼 색 빨갛게
        [btnSelected setBackgroundColor:BTN_INCORRECT];
        [btnSelected setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }
    
    
    [NSTimer scheduledTimerWithTimeInterval:1.0f repeats:NO block:^(NSTimer * _Nonnull timer) {
        [btnSelected setBackgroundColor:BTN_NORMAL];
        [btnSelected setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        
        
        [self countQuizDate];
        [self getQuizInfomation];
    }];
    
}


- (void) countQuizDate {
    
    self.nQuizDay++;
    
    if (self.nQuizMonth == 2) {
        if (self.nQuizYear%4 == 0) {
            if (self.nQuizDay > 29) {
                self.nQuizDay = 1;
                self.nQuizMonth++;
            }
        } else {
            if (self.nQuizDay > 28) {
                self.nQuizDay = 1;
                self.nQuizMonth++;
            }
        }
    } else if (self.nQuizMonth == 4 || self.nQuizMonth == 6 || self.nQuizMonth == 9 || self.nQuizMonth == 11) {
        if (self.nQuizDay > 30) {
            self.nQuizDay = 1;
            self.nQuizMonth++;
        }
    } else if (self.nQuizMonth == 12) {
        if (self.nQuizDay > 31) {
            self.nQuizDay = 1;
            self.nQuizMonth = 1;
            self.nQuizYear++;
        }
    } else {
        if (self.nQuizDay > 31) {
            self.nQuizDay = 1;
            self.nQuizMonth++;
        }
    }
    
    // 바뀐 날짜 정보는 저장하기
    NSString* strCurrent = [NSString stringWithFormat:@"%ld%02ld%02ld", self.nQuizYear, self.nQuizMonth, self.nQuizDay];
    [[NSUserDefaults standardUserDefaults] setObject:strCurrent forKey:@"CurrentDateKey"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}


#pragma mark - REQUEST

- (void) placeGetRequest:(NSString*)quizeNum WithHandler:(void (^) (NSData* data, NSURLResponse* response, NSError* error))ourBlock {
    
    NSString* strUrl = [NSString stringWithFormat:@"%@%@", API_URL, quizeNum];
    
    NSURL* url = [NSURL URLWithString:strUrl];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:ourBlock] resume];
}



#pragma mark - XML_PARSER

- (void) parserDidStartDocument:(NSXMLParser *)parser {
    
    // 해석중인 태그 초기화
    nowTagStr = [NSString stringWithFormat:@""];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict {
    
    if ([elementName isEqualToString:@"KoreanAnswerInfo"]) {
        arQuiz = [[NSMutableArray alloc] init];
    } else if ([elementName isEqualToString:@"CODE"]) {
        nowTagStr = [NSString stringWithString:elementName];
        dicQuizInfo = [[NSMutableDictionary alloc] init];
    } else if ([elementName isEqualToString:@"row"]) {
        nowTagStr = [NSString stringWithString:elementName];
        dicRowData = [[NSMutableDictionary alloc] init];
    } else if ([elementName isEqualToString:@"Q_NAME"]) {
        nowTagStr = [NSString stringWithString:elementName];
    } else if ([elementName isEqualToString:@"Q_SEQ"]) {
        nowTagStr = [NSString stringWithString:elementName];
    } else if ([elementName isEqualToString:@"Q_OPEN"]) {
        nowTagStr = [NSString stringWithString:elementName];
    } else if ([elementName isEqualToString:@"A_SEQ"]) {
        nowTagStr = [NSString stringWithString:elementName];
    } else if ([elementName isEqualToString:@"A_NAME"]) {
        nowTagStr = [NSString stringWithString:elementName];
    } else if ([elementName isEqualToString:@"A_CORRECT"]) {
        nowTagStr = [NSString stringWithString:elementName];
    }
}


- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
    if ([nowTagStr isEqualToString:@"CODE"]) {
        [dicQuizInfo setObject:string forKey:@"Result"];
    } else if ([nowTagStr isEqualToString:@"Q_NAME"]) {
        [dicQuizInfo setObject:string forKey:@"Quiz"];
    } else if ([nowTagStr isEqualToString:@"Q_SEQ"]) {
        [dicQuizInfo setObject:string forKey:@"QuizNum"];
    } else if ([nowTagStr isEqualToString:@"Q_OPEN"]) {
        [dicQuizInfo setObject:string forKey:@"QuizDate"];
    } else if ([nowTagStr isEqualToString:@"A_SEQ"]) {
        [dicRowData setObject:string forKey:@"AnswerNum"];
    } else if ([nowTagStr isEqualToString:@"A_NAME"]) {
        [dicRowData setObject:string forKey:@"Answer"];
    } else if ([nowTagStr isEqualToString:@"A_CORRECT"]) {
//        [dicRowData setObject:string forKey:@"Correct"];
        [dicQuizInfo setObject:[dicRowData objectForKey:@"AnswerNum"] forKey:@"Correct"];
    }
}


- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    if ([elementName isEqualToString:@"row"]) {
        [arQuiz addObject:dicRowData];
    } else if ([elementName isEqualToString:@"KoreanAnswerInfo"]) {
        [dicQuizInfo setObject:arQuiz forKey:@"Answers"];
    }
    
    // 태그 초기화
    nowTagStr = @"";
}



@end

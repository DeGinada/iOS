//
//  SearchViewController.m
//  MusicAppTest
//
//  Created by DeGi on 2017. 5. 18..
//  Copyright © 2017년 DeGi. All rights reserved.
//

#import "SearchViewController.h"
#import "ResultViewController.h"
#import "SearchTableViewCell.h"

#define RED_COLOR       [UIColor colorWithRed:252.0/255.0 green:24.0/255.0 blue:88.0/255.0 alpha:1.0]

@interface SearchViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating>

@property (nonatomic, strong) UISearchController* searchController;
@property (nonatomic, strong) ResultViewController* resultTableVC;
@property IBOutlet UITableView* tableView;

@property BOOL searchControllerWasActive;
@property BOOL searchControllerSearchFieldWasFirstResponder;

@end

@implementation SearchViewController {
    NSArray* g_arPopularity;
    NSMutableArray* g_arLatest;
    NSDictionary* g_dicSearch;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    // [170525] 테이블뷰 상단 bounce area 컬러 바꾸기 (light gray -> white)
    UIView* viewBack = [[UIView alloc] initWithFrame:self.tableView.frame];
    [viewBack setBackgroundColor:[UIColor whiteColor]];
    self.tableView.backgroundView = viewBack;

    
//    // status bar 밑으로 보내기
//    self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
//    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(20, 0, 0, 0);
////    self.tableView.contentOffset = CGPointMake(0, -20);
//    self.automaticallyAdjustsScrollViewInsets = NO;
//    self.extendedLayoutIncludesOpaqueBars = NO;
//    self.definesPresentationContext = YES;
//
//    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    
    // [170522] 검색어 관련 정보 가져오기
    g_arPopularity = [[NSArray alloc] initWithObjects:@"칸쟈니", @"kanjani8", @"백퍼센트", nil];
    g_arLatest = [[[NSUserDefaults standardUserDefaults] objectForKey:@"LatestSearch"] mutableCopy];
    if (!g_arLatest) {
        g_arLatest = [[NSMutableArray alloc] init];
    }
    
//    g_dicSearch = [NSDictionary dictionary];
//    [g_dicSearch setValue:g_arLatest forKey:@"최근 검색어"];
//    [g_dicSearch setValue:g_arPopularity forKey:@"인기 검색어"];
    
    
    [self setBasicTableview];
    

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.searchControllerWasActive) {
        self.searchController.active = self.searchControllerWasActive;
        _searchControllerWasActive = NO;
        
        if (self.searchControllerSearchFieldWasFirstResponder) {
            [self.searchController.searchBar becomeFirstResponder];
            _searchControllerSearchFieldWasFirstResponder = NO;
        }
    }
}

- (void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
}


- (void) viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
}


//- (void) viewDidLayoutSubviews {
//    float systemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
//    if (systemVersion >= 7.0f) {
//        CGRect bounds = self.view.bounds;
//        if(self.navigationController == nil || self.navigationController.isNavigationBarHidden == YES){
//            bounds.origin.y -= 20.0;
//            [self.view setBounds:bounds];
//        }
//        else{
//            self.edgesForExtendedLayout = UIRectEdgeNone;
//        }
//    }
//}


//- (void) viewDidLayoutSubviews {
//    [self.navigationController.navigationBar setFrame:CGRectMake(self.navigationController.navigationBar.frame.origin.x, self.navigationController.navigationBar.frame.origin.y, self.navigationController.navigationBar.frame.size.width, 0.0)];
//}


// [170519] table view를 설정한다.
- (void) setBasicTableview {
    
//    UIView* viewHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 80)];
//    [viewHeader setBackgroundColor:[UIColor clearColor]];
//    
//    UILabel* lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, viewHeader.frame.size.width-20, 30)];
//    [lbTitle setText:@"검색"];
//    [lbTitle setTextAlignment:NSTextAlignmentLeft];
//    [lbTitle setFont:[UIFont boldSystemFontOfSize:25.0f]];
//    [lbTitle setTextColor:[UIColor blackColor]];
//    [viewHeader addSubview:lbTitle];
    
    
    
    _resultTableVC = [[ResultViewController alloc] init];
    _searchController = [[UISearchController alloc] initWithSearchResultsController:self.resultTableVC];
    self.searchController.searchResultsUpdater = self;
    [self.searchController.searchBar setSearchBarStyle:UISearchBarStyleMinimal];
    [self.searchController.searchBar sizeToFit];
    //[viewHeader addSubview:self.searchController.searchBar];
    
    //self.tableView.tableHeaderView = viewHeader;
    self.tableView.tableHeaderView = self.searchController.searchBar;
//    self.searchController.searchBar.translatesAutoresizingMaskIntoConstraints = true;
    
    
    self.resultTableVC.tableView.delegate = self;
    self.searchController.delegate = self;
    self.searchController.dimsBackgroundDuringPresentation = TRUE;
    self.searchController.searchBar.delegate = self;
    
    self.definesPresentationContext = YES;
    
    
    // 취소 버튼 폰트 크기 바꾸기
    [[UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]]
     setTitleTextAttributes:@{
                              NSForegroundColorAttributeName: RED_COLOR,
                              NSFontAttributeName: [UIFont systemFontOfSize:17]}
     forState:UIControlStateNormal];
    
    [[UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]] setTitle:@"취소"];
    
    
    // [170523] 테이블뷰에 빈공간에 생기는 separator line 없애기
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}


// [170523] 선택된 단어 검색하기
- (IBAction) searchSelectedWord:(id)sender {
    
    UIButton* button = sender;
    
    self.searchController.searchBar.text = button.titleLabel.text;
    [self searchBarSearchButtonClicked:self.searchController.searchBar];
    
}



// [170523] 검색했던 단어목록 지우기
- (void) removeSearchedWord {
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* actionCancel = [UIAlertAction actionWithTitle:@"취소" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction* actionOk = [UIAlertAction actionWithTitle:@"최근 검색 지우기" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // 지우기
        g_arLatest = [[NSMutableArray alloc] init];
        [[NSUserDefaults standardUserDefaults] setObject:g_arLatest forKey:@"LatestSearch"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self.tableView reloadData];
    }];
    
    [actionCancel setValue:RED_COLOR forKey:@"titleTextColor"];
    [actionOk setValue:RED_COLOR forKey:@"titleTextColor"];
    
    [alertController addAction:actionOk];
    [alertController addAction:actionCancel];
    
    [self presentViewController:alertController animated:YES completion:nil];
}


#pragma mark - TABLE_VIEW


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
//    return 2;
    if (g_arLatest.count > 0) {
        return 2;
    }
    
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (g_arLatest.count > 0) {
        if (section == 0) {
            return g_arLatest.count;
        } else {
            return g_arPopularity.count;
        }
    } else {
        return g_arPopularity.count;
    }
    
//    if (section == 0) {
//        return g_arLatest.count+g_arPopularity.count;
//    }
    
//    NSString* key = [[g_dicSearch allKeys] objectAtIndex:section];
//    return [[g_dicSearch objectForKey:key] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    static NSString* identifier = @"Cell";
//    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//    
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//    }
//    
//    if (g_arLatest.count > 0) {
//        
//        
//        
////        if (indexPath.row >= g_arLatest.count) {
////            // 인기 검색어
////            cell.textLabel.text = [g_arPopularity objectAtIndex:(indexPath.row-g_arLatest.count)];
////        } else {
////            // 최근 검색어
////            cell.textLabel.text = [g_arLatest objectAtIndex:indexPath.row];
////        }
//        
//        // [170523] 정보 출력 오류로 수정
//        if (indexPath.section == 0) {
//            cell.textLabel.text = [g_arLatest objectAtIndex:indexPath.row];
//        } else {
//            cell.textLabel.text = [g_arPopularity objectAtIndex:indexPath.row];
//        }
//        
//    } else {
//        cell.textLabel.text = [g_arPopularity objectAtIndex:indexPath.row];
//    }
//    
//    cell.textLabel.textColor = [UIColor blackColor];
    
    
    // [170523] custom cell로 변경
    static NSString* identifier = @"Cell";
    SearchTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[SearchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    NSString* strTitle = @"";
    
    if (g_arLatest.count > 0) {
        // [170523] 정보 출력 오류로 수정
        if (indexPath.section == 0) {
            strTitle = [g_arLatest objectAtIndex:indexPath.row];
        } else {
            strTitle = [g_arPopularity objectAtIndex:indexPath.row];
        }
        
    } else {
        strTitle = [g_arPopularity objectAtIndex:indexPath.row];
    }
    
    BOOL isLast = NO;
    if (indexPath.row == (g_arLatest.count-1) || indexPath.row == (g_arPopularity.count-1)) {
        isLast= YES;
    }
    
    [cell setButtonInfo:strTitle last:isLast];
    
    
    return cell;
}



- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    
    if (g_arLatest.count > 0) {
        if (section == 0) {
            return @"최근 검색어";
        } else {
            return @"인기 검색어";
        }
    }
    
    return @"인기 검색어";
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 54.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView* viewSection = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 54.0)];
    [viewSection setBackgroundColor:self.view.backgroundColor];
//    [viewSection setBackgroundColor:[UIColor clearColor]];
    
    UILabel* lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, viewSection.frame.size.width-30, 34)];
    [lbTitle setText:[self tableView:tableView titleForHeaderInSection:section]];
    [lbTitle setFont:[UIFont boldSystemFontOfSize:20.0]];
    [lbTitle setTextColor:[UIColor blackColor]];
    [viewSection addSubview:lbTitle];
    
    // [170522] 최근 검색어가 있는 경우, 최근 검색어는 지우기 가능하게
    if (g_arLatest.count > 0 && section == 0) {
        UIButton* btnRemove = [[UIButton alloc] initWithFrame:CGRectMake(viewSection.frame.size.width-85, 20, 70, 34)];
        [btnRemove setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        [btnRemove setTitleColor:RED_COLOR forState:UIControlStateNormal];
        [btnRemove setTitle:@"비우기" forState:UIControlStateNormal];
        btnRemove.titleLabel.font = [UIFont systemFontOfSize:18.0];
        [btnRemove addTarget:self action:@selector(removeSearchedWord) forControlEvents:UIControlEventTouchUpInside];
        [viewSection addSubview:btnRemove];
    }
    
    [self.searchController.searchBar setBackgroundColor:[UIColor whiteColor]];
    
    
    return viewSection;
}



#pragma mark - SEARCH_RESULT

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    if (g_arLatest.count > 0) {
        
        // [170524] 들어온 검색어가 중복되는 경우는 기존에꺼 지우고 다시 저장
        for (NSString* string in g_arLatest) {
            if ([string isEqualToString:searchBar.text]) {
                [g_arLatest removeObject:string];
            }
        }
        
        [g_arLatest insertObject:searchBar.text atIndex:0];
        
        if (g_arLatest.count > 3) {
            [g_arLatest removeObjectAtIndex:3];
        }
    } else {
        [g_arLatest addObject:searchBar.text];
    }
    
    
    [[NSUserDefaults standardUserDefaults] setObject:g_arLatest forKey:@"LatestSearch"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    [self.tableView reloadData];
}

@end

//
//  SearchViewController.m
//  MusicAppTest
//
//  Created by DeGi on 2017. 5. 18..
//  Copyright © 2017년 DeGi. All rights reserved.
//

#import "SearchViewController.h"
#import "ResultViewController.h"

@interface SearchViewController () <UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating>

@property (nonatomic, strong) UISearchController* searchController;
@property (nonatomic, strong) ResultViewController* resultTableVC;

@property BOOL searchControllerWasActive;
@property BOOL searchControllerSearchFieldWasFirstResponder;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    // status bar 밑으로 보내기
//    self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
//    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(20, 0, 0, 0);
////    self.tableView.contentOffset = CGPointMake(0, -20);
//    self.automaticallyAdjustsScrollViewInsets = NO;
//    self.extendedLayoutIncludesOpaqueBars = NO;
//    self.definesPresentationContext = YES;
//
//    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    
    
    
    
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
    
    
    _resultTableVC = [[ResultViewController alloc] init];
    _searchController = [[UISearchController alloc] initWithSearchResultsController:self.resultTableVC];
    self.searchController.searchResultsUpdater = self;
    [self.searchController.searchBar setSearchBarStyle:UISearchBarStyleMinimal];
    [self.searchController.searchBar sizeToFit];
    self.tableView.tableHeaderView = self.searchController.searchBar;
    
    
    self.resultTableVC.tableView.delegate = self;
    self.searchController.delegate = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.searchBar.delegate = self;
    
    self.definesPresentationContext = YES;
}



#pragma mark - TABLE_VIEW



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* identifier = @"Cell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    
    return cell;
}



#pragma mark - SEARCH_RESULT

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
}


@end

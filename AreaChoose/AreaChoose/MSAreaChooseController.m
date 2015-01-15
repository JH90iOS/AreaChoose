//
//  MSAreaChooseController.m
//  MySteel2Demo
//
//  Created by jinhua on 14-4-29.
//  Copyright (c) 2014年 jin hua. All rights reserved.
//

#import "MSAreaChooseController.h"

@interface MSAreaChooseController ()<UISearchDisplayDelegate>

@property (nonatomic, strong) NSMutableDictionary *cities;

@property (nonatomic, strong) NSMutableArray *keys; //城市首字母
@property (nonatomic, strong) NSMutableArray *arrayCitys;   //城市数据
@property (nonatomic, strong) NSMutableArray *arrayHotCity;
@property (nonatomic, strong) NSMutableArray *arrayAllCitys;
@property (nonatomic, strong) NSMutableDictionary *dicAllCitysPinyin;//城市拼音

@property (nonatomic,strong) NSMutableArray* searchResults;

@end

@implementation MSAreaChooseController

-(void)loadView{
    [super loadView];
}

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
   return  [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.arrayHotCity = [NSMutableArray arrayWithObjects:@"广州市",@"北京市",@"天津市",@"西安市",@"重庆市",@"沈阳市",@"青岛市",@"济南市",@"深圳市",@"长沙市",@"无锡市", nil];
    self.keys = [NSMutableArray array];
    self.arrayCitys = [NSMutableArray array];
    self.searchResults = [NSMutableArray array];
    self.arrayAllCitys = [NSMutableArray array];
    self.dicAllCitysPinyin = [[NSMutableDictionary alloc]init];
    
    [self getCityData];
    
    self.title = @"城市选择器";
    
    self.navigationController.navigationBar.translucent = NO;
       
}

#define Version_IOS7 [[UIDevice currentDevice].systemVersion doubleValue]>=7.0

//设置导航
- (void)setNavigationBarStyle{
    UINavigationBar* navigationBar =[[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, 320, 64)];
    
    if (Version_IOS7) {
        navigationBar.translucent = NO;
        [navigationBar setBarTintColor:[UIColor lightGrayColor]];
        self.automaticallyAdjustsScrollViewInsets = NO;
        
    }
    
    
    UINavigationItem *navigationItem = [[UINavigationItem alloc] initWithTitle:nil];
    navigationItem.title = @"选择城市";
    
    [navigationBar pushNavigationItem:navigationItem animated:NO];

    
    [self.view addSubview:navigationBar];
    
}

- (void)backHome:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//-(BOOL) searchBarShouldBeginEditing:(UISearchBar *)searchBar{
//    for (UIView *searchbuttons in self.searchDisplayController.searchBar.subviews)
//    {
//        if ([searchbuttons isKindOfClass:[UIButton class]])
//        {
//            UIButton *cancelButton = (UIButton*)searchbuttons;
//            cancelButton.enabled = YES;
////            cancelButton.backgroundColor = [Utils colorWithHexString:CustomColorForOrange];
//            [cancelButton setTintColor:[UIColor whiteColor]];
//            [cancelButton setTitle:@"取消"  forState:UIControlStateNormal];//文字
//            break;
//        }
//    }
//    return YES;
//}



-(void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller{
    
    self.searchDisplayController.searchBar.showsCancelButton = YES;
    UIButton *cancelButton;
    UIView *topView = self.searchDisplayController.searchBar.subviews[0];
    
    for (UIView *subView in topView.subviews) {
        if ([subView isKindOfClass:NSClassFromString(@"UINavigationButton")]) {
            cancelButton = (UIButton*)subView;
        }
    }
    if (cancelButton) {
//        cancelButton.backgroundColor = [Utils colorWithHexString:CustomColorForOrange];
        [cancelButton setTintColor:[UIColor whiteColor]];
        [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

        [cancelButton setTitle:@"取消"  forState:UIControlStateNormal];//文字
    }
}


#pragma mark - 获取城市数据
-(void)getCityData
{
    NSString *path=[[NSBundle mainBundle] pathForResource:@"citydict"
                                                   ofType:@"plist"];
    self.cities = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    
    [self.keys addObjectsFromArray:[[self.cities allKeys] sortedArrayUsingSelector:@selector(compare:)]];
    
    for (NSString* key in self.keys) {
        NSArray* array = [self.cities objectForKey:key];
        for (NSString* city in array) {
            
            //汉字转拼音
            NSMutableString* ms = [[NSMutableString alloc]initWithString:city];
            if (CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformMandarinLatin, NO)) {
                
            }
            if (CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformMandarinLatin, NO)) {
                [self.dicAllCitysPinyin setObject:city forKey:ms];
            }
        }
        
        [self.arrayAllCitys  addObjectsFromArray:array];
    }
    
    //添加热门城市
    NSString *strHot = @"热";
    [self.keys insertObject:strHot atIndex:0];
    [self.cities setObject:self.arrayHotCity forKey:strHot];
    

    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20.0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    bgView.backgroundColor = [UIColor lightGrayColor];
    
    if (tableView != self.searchDisplayController.searchResultsTableView) {
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(13, 0, 250, 20)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.font = [UIFont systemFontOfSize:12];
        
        NSString *key = [_keys objectAtIndex:section];
        if ([key rangeOfString:@"热"].location != NSNotFound) {
            titleLabel.text = @"热门城市";
        }
        else
            titleLabel.text = key;
        
        [bgView addSubview:titleLabel];
    }
    else{
//        return NULL;
    }
    

    

    
    return bgView;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (tableView != self.searchDisplayController.searchResultsTableView) {
        return self.keys;
    }
    else{
        return NULL;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView != self.searchDisplayController.searchResultsTableView) {
            return [self.keys count];
    }
    else{
        return 1;
    }

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView != self.searchDisplayController.searchResultsTableView) {
        NSString* key = [self.keys objectAtIndex:section];
        NSArray* cities = [self.cities objectForKey:key];
        
        return [cities count];    }
    else{
        return [self.searchResults count];
    }
    

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
    }

    if (tableView != self.searchDisplayController.searchResultsTableView) {
        
        NSString *key = [_keys objectAtIndex:indexPath.section];
        

            cell.backgroundColor = [UIColor clearColor];
            cell.contentView.backgroundColor = [UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            [cell.textLabel setTextColor:[UIColor blackColor]];
            cell.textLabel.font = [UIFont systemFontOfSize:18];
        
        cell.textLabel.text = [[_cities objectForKey:key] objectAtIndex:indexPath.row];
    }
    else{
        
        cell.textLabel.text = [self.searchResults objectAtIndex:indexPath.row];
    }
    
    

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    NSString* city = nil;
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    city = cell.textLabel.text;
    
        [self dismissViewControllerAnimated:YES completion:^{
            [self.delegate chooseCityComplete:city];
        }];



}


-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString{
    
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}


- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate
                                    predicateWithFormat:@"SELF contains[cd] %@",
                                    searchText];
    
    self.searchResults = [self.arrayAllCitys filteredArrayUsingPredicate:resultPredicate];
    if ([self.searchResults count]==0) {
        NSMutableArray* temArray = [[NSMutableArray alloc]init];
        NSArray* array = [self.dicAllCitysPinyin allKeys];
        NSArray* results = [array filteredArrayUsingPredicate:resultPredicate];
        for (NSString* key in results) {
            NSString* city = [self.dicAllCitysPinyin objectForKey:key];
            [temArray addObject:city];
        }
        self.searchResults = temArray;
        
    }
    NSLog(@"---%@",self.searchResults);
}


@end

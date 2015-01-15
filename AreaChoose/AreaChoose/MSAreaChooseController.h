//
//  MSAreaChooseController.h
//  MySteel2Demo
//
//  Created by jinhua on 14-4-29.
//  Copyright (c) 2014年 jinhua. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MSAreaChooseDelegate

@required
-(void)chooseCityComplete:(NSString*)city;
@end

@interface MSAreaChooseController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (weak,nonatomic)id<MSAreaChooseDelegate> delegate;
@end

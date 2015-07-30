//
//  MainViewController.h
//  
//
//  Created by Russ Wetmore on 7/27/15.
//
//

@import UIKit;

#import "RedditFetchController.h"


@interface MainViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, RedditFetchControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *redditTableView;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UIButton *redditSearchButton;

@end

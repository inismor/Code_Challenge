//
//  RedditPostCell.h
//  
//
//  Created by Russ Wetmore on 7/28/15.
//
//

@import UIKit;
#import "RedditTitleLabel.h"


@interface RedditPostCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *thumbnail;
@property (weak, nonatomic) IBOutlet UILabel *author;
@property (weak, nonatomic) IBOutlet RedditTitleLabel *title;
@property (weak, nonatomic) IBOutlet UIView *statsView;
@property (weak, nonatomic) IBOutlet UILabel *comments;
@property (weak, nonatomic) IBOutlet UILabel *ups;
@property (weak, nonatomic) IBOutlet UILabel *downs;

@end

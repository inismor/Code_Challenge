//
//  RedditFetchController.h
//  
//
//  Created by Russ Wetmore on 7/27/15.
//
//

@import UIKit;


extern NSString * const START_FETCH_NOTIFICATION;


@class RedditFetchController;


@protocol RedditFetchControllerDelegate <NSObject>

@optional
- (BOOL)        fetchController:(RedditFetchController *)fetchController
 shouldStartFetchWithSearchTerm:(NSString *)searchTerm;
- (void) fetchControllerDidStartFetch:(RedditFetchController *)fetchController;
- (void) fetchControllerDidEndFetch:(RedditFetchController *)fetchController;
- (void) fetchControllerDidFailFetchWithError:(RedditFetchController *)fetchController
										error:(NSError *)error;

@end


@interface RedditFetchController : NSObject <NSURLConnectionDelegate>

@property (nonatomic, strong) NSString *searchTerm;
@property (nonatomic, assign) id<RedditFetchControllerDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *posts;

- (instancetype) initWithDelegate:(id<RedditFetchControllerDelegate>)delegate;
- (void) startFetchWithSearchTerm:(NSString *)searchTerm;
- (void) start;
- (void) cancel;

@end


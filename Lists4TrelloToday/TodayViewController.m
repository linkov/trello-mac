//
//  TodayViewController.m
//  Lists4TrelloToday
//
//  Created by Alex Linkov on 3/31/19.
//  Copyright © 2019 SDWR. All rights reserved.
//

#import "TodayViewController.h"
#import "ListRowViewController.h"
#import <NotificationCenter/NotificationCenter.h>

typedef void (^SDWUpdateResultBlock)(NCUpdateResult updateResult);

@interface TodayViewController () <NCWidgetProviding, NCWidgetListViewDelegate, NCWidgetSearchViewDelegate>

@property (strong) IBOutlet NCWidgetListViewController *listViewController;
@property (strong) NCWidgetSearchViewController *searchController;
@property (strong) NSArray *data;
@end


@implementation TodayViewController

#pragma mark - NSViewController

- (void)viewWillAppear {
    [super viewWillAppear];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.listViewController setHasDividerLines:NO];
    [self fetchContentWithUpdate:^(NCUpdateResult updateResult) {
        
    }];
    

   
}

- (void)fetchContentWithUpdate:(SDWUpdateResultBlock)block {
    NSUserDefaults *shared = [[NSUserDefaults alloc] initWithSuiteName:@"43R88X5B35.com.sdwr.lists.appgroup"];
    NSString *listID = [shared objectForKey:@"com.sdwr.trello-mac.todaylistID"];
    NSString *listName = [shared objectForKey:@"com.sdwr.trello-mac.todaylistName"];
    NSString *userToken = [shared objectForKey:@"com.sdwr.trello-mac.userToken"];
    
    if (listID) {
        self.listViewController.contents = @[@"loading ..."];
        
        
        // 1
        NSString *dataUrl = [NSString stringWithFormat:@"https://api.trello.com/1/lists/%@/cards?lists=open&cards=open&key=6825229a76db5b6a5737eb97e9c4a923&token=%@",listID,userToken];
        NSURL *url = [NSURL URLWithString:dataUrl];
        
        
        
        
        
        NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:url];
        
        //create the Method "GET"
        [urlRequest setHTTPMethod:@"GET"];
        
        NSURLSession *session = [NSURLSession sharedSession];
        
        NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                          {
                                              NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                                              if(httpResponse.statusCode == 200)
                                              {
                                                  NSError *parseError = nil;
                                                  NSArray *responseArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
                                                  
                                                  NSMutableArray *ts = [NSMutableArray array];
                                                  
                                                  for (NSDictionary *taskObject in responseArray) {
                                                      [ts addObject:[taskObject valueForKey:@"name"]];
                                                      
                                                  }
                                                  
                                                  [ts insertObject:listName atIndex:0];
                                                  
                                                  dispatch_async(dispatch_get_main_queue(), ^(void) {
                                                      if ([self.listViewController.contents isEqualToArray:[NSArray arrayWithArray:ts]]) {
                                                          NSLog(@"EQUAL");
                                                          block(NCUpdateResultNoData);
                                                      } else {
                                                          NSLog(@"NOT EQUAL");
                                                          self.listViewController.contents = [NSArray arrayWithArray:ts];
                                                           block(NCUpdateResultNewData);
                                                      }
                                                      
                                                  });
                                                  
                                                  
                                                  
                                              }
                                              else
                                              {
                                                  dispatch_async(dispatch_get_main_queue(), ^(void) {
                                                      self.listViewController.contents = @[@"Failed to load tasks, try again later"];
                                                      block(NCUpdateResultFailed);
                                                  });
                                                  
                                              }
                                          }];
        [dataTask resume];
        
        
        
    } else {
        self.listViewController.contents = @[@"Left click on a list in the main application and select 'Show in Today Widget' to add it."];
    }
    
}

- (void)dismissViewController:(NSViewController *)viewController {
    [super dismissViewController:viewController];

    // The search controller has been dismissed and is no longer needed.
    if (viewController == self.searchController) {
        self.searchController = nil;
    }
}

#pragma mark - NCWidgetProviding

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult result))completionHandler {
    [self fetchContentWithUpdate:^(NCUpdateResult updateResult) {
        completionHandler(updateResult);
    }];
    
}

- (NSEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(NSEdgeInsets)defaultMarginInset {
    // Override the left margin so that the list view is flush with the edge.
    defaultMarginInset.left = -6;
    defaultMarginInset.right = -6;
    return defaultMarginInset;
}

- (BOOL)widgetAllowsEditing {
    // Return YES to indicate that the widget supports editing of content and
    // that the list view should be allowed to enter an edit mode.
    return NO;
}

- (void)widgetDidBeginEditing {
    // The user has clicked the edit button.
    // Put the list view into editing mode.
    self.listViewController.editing = YES;
}

- (void)widgetDidEndEditing {
    // The user has clicked the Done button, begun editing another widget,
    // or the Notification Center has been closed.
    // Take the list view out of editing mode.
    self.listViewController.editing = NO;
}

#pragma mark - NCWidgetListViewDelegate

- (NSViewController *)widgetList:(NCWidgetListViewController *)list viewControllerForRow:(NSUInteger)row {
    
    ListRowViewController *cr  =  [[ListRowViewController alloc] init];
    cr.taskName = [self.listViewController.contents objectAtIndex:row];
    cr.isHeaderRow = NO;
    
    if ([self.listViewController.contents indexOfObject:[self.listViewController.contents objectAtIndex:row]] == 0)  {
    
        cr.isHeaderRow = YES;
    }
    
    return cr;
}

- (void)widgetListPerformAddAction:(NCWidgetListViewController *)list {
    // The user has clicked the add button in the list view.
    // Display a search controller for adding new content to the widget.
    self.searchController = [[NCWidgetSearchViewController alloc] init];
    self.searchController.delegate = self;

    // Present the search view controller with an animation.
    // Implement dismissViewController to observe when the view controller
    // has been dismissed and is no longer needed.
    [self presentViewControllerInWidget:self.searchController];
}

- (BOOL)widgetList:(NCWidgetListViewController *)list shouldReorderRow:(NSUInteger)row {
    // Return YES to allow the item to be reordered in the list by the user.
    return NO;
}

- (void)widgetList:(NCWidgetListViewController *)list didReorderRow:(NSUInteger)row toRow:(NSUInteger)newIndex {
    // The user has reordered an item in the list.
}

- (BOOL)widgetList:(NCWidgetListViewController *)list shouldRemoveRow:(NSUInteger)row {
    // Return YES to allow the item to be removed from the list by the user.
    return NO;
}

- (void)widgetList:(NCWidgetListViewController *)list didRemoveRow:(NSUInteger)row {
    // The user has removed an item from the list.
}

#pragma mark - NCWidgetSearchViewDelegate

- (void)widgetSearch:(NCWidgetSearchViewController *)searchController searchForTerm:(NSString *)searchTerm maxResults:(NSUInteger)max {
    // The user has entered a search term. Set the controller's searchResults property to the matching items.
    searchController.searchResults = @[];
}

- (void)widgetSearchTermCleared:(NCWidgetSearchViewController *)searchController {
    // The user has cleared the search field. Remove the search results.
    searchController.searchResults = nil;
}

- (void)widgetSearch:(NCWidgetSearchViewController *)searchController resultSelected:(id)object {
    // The user has selected a search result from the list.
}

@end

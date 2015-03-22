//
//  SDWTrelloStore.m
//  Lists
//
//  Created by alex on 1/4/15.
//  Copyright (c) 2015 SDWR. All rights reserved.
//

#import "SDWTrelloStore.h"
#import "AFTrelloAPIClient.h"
#import <Crashlytics/Crashlytics.h>
#import "SDWAppSettings.h"
#import "SDWChecklist.h"

@implementation SDWTrelloStore

+ (instancetype)store {
    static dispatch_once_t pred;
    static SDWTrelloStore *store = nil;
    dispatch_once(&pred, ^{
        store = [SDWTrelloStore new];
    });
    return store;
}

- (void)handleError:(NSError *)error {

    CLS_LOG(@"err - %@",error.localizedDescription);
}

- (void)handleError:(NSError *)error withReason:(id)reason {}


- (void)fetchAllAssigneesWithCompletion:(SDWTrelloStoreCompletionBlock)block {

    [[AFTrelloAPIClient sharedClient] GET:@"members/me?fields=none&cards=all&card_fields=idBoard,idList" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {

        SharedSettings.userID = responseObject[@"id"];
        NSArray *crownBoardIDs = [responseObject[@"cards"] valueForKeyPath:@"idBoard"];
        NSArray *crownListIDs = [responseObject[@"cards"] valueForKeyPath:@"idList"];

        if(block)block(@{@"crownBoardIDs":crownBoardIDs,@"crownListIDs":crownListIDs},nil);



    } failure:^(NSURLSessionDataTask *task, NSError *error) {

        [self handleError:error];
        if(block)block(nil,error);

    }];
}


#pragma mark - Cards ops

- (void)createCardWithName:(NSString *)name
                    listID:(NSString *)listID
            withCompletion:(SDWTrelloStoreCompletionBlock)block {

    NSDictionary *params = @{
                             @"name":name,
                             @"due":@"",
                             @"idList":listID,
                             @"urlSource":@"null"
                             };

    [[AFTrelloAPIClient sharedClient] POST:@"cards?"
                                parameters:params
                                   success:^(NSURLSessionDataTask *task, id responseObject)
     {

         if(block) block(responseObject,nil);

     } failure:^(NSURLSessionDataTask *task, NSError *error) {

         if(block) block(nil,error);
         [self handleError:error];
     }];

}

- (void)moveCardID:(NSString *)cardID
          toListID:(NSString *)listID
           boardID:(NSString *)boardID {

    NSString *urlString = [NSString stringWithFormat:@"cards/%@?",cardID];

    [[AFTrelloAPIClient sharedClient] PUT:urlString parameters:@{
                                                                 @"idList":listID,
                                                                 @"idBoard":boardID,
                                                                 @"pos":@0
                                                                 }
                                  success:^(NSURLSessionDataTask *task, id responseObject)
     {


     } failure:^(NSURLSessionDataTask *task, NSError *error) {

         [self handleError:error];
     }];

}

- (void)moveCardID:(NSString *)cardID
        toPosition:(NSNumber *)pos
        completion:(SDWTrelloStoreCompletionBlock)block {

    NSString *urlString = [NSString stringWithFormat:@"cards/%@/pos?",cardID];
    [[AFTrelloAPIClient sharedClient] PUT:urlString parameters:@{@"value":pos}
                                  success:^(NSURLSessionDataTask *task, id responseObject)
    {
        if(block) block(responseObject,nil);

    } failure:^(NSURLSessionDataTask *task, NSError *error)

    {

        if(block) block(nil,error);
        [self handleError:error];

    }];

}

- (void)updateCard:(SDWCard *)card
    withCompletion:(SDWTrelloStoreCompletionBlock)block {

    NSString *urlString = [NSString stringWithFormat:@"cards/%@?",card.cardID];
    [[AFTrelloAPIClient sharedClient] PUT:urlString parameters:@{
                                                                 @"name":card.name,
                                                                 @"desc":card.cardDescription ?: @"",
                                                                 @"due":(card.dueDate && (id)card.dueDate != [NSNull null]) ? [NSNumber numberWithLongLong:[card.dueDate timeIntervalSince1970]*1000] : @""
                                                                 }
                                  success:^(NSURLSessionDataTask *task, id responseObject)
     {

         if(block) block(responseObject,nil);
         

     } failure:^(NSURLSessionDataTask *task, NSError *error) {

         if(block) block(nil,error);
         [self handleError:error];

     }];
}

- (void)deleteCardID:(NSString *)cardID
      withCompletion:(SDWTrelloStoreCompletionBlock)block {

    NSString *urlString = [NSString stringWithFormat:@"cards/%@?",cardID];

    [[AFTrelloAPIClient sharedClient] DELETE:urlString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {

        if(block) block(responseObject,nil);

        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {

        if(block) block(nil,error);
        [self handleError:error];
    }];
}

- (void)updateLabelsForCardID:(NSString *)cardID
                       colors:(NSString *)colors
                   completion:(SDWTrelloStoreCompletionBlock)block
{


    NSString *urlString = [NSString stringWithFormat:@"cards/%@/labels?",cardID];

    [[AFTrelloAPIClient sharedClient] PUT:urlString parameters:@{@"value":colors} success:^(NSURLSessionDataTask *task, id responseObject) {

        if(block) block(responseObject,nil);

    } failure:^(NSURLSessionDataTask *task, NSError *error) {

        if(block) block(nil,error);
        [self handleError:error];
    }];
}

- (void)removeLabelForCardID:(NSString *)cardID
                       color:(NSString *)color
                  completion:(SDWTrelloStoreCompletionBlock)block {

    NSString *urlString = [NSString stringWithFormat:@"cards/%@/labels/%@?",cardID,color];

    [[AFTrelloAPIClient sharedClient] DELETE:urlString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {

        if(block) block(responseObject,nil);

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        if(block) block(nil,error);
        [self handleError:error];
    }];

}

#pragma mark - Lists ops

- (void)createListWithName:(NSString *)name
                   boardID:(NSString *)boardID
                  position:(NSNumber *)pos
                completion:(SDWTrelloStoreCompletionBlock)block {

    [[AFTrelloAPIClient sharedClient] POST:@"lists?"
                                parameters:@{
                                             @"name":name,
                                             @"idBoard":boardID,
                                             @"pos":pos
                                             }
                                   success:^(NSURLSessionDataTask *task, id responseObject)
     {

         if(block) block(responseObject,nil);

     } failure:^(NSURLSessionDataTask *task, NSError *error) {

         if(block) block(nil,error);
         [self handleError:error];
     }];

}

- (void)deleteListID:(NSString *)listID withCompletion:(SDWTrelloStoreCompletionBlock)block {

    NSString *urlString = [NSString stringWithFormat:@"lists/%@?",listID];

    [[AFTrelloAPIClient sharedClient] PUT:urlString parameters:@{@"closed":@"true"} success:^(NSURLSessionDataTask *task, id responseObject) {

        if(block) block(responseObject,nil);

    } failure:^(NSURLSessionDataTask *task, NSError *error) {

        if(block) block(nil,error);
        [self handleError:error];
    }];
}


#pragma mark - Checklists ops


- (void)createChecklistWithName:(NSString *)name
                         cardID:(NSString *)cardID
                     completion:(SDWTrelloStoreCompletionBlock)block {

    NSString *urlString = [NSString stringWithFormat:@"cards/%@/checklists?",cardID];

    [[AFTrelloAPIClient sharedClient] POST:urlString
                                parameters:@{@"name":name}
                                   success:^(NSURLSessionDataTask *task, id responseObject)
     {

         if(block) block(responseObject,nil);

     } failure:^(NSURLSessionDataTask *task, NSError *error) {

         if(block) block(nil,error);
         [self handleError:error];
     }];
}

- (void)fetchChecklistsForCardID:(NSString *)cardID
                      completion:(SDWTrelloStoreCompletionBlock)block {


    [[AFRecordPathManager manager]
     setAFRecordMethod:@"findAll"
     forModel:[SDWChecklist class]
     toConcretePath:[NSString stringWithFormat:@"cards/%@/checklists?",cardID]];


    [SDWChecklist findAll:^(NSArray *objects, NSError *error) {

        if (!error) {

            if(block) block(objects,nil);

        } else {
            
            if(block) block(nil,error);
            [self handleError:error];
        }
    }];

}

- (void)moveCheckItem:(SDWChecklistItem *)item
             fromList:(NSString *)initialListID
               cardID:(NSString *)cardID
       withCompletion:(SDWTrelloStoreCompletionBlock)block {

    NSString *urlString = [NSString stringWithFormat:@"cards/%@/checklist/%@/checkItem/%@?",cardID,initialListID,item.itemID];

    [[AFTrelloAPIClient sharedClient] PUT:urlString parameters:@{@"idChecklist":item.listID}
                                  success:^(NSURLSessionDataTask *task, id responseObject) {

                                      if(block) block(responseObject,nil);

                                  } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                      
                                      if(block) block(nil,error);
                                      [self handleError:error];
                                  }];
}

- (void)updateCheckItem:(SDWChecklistItem *)item
                 cardID:(NSString *)cardID
         withCompletion:(SDWTrelloStoreCompletionBlock)block {

    NSString *urlString = [NSString stringWithFormat:@"cards/%@/checklist/%@/checkItem/%@?",cardID,item.listID,item.itemID];

    [[AFTrelloAPIClient sharedClient] PUT:urlString parameters:@{
                                                                 @"state":item.state,
                                                                 @"name":item.name,
                                                                 }
                                  success:^(NSURLSessionDataTask *task, id responseObject) {

        if(block) block(responseObject,nil);

    } failure:^(NSURLSessionDataTask *task, NSError *error) {

        if(block) block(nil,error);
        [self handleError:error];
    }];
}

- (void)updateCheckItemPosition:(SDWChecklistItem *)item
                         cardID:(NSString *)cardID
                 withCompletion:(SDWTrelloStoreCompletionBlock)block {

    NSString *urlString = [NSString stringWithFormat:@"cards/%@/checklist/%@/checkItem/%@/pos?",cardID,item.listID,item.itemID];

    [[AFTrelloAPIClient sharedClient] PUT:urlString parameters:@{@"value":[NSNumber numberWithInteger:item.position]}
                                  success:^(NSURLSessionDataTask *task, id responseObject) {

                                      if(block) block(responseObject,nil);

                                  } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                      
                                      if(block) block(nil,error);
                                      [self handleError:error];
                                  }];

}

- (void)createCheckItem:(SDWChecklistItem *)item
                 cardID:(NSString *)cardID
         withCompletion:(SDWTrelloStoreCompletionBlock)block {

    NSString *urlString = [NSString stringWithFormat:@"cards/%@/checklist/%@/checkItem?",cardID,item.listID];

    [[AFTrelloAPIClient sharedClient] POST:urlString parameters:@{
                                                                 @"name":item.name
                                                                 }
                                  success:^(NSURLSessionDataTask *task, id responseObject) {

                                      if(block) block(responseObject,nil);

                                  } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                      
                                      if(block) block(nil,error);
                                      [self handleError:error];
                                  }];

}

- (void)deleteCheckItem:(SDWChecklistItem *)item
                 cardID:(NSString *)cardID
         withCompletion:(SDWTrelloStoreCompletionBlock)block {

    NSString *urlString = [NSString stringWithFormat:@"cards/%@/checklist/%@/checkItem/%@?",cardID,item.listID,item.itemID];

    [[AFTrelloAPIClient sharedClient] DELETE:urlString parameters:@{
                                                                 @"state":item.state,
                                                                 @"name":item.name
                                                                 }
                                  success:^(NSURLSessionDataTask *task, id responseObject) {

                                      if(block) block(responseObject,nil);

                                  } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                      
                                      if(block) block(nil,error);
                                      [self handleError:error];
                                  }];

}

- (void)deleteCheckList:(SDWChecklist *)checkList
         withCompletion:(SDWTrelloStoreCompletionBlock)block {

    NSString *urlString = [NSString stringWithFormat:@"checklists/%@?",checkList.listID];

    [[AFTrelloAPIClient sharedClient] DELETE:urlString parameters:nil
                                     success:^(NSURLSessionDataTask *task, id responseObject) {

                                         if(block) block(responseObject,nil);

                                     } failure:^(NSURLSessionDataTask *task, NSError *error) {

                                         if(block) block(nil,error);
                                         [self handleError:error];
                                     }];
    
}

- (void)addCheckListForCardID:(NSString *)cardID
               withCompletion:(SDWTrelloStoreCompletionBlock)block {

    [[AFTrelloAPIClient sharedClient] POST:@"checklists?" parameters:@{
                                                                    @"idCard":cardID,
                                                                    }
                                     success:^(NSURLSessionDataTask *task, id responseObject) {

                                         SDWChecklist *newCheckList = [[SDWChecklist alloc]initWithAttributes:responseObject];
                                         if(block) block(newCheckList,nil);

                                     } failure:^(NSURLSessionDataTask *task, NSError *error) {

                                         if(block) block(nil,error);
                                         [self handleError:error];
                                     }];

}


- (void)updateChecklistName:(NSString *)newName
                  forListID:(NSString *)listID
         withCompletion:(SDWTrelloStoreCompletionBlock)block {

    NSString *urlString = [NSString stringWithFormat:@"checklists/%@/name?",listID];

    [[AFTrelloAPIClient sharedClient] PUT:urlString parameters:@{
                                                                 @"value":newName
                                                                 }
                                  success:^(NSURLSessionDataTask *task, id responseObject) {

                                      if(block) block(responseObject,nil);

                                  } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                      
                                      if(block) block(nil,error);
                                      [self handleError:error];
                                  }];
}


@end

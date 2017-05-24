//
//  SDWTrelloStore.m
//  Lists
//
//  Created by alex on 1/4/15.
//  Copyright (c) 2015 SDWR. All rights reserved.
//
#import "SDWMacros.h"

#import "SDWTrelloStore.h"
#import "AFTrelloAPIClient.h"

#import "SDWAppSettings.h"
#import "SDWChecklist.h"
#import "SDWMapper.h"
#import "SDWMChecklist.h"

#import "SDWBoardDisplayItem.h"
#import "SDWListDisplayItem.h"
#import "SDWUserDisplayItem.h"
#import "SDWCardDisplayItem.h"
#import "SDWChecklistItemDisplayItem.h"
#import "SDWChecklistDisplayItem.h"

#import "SDWMCard.h"
#import "SDWMList.h"
#import "SDWMBoard.h"
#import "SDWMChecklistItem.h"
#import "SDWMUser.h"
#import "SDWMLabel.h"
#import "SDWActivityDisplayItem.h"
#import "SDWMActivity.h"

#import "SDWAppSettings.h"

@interface SDWTrelloStore ()

@property (nonatomic, strong) SDWDataModelManager *dataModelManager;
@property (strong) NSArray *crownCardIDs;

@end

@implementation SDWTrelloStore

+ (instancetype)store {
    static dispatch_once_t pred;
    static SDWTrelloStore *store = nil;
    dispatch_once(&pred, ^{
        store = [SDWTrelloStore new];
        store.dataModelManager = [SDWDataModelManager manager];
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
        [[AFTrelloAPIClient sharedClient].reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            

            switch (status) {
                case AFNetworkReachabilityStatusReachableViaWWAN:
                case AFNetworkReachabilityStatusReachableViaWiFi: {
                    [[NSNotificationCenter defaultCenter] postNotificationName:SDWListsDidReceiveNetworkOnNotification object:nil userInfo:nil];
                    NSOperationQueue *operationQueue = [AFTrelloAPIClient sharedClient].operationQueue;
                    [SharedSettings setOffline:NO];
                    [operationQueue setSuspended:NO];
                    NSLog(@"WIFI");
                    break;
                }
                case AFNetworkReachabilityStatusNotReachable:
                 {
                    [[NSNotificationCenter defaultCenter] postNotificationName:SDWListsDidReceiveNetworkOffNotification object:nil userInfo:nil];
                     NSOperationQueue *operationQueue = [AFTrelloAPIClient sharedClient].operationQueue;
                     [SharedSettings setOffline:YES];
                    [operationQueue setSuspended:YES];
                    NSLog(@"oflline, baby");
                    break;
                }
                default: {
                    break;
                }

            }
        }];
                                            
        
    });
    return store;
}


+ (NSArray <SDWBoardDisplayItem *>*)displayBoardsFromBoards:(NSArray<SDWMBoard *> *)modelBoards crownBoardIDs:(NSArray *)Bids crownListIDs:(NSArray *)Lids {
    
    NSMutableArray  <SDWBoardDisplayItem *>*arr = [NSMutableArray arrayWithCapacity:modelBoards.count];
    for (SDWMBoard *board in modelBoards) {
        
        if ([Bids containsObject:board.trelloID]) {
            SDWBoardDisplayItem *item = [[SDWBoardDisplayItem alloc]initWithModel:board crownListIDs:Lids];
            [arr addObject:item];
        }

        
    }
    
    return [arr copy];
    
}

+ (NSArray <SDWBoardDisplayItem *>*)displayBoardsFromBoards:(NSArray<SDWMBoard *> *)modelBoards {
    
    NSMutableArray  <SDWBoardDisplayItem *>*arr = [NSMutableArray arrayWithCapacity:modelBoards.count];
    for (SDWMBoard *board in modelBoards) {
            SDWBoardDisplayItem *item = [[SDWBoardDisplayItem alloc]initWithModel:board];
            [arr addObject:item];
    }
    
    return [arr copy];
    
}

+ (NSArray <SDWUserDisplayItem *>*)displayUsersFromUsers:(NSArray<SDWMUser *> *)modelUsers {
    
    NSMutableArray  <SDWUserDisplayItem *>*arr = [NSMutableArray arrayWithCapacity:modelUsers.count];
    for (SDWMUser *model in modelUsers) {
        SDWUserDisplayItem *item = [[SDWUserDisplayItem alloc]initWithModel:model];
        [arr addObject:item];
    }
    
    return [arr copy];
    
}

- (NSArray <SDWCardDisplayItem *>*)displayCardsfromCards:(NSArray<SDWMCard *> *)modelUsers crownFiltered:(BOOL)crownFiltered {
    
    NSMutableArray  <SDWCardDisplayItem *>*arr = [NSMutableArray arrayWithCapacity:modelUsers.count];
    for (SDWMCard *model in modelUsers) {
        
         SDWCardDisplayItem *item = [[SDWCardDisplayItem alloc]initWithModel:model];
        if (crownFiltered) {
            
            if([self.crownCardIDs containsObject:item.trelloID]) {
                [arr addObject:item];
            }
            
        } else {
            [arr addObject:item];
        }
       
        
    }
    
    return [arr copy];
    
}

+ (NSArray <SDWChecklistDisplayItem *>*)displayChecklistsfromChecklists:(NSArray<SDWMChecklist *> *)models {
    
    NSMutableArray  <SDWChecklistDisplayItem *>*arr = [NSMutableArray arrayWithCapacity:models.count];
    for (SDWMChecklist *model in models) {
        SDWChecklistDisplayItem *item = [[SDWChecklistDisplayItem alloc]initWithModel:model];
        [arr addObject:item];
    }
    
    return [arr copy];
    
}


+ (NSArray <SDWActivityDisplayItem *>*)displayActivitiesFromActivities:(NSArray<SDWMActivity *> *)models {
    
    NSMutableArray  <SDWActivityDisplayItem *>*arr = [NSMutableArray arrayWithCapacity:models.count];
    for (SDWMActivity *model in models) {
        SDWActivityDisplayItem *item = [[SDWActivityDisplayItem alloc]initWithModel:model];
        [arr addObject:item];
    }
    
    return [arr copy];
    
}


- (void)handleError:(NSError *)error {

//    CLS_LOG(@"err - %@",error.localizedDescription);
}

- (void)handleError:(NSError *)error withReason:(id)reason {}


- (void)fetchAllAssigneesWithCompletion:(SDWTrelloStoreCompletionBlock)block {

    [[AFTrelloAPIClient sharedClient] GET:@"members/me?fields=none&cards=all&card_fields=idBoard,idList" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {

        SharedSettings.userID = responseObject[@"id"];
        self.crownCardIDs = [responseObject[@"cards"] valueForKeyPath:@"id"];
        NSArray *crownBoardIDs = [responseObject[@"cards"] valueForKeyPath:@"idBoard"];
        NSArray *crownListIDs = [responseObject[@"cards"] valueForKeyPath:@"idList"];
        

        [self.dataModelManager.managedObjectContext performBlockAndWait:^{
            [self.dataModelManager fetchAllEntitiesForName:[SDWMBoard entityName] withPredicate:nil inContext:self.dataModelManager.managedObjectContext withCompletion:^(id fetchedEntities, NSError *error) {
                if (error) {
                    SDWPerformBlock(block,nil,error);
                } else {
                    SDWPerformBlock(block,[SDWTrelloStore displayBoardsFromBoards:fetchedEntities crownBoardIDs:crownBoardIDs crownListIDs:crownListIDs],nil);
                }
            }];
        }];
        



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

         [self.dataModelManager.managedObjectContext performBlockAndWait:^{
             
             SDWMCard *mappedObject =  [SDWMapper ez_objectOfClass:[SDWMCard class] fromJSON:responseObject context:self.dataModelManager.managedObjectContext];

             [self saveContext];
             SDWPerformBlock(block,[[SDWCardDisplayItem alloc]initWithModel:mappedObject],nil);
             
         }];

     } failure:^(NSURLSessionDataTask *task, NSError *error) {

         if(block) block(nil,error);
         [self handleError:error];
     }];

}

- (void)moveCardID:(NSString *)cardID
          toListID:(NSString *)listID
           boardID:(NSString *)boardID {
    
    SDWMCard *card = [self.dataModelManager fetchEntityForName:SDWMCard.entityName withTrelloID:cardID inContext:self.dataModelManager.managedObjectContext];
    
    SDWMList *list = [self.dataModelManager fetchEntityForName:SDWMList.entityName withTrelloID:listID inContext:self.dataModelManager.managedObjectContext];
    
    card.list = list;
    
    

    NSString *urlString = [NSString stringWithFormat:@"cards/%@?",cardID];

    [[AFTrelloAPIClient sharedClient] PUT:urlString parameters:@{
                                                                 @"idList":listID,
                                                                 @"idBoard":boardID,
                                                                 @"pos":@0
                                                                 }
                                  success:^(NSURLSessionDataTask *task, id responseObject)
     {
         
         [self saveContext];


     } failure:^(NSURLSessionDataTask *task, NSError *error) {

         [self handleError:error];
     }];

}

- (void)moveCardID:(NSString *)cardID
        toPosition:(NSNumber *)pos
        completion:(SDWTrelloStoreCompletionBlock)block {
    
    SDWMCard *card = [self.dataModelManager fetchEntityForName:SDWMCard.entityName withTrelloID:cardID inContext:self.dataModelManager.managedObjectContext];
    card.position = pos;
    

    NSString *urlString = [NSString stringWithFormat:@"cards/%@/pos?",cardID];
    [[AFTrelloAPIClient sharedClient] PUT:urlString parameters:@{@"value":pos}
                                  success:^(NSURLSessionDataTask *task, id responseObject)
    {
        
        [self saveContext];
        if(block) block(responseObject,nil);

    } failure:^(NSURLSessionDataTask *task, NSError *error)

    {

        if(block) block(nil,error);
        [self handleError:error];

    }];

}

- (void)updateCard:(SDWCardDisplayItem *)card
    withCompletion:(SDWTrelloStoreCompletionBlock)block {

    NSString *urlString = [NSString stringWithFormat:@"cards/%@?",card.trelloID];
    [[AFTrelloAPIClient sharedClient] PUT:urlString parameters:@{
                                                                 @"name":card.name,
                                                                 @"desc":card.cardDescription ?: @"",
                                                                 @"due":(card.dueDate && (id)card.dueDate != [NSNull null]) ? [NSNumber numberWithLongLong:[card.dueDate timeIntervalSince1970]*1000] : @""
                                                                 }
                                  success:^(NSURLSessionDataTask *task, id responseObject)
     {

         [self.dataModelManager.managedObjectContext performBlockAndWait:^{
             
             SDWMCard *mappedObject =  [SDWMapper ez_objectOfClass:[SDWMCard class] fromJSON:responseObject context:self.dataModelManager.managedObjectContext];
             
             [self saveContext];
             SDWPerformBlock(block,[[SDWCardDisplayItem alloc]initWithModel:mappedObject],nil);
             
         }];
         

     } failure:^(NSURLSessionDataTask *task, NSError *error) {

         if(block) block(nil,error);
         [self handleError:error];

     }];
}

- (void)archiveCardID:(NSString *)cardID
      withCompletion:(SDWTrelloStoreCompletionBlock)block {

    NSString *urlString = [NSString stringWithFormat:@"cards/%@/closed?",cardID];

    [[AFTrelloAPIClient sharedClient] PUT:urlString parameters:@{@"value":@"true"} success:^(NSURLSessionDataTask *task, id responseObject) {
        
        SDWMCard *card = [self.dataModelManager fetchEntityForName:SDWMCard.entityName withTrelloID:cardID inContext:self.dataModelManager.managedObjectContext];
        [self.dataModelManager.managedObjectContext deleteObject:card];
        [self saveContext];

        SDWPerformBlock(block,responseObject,nil);


    } failure:^(NSURLSessionDataTask *task, NSError *error) {

        if(block) block(nil,error);
        [self handleError:error];
    }];
}

- (void)deleteCardID:(NSString *)cardID
      withCompletion:(SDWTrelloStoreCompletionBlock)block {
    

    
    NSString *urlString = [NSString stringWithFormat:@"cards/%@?",cardID];

    [[AFTrelloAPIClient sharedClient] DELETE:urlString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        SDWMCard *card = [self.dataModelManager fetchEntityForName:SDWMCard.entityName withTrelloID:cardID inContext:self.dataModelManager.managedObjectContext];
        [self.dataModelManager.managedObjectContext deleteObject:card];
        [self saveContext];
        SDWPerformBlock(block,responseObject,nil);

        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {

        if(block) block(nil,error);
        [self handleError:error];
    }];
}



- (void)addLabelForCardID:(NSString *)cardID
                       color:(NSString *)color
                  completion:(SDWTrelloStoreCompletionBlock)block {
    
    NSString *urlString = [NSString stringWithFormat:@"cards/%@/labels?",cardID];
    
    [[AFTrelloAPIClient sharedClient] POST:urlString parameters:@{@"color":color} success:^(NSURLSessionDataTask *task, id responseObject) {
        
        SDWMLabel *label = [self.dataModelManager fetchEntityForName:SDWMLabel.entityName withPredicate:[NSPredicate predicateWithFormat:@"color == %@",color] inContext:self.dataModelManager.managedObjectContext];
        SDWMCard *card = [self.dataModelManager fetchEntityForName:SDWMCard.entityName withTrelloID:cardID inContext:self.dataModelManager.managedObjectContext];
        
        
        [card addLabelsObject:label];
        [self saveContext];
        
        SDWPerformBlock(block,responseObject,nil);
        
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
        
        SDWMLabel *label = [self.dataModelManager fetchEntityForName:SDWMLabel.entityName withPredicate:[NSPredicate predicateWithFormat:@"color == %@",color] inContext:self.dataModelManager.managedObjectContext];
         SDWMCard *card = [self.dataModelManager fetchEntityForName:SDWMCard.entityName withTrelloID:cardID inContext:self.dataModelManager.managedObjectContext];
        
        
        [card removeLabelsObject:label];
        [self saveContext];

        SDWPerformBlock(block,responseObject,nil);

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        if(block) block(nil,error);
        [self handleError:error];
    }];

}


#pragma mark - Boards ops

- (void)fetchAllCardsForListID:(NSString *)listID
                   CurrentData:(SDWTrelloStoreCompletionBlock)currentBlock
                   FetchedData:(SDWTrelloStoreCompletionBlock)fetchedBlock
                 crownFiltered:(BOOL)crownFiltered {
    
    
    [self.dataModelManager.managedObjectContext performBlockAndWait:^{
        
        SDWMList *list = [self.dataModelManager fetchEntityForName:[SDWMList entityName] withTrelloID:listID inContext:self.dataModelManager.managedObjectContext];
        SDWPerformBlock(currentBlock,[self displayCardsfromCards:list.cards.allObjects crownFiltered:crownFiltered],nil);

    }];
    
    NSString *urlString = [NSString stringWithFormat:@"lists/%@/cards?lists=open&cards=open",listID];
    
    [[AFTrelloAPIClient sharedClient] GET:urlString
                               parameters:nil
                                  success:^(NSURLSessionDataTask *task, id responseObject)
     {
         
         
         [self.dataModelManager.managedObjectContext performBlockAndWait:^{
             
             NSArray *mappedObjects =  [SDWMapper ez_arrayOfObjectsOfClass:[SDWMCard class] fromJSON:responseObject context:self.dataModelManager.managedObjectContext];
             [self saveContext];
             SDWPerformBlock(fetchedBlock,[self displayCardsfromCards:mappedObjects crownFiltered:crownFiltered],nil);
             
         }];
         
         
     } failure:^(NSURLSessionDataTask *task, NSError *error) {
         SDWPerformBlock(fetchedBlock,nil,error);
         [self handleError:error];
     }];
}

- (void)fetchAllActivitiesForCardID:(NSString *)cardID
                        currentData:(SDWTrelloStoreCompletionBlock)currentBlock
                        fetchedData:(SDWTrelloStoreCompletionBlock)fetchedBlock {
    
    
    [self.dataModelManager.managedObjectContext performBlockAndWait:^{
        
        SDWMCard *card = [self.dataModelManager fetchEntityForName:[SDWMCard entityName] withTrelloID:cardID inContext:self.dataModelManager.managedObjectContext];

        SDWPerformBlock(currentBlock,[SDWTrelloStore displayActivitiesFromActivities:card.activities.allObjects],nil);
        
    }];
    
    NSString *urlString = [NSString stringWithFormat:@"cards/%@/actions?filter=commentCard",cardID];
    
    [[AFTrelloAPIClient sharedClient] GET:urlString
                               parameters:nil
                                  success:^(NSURLSessionDataTask *task, id responseObject)
     {
         
         
         [self.dataModelManager.managedObjectContext performBlockAndWait:^{
             
             NSArray *mappedObjects =  [SDWMapper ez_arrayOfObjectsOfClass:[SDWMActivity class] fromJSON:responseObject context:self.dataModelManager.managedObjectContext];
             SDWMCard *card = [self.dataModelManager fetchEntityForName:[SDWMCard entityName] withTrelloID:cardID inContext:self.dataModelManager.managedObjectContext];
             [card addActivities:[NSSet setWithArray:mappedObjects]];
              [self saveContext];
             SDWPerformBlock(fetchedBlock,[SDWTrelloStore displayActivitiesFromActivities:card.activities.allObjects],nil);
             
         }];
         
         
     } failure:^(NSURLSessionDataTask *task, NSError *error) {
         SDWPerformBlock(fetchedBlock,nil,error);
         [self handleError:error];
     }];
    
}


- (void)fetchUsersForBoardID:(NSString *)boardID
                 currentData:(SDWTrelloStoreCompletionBlock)currentBlock
                 fetchedData:(SDWTrelloStoreCompletionBlock)fetchedBlock {
    [self.dataModelManager.managedObjectContext performBlockAndWait:^{
        
        NSArray <SDWMUser*> *users = [self.dataModelManager fetchEntityForName:[SDWMUser entityName] withTrelloID:boardID inContext:self.dataModelManager.managedObjectContext];
        SDWPerformBlock(currentBlock,[SDWTrelloStore displayUsersFromUsers:users],nil);
        
    }];
    
    NSString *urlString = [NSString stringWithFormat:@"boards/%@/members",boardID];
    
    [[AFTrelloAPIClient sharedClient] GET:urlString
                               parameters:nil
                                  success:^(NSURLSessionDataTask *task, id responseObject)
     {
         
         
         [self.dataModelManager.managedObjectContext performBlockAndWait:^{
             
             NSArray *mappedObjects =  [SDWMapper ez_arrayOfObjectsOfClass:[SDWMUser class] fromJSON:responseObject context:self.dataModelManager.managedObjectContext];

             [self saveContext];
             SDWPerformBlock(fetchedBlock,[SDWTrelloStore displayUsersFromUsers:mappedObjects],nil);
             
         }];
         
         
     } failure:^(NSURLSessionDataTask *task, NSError *error) {
         SDWPerformBlock(fetchedBlock,nil,error);
         [self handleError:error];
     }];
}


- (void)fetchAllBoardsCurrentData:(SDWTrelloStoreCompletionBlock)currentBlock fetchedData:(SDWTrelloStoreCompletionBlock)fetchedBlock
                    crownFiltered:(BOOL)shouldCrownFilter {
    
    if (!shouldCrownFilter) {
        [self.dataModelManager.managedObjectContext performBlockAndWait:^{
            [self.dataModelManager fetchAllEntitiesForName:[SDWMBoard entityName] withPredicate:nil inContext:self.dataModelManager.managedObjectContext withCompletion:^(id fetchedEntities, NSError *error) {
                if (error) {
                    SDWPerformBlock(currentBlock,nil,error);
                } else {
                    SDWPerformBlock(currentBlock,[SDWTrelloStore displayBoardsFromBoards:fetchedEntities],nil);
                }
            }];
        }];
    }

    
    [[AFTrelloAPIClient sharedClient] GET:@"members/me/boards?filter=open&fields=name,starred&lists=open"
                                parameters:nil
                                   success:^(NSURLSessionDataTask *task, id responseObject)
     {
         
         
         [self.dataModelManager.managedObjectContext performBlockAndWait:^{
             
           NSArray *mappedObjects =  [SDWMapper ez_arrayOfObjectsOfClass:[SDWMBoard class] fromJSON:responseObject context:self.dataModelManager.managedObjectContext];
             [self saveContext];
             if (shouldCrownFilter) {
                 
                 [[SDWTrelloStore store] fetchAllAssigneesWithCompletion:^(id objects, NSError *error) {
                     SDWPerformBlock(fetchedBlock,objects,nil);

                 }];
                 
             } else {
              SDWPerformBlock(fetchedBlock,[SDWTrelloStore displayBoardsFromBoards:mappedObjects],nil);
             }
             
             
         }];
         
         
     } failure:^(NSURLSessionDataTask *task, NSError *error) {
         SDWPerformBlock(fetchedBlock,nil,error);
         [self handleError:error];
     }];
}

- (void)createBoardWithName:(NSString *)name
                completion:(SDWTrelloStoreCompletionBlock)block {

    [[AFTrelloAPIClient sharedClient] POST:@"boards?"
                                parameters:@{
                                             @"name":name
                                             }
                                   success:^(NSURLSessionDataTask *task, id responseObject)
     {
         SDWMBoard *mappedObject =  [SDWMapper ez_objectOfClass:[SDWMBoard class] fromJSON:responseObject context:self.dataModelManager.managedObjectContext];
         
         [self saveContext];
         SDWPerformBlock(block,[[SDWBoardDisplayItem alloc]initWithModel:mappedObject],nil);


     } failure:^(NSURLSessionDataTask *task, NSError *error) {

         if(block) block(nil,error);
         [self handleError:error];
     }];
    
}

- (void)renameBoardID:(NSString *)boardID
                 name:(NSString *)newName
           completion:(SDWTrelloStoreCompletionBlock)block {

    NSString *urlString = [NSString stringWithFormat:@"boards/%@/name?",boardID];
    [[AFTrelloAPIClient sharedClient] PUT:urlString
                                  parameters:@{@"value":newName}
                                     success:^(NSURLSessionDataTask *task, id responseObject)
     {

         SDWMBoard *mappedObject =  [SDWMapper ez_objectOfClass:[SDWMBoard class] fromJSON:responseObject context:self.dataModelManager.managedObjectContext];
         
         [self saveContext];
         SDWPerformBlock(block,[[SDWBoardDisplayItem alloc]initWithModel:mappedObject],nil);

     } failure:^(NSURLSessionDataTask *task, NSError *error) {

         if(block) block(nil,error);
         [self handleError:error];
     }];
}

- (void)deleteBoardID:(NSString *)boardID
                 completion:(SDWTrelloStoreCompletionBlock)block {

    NSString *urlString = [NSString stringWithFormat:@"boards/%@?",boardID];
    [[AFTrelloAPIClient sharedClient] DELETE:urlString
                                parameters:@{@"closed":@"true"}
                                   success:^(NSURLSessionDataTask *task, id responseObject)
     {

         
         SDWMBoard *board = [self.dataModelManager fetchEntityForName:SDWMBoard.entityName withTrelloID:boardID inContext:self.dataModelManager.managedObjectContext];
         [self.dataModelManager.managedObjectContext deleteObject:board];
         [self saveContext];
         if(block) block(responseObject,nil);

     } failure:^(NSURLSessionDataTask *task, NSError *error) {

         if(block) block(nil,error);
         [self handleError:error];
     }];
}


#pragma mark - Lists ops

- (void)renameListID:(NSString *)boardID
                name:(NSString *)newName
          completion:(SDWTrelloStoreCompletionBlock)block {

    NSString *urlString = [NSString stringWithFormat:@"lists/%@/name?",boardID];
    [[AFTrelloAPIClient sharedClient] PUT:urlString
                               parameters:@{@"value":newName}
                                  success:^(NSURLSessionDataTask *task, id responseObject)
     {

         SDWMList *mappedObject =  [SDWMapper ez_objectOfClass:[SDWMList class] fromJSON:responseObject context:self.dataModelManager.managedObjectContext];
         
         [self saveContext];
         SDWPerformBlock(block,[[SDWListDisplayItem alloc]initWithModel:mappedObject],nil);

     } failure:^(NSURLSessionDataTask *task, NSError *error) {

         if(block) block(nil,error);
         [self handleError:error];
     }];
}

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

         SDWMList *mappedObject =  [SDWMapper ez_objectOfClass:[SDWMList class] fromJSON:responseObject context:self.dataModelManager.managedObjectContext];
         
         [self saveContext];
         SDWPerformBlock(block,[[SDWListDisplayItem alloc]initWithModel:mappedObject],nil);

     } failure:^(NSURLSessionDataTask *task, NSError *error) {

         if(block) block(nil,error);
         [self handleError:error];
     }];

}

- (void)deleteListID:(NSString *)listID withCompletion:(SDWTrelloStoreCompletionBlock)block {

    NSString *urlString = [NSString stringWithFormat:@"lists/%@?",listID];

    [[AFTrelloAPIClient sharedClient] PUT:urlString parameters:@{@"closed":@"true"} success:^(NSURLSessionDataTask *task, id responseObject) {

        SDWMList *list = [self.dataModelManager fetchEntityForName:SDWMList.entityName withTrelloID:listID inContext:self.dataModelManager.managedObjectContext];
        [self.dataModelManager.managedObjectContext deleteObject:list];
        [self saveContext];
        if(block) block(responseObject,nil);

    } failure:^(NSURLSessionDataTask *task, NSError *error) {

        if(block) block(nil,error);
        [self handleError:error];
    }];
}


#pragma mark - Checklists ops


//- (void)createChecklistWithName:(NSString *)name
//                         cardID:(NSString *)cardID
//                     completion:(SDWTrelloStoreCompletionBlock)block {
//
//    NSString *urlString = [NSString stringWithFormat:@"cards/%@/checklists?",cardID];
//
//    [[AFTrelloAPIClient sharedClient] POST:urlString
//                                parameters:@{@"name":name}
//                                   success:^(NSURLSessionDataTask *task, id responseObject)
//     {
//
//         SDWMChecklist *mappedObject =  [SDWMapper ez_objectOfClass:[SDWMChecklist class] fromJSON:responseObject context:self.dataModelManager.managedObjectContext];
//         
//         [self saveContext];
//         SDWPerformBlock(block,[[SDWChecklistDisplayItem alloc]initWithModel:mappedObject],nil);
//
//     } failure:^(NSURLSessionDataTask *task, NSError *error) {
//         SDWPerformBlock(block,nil,error);
//         [self handleError:error];
//     }];
//}

- (void)fetchAllChecklistsForCardID:(NSString *)cardID
                        CurrentData:(SDWTrelloStoreCompletionBlock)currentBlock
                        FetchedData:(SDWTrelloStoreCompletionBlock)fetchedBlock {
    
    
    [self.dataModelManager.managedObjectContext performBlockAndWait:^{
        
        SDWMCard *card = [self.dataModelManager fetchEntityForName:[SDWMCard entityName] withTrelloID:cardID inContext:self.dataModelManager.managedObjectContext];
        SDWPerformBlock(currentBlock,[SDWTrelloStore displayChecklistsfromChecklists:card.checklists.allObjects],nil);
        
    }];
    
    
    [[AFTrelloAPIClient sharedClient] GET:[NSString stringWithFormat:@"cards/%@/checklists?",cardID]
                               parameters:nil
                                  success:^(NSURLSessionDataTask *task, id responseObject)
     {
         
         
         [self.dataModelManager.managedObjectContext performBlockAndWait:^{
             
             NSArray *mappedObjects =  [SDWMapper ez_arrayOfObjectsOfClass:[SDWMChecklist class] fromJSON:responseObject context:self.dataModelManager.managedObjectContext];
             SDWMCard *card = [self.dataModelManager fetchEntityForName:[SDWMCard entityName] withTrelloID:cardID inContext:self.dataModelManager.managedObjectContext];

             card.checklists = [NSSet setWithArray:mappedObjects];
             [self saveContext];
             SDWPerformBlock(fetchedBlock,[SDWTrelloStore displayChecklistsfromChecklists:mappedObjects],nil);
             
         }];
         
         
     } failure:^(NSURLSessionDataTask *task, NSError *error) {
         SDWPerformBlock(fetchedBlock,nil,error);
         [self handleError:error];
     }];
    
    
}


- (void)moveCheckItem:(SDWChecklistItemDisplayItem *)item
             fromList:(NSString *)initialListID
               toList:(NSString *)newListID
               cardID:(NSString *)cardID
       withCompletion:(SDWTrelloStoreCompletionBlock)block {

    NSString *urlString = [NSString stringWithFormat:@"cards/%@/checklist/%@/checkItem/%@?",cardID,initialListID,item.trelloID];

    [[AFTrelloAPIClient sharedClient] PUT:urlString parameters:@{@"idChecklist":newListID}
                                  success:^(NSURLSessionDataTask *task, id responseObject) {
                                      SDWMChecklistItem *mappedObject =  [SDWMapper ez_objectOfClass:[SDWMChecklistItem class] fromJSON:responseObject context:self.dataModelManager.managedObjectContext];
                                      [self saveContext];
                                      if(block) block([[SDWChecklistItemDisplayItem alloc]initWithModel:mappedObject],nil);

                                  } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                      
                                      if(block) block(nil,error);
                                      [self handleError:error];
                                  }];
}

- (void)updateCheckItem:(SDWChecklistItemDisplayItem *)item
                 cardID:(NSString *)cardID
         withCompletion:(SDWTrelloStoreCompletionBlock)block {

    NSString *urlString = [NSString stringWithFormat:@"cards/%@/checklist/%@/checkItem/%@?",cardID,item.checklist.trelloID,item.trelloID];

    [[AFTrelloAPIClient sharedClient] PUT:urlString parameters:@{
                                                                 @"state":item.state,
                                                                 @"name":item.name,
                                                                 }
                                  success:^(NSURLSessionDataTask *task, id responseObject) {
                            SDWMChecklistItem *mappedObject =  [SDWMapper ez_objectOfClass:[SDWMChecklistItem class] fromJSON:responseObject context:self.dataModelManager.managedObjectContext];
                            [self saveContext];
                            SDWPerformBlock(block,[[SDWChecklistItemDisplayItem alloc]initWithModel:mappedObject],nil);
                                      

    } failure:^(NSURLSessionDataTask *task, NSError *error) {

        if(block) block(nil,error);
        [self handleError:error];
    }];
}

- (void)updateCheckItemPosition:(SDWChecklistItemDisplayItem *)item
                         cardID:(NSString *)cardID
                 withCompletion:(SDWTrelloStoreCompletionBlock)block {

    NSString *urlString = [NSString stringWithFormat:@"cards/%@/checklist/%@/checkItem/%@/pos?",cardID,item.checklist.trelloID,item.trelloID];

    [[AFTrelloAPIClient sharedClient] PUT:urlString parameters:@{@"value":[NSNumber numberWithInteger:item.position]}
                                  success:^(NSURLSessionDataTask *task, id responseObject) {
                                      
                                      SDWMChecklistItem *mappedObject =  [SDWMapper ez_objectOfClass:[SDWMChecklistItem class] fromJSON:responseObject context:self.dataModelManager.managedObjectContext];
                                      [self saveContext];
                                      if(block) block([[SDWChecklistItemDisplayItem alloc]initWithModel:mappedObject],nil);

                                  } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                      
                                      if(block) block(nil,error);
                                      [self handleError:error];
                                  }];

}

- (void)createCheckItemWithName:(NSString *)name
                  inChecklistID:(NSString *)checklistID
                         cardID:(NSString *)cardID
         withCompletion:(SDWTrelloStoreCompletionBlock)block {

    NSString *urlString = [NSString stringWithFormat:@"cards/%@/checklist/%@/checkItem?",cardID,checklistID];

    [[AFTrelloAPIClient sharedClient] POST:urlString parameters:@{
                                                                 @"name":name
                                                                 }
                                  success:^(NSURLSessionDataTask *task, id responseObject) {

                                      [self.dataModelManager.managedObjectContext performBlockAndWait:^{
                                          
                                          SDWMChecklistItem *mappedObject =  [SDWMapper ez_objectOfClass:[SDWMChecklistItem class] fromJSON:responseObject context:self.dataModelManager.managedObjectContext];
                                          
                                          SDWMChecklist *list = [self.dataModelManager fetchEntityForName:[SDWMChecklist entityName] withTrelloID:checklistID inContext:self.dataModelManager.managedObjectContext];
                                          
                                          [list addItemsObject:mappedObject];
                                          [self saveContext];
                                          SDWPerformBlock(block,[[SDWChecklistItemDisplayItem alloc]initWithModel:mappedObject],nil);
                                          
                                          //             CNIPerformBlock(updatedDataHandler, mappedTransactions, nil);
                                      }];
                                      


                                  } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                      
                                      if(block) block(nil,error);
                                      [self handleError:error];
                                  }];

}

- (void)deleteCheckItem:(SDWChecklistItemDisplayItem *)item
                 cardID:(NSString *)cardID
         withCompletion:(SDWTrelloStoreCompletionBlock)block {

    NSString *urlString = [NSString stringWithFormat:@"cards/%@/checklist/%@/checkItem/%@?",cardID,item.checklist.trelloID,item.trelloID];

    [[AFTrelloAPIClient sharedClient] DELETE:urlString parameters:@{
                                                                 @"state":item.state,
                                                                 @"name":item.name
                                                                 }
                                  success:^(NSURLSessionDataTask *task, id responseObject) {
                                      
                                      SDWMChecklistItem *itm = [self.dataModelManager fetchEntityForName:SDWMChecklistItem.entityName withTrelloID:item.trelloID inContext:self.dataModelManager.managedObjectContext];
                                      [self.dataModelManager.managedObjectContext deleteObject:itm];
                                      [self saveContext];

                                      if(block) block(responseObject,nil);

                                  } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                      
                                      if(block) block(nil,error);
                                      [self handleError:error];
                                  }];

}

- (void)deleteCheckList:(SDWChecklistDisplayItem *)checkList
         withCompletion:(SDWTrelloStoreCompletionBlock)block {

    NSString *urlString = [NSString stringWithFormat:@"checklists/%@?",checkList.trelloID];

    [[AFTrelloAPIClient sharedClient] DELETE:urlString parameters:nil
                                     success:^(NSURLSessionDataTask *task, id responseObject) {
                                         SDWMChecklistItem *itm = [self.dataModelManager fetchEntityForName:SDWMChecklistItem.entityName withTrelloID:checkList.trelloID inContext:self.dataModelManager.managedObjectContext];
                                         [self.dataModelManager.managedObjectContext deleteObject:itm];
                                         [self saveContext];
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
                                         
                                         [self.dataModelManager.managedObjectContext performBlockAndWait:^{
                                             
                                             SDWMChecklist *mappedObject =  [SDWMapper ez_objectOfClass:[SDWMChecklist class] fromJSON:responseObject context:self.dataModelManager.managedObjectContext];
                                             
                                             SDWMCard *card = [self.dataModelManager fetchEntityForName:[SDWMCard entityName] withTrelloID:cardID inContext:self.dataModelManager.managedObjectContext];
                                             
                                             [card addChecklistsObject:mappedObject];
                                             [self saveContext];
                                             SDWPerformBlock(block,[[SDWChecklistDisplayItem alloc] initWithModel:mappedObject],nil);
                                             
                                             //             CNIPerformBlock(updatedDataHandler, mappedTransactions, nil);
                                         }];
                                         
                                        

                                     } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                         SDWPerformBlock(block,nil,error);
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
                                      
                                      [self.dataModelManager.managedObjectContext performBlockAndWait:^{
                                          
                                          SDWMChecklist *mappedObject =  [SDWMapper ez_objectOfClass:[SDWMChecklist class] fromJSON:responseObject context:self.dataModelManager.managedObjectContext];
  
                                          [self saveContext];
                                          SDWPerformBlock(block,mappedObject,nil);
                                          
                                          //             CNIPerformBlock(updatedDataHandler, mappedTransactions, nil);
                                      }];

                                      if(block) block(responseObject,nil);

                                  } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                      
                                      if(block) block(nil,error);
                                      [self handleError:error];
                                  }];
}




- (void)clearDataOnDisk {
    [self.dataModelManager resetPersistentStore];
}

#pragma mark - Merchant

- (void)saveContext {
    [self.dataModelManager saveContext];
}



@end

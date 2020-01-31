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

#import "MixpanelTracker.h"


#import "SDWLabelDisplayItem.h"

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

- (void)clearDatabase {
    
    [self.dataModelManager deleteAllEntitiesWithName:@"SDWMBoard" inContext:self.dataModelManager.managedObjectContext];
    [self.dataModelManager.managedObjectContext processPendingChanges];
    [self saveContext];
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

+ (NSArray <SDWLabelDisplayItem *>*)displayLabelsFromLabels:(NSArray<SDWMLabel *> *)modelLabels {
    
    NSMutableArray  <SDWLabelDisplayItem *>*arr = [NSMutableArray arrayWithCapacity:modelLabels.count];
    for (SDWMLabel *model in modelLabels) {
        SDWLabelDisplayItem *item = [[SDWLabelDisplayItem alloc]initWithModel:model];
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

- (NSArray <SDWCardDisplayItem *>*)displayCardsfromCards:(NSArray<SDWMCard *> *)modelCards crownFiltered:(BOOL)crownFiltered {
    
    NSMutableArray  <SDWCardDisplayItem *>*arr = [NSMutableArray arrayWithCapacity:modelCards.count];
    for (SDWMCard *model in modelCards) {
        
         SDWCardDisplayItem *item = [[SDWCardDisplayItem alloc]initWithModel:model];
        if (crownFiltered) {
            
            if([self.crownCardIDs containsObject:item.trelloID]) {
                [arr addObject:item];
            }
            
        } else {
            [arr addObject:item];
        }
       
        
    }
    
    NSSortDescriptor *ageDescriptor = [[NSSortDescriptor alloc] initWithKey:@"position" ascending:YES];
    NSArray *sortDescriptors = @[ageDescriptor];
    
    return [[arr copy] sortedArrayUsingDescriptors:sortDescriptors];
    
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
                    list:(SDWListDisplayItem *)list
                  position:(int64_t)position updatedCard:(SDWTrelloStoreLocalCompletionBlock)block {
    
    if (name.length == 0) {
        return;
    }
    
//    SDWMCard *card = [SDWMCard insertInManagedObjectContext:self.dataModelManager.managedObjectContext];
//    card.name = name;
//    card.positionValue =  position;
//    card.list = list.model;
//    [self saveContext];
//    
    
    MIXPANEL_TRACK_EVENT(@"Create card",NULL);
    

    NSDictionary *params = @{
                             @"name":name,
                             @"due":@"",
                             @"idList":list.trelloID,
                             @"urlSource":@"null"
                             };

    [[AFTrelloAPIClient sharedClient] POST:@"cards?"
                                parameters:params
                                   success:^(NSURLSessionDataTask *task, id responseObject)
     {

         [self.dataModelManager.managedObjectContext performBlockAndWait:^{
             
             SDWMCard *card =  [SDWMapper ez_objectOfClass:[SDWMCard class] fromJSON:responseObject context:self.dataModelManager.managedObjectContext];
             [self saveContext];
             
             SDWPerformBlock(block,[[SDWCardDisplayItem alloc]initWithModel:card])
             [[NSNotificationCenter defaultCenter] postNotificationName:@"SDWListsShouldReloadBoardsDatasourceNotification" object:nil];
             
             
         }];

     } failure:^(NSURLSessionDataTask *task, NSError *error) {

         [self handleError:error];
     }];

}

- (void)moveCardID:(NSString *)cardID
          toListID:(NSString *)listID
           boardID:(NSString *)boardID
        completion:(SDWTrelloStoreLocalCompletionBlock)block {
    
    MIXPANEL_TRACK_EVENT(@"Move card",NULL);

    
    SDWMCard *card = [self.dataModelManager fetchEntityForName:SDWMCard.entityName withUID:cardID inContext:self.dataModelManager.managedObjectContext];
    SDWMBoard *board = [self.dataModelManager fetchEntityForName:SDWMBoard.entityName withUID:boardID inContext:self.dataModelManager.managedObjectContext];
    SDWMList *list = [self.dataModelManager fetchEntityForName:SDWMList.entityName withUID:listID inContext:self.dataModelManager.managedObjectContext];
    
    [card setList:list];
    

    NSString *urlString = [NSString stringWithFormat:@"cards/%@?",card.trelloID];

    [[AFTrelloAPIClient sharedClient] PUT:urlString parameters:@{
                                                                 @"idList":list.trelloID,
                                                                 @"idBoard":board.trelloID,
                                                                 @"pos":@0
                                                                 }
                                  success:^(NSURLSessionDataTask *task, id responseObject)
     {
         
         [self saveContext];
         SDWPerformBlock(block,NULL);


     } failure:^(NSURLSessionDataTask *task, NSError *error) {

         [self handleError:error];
     }];

}

- (void)moveCard:(SDWCardDisplayItem *)card
        toPosition:(NSNumber *)pos {
    
    MIXPANEL_TRACK_EVENT(@"Reorder card",NULL);
    
    SDWMCard *crd = [self.dataModelManager fetchEntityForName:SDWMCard.entityName withUID:card.model.uniqueIdentifier inContext:self.dataModelManager.managedObjectContext];
    crd.position = pos;
    [self saveContext];

    NSString *urlString = [NSString stringWithFormat:@"cards/%@/pos?",card.trelloID];
    [[AFTrelloAPIClient sharedClient] PUT:urlString parameters:@{@"value":pos}
                                  success:^(NSURLSessionDataTask *task, id responseObject)
    {
        
        [self saveContext];

    } failure:^(NSURLSessionDataTask *task, NSError *error)

    {

        [self handleError:error];

    }];

}

- (void)updateCard:(SDWCardDisplayItem *)card
    withCompletion:(SDWTrelloStoreCompletionBlock)block {
    
    MIXPANEL_TRACK_EVENT(@"Update card",NULL);
    
    SDWMCard *crd = card.model;
    crd.name = card.name;
    crd.cardDescription = card.cardDescription;
    crd.dueDate = (card.dueDate && (id)card.dueDate != [NSNull null]) ? card.dueDate : nil;
    [self saveContext];
    

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

- (void)archiveCard:(SDWCardDisplayItem *)card {
    
    MIXPANEL_TRACK_EVENT(@"Archive card",NULL);
    
    SDWMCard *crd = [self.dataModelManager fetchEntityForName:SDWMCard.entityName withUID:card.model.uniqueIdentifier inContext:self.dataModelManager.managedObjectContext];
    [self.dataModelManager.managedObjectContext deleteObject:crd];
    [self saveContext];

    NSString *urlString = [NSString stringWithFormat:@"cards/%@/closed?",card.trelloID];

    [[AFTrelloAPIClient sharedClient] PUT:urlString parameters:@{@"value":@"true"} success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SDWListsShouldReloadBoardsDatasourceNotification" object:nil];



    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self handleError:error];
    }];
}



- (void)addUserToCard:(SDWCardDisplayItem *)card
                       userID:(NSString *)trelloID
                  completion:(SDWTrelloStoreCompletionBlock)block {
    
    MIXPANEL_TRACK_EVENT(@"Add user to card",NULL);
    
    NSString *urlString = [NSString stringWithFormat:@"cards/%@/idMembers?",card.trelloID];
    [[AFTrelloAPIClient sharedClient] POST:urlString parameters:@{@"value":trelloID} success:^(NSURLSessionDataTask *task, id responseObject) {
        

        [self saveContext];
        
        SDWPerformBlock(block,responseObject,nil);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        if(block) block(nil,error);
        [self handleError:error];
    }];
    
}


- (void)removeUserFromCard:(SDWCardDisplayItem *)card
                       userID:(NSString *)trelloID
                  completion:(SDWTrelloStoreCompletionBlock)block {
    
    MIXPANEL_TRACK_EVENT(@"Remove user from card",NULL);
    
    NSString *urlString = [NSString stringWithFormat:@"cards/%@/idMembers/%@?",card.trelloID, trelloID];
    [[AFTrelloAPIClient sharedClient] DELETE:urlString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        

        [self saveContext];
        
        SDWPerformBlock(block,responseObject,nil);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        if(block) block(nil,error);
        [self handleError:error];
    }];
    
}



- (void)addLabelForCard:(SDWCardDisplayItem *)card
                       labelID:(NSString *)trelloID
                  completion:(SDWTrelloStoreCompletionBlock)block {
    
    MIXPANEL_TRACK_EVENT(@"Add label",NULL);
    
    NSString *urlString = [NSString stringWithFormat:@"cards/%@/idLabels?",card.trelloID];
    [[AFTrelloAPIClient sharedClient] POST:urlString parameters:@{@"value":trelloID} success:^(NSURLSessionDataTask *task, id responseObject) {
        

        [self saveContext];
        
        SDWPerformBlock(block,responseObject,nil);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        if(block) block(nil,error);
        [self handleError:error];
    }];
    
}

- (void)removeLabelForCardID:(NSString *)cardID
                       labelID:(NSString *)trelloID
                  completion:(SDWTrelloStoreCompletionBlock)block {
    
    MIXPANEL_TRACK_EVENT(@"Remove label",NULL);

    NSString *urlString = [NSString stringWithFormat:@"cards/%@/idLabels/%@?",cardID, trelloID];

    [[AFTrelloAPIClient sharedClient] DELETE:urlString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
         SDWMLabel *label = [self.dataModelManager fetchEntityForName:SDWMLabel.entityName withPredicate:[NSPredicate predicateWithFormat:@"trelloID == %@",trelloID] inContext:self.dataModelManager.managedObjectContext];
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

- (void)fetchAllCardsForBoard:(SDWBoardDisplayItem *)board
                   CurrentData:(SDWTrelloStoreCompletionBlock)currentBlock
                   FetchedData:(SDWTrelloStoreCompletionBlock)fetchedBlock
                 crownFiltered:(BOOL)crownFiltered {
    
    
    SDWPerformBlock(currentBlock,@[],nil);
    
    [self.dataModelManager.managedObjectContext performBlockAndWait:^{

        SDWMBoard *brd = [self.dataModelManager fetchEntityForName:[SDWMBoard entityName] withUID:board.model.uniqueIdentifier inContext:self.dataModelManager.managedObjectContext];
        SDWPerformBlock(currentBlock,[self displayCardsfromCards:brd.cards.allObjects crownFiltered:crownFiltered],nil);

    }];
    
    NSString *urlString = [NSString stringWithFormat:@"boards/%@/cards/open?limit=10000&members=true",board.trelloID];
    
    [[AFTrelloAPIClient sharedClient] GET:urlString
                               parameters:nil
                                  success:^(NSURLSessionDataTask *task, id responseObject)
     {
         
         
         [self.dataModelManager.managedObjectContext performBlockAndWait:^{
             
             NSArray *mappedObjects =  [SDWMapper ez_arrayOfObjectsOfClass:[SDWMCard class] fromJSON:responseObject context:self.dataModelManager.managedObjectContext];
              SDWMBoard *brd = [self.dataModelManager fetchEntityForName:[SDWMBoard entityName] withUID:board.model.uniqueIdentifier inContext:self.dataModelManager.managedObjectContext];
             [brd addCards:[NSSet setWithArray:mappedObjects]];
             [self saveContext];
             SDWPerformBlock(fetchedBlock,[self displayCardsfromCards:mappedObjects crownFiltered:crownFiltered],nil);
             
         }];
         
         
     } failure:^(NSURLSessionDataTask *task, NSError *error) {
         SDWPerformBlock(fetchedBlock,nil,error);
         [self handleError:error];
     }];
}

- (void)fetchAllCardsForList:(SDWListDisplayItem *)list
                   CurrentData:(SDWTrelloStoreCompletionBlock)currentBlock
                   FetchedData:(SDWTrelloStoreCompletionBlock)fetchedBlock
                 crownFiltered:(BOOL)crownFiltered {
    
    
    
    
    [self.dataModelManager.managedObjectContext performBlockAndWait:^{
        
        SDWMList *lst = [self.dataModelManager fetchEntityForName:[SDWMList entityName] withUID:list.model.uniqueIdentifier inContext:self.dataModelManager.managedObjectContext];
        SDWPerformBlock(currentBlock,[self displayCardsfromCards:lst.cards.allObjects crownFiltered:crownFiltered],nil);

    }];
    
    NSString *urlString = [NSString stringWithFormat:@"lists/%@/cards?lists=open&cards=open&members=true&member_fields=initials,id,fullName",list.trelloID];
    
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

- (void)fetchAllActivitiesForCard:(SDWCardDisplayItem *)card
                        currentData:(SDWTrelloStoreCompletionBlock)currentBlock
                        fetchedData:(SDWTrelloStoreCompletionBlock)fetchedBlock {
    
    NSSortDescriptor *ageDescriptor = [[NSSortDescriptor alloc] initWithKey:@"time" ascending:YES];
    NSArray *sortDescriptors = @[ageDescriptor];
    
    
    [self.dataModelManager.managedObjectContext performBlockAndWait:^{
        
        SDWMCard *crd = [self.dataModelManager fetchEntityForName:[SDWMCard entityName] withUID:card.model.uniqueIdentifier inContext:self.dataModelManager.managedObjectContext];

        SDWPerformBlock(currentBlock,[SDWTrelloStore displayActivitiesFromActivities:[crd.activities.allObjects sortedArrayUsingDescriptors:sortDescriptors]],nil);
        
    }];
    
    NSString *urlString = [NSString stringWithFormat:@"cards/%@/actions?filter=commentCard",card.trelloID];
    
    [[AFTrelloAPIClient sharedClient] GET:urlString
                               parameters:nil
                                  success:^(NSURLSessionDataTask *task, id responseObject)
     {
         
         
         [self.dataModelManager.managedObjectContext performBlockAndWait:^{
             
             NSArray *mappedObjects =  [SDWMapper ez_arrayOfObjectsOfClass:[SDWMActivity class] fromJSON:responseObject context:self.dataModelManager.managedObjectContext];
             SDWMCard *crd = [self.dataModelManager fetchEntityForName:[SDWMCard entityName] withUID:card.model.uniqueIdentifier inContext:self.dataModelManager.managedObjectContext];
             mappedObjects = [mappedObjects sortedArrayUsingDescriptors:sortDescriptors];
             [crd addActivities:[NSSet setWithArray:mappedObjects]];
              [self saveContext];
             SDWPerformBlock(fetchedBlock,[SDWTrelloStore displayActivitiesFromActivities:crd.activities.allObjects],nil);
             
         }];
         
         
     } failure:^(NSURLSessionDataTask *task, NSError *error) {
         SDWPerformBlock(fetchedBlock,nil,error);
         [self handleError:error];
     }];
    
}


- (void)fetchLabelsForBoardID:(NSString *)boardID
                 currentData:(SDWTrelloStoreCompletionBlock)currentBlock
                 fetchedData:(SDWTrelloStoreCompletionBlock)fetchedBlock {
    
    [self.dataModelManager.managedObjectContext performBlockAndWait:^{
        
          SDWMBoard *board = [self.dataModelManager fetchEntityForName:[SDWMBoard entityName] withTrelloID:boardID inContext:self.dataModelManager.managedObjectContext];
        
        NSArray <SDWMLabel*> *labels = [self.dataModelManager fetchAllEntitiesForName:[SDWMLabel entityName] withPredicate:[NSPredicate predicateWithFormat:@"board.trelloID == %@",boardID] inContext:self.dataModelManager.managedObjectContext];
        board.labels = [NSSet setWithArray:labels];
        SDWPerformBlock(currentBlock,[SDWTrelloStore displayLabelsFromLabels:labels],nil);
        
    }];
    
    NSString *urlString = [NSString stringWithFormat:@"boards/%@/labels?",boardID];
    
    [[AFTrelloAPIClient sharedClient] GET:urlString
                               parameters:nil
                                  success:^(NSURLSessionDataTask *task, id responseObject)
     {
         
         
         [self.dataModelManager.managedObjectContext performBlockAndWait:^{
                    
             NSArray *mappedObjects =  [SDWMapper ez_arrayOfObjectsOfClass:[SDWMLabel class] fromJSON:responseObject context:self.dataModelManager.managedObjectContext];
                        SDWMBoard *board = [self.dataModelManager fetchEntityForName:[SDWMBoard entityName] withTrelloID:boardID inContext:self.dataModelManager.managedObjectContext];

                        board.labels = [NSSet setWithArray:mappedObjects];
                        [self saveContext];
             

             SDWPerformBlock(fetchedBlock,[SDWTrelloStore displayLabelsFromLabels:mappedObjects],nil);
             
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
    
    NSString *urlString = [NSString stringWithFormat:@"boards/%@/members?",boardID];
    
    [[AFTrelloAPIClient sharedClient] GET:urlString
                               parameters:nil
                                  success:^(NSURLSessionDataTask *task, id responseObject)
     {
         
         
         [self.dataModelManager.managedObjectContext performBlockAndWait:^{
             
             NSArray *mappedObjects =  [SDWMapper ez_arrayOfObjectsOfClass:[SDWMUser class] fromJSON:responseObject context:self.dataModelManager.managedObjectContext];
             SDWMBoard *board = [self.dataModelManager fetchEntityForName:[SDWMBoard entityName] withTrelloID:boardID inContext:self.dataModelManager.managedObjectContext];

             board.members = [NSSet setWithArray:mappedObjects];
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
    
    __block NSArray *storedBoards;
    if (!shouldCrownFilter) {
        [self.dataModelManager.managedObjectContext performBlockAndWait:^{
            [self.dataModelManager fetchAllEntitiesForName:[SDWMBoard entityName] withPredicate:nil inContext:self.dataModelManager.managedObjectContext withCompletion:^(id fetchedEntities, NSError *error) {
                
                storedBoards = fetchedEntities;
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
             
             NSMutableArray *mutalbleStored = [NSMutableArray arrayWithArray:storedBoards];
             [mutalbleStored removeObjectsInArray:mappedObjects];
             for (SDWMBoard *board in mutalbleStored) {
                 [self.dataModelManager.managedObjectContext deleteObject:board];
             }
             
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

- (void)createBoardWithName:(NSString *)name updatedBoard:(SDWTrelloStoreLocalCompletionBlock)block {
    
    MIXPANEL_TRACK_EVENT(@"Create board",NULL);
    
    SDWMBoard *board = [SDWMBoard insertInManagedObjectContext:self.dataModelManager.managedObjectContext];
    board.name = name;
    [self saveContext];
    
    

    [[AFTrelloAPIClient sharedClient] POST:@"boards?"
                                parameters:@{
                                             @"name":name
                                             }
                                   success:^(NSURLSessionDataTask *task, id responseObject)
     {
         [SDWMapper ez_objectOfClass:[SDWMBoard class] fromJSON:responseObject context:self.dataModelManager.managedObjectContext];
         
         [self saveContext];
         
         SDWPerformBlock(block,[[SDWBoardDisplayItem alloc]initWithModel:board])


     } failure:^(NSURLSessionDataTask *task, NSError *error) {


        [self handleError:error];
     }];
    
}

- (void)renameBoard:(SDWBoardDisplayItem *)board complition:(SDWTrelloStoreLocalCompletionBlock)block {
    
    MIXPANEL_TRACK_EVENT(@"Rename board",NULL);
    
    SDWMBoard *brd = board.model;
    brd.name = board.name;

    [self saveContext];

    NSString *urlString = [NSString stringWithFormat:@"boards/%@/name?",board.trelloID];
    [[AFTrelloAPIClient sharedClient] PUT:urlString
                                  parameters:@{@"value":board.name}
                                     success:^(NSURLSessionDataTask *task, id responseObject)
     {

         [SDWMapper ez_objectOfClass:[SDWMBoard class] fromJSON:responseObject context:self.dataModelManager.managedObjectContext];
          [self saveContext];
         SDWPerformBlock(block,nil);
        

     } failure:^(NSURLSessionDataTask *task, NSError *error) {

         [self handleError:error];
     }];
}

- (void)deleteBoard:(SDWBoardDisplayItem *)board complition:(SDWTrelloStoreLocalCompletionBlock)block {
    
    MIXPANEL_TRACK_EVENT(@"Delete board",NULL);
    
    SDWMBoard *brd = [self.dataModelManager fetchEntityForName:SDWMBoard.entityName withUID:board.model.uniqueIdentifier inContext:self.dataModelManager.managedObjectContext];
    [self.dataModelManager.managedObjectContext deleteObject:brd];
    [self saveContext];

    NSString *urlString = [NSString stringWithFormat:@"boards/%@?",board.trelloID];
    [[AFTrelloAPIClient sharedClient] DELETE:urlString
                                parameters:@{@"closed":@"true"}
                                   success:^(NSURLSessionDataTask *task, id responseObject)
     {

         SDWPerformBlock(block,nil);

     } failure:^(NSURLSessionDataTask *task, NSError *error) {


         [self handleError:error];
     }];
}


#pragma mark - Lists ops

- (void)renameList:(SDWListDisplayItem *)list complition:(SDWTrelloStoreLocalCompletionBlock)block {
    
    MIXPANEL_TRACK_EVENT(@"Rename list",NULL);
    
    SDWMList *lst = list.model;
    lst.name = list.name;
    [self saveContext];
    

    NSString *urlString = [NSString stringWithFormat:@"lists/%@/name?",list.trelloID];
    [[AFTrelloAPIClient sharedClient] PUT:urlString
                               parameters:@{@"value":list.name}
                                  success:^(NSURLSessionDataTask *task, id responseObject)
     {

         [SDWMapper ez_objectOfClass:[SDWMList class] fromJSON:responseObject context:self.dataModelManager.managedObjectContext];
         
         [self saveContext];
         
         SDWPerformBlock(block,nil);

     } failure:^(NSURLSessionDataTask *task, NSError *error) {

         [self handleError:error];
     }];
}

- (void)createListWithName:(NSString *)name
                   inBoard:(SDWBoardDisplayItem *)board
                  position:(NSNumber *)pos
               updatedList:(SDWTrelloStoreLocalCompletionBlock)block {
    
    MIXPANEL_TRACK_EVENT(@"Create list",NULL);

    
    SDWMList *list = [SDWMList insertInManagedObjectContext:self.dataModelManager.managedObjectContext];
    list.name = name;
    list.board = board.model;
    [self saveContext];

    [[AFTrelloAPIClient sharedClient] POST:@"lists?"
                                parameters:@{
                                             @"name":name,
                                             @"idBoard":board.trelloID,
                                             @"pos":@"bottom"
                                             }
                                   success:^(NSURLSessionDataTask *task, id responseObject)
     {

         [SDWMapper ez_objectOfClass:[SDWMList class] fromJSON:responseObject context:self.dataModelManager.managedObjectContext];
         [self saveContext];
         
         SDWPerformBlock(block,[[SDWListDisplayItem alloc]initWithModel:list]);

     } failure:^(NSURLSessionDataTask *task, NSError *error) {

         [self handleError:error];
     }];

}

- (void)deleteList:(SDWListDisplayItem *)list complition:(SDWTrelloStoreLocalCompletionBlock)block {
    
    MIXPANEL_TRACK_EVENT(@"Delete list",NULL);
    
    SDWMList *lst = [self.dataModelManager fetchEntityForName:SDWMList.entityName withUID:list.model.uniqueIdentifier inContext:self.dataModelManager.managedObjectContext];
    [self.dataModelManager.managedObjectContext deleteObject:lst];
    [self saveContext];
    
    

    NSString *urlString = [NSString stringWithFormat:@"lists/%@?",list.trelloID];

    [[AFTrelloAPIClient sharedClient] PUT:urlString parameters:@{@"closed":@"true"} success:^(NSURLSessionDataTask *task, id responseObject) {


        SDWPerformBlock(block,nil);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
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
    
     MIXPANEL_TRACK_EVENT(@"Update checklist item",NULL);

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
    
     MIXPANEL_TRACK_EVENT(@"Reorder checklist item",NULL);

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
    
    MIXPANEL_TRACK_EVENT(@"Create checklist item",NULL);


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
    
     MIXPANEL_TRACK_EVENT(@"Delete checklist item",NULL);

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
    
     MIXPANEL_TRACK_EVENT(@"Delete checklist",NULL);

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
    
    
    MIXPANEL_TRACK_EVENT(@"Create checklist",NULL);

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

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
#import <Crashlytics/Crashlytics.h>
#import "SDWAppSettings.h"
#import "SDWChecklist.h"
#import "SDWMapper.h"
#import "SDWMChecklist.h"

@interface SDWTrelloStore ()

@property (nonatomic, strong) SDWDataModelManager *dataModelManager;

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
                    NSOperationQueue *operationQueue = [AFTrelloAPIClient sharedClient].operationQueue;
                    [operationQueue setSuspended:NO];
                    NSLog(@"WIFI");
                    break;
                }
                case AFNetworkReachabilityStatusNotReachable:
                 {
                    NSOperationQueue *operationQueue = [AFTrelloAPIClient sharedClient].operationQueue;
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

- (void)handleError:(NSError *)error {

//    CLS_LOG(@"err - %@",error.localizedDescription);
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
    
    [self saveContext];

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
    
    [self saveContext];

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

- (void)archiveCardID:(NSString *)cardID
      withCompletion:(SDWTrelloStoreCompletionBlock)block {

    NSString *urlString = [NSString stringWithFormat:@"cards/%@/closed?",cardID];

    [[AFTrelloAPIClient sharedClient] PUT:urlString parameters:@{@"value":@"true"} success:^(NSURLSessionDataTask *task, id responseObject) {

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
                   completion:(SDWTrelloStoreCompletionBlock)block {


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



#pragma mark - Boards ops

- (void)fetchAllCardsForListID:(NSString *)listID
                   CurrentData:(SDWTrelloStoreCompletionBlock)currentBlock
                   FetchedData:(SDWTrelloStoreCompletionBlock)fetchedBlock {
    
    
    [self.dataModelManager.managedObjectContext performBlockAndWait:^{
        
        SDWMList *list = [self.dataModelManager fetchEntityForName:[SDWMList entityName] withTrelloID:listID inContext:self.dataModelManager.managedObjectContext];
        SDWPerformBlock(currentBlock,list.cards.allObjects,nil);

    }];
    
    NSString *urlString = [NSString stringWithFormat:@"lists/%@/cards?lists=open&cards=open",listID];
    
    [[AFTrelloAPIClient sharedClient] GET:urlString
                               parameters:nil
                                  success:^(NSURLSessionDataTask *task, id responseObject)
     {
         
         //         if(block) block(responseObject,nil);
         
         [self.dataModelManager.managedObjectContext performBlockAndWait:^{
             
             NSArray *mappedObjects =  [SDWMapper ez_arrayOfObjectsOfClass:[SDWMCard class] fromJSON:responseObject context:self.dataModelManager.managedObjectContext];
             SDWMList *list = [self.dataModelManager fetchEntityForName:[SDWMList entityName] withTrelloID:listID inContext:self.dataModelManager.managedObjectContext];
             SDWMBoard *board = [self.dataModelManager fetchEntityForName:[SDWMBoard entityName] withTrelloID:list.board.trelloID inContext:self.dataModelManager.managedObjectContext];
             board.cards = [NSSet setWithArray:mappedObjects];
             list.cards = [NSSet setWithArray:mappedObjects];
             [self saveContext];
             SDWPerformBlock(fetchedBlock,mappedObjects,nil);
             
             //             CNIPerformBlock(updatedDataHandler, mappedTransactions, nil);
         }];
         
         
     } failure:^(NSURLSessionDataTask *task, NSError *error) {
         SDWPerformBlock(fetchedBlock,nil,error);
         [self handleError:error];
     }];
}


- (void)fetchAllBoardsCurrentData:(SDWTrelloStoreCompletionBlock)currentBlock fetchedData:(SDWTrelloStoreCompletionBlock)fetchedBlock {
    
    [self.dataModelManager.managedObjectContext performBlockAndWait:^{
        [self.dataModelManager fetchAllEntitiesForName:[SDWMBoard entityName] withPredicate:nil inContext:self.dataModelManager.managedObjectContext withCompletion:^(id fetchedEntities, NSError *error) {
            if (error) {
                SDWPerformBlock(currentBlock,nil,error);
//                CNIPerformBlockOnMainThread(dataHandler, nil, error);
            } else {
                SDWPerformBlock(currentBlock,fetchedEntities,nil);
//                CNIPerformBlockOnMainThread(dataHandler, fetchedEntities, nil);
            }
        }];
    }];
    
    [[AFTrelloAPIClient sharedClient] GET:@"members/me/boards?filter=open&fields=name,starred&lists=open"
                                parameters:nil
                                   success:^(NSURLSessionDataTask *task, id responseObject)
     {
         
//         if(block) block(responseObject,nil);
         
         [self.dataModelManager.managedObjectContext performBlockAndWait:^{
             
           NSArray *mappedObjects =  [SDWMapper ez_arrayOfObjectsOfClass:[SDWMBoard class] fromJSON:responseObject context:self.dataModelManager.managedObjectContext];
             [self saveContext];
             SDWPerformBlock(fetchedBlock,mappedObjects,nil);
             
//             CNIPerformBlock(updatedDataHandler, mappedTransactions, nil);
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

         if(block) block(responseObject,nil);

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

         if(block) block(responseObject,nil);

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

         if(block) block(responseObject,nil);

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

- (void)fetchAllChecklistsForCardID:(NSString *)cardID
                        CurrentData:(SDWTrelloStoreCompletionBlock)currentBlock
                        FetchedData:(SDWTrelloStoreCompletionBlock)fetchedBlock {
    
    
    [self.dataModelManager.managedObjectContext performBlockAndWait:^{
        
        SDWMCard *card = [self.dataModelManager fetchEntityForName:[SDWMCard entityName] withTrelloID:cardID inContext:self.dataModelManager.managedObjectContext];
        SDWPerformBlock(currentBlock,card.checklists.allObjects,nil);
        
    }];
    
    
    [[AFTrelloAPIClient sharedClient] GET:[NSString stringWithFormat:@"cards/%@/checklists?",cardID]
                               parameters:nil
                                  success:^(NSURLSessionDataTask *task, id responseObject)
     {
         
         //         if(block) block(responseObject,nil);
         
         [self.dataModelManager.managedObjectContext performBlockAndWait:^{
             
             NSArray *mappedObjects =  [SDWMapper ez_arrayOfObjectsOfClass:[SDWMChecklist class] fromJSON:responseObject context:self.dataModelManager.managedObjectContext];
             SDWMCard *card = [self.dataModelManager fetchEntityForName:[SDWMCard entityName] withTrelloID:cardID inContext:self.dataModelManager.managedObjectContext];

             card.checklists = [NSSet setWithArray:mappedObjects];
             [self saveContext];
             SDWPerformBlock(fetchedBlock,mappedObjects,nil);
             
             //             CNIPerformBlock(updatedDataHandler, mappedTransactions, nil);
         }];
         
         
     } failure:^(NSURLSessionDataTask *task, NSError *error) {
         SDWPerformBlock(fetchedBlock,nil,error);
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

- (void)moveCheckItem:(SDWMChecklistItem *)item
             fromList:(NSString *)initialListID
               cardID:(NSString *)cardID
       withCompletion:(SDWTrelloStoreCompletionBlock)block {

//    NSString *urlString = [NSString stringWithFormat:@"cards/%@/checklist/%@/checkItem/%@?",cardID,initialListID,item.itemID];
//
//    [[AFTrelloAPIClient sharedClient] PUT:urlString parameters:@{@"idChecklist":item.listID}
//                                  success:^(NSURLSessionDataTask *task, id responseObject) {
//
//                                      if(block) block(responseObject,nil);
//
//                                  } failure:^(NSURLSessionDataTask *task, NSError *error) {
//                                      
//                                      if(block) block(nil,error);
//                                      [self handleError:error];
//                                  }];
}

- (void)updateCheckItem:(SDWMChecklistItem *)item
                 cardID:(NSString *)cardID
         withCompletion:(SDWTrelloStoreCompletionBlock)block {

    NSString *urlString = [NSString stringWithFormat:@"cards/%@/checklist/%@/checkItem/%@?",cardID,item.checklist.trelloID,item.trelloID];

    [[AFTrelloAPIClient sharedClient] PUT:urlString parameters:@{
                                                                 @"state":item.state,
                                                                 @"name":item.name,
                                                                 }
                                  success:^(NSURLSessionDataTask *task, id responseObject) {
                            
                            [self saveContext];
                            SDWPerformBlock(block,responseObject,nil);
                                      

    } failure:^(NSURLSessionDataTask *task, NSError *error) {

        if(block) block(nil,error);
        [self handleError:error];
    }];
}

- (void)updateCheckItemPosition:(SDWMChecklistItem *)item
                         cardID:(NSString *)cardID
                 withCompletion:(SDWTrelloStoreCompletionBlock)block {

//    NSString *urlString = [NSString stringWithFormat:@"cards/%@/checklist/%@/checkItem/%@/pos?",cardID,item.listID,item.itemID];
//
//    [[AFTrelloAPIClient sharedClient] PUT:urlString parameters:@{@"value":[NSNumber numberWithInteger:item.position]}
//                                  success:^(NSURLSessionDataTask *task, id responseObject) {
//
//                                      if(block) block(responseObject,nil);
//
//                                  } failure:^(NSURLSessionDataTask *task, NSError *error) {
//                                      
//                                      if(block) block(nil,error);
//                                      [self handleError:error];
//                                  }];

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
                                          SDWPerformBlock(block,mappedObject,nil);
                                          
                                          //             CNIPerformBlock(updatedDataHandler, mappedTransactions, nil);
                                      }];
                                      


                                  } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                      
                                      if(block) block(nil,error);
                                      [self handleError:error];
                                  }];

}

- (void)deleteCheckItem:(SDWMChecklistItem *)item
                 cardID:(NSString *)cardID
         withCompletion:(SDWTrelloStoreCompletionBlock)block {

//    NSString *urlString = [NSString stringWithFormat:@"cards/%@/checklist/%@/checkItem/%@?",cardID,item.listID,item.itemID];
//
//    [[AFTrelloAPIClient sharedClient] DELETE:urlString parameters:@{
//                                                                 @"state":item.state,
//                                                                 @"name":item.name
//                                                                 }
//                                  success:^(NSURLSessionDataTask *task, id responseObject) {
//
//                                      if(block) block(responseObject,nil);
//
//                                  } failure:^(NSURLSessionDataTask *task, NSError *error) {
//                                      
//                                      if(block) block(nil,error);
//                                      [self handleError:error];
//                                  }];

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
                                         
                                         [self.dataModelManager.managedObjectContext performBlockAndWait:^{
                                             
                                             SDWMChecklist *mappedObject =  [SDWMapper ez_objectOfClass:[SDWMChecklist class] fromJSON:responseObject context:self.dataModelManager.managedObjectContext];
                                             
                                             SDWMCard *card = [self.dataModelManager fetchEntityForName:[SDWMCard entityName] withTrelloID:cardID inContext:self.dataModelManager.managedObjectContext];
                                             
                                             [card addChecklistsObject:mappedObject];
                                             [self saveContext];
                                             SDWPerformBlock(block,mappedObject,nil);
                                             
                                             //             CNIPerformBlock(updatedDataHandler, mappedTransactions, nil);
                                         }];
                                         
                                        

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

//
//  SDWTrelloStore.h
//  Lists
//
//  Created by alex on 1/4/15.
//  Copyright (c) 2015 SDWR. All rights reserved.
//

#import <Foundation/Foundation.h>


#import "SDWDataModelManager.h"


@class SDWCardDisplayItem,SDWMChecklist,SDWMChecklistItem,SDWChecklistItemDisplayItem,SDWChecklistDisplayItem;

typedef void (^SDWTrelloStoreCompletionBlock)(id object, NSError *error);

@interface SDWTrelloStore : NSObject

@property (nonatomic, strong, readonly) SDWDataModelManager *dataModelManager;

+ (instancetype)store;

- (void)handleError:(NSError *)error;
- (void)handleError:(NSError *)error withReason:(id)reason;

/* General */
- (void)fetchAllAssigneesWithCompletion:(SDWTrelloStoreCompletionBlock)block;


/* Cards ops */


//v2
- (void)fetchAllActivitiesForCardID:(NSString *)cardID
                        currentData:(SDWTrelloStoreCompletionBlock)currentBlock
                        fetchedData:(SDWTrelloStoreCompletionBlock)fetchedBlock;


//v2
- (void)fetchAllCardsForListID:(NSString *)listID
                   CurrentData:(SDWTrelloStoreCompletionBlock)currentBlock
                   FetchedData:(SDWTrelloStoreCompletionBlock)fetchedBlock
                 crownFiltered:(BOOL)crownFiltered;

//v2
- (void)createCardWithName:(NSString *)name
                    listID:(NSString *)listID
            withCompletion:(SDWTrelloStoreCompletionBlock)block;

//v2
- (void)moveCardID:(NSString *)cardID
          toListID:(NSString *)listID
           boardID:(NSString *)boardID;

//v2
- (void)moveCardID:(NSString *)cardID
        toPosition:(NSNumber *)pos
        completion:(SDWTrelloStoreCompletionBlock)block;


//v2
- (void)updateCard:(SDWCardDisplayItem *)card
    withCompletion:(SDWTrelloStoreCompletionBlock)block;

//v2
- (void)deleteCardID:(NSString *)cardID
      withCompletion:(SDWTrelloStoreCompletionBlock)block;

//v2
- (void)archiveCardID:(NSString *)cardID
       withCompletion:(SDWTrelloStoreCompletionBlock)block;


//v2
- (void)addLabelForCardID:(NSString *)cardID
                    color:(NSString *)color
               completion:(SDWTrelloStoreCompletionBlock)block;

//v2
- (void)removeLabelForCardID:(NSString *)cardID
                       color:(NSString *)color
                  completion:(SDWTrelloStoreCompletionBlock)block;


/* Boards ops */

//v2
- (void)fetchUsersForBoardID:(NSString *)boardID
                 currentData:(SDWTrelloStoreCompletionBlock)currentBlock
                 fetchedData:(SDWTrelloStoreCompletionBlock)fetchedBlock;

//v2
- (void)fetchAllBoardsCurrentData:(SDWTrelloStoreCompletionBlock)currentBlock
                      fetchedData:(SDWTrelloStoreCompletionBlock)fetchedBlock
                    crownFiltered:(BOOL)shouldCrownFilter;

//v2
- (void)createBoardWithName:(NSString *)name
                 completion:(SDWTrelloStoreCompletionBlock)block;

//v2
- (void)deleteBoardID:(NSString *)name
                 completion:(SDWTrelloStoreCompletionBlock)block;


//v2
- (void)renameBoardID:(NSString *)boardID
                 name:(NSString *)newName
           completion:(SDWTrelloStoreCompletionBlock)block;



/* Lists ops */


//v2
- (void)createListWithName:(NSString *)name
                   boardID:(NSString *)boardID
                  position:(NSNumber *)pos
                completion:(SDWTrelloStoreCompletionBlock)block;

//v2
- (void)deleteListID:(NSString *)listID
      withCompletion:(SDWTrelloStoreCompletionBlock)block;

//v2
- (void)renameListID:(NSString *)boardID
                 name:(NSString *)newName
           completion:(SDWTrelloStoreCompletionBlock)block;




/* Checklists ops */

//v2
- (void)fetchAllChecklistsForCardID:(NSString *)cardID
                   CurrentData:(SDWTrelloStoreCompletionBlock)currentBlock
                   FetchedData:(SDWTrelloStoreCompletionBlock)fetchedBlock;



//v2
- (void)fetchChecklistsForCardID:(NSString *)cardID
                      completion:(SDWTrelloStoreCompletionBlock)block;

- (void)updateCheckItem:(SDWChecklistItemDisplayItem *)item
                 cardID:(NSString *)cardID
         withCompletion:(SDWTrelloStoreCompletionBlock)block;


- (void)createCheckItemWithName:(NSString *)name
                  inChecklistID:(NSString *)checklistID
                         cardID:(NSString *)cardID
                 withCompletion:(SDWTrelloStoreCompletionBlock)block;


//v2
- (void)deleteCheckItem:(SDWChecklistItemDisplayItem *)item
                 cardID:(NSString *)cardID
         withCompletion:(SDWTrelloStoreCompletionBlock)block;

//v2
- (void)updateCheckItemPosition:(SDWChecklistItemDisplayItem *)item
                         cardID:(NSString *)cardID
                 withCompletion:(SDWTrelloStoreCompletionBlock)block;

//v2
- (void)deleteCheckList:(SDWChecklistDisplayItem *)checkList
         withCompletion:(SDWTrelloStoreCompletionBlock)block;


//- (void)createChecklistWithName:(NSString *)name
//                         cardID:(NSString *)cardID
//                     completion:(SDWTrelloStoreCompletionBlock)block;


//v2
- (void)addCheckListForCardID:(NSString *)cardID
               withCompletion:(SDWTrelloStoreCompletionBlock)block;

- (void)updateChecklistName:(NSString *)newName
                  forListID:(NSString *)listID
             withCompletion:(SDWTrelloStoreCompletionBlock)block;


- (void)moveCheckItem:(SDWChecklistItemDisplayItem *)item
             fromList:(NSString *)initialListID
               toList:(NSString *)newListID
               cardID:(NSString *)cardID
       withCompletion:(SDWTrelloStoreCompletionBlock)block;

@end

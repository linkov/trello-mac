//
//  SDWTrelloStore.h
//  Lists
//
//  Created by alex on 1/4/15.
//  Copyright (c) 2015 SDWR. All rights reserved.
//

#import <Foundation/Foundation.h>


#import "SDWDataModelManager.h"


@class SDWCardDisplayItem,SDWMChecklist,SDWMChecklistItem,SDWChecklistItemDisplayItem,SDWChecklistDisplayItem,SDWListDisplayItem,SDWBoardDisplayItem, SDWMLabel, SDWLabelDisplayItem;

typedef void (^SDWTrelloStoreCompletionBlock)(id object, NSError *error);
typedef void (^SDWTrelloStoreLocalCompletionBlock)(id object);

@interface SDWTrelloStore : NSObject

@property (nonatomic, strong, readonly) SDWDataModelManager *dataModelManager;

+ (instancetype)store;

- (void)handleError:(NSError *)error;
- (void)handleError:(NSError *)error withReason:(id)reason;


- (void)clearDatabase;


- (void)fetchAllCardsForTodayCurrentData:(SDWTrelloStoreCompletionBlock)currentBlock
                           crownFiltered:(BOOL)crownFiltered;

/* General */
- (void)fetchAllAssigneesWithCompletion:(SDWTrelloStoreCompletionBlock)block;


/* Cards ops */


//v3
- (void)fetchAllActivitiesForCard:(SDWCardDisplayItem *)card
                      currentData:(SDWTrelloStoreCompletionBlock)currentBlock
                      fetchedData:(SDWTrelloStoreCompletionBlock)fetchedBlock;


//v3

- (void)fetchLabelsForBoardID:(NSString *)boardID
currentData:(SDWTrelloStoreCompletionBlock)currentBlock
                  fetchedData:(SDWTrelloStoreCompletionBlock)fetchedBlock;


- (void)fetchAllCardsForBoard:(SDWBoardDisplayItem *)board
  CurrentData:(SDWTrelloStoreCompletionBlock)currentBlock
  FetchedData:(SDWTrelloStoreCompletionBlock)fetchedBlock
                crownFiltered:(BOOL)crownFiltered;

- (void)fetchAllCardsForList:(SDWListDisplayItem *)list
                 CurrentData:(SDWTrelloStoreCompletionBlock)currentBlock
                 FetchedData:(SDWTrelloStoreCompletionBlock)fetchedBlock
               crownFiltered:(BOOL)crownFiltered;

//v3
- (void)createCardWithName:(NSString *)name
                      list:(SDWListDisplayItem *)list
                  position:(int64_t)position
updatedCard:(SDWTrelloStoreLocalCompletionBlock)block;

//v3
- (void)moveCardID:(NSString *)cardID
          toListID:(NSString *)listID
           boardID:(NSString *)boardID
        completion:(SDWTrelloStoreLocalCompletionBlock)block;

//v3
- (void)moveCard:(SDWCardDisplayItem *)card
      toPosition:(NSNumber *)pos;

//v3
- (void)moveBoard:(SDWListDisplayItem *)board toPosition:(NSString *)pos withCompletion:(SDWTrelloStoreCompletionBlock)block;

//v3
- (void)updateCard:(SDWCardDisplayItem *)card
    withCompletion:(SDWTrelloStoreCompletionBlock)block;



//v3
- (void)archiveCard:(SDWCardDisplayItem *)card;


//v3
- (void)addLabelForCard:(SDWCardDisplayItem *)card
                labelID:(NSString *)trelloID
             completion:(SDWTrelloStoreCompletionBlock)block;

//v2
- (void)removeLabelForCardID:(NSString *)cardID
                     labelID:(NSString *)trelloID
                  completion:(SDWTrelloStoreCompletionBlock)block;


/* Boards ops */

//v2
- (void)fetchUsersForBoardID:(NSString *)boardID
                 currentData:(SDWTrelloStoreCompletionBlock)currentBlock
                 fetchedData:(SDWTrelloStoreCompletionBlock)fetchedBlock;

//v3
- (void)fetchAllBoardsCurrentData:(SDWTrelloStoreCompletionBlock)currentBlock
                      fetchedData:(SDWTrelloStoreCompletionBlock)fetchedBlock
                    crownFiltered:(BOOL)shouldCrownFilter;

//v3
- (void)createBoardWithName:(NSString *)name
                updatedBoard:(SDWTrelloStoreLocalCompletionBlock)block;

//v3
- (void)deleteBoard:(SDWBoardDisplayItem *)board
       complition:(SDWTrelloStoreLocalCompletionBlock)block;


//v3
- (void)renameBoard:(SDWBoardDisplayItem *)board complition:(SDWTrelloStoreLocalCompletionBlock)block;


/* Labels ops */




/* Lists ops */


//v3
- (void)createListWithName:(NSString *)name
                   inBoard:(SDWBoardDisplayItem *)board
                  position:(NSNumber *)pos
               updatedList:(SDWTrelloStoreLocalCompletionBlock)block;

//v3
- (void)deleteList:(SDWListDisplayItem *)list complition:(SDWTrelloStoreLocalCompletionBlock)block;


//v3
- (void)renameList:(SDWListDisplayItem *)list complition:(SDWTrelloStoreLocalCompletionBlock)block;



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


- (void)removeUserFromCard:(SDWCardDisplayItem *)card
     userID:(NSString *)trelloID
                completion:(SDWTrelloStoreCompletionBlock)block;

- (void)addUserToCard:(SDWCardDisplayItem *)card
                       userID:(NSString *)trelloID
           completion:(SDWTrelloStoreCompletionBlock)block;

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

+ (NSArray <SDWLabelDisplayItem *>*)displayLabelsFromLabels:(NSArray<SDWMLabel *> *)modelLabels;
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

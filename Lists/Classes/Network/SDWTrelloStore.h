//
//  SDWTrelloStore.h
//  Lists
//
//  Created by alex on 1/4/15.
//  Copyright (c) 2015 SDWR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDWCard.h"


#import "SDWMList.h"
#import "SDWMBoard.h"
#import "SDWMCard.h"

#import "SDWMChecklistItem.h"

#import "SDWDataModelManager.h"

typedef void (^SDWTrelloStoreCompletionBlock)(id object, NSError *error);

@interface SDWTrelloStore : NSObject

@property (nonatomic, strong, readonly) SDWDataModelManager *dataModelManager;

+ (instancetype)store;

- (void)handleError:(NSError *)error;
- (void)handleError:(NSError *)error withReason:(id)reason;

/* General */
- (void)fetchAllAssigneesWithCompletion:(SDWTrelloStoreCompletionBlock)block;

/* Cards ops */
- (void)fetchAllCardsForListID:(NSString *)listID
                   CurrentData:(SDWTrelloStoreCompletionBlock)currentBlock
                   FetchedData:(SDWTrelloStoreCompletionBlock)fetchedBlock;

- (void)createCardWithName:(NSString *)name
                    listID:(NSString *)listID
            withCompletion:(SDWTrelloStoreCompletionBlock)block;

- (void)moveCardID:(NSString *)cardID
          toListID:(NSString *)listID
           boardID:(NSString *)boardID;

- (void)moveCardID:(NSString *)cardID
        toPosition:(NSNumber *)pos
        completion:(SDWTrelloStoreCompletionBlock)block;


- (void)updateCard:(SDWMCard *)card
    withCompletion:(SDWTrelloStoreCompletionBlock)block;

- (void)deleteCardID:(NSString *)cardID
      withCompletion:(SDWTrelloStoreCompletionBlock)block;

- (void)archiveCardID:(NSString *)cardID
       withCompletion:(SDWTrelloStoreCompletionBlock)block;

- (void)updateLabelsForCardID:(NSString *)cardID
                       colors:(NSString *)colors
                   completion:(SDWTrelloStoreCompletionBlock)block;

- (void)removeLabelForCardID:(NSString *)cardID
                       color:(NSString *)color
                  completion:(SDWTrelloStoreCompletionBlock)block;


/* Boards ops */
- (void)fetchAllBoardsCurrentData:(SDWTrelloStoreCompletionBlock)currentBlock
                      fetchedData:(SDWTrelloStoreCompletionBlock)fetchedBlock;

- (void)createBoardWithName:(NSString *)name
                 completion:(SDWTrelloStoreCompletionBlock)block;
- (void)deleteBoardID:(NSString *)name
                 completion:(SDWTrelloStoreCompletionBlock)block;
- (void)renameBoardID:(NSString *)boardID
                 name:(NSString *)newName
           completion:(SDWTrelloStoreCompletionBlock)block;

/* Lists ops */

- (void)createListWithName:(NSString *)name
                   boardID:(NSString *)boardID
                  position:(NSNumber *)pos
                completion:(SDWTrelloStoreCompletionBlock)block;

- (void)deleteListID:(NSString *)listID
      withCompletion:(SDWTrelloStoreCompletionBlock)block;

- (void)renameListID:(NSString *)boardID
                 name:(NSString *)newName
           completion:(SDWTrelloStoreCompletionBlock)block;


/* Checklists ops */

- (void)fetchAllChecklistsForCardID:(NSString *)cardID
                   CurrentData:(SDWTrelloStoreCompletionBlock)currentBlock
                   FetchedData:(SDWTrelloStoreCompletionBlock)fetchedBlock;

- (void)createChecklistWithName:(NSString *)name
                         cardID:(NSString *)cardID
                     completion:(SDWTrelloStoreCompletionBlock)block;

- (void)fetchChecklistsForCardID:(NSString *)cardID
                      completion:(SDWTrelloStoreCompletionBlock)block;

- (void)updateCheckItem:(SDWMChecklistItem *)item
                 cardID:(NSString *)cardID
         withCompletion:(SDWTrelloStoreCompletionBlock)block;


- (void)createCheckItemWithName:(NSString *)name
                  inChecklistID:(NSString *)checklistID
                         cardID:(NSString *)cardID
                 withCompletion:(SDWTrelloStoreCompletionBlock)block;


- (void)deleteCheckItem:(SDWMChecklistItem *)item
                 cardID:(NSString *)cardID
         withCompletion:(SDWTrelloStoreCompletionBlock)block;

- (void)updateCheckItemPosition:(SDWMChecklistItem *)item
                         cardID:(NSString *)cardID
                 withCompletion:(SDWTrelloStoreCompletionBlock)block;

- (void)deleteCheckList:(SDWMChecklist *)checkList
         withCompletion:(SDWTrelloStoreCompletionBlock)block;

- (void)addCheckListForCardID:(NSString *)cardID
               withCompletion:(SDWTrelloStoreCompletionBlock)block;

- (void)updateChecklistName:(NSString *)newName
                  forListID:(NSString *)listID
             withCompletion:(SDWTrelloStoreCompletionBlock)block;

- (void)moveCheckItem:(SDWMChecklistItem *)item
             fromList:(NSString *)initialListID
               cardID:(NSString *)cardID
       withCompletion:(SDWTrelloStoreCompletionBlock)block;

@end

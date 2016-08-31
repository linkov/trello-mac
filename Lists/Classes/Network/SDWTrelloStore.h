//
//  SDWTrelloStore.h
//  Lists
//
//  Created by alex on 1/4/15.
//  Copyright (c) 2015 SDWR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDWCard.h"
#import "SDWChecklistItem.h"
#import "SDWChecklist.h"

typedef void (^SDWTrelloStoreCompletionBlock)(id object, NSError *error);

@interface SDWTrelloStore : NSObject

+ (instancetype)store;

- (void)handleError:(NSError *)error;
- (void)handleError:(NSError *)error withReason:(id)reason;

/* General */
- (void)fetchAllAssigneesWithCompletion:(SDWTrelloStoreCompletionBlock)block;

/* Cards ops */
- (void)createCardWithName:(NSString *)name
                    listID:(NSString *)listID
            withCompletion:(SDWTrelloStoreCompletionBlock)block;

- (void)moveCardID:(NSString *)cardID
          toListID:(NSString *)listID
           boardID:(NSString *)boardID;

- (void)moveCardID:(NSString *)cardID
        toPosition:(NSNumber *)pos
        completion:(SDWTrelloStoreCompletionBlock)block;


- (void)updateCard:(SDWCard *)card
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
- (void)createBoardWithName:(NSString *)name
                 completion:(SDWTrelloStoreCompletionBlock)block;
- (void)deleteBoardID:(NSString *)name
                 completion:(SDWTrelloStoreCompletionBlock)block;


/* Lists ops */
- (void)createListWithName:(NSString *)name
                   boardID:(NSString *)boardID
                  position:(NSNumber *)pos
                completion:(SDWTrelloStoreCompletionBlock)block;

- (void)deleteListID:(NSString *)listID
      withCompletion:(SDWTrelloStoreCompletionBlock)block;



/* Checklists ops */
- (void)createChecklistWithName:(NSString *)name
                         cardID:(NSString *)cardID
                     completion:(SDWTrelloStoreCompletionBlock)block;

- (void)fetchChecklistsForCardID:(NSString *)cardID
                      completion:(SDWTrelloStoreCompletionBlock)block;

- (void)updateCheckItem:(SDWChecklistItem *)item
                 cardID:(NSString *)cardID
         withCompletion:(SDWTrelloStoreCompletionBlock)block;

- (void)createCheckItem:(SDWChecklistItem *)item
                 cardID:(NSString *)cardID
         withCompletion:(SDWTrelloStoreCompletionBlock)block;


- (void)deleteCheckItem:(SDWChecklistItem *)item
                 cardID:(NSString *)cardID
         withCompletion:(SDWTrelloStoreCompletionBlock)block;

- (void)updateCheckItemPosition:(SDWChecklistItem *)item
                         cardID:(NSString *)cardID
                 withCompletion:(SDWTrelloStoreCompletionBlock)block;

- (void)deleteCheckList:(SDWChecklist *)checkList
         withCompletion:(SDWTrelloStoreCompletionBlock)block;

- (void)addCheckListForCardID:(NSString *)cardID
               withCompletion:(SDWTrelloStoreCompletionBlock)block;

- (void)updateChecklistName:(NSString *)newName
                  forListID:(NSString *)listID
             withCompletion:(SDWTrelloStoreCompletionBlock)block;

- (void)moveCheckItem:(SDWChecklistItem *)item
             fromList:(NSString *)initialListID
               cardID:(NSString *)cardID
       withCompletion:(SDWTrelloStoreCompletionBlock)block;

@end

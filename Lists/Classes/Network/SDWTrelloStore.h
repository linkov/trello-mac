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

- (void)updateLabelsForCardID:(NSString *)cardID
                       colors:(NSString *)colors
                   completion:(SDWTrelloStoreCompletionBlock)block;

- (void)removeLabelForCardID:(NSString *)cardID
                       color:(NSString *)color
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

@end

//
//  SDWddNamedItemVC.m
//  Lists
//
//  Created by alex on 8/31/16.
//  Copyright © 2016 SDWR. All rights reserved.
//

#import "SDWAddNamedItemVC.h"
#import "SDWAppSettings.h"

@interface SDWAddNamedItemVC () <NSTextFieldDelegate>
@property (strong) IBOutlet NSTextField *mainTextField;
@property BOOL shouldCancel;
@end

@implementation SDWAddNamedItemVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mainTextField.delegate = self;

    NSDictionary *attributes = @{NSFontAttributeName: self.mainTextField.font, NSForegroundColorAttributeName:[[SDWAppSettings sharedSettings] appUIColor]};

    self.mainTextField.placeholderAttributedString = [[NSAttributedString alloc] initWithString:self.titleString attributes:attributes];

    self.mainTextField.editable = NO;
    [self.mainTextField resignFirstResponder];


}

- (void)awakeFromNib {

    self.shouldCancel = NO;

}

- (IBAction)didCancel:(id)sender {


    self.shouldCancel = YES;

    if (self.delegate) {
        [self.delegate addItemVCDidFinishWithName:nil didCancel:YES];
    }
}



#pragma mark - NSTextFieldDelegate

- (BOOL)control:(NSControl *)control textShouldBeginEditing:(NSText *)fieldEditor {



    NSTextField *textField = self.mainTextField;
    NSColor *insertionPointColor = [NSColor whiteColor];

    NSTextView *fEditor = (NSTextView*)[textField.window fieldEditor:YES
                                                               forObject:textField];
    fEditor.insertionPointColor = insertionPointColor;

    return YES;
}

- (BOOL)control:(NSControl *)control textShouldEndEditing:(NSText *)fieldEditor {
    
    if (self.delegate && !self.shouldCancel) {
        if ([self.mainTextField.stringValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet] ].length == 0) {

            [self.delegate addItemVCDidFinishWithName:nil didCancel:YES];
        } else {
            self.shouldCancel = YES;
            [self.delegate addItemVCDidFinishWithName:self.mainTextField.stringValue didCancel:NO];

        }
    }


    return YES;
}


@end

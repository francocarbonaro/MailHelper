//
//  MailHelper.h
//
//  Created by Franco on 02/06/10.
//  Copyright 2010 Finger Tips. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface MailHelper : MFMailComposeViewController <MFMailComposeViewControllerDelegate> {
	
@private
	NSMutableArray *_attachmentsFiles;
	UIViewController *_mainController;	
	NSMutableDictionary *_mimeTypeDictionary;
}

- (MailHelper *)initWithMailTo:(NSString *)mailTo MailSubject:(NSString *)mailSubject MailMessageBody:(NSString *)mailMessagBody MailMessageBodyIsHTML:(BOOL) mailMessageBodyIsHTML;
- (MailHelper *)initWithMailSubject:(NSString *)mailSubject MailMessageBody:(NSString *)mailMessagBody MailMessageBodyIsHTML:(BOOL) mailMessageBodyIsHTML;

- (BOOL)canSendMail;
- (void)displayMailCompose:(UIViewController *)controller;
- (void)addAttachmentFileToArray:(NSString *)fileName Type:(NSString *)fileMimeType;

@end
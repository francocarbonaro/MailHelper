//
//  MailHelper.h
//
//  Created by Franco on 02/06/10.
//  Copyright 2010 Finger Tips. All rights reserved.
//

#import "MailHelper.h"


@interface MailHelper (Private)
- (void)_addAttachmentsFiles;
- (void)_setMimeTypeDictionary;
@end

@implementation MailHelper

#pragma mark -
#pragma mark Initializers


- (MailHelper *)initWithMailTo:(NSString *)mailTo MailSubject:(NSString *)mailSubject MailMessageBody:(NSString *)mailMessagBody MailMessageBodyIsHTML:(BOOL) mailMessageBodyIsHTML{
	self = [super init];
	
	if (self != nil) {
        
		if (![mailTo isEqualToString:@""]) {
			[self setToRecipients: [[NSArray alloc] initWithObjects:mailTo, nil]];
		}
		
		if (![mailSubject isEqualToString:@""]) {
			[self setSubject:mailSubject];
		}
		
		if (![mailMessagBody isEqualToString:@""]) {
			[self setMessageBody:mailMessagBody isHTML:mailMessageBodyIsHTML];
		}
		
		self.mailComposeDelegate = self;
	}
	
    return self;	
}

- (MailHelper *)initWithMailSubject:(NSString *)mailSubject MailMessageBody:(NSString *)mailMessagBody MailMessageBodyIsHTML:(BOOL) mailMessageBodyIsHTML{
	return [self initWithMailTo:@"" MailSubject:mailSubject MailMessageBody:mailMessagBody MailMessageBodyIsHTML:mailMessageBodyIsHTML];
}

#pragma mark -
#pragma mark Methods

- (BOOL)canSendMail{
	
	Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
	
	if (mailClass != nil)
	{
		if ([mailClass canSendMail])
		{
			return YES;
		}
	}
	
	return NO;
}

- (void)displayMailCompose:(UIViewController *)controller{
	
	if ([self canSendMail]) {
/*		MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
		mail.mailComposeDelegate = self;
*/		
		_mainController = controller;
		
		if ([_attachmentsFiles count] > 0) {
			[self _addAttachmentsFiles];
		}
		
		[_mainController presentModalViewController:self animated:YES];		
	}
}

- (void)addAttachmentFileToArray:(NSString *)fileName Type:(NSString *)fileType{
	NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
	[dictionary setObject: fileName forKey: @"fileName"];
	[dictionary setObject: fileType forKey: @"fileType"];
	
	if (_attachmentsFiles == nil) {
		_attachmentsFiles = [[NSMutableArray alloc] init];
	}
	
	[_attachmentsFiles addObject: dictionary];
	
	[dictionary release];
}

#pragma mark -
#pragma mark Private Methods

- (void)_setMimeTypeDictionary{
	_mimeTypeDictionary = [[NSMutableDictionary alloc] init]; 
	[_mimeTypeDictionary setObject: @"image/jpeg" forKey: @"jpg"];
	[_mimeTypeDictionary setObject: @"image/jpeg" forKey: @"jpeg"];
	[_mimeTypeDictionary setObject: @"image/gif" forKey: @"gif"];
	[_mimeTypeDictionary setObject: @"image/png" forKey: @"png"];
	[_mimeTypeDictionary setObject: @"application/pdf" forKey: @"pdf"];	
}

- (void)_addAttachmentsFiles{
	
	NSMutableDictionary *dictionary = nil;
	NSString *path = @"";
	NSData *fileData;
	
	[self _setMimeTypeDictionary];
	
	for (NSInteger i = 0; i < [_attachmentsFiles count]; i++) {
		dictionary = [_attachmentsFiles objectAtIndex: i];
		path = [[NSBundle mainBundle] pathForResource: [dictionary objectForKey: @"fileName"] ofType: [dictionary objectForKey: @"fileType"]];
		fileData = [NSData dataWithContentsOfFile:path];
		
		[self addAttachmentData:fileData mimeType: [_mimeTypeDictionary objectForKey: [dictionary objectForKey: @"fileType"]] fileName: [dictionary objectForKey: @"fileName"]];		
	}
	
	dictionary = nil;	
	path = nil;
	fileData = nil;
	
	[dictionary release];	
	[path release];
	[fileData release];
	
}

#pragma mark -
#pragma mark Mail Delegate

// Dismisses the email composition interface when users tap Cancel or Send. Proceeds to update the message field with the result of the operation.
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error 
{   
    //message.hidden = NO;
    // Notifies users about errors associated with the interface
    switch (result)
    {
        case MFMailComposeResultCancelled:
			NSLog(@"Cancelled");
			break;
        case MFMailComposeResultSaved:
            NSLog(@"Saved");
			break;
        case MFMailComposeResultSent:
            NSLog(@"Sent");
			break;
        case MFMailComposeResultFailed:
            NSLog(@"Failed");
			break;
        default:
			NSLog(@"Default");
            break;
    }
	
    [_mainController dismissModalViewControllerAnimated:YES];
}



@end

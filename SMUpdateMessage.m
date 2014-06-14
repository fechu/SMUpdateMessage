//
//  SMUpdateMessage.m
//
//  Created by Sandro Meier on 20.02.12.
//  Copyright (c) 2012 FidelisFactory. All rights reserved.
//

#import "SMUpdateMessage.h"

#define LAST_ID_KEY @"SMUpdateMessageLastID"

@interface SMUpdateMessage ()

/**
 Zeigt eine Nachricht mit den übergebenen Daten an. 
 */
- (void)showMessageWithTitle:(NSString *)title 
                     message:(NSString *)message 
                  andButtons:(NSArray *)buttonTitles;

@end

@implementation SMUpdateMessage {
    
    NSURLConnection *connection;
    NSMutableData *receivedData;
    NSString *encoding;
    
    NSDictionary *messageData;
}

@synthesize url;
@synthesize lastID;

- (id)init
{
    self = [super init];
    if (self) {
        lastID = -1;
    }
    return self;
}

- (void)showMessage
{
    if (url == nil) {
        // Raise an exception if no url is given.
        [[NSException exceptionWithName:@"InvalidURLException"
                                 reason:@"No URL was set in SMUpdateMessage"
                               userInfo:nil] raise];
    }
    
    // Replace __VERSION__ in the url
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = infoDic[@"CFBundleShortVersionString"];
    NSString *urlString = [url stringByReplacingOccurrencesOfString:@"__VERSION__"
                                                         withString:appVersion];
    
    // Create the request and start it.
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    receivedData = [NSMutableData data];
    connection = [[NSURLConnection alloc] initWithRequest:request
                                                 delegate:self
                                         startImmediately:YES];
    if (!connection) {
        NSLog(@"SMUpdateMessage: No connection to server");
    }
}

- (void)showMessageWithTitle:(NSString *)title
                     message:(NSString *)message
                  andButtons:(NSArray *)buttonTitles
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:nil 
                                          otherButtonTitles:nil];
    
    // Add the buttons
    for (NSString *buttonTitle in buttonTitles) {
        [alert addButtonWithTitle:buttonTitle];
    }
    
    // Show the alert
    [alert show];
    
    // Call the block that the alert was shown.
    if (self.showMessageBlock) {
        self.showMessageBlock([messageData[@"id"] intValue]);
    }
}

#pragma UIAlertViewDelegate Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSArray *buttons = messageData[@"buttons"];
    NSDictionary *button = [buttons objectAtIndex:buttonIndex];
    
    // Call the block that a button was clicked
    if (self.buttonTouchedBlock) {
        self.buttonTouchedBlock([messageData[@"id"] intValue], button);
    }
    
    if ([button[@"action"] isEqualToString:@"url"]) {
        // Open the url
        NSURL *openUrl = [NSURL URLWithString:button[@"url"]];
        [[UIApplication sharedApplication] openURL:openUrl];
    }
}

#pragma NSURLConnection Delegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // Perhaps a redirection occured. So we reset the received data.
    [receivedData setLength:0];
    
    // Get the encoding. 
    encoding = [response textEncodingName];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // Append the received data.
    [receivedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // We finished loading. 
    
    // Parse the json.
    NSError *error = nil;
    messageData = [NSJSONSerialization JSONObjectWithData:receivedData
                                                  options:NSJSONReadingMutableLeaves
                                                    error:&error];
    if (messageData == nil) {
        NSLog(@"SMUpdateMessage: Received data could not be parsed");
        return;
    }
    
    // Show the message if its a new message
    if ([[messageData objectForKey:@"id"] intValue] != self.lastID) {
        // Get the data
        NSString *title = messageData[@"title"];
        NSString *message = messageData[@"message"];
        NSArray *buttons = messageData[@"buttons"];
        
        // Get the button names
        NSMutableArray *buttonNames = [NSMutableArray array];
        for (NSDictionary *buttonDic in buttons) {
            [buttonNames addObject:buttonDic[@"title"]];
        }
        
        [self showMessageWithTitle:title message:message andButtons:buttonNames];
        
        // Update the id.
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:messageData[@"id"] forKey:LAST_ID_KEY];
    }
    else {
        NSLog(@"SMUpdateMessage: Message with id %d already shown!", self.lastID);
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"SMUpdateMessage: Connection failed");
}

#pragma Getter

- (int)lastID
{
    if (lastID == -1) {
         // Load the last ID.
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        lastID = [[defaults objectForKey:LAST_ID_KEY] intValue];
    }
    
    return lastID;
}

@end

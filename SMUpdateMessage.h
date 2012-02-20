//
//  SMUpdateMessage.h
//
//  Created by Sandro Meier on 20.02.12.
//  Copyright (c) 2012 FidelisFactory. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMUpdateMessage : NSObject <NSURLConnectionDataDelegate, UIAlertViewDelegate>{
    NSURLConnection *connection;
    NSMutableData *receivedData;
    NSString *encoding;
    
    NSDictionary *messageData;
}

/**
 Der URL wo die News gespeichert sind.
 */
@property(nonatomic, strong) NSURL *url;

/**
 Die ID der letzten Nachricht die angezeigt wurde.
 */
@property(nonatomic, readonly) int lastID;

/**
 Lädt die Nachricht herunter und zeigt sie an, wenn es eine neue ist.
 */
- (void)showMessage;

@end

/**
 @file SMUpdateMessage.h
 @author Sandro Meier <sandro.meier@fidelisfactory.ch>
 @copyright 2012 FidelisFactory
 */

#import <Foundation/Foundation.h>

@interface SMUpdateMessage : NSObject <NSURLConnectionDataDelegate, UIAlertViewDelegate>{
    NSURLConnection *connection;
    NSMutableData *receivedData;
    NSString *encoding;
    
    NSDictionary *messageData;
}

/**
 Der URL wo die News gespeichert sind.
 Ein URL wird normalerweise das Format "http://www.example.com/news.json" haben. 
 Falls das benötigt wird, kann "__VERSION__" im String verwendet werden. Das wird
 vor dem absenden des Requests ersetzt durch den Versionen String der Applikation. (z.B. 1.0.0)
 Beispiel: 
    http://www.example.com/news.php?version=__VERSION__
 In der Version 1.0.0 der Applikatin würde der URL so aussehen: 
    http://www.example.com/news.php?version=1.0.0
 */
@property(nonatomic, strong) NSString *url;

/**
 Die ID der letzten Nachricht die angezeigt wurde.
 Stellen Sie sicher dass die ID der Nachricht auf dem Server eindeutig ist. 
 Es kann sonst vorkommen, dass die Nachricht mehr als einmal angezeigt wird.
 */
@property(nonatomic, readonly) int lastID;

/**
 Lädt die Nachricht herunter und zeigt sie an, wenn es eine neue ist.
 */
- (void)showMessage;

@end

# SMUpdateMessage

SMUpdateMessage ist eine Klasse die an einem angegebenen Ort (URL) nach einer Nachricht sucht die angezeigt werden soll.
Das Resultat ist eine AlertView mit der Nachricht und eventuellen Buttons.

## Daten

Die Daten werden als JSON online gespeichert. Ein Beispiel kann so aussehen:

    {
     "id"      : 1,
     "title"   : "Test Titel",
     "message" : "Die Nachricht die angezeigt werden soll",
     "buttons" : [
      {
       "title" : "Schliessen",
       "action": "cancel",
      },
      {
       "title" : "Google",
       "action": "url",
       "url"   : "http://www.google.ch"
      }
     ]
    }

## Anwendung

Am besten wird die Klasse im AppDelegate instanziert und ausgeführt. Als erstes die SMUpdateMessage.h Datei importieren.

    #import "SMUpdateMessage.h"

Dann muss im AppDelegate.h eine Instanzvariable hinzugefügt werden. 

    SMUpdateMessage *message;

In der Methode 

    - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions

wird dann eine Instanz erstellt und ihr beauftragt die Nachricht anzuzeigen.

    // Check for news.
    message = [[SMUpdateMessage alloc] init];
    message.url = [NSURL URLWithString:@"http://www.example.com/path/to/update.json"];
    [message showMessage];

Nun wird von der Applikation eine UIAlertView angezeigt, falls die Nachricht eine Andere ist oder noch keine angezeigt wurde. 

## Neue Nachricht

Das anzeigen einer anderen Nachricht ist einfach. Passen sie den Text in der JSON Datei an. Am Schluss ändern Sie die ID. Erhöhen sie sie um 1. Dann wird die Nachricht auf den Devices beim nächsten Start angezeigt.
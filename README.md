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
    
Ob es sich dabei um ein File handelt oder ein Skript (z.B. PHP) spielt keine Rolle. Die klasse erwartet als Antwort auf den Request ein JSON Objekt wie das oben abgebildete. 

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
    message.url = @"http://www.example.com/path/to/update.json";
    [message showMessage];

Im URL kann `__VERSION__` verwendet werden. Dies wird vor dem abschicken des Requests durch den Wert des `CFBundleShortVersionString`ersetzt. 

Beispiel:  
`http://example.com/news.php?version=__VERSION__` wird zu `http://example.com/news.php?version=1.0.0`

## Neue Nachricht

Das anzeigen einer anderen Nachricht ist einfach. Passen sie den Text in der JSON Datei an. Am Schluss ändern Sie die ID. Erhöhen sie sie um 1. Dann wird die Nachricht auf den Geräten beim nächsten Start angezeigt. 

## Lizenz (MIT)

Copyright (C) 2012 - Today FidelisFactory

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
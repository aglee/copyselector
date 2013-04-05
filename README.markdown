# CopySelector

This service tries to detect an Objective-C method name in your selected text. If it succeeds, it puts the selector into the system paste buffer. Otherwise, it beeps.

It's assumed that you've selected either a selector, a method declaration, or a method invocation. The algorithm tries to be forgiving and not require you to be 100% precise about where you start and end the text selection.

## Installation

To install this service, copy CopySelector.service into ~/Library/Services. If you use the service often, you'll want to assign a hotkey in System Preferences > Keyboard > Keyboard Shortcuts > Services. You may need to relaunch applications to get them to see the service.

To uninstall, delete CopySelector.service from ~/Library/Services. You might have to first kill the service's process before you can do this. You can use Activity Monitor or the kill command to kill the process.

## Examples

Here are examples of text fragments that you can select that the algorithm can handle. You can probably figure it out for yourself without all these explicit examples, but they're helpful to me for testing purposes.

Plain selector:

    flyToX:y:z:

Method declaration (class methods work too):

    - (id)browser:(NSBrowser *)browser child:(NSInteger)index ofItem:(id)item;

You don't have to select precisely all the way to the end:

    - (id)browser:(NSBrowser *)browser child:(NSInteger)index ofItem:(i

Whitespace and comments are ignored:

    // Detects browser:child:ofItem:.
    - (id)browser:(NSBrowser *) browser  // comment
            child: (NSInteger)index  /* comment */
           ofItem:(id)item;

No-argument method invocation:

    [myButton sizeToFit];

Method invocation with arguments:

    [self flyToX:100 y:200 z:300];

You can be sloppy and select past the end:

    [self flyToX:100 y:200 z:300] ]; }

The brackets themselves don't have to be included in the selection:

    self flyToX:100 y:200 z:300

(This means that if you are in BBEdit, where double-clicking a bracket selects the text *inside* the brackets, the service still works.)

When messages are nested or contain subexpressions, the top-level message is detected (in this case, flyToX:y:z:):

    [[self pilot] flyToX:100 y:(150 + 50) z:[self zCoord]];

Typecasts are ignored:

    (void)[(Aviator *)self flyToX:100 y:200 z:300];

Object literals and struct literals are supported:

    [self useNumber:@(2 + 2)
              array:@[@"four"]
               dict:@{ @"count": @4 }
               rect:(NSRect){ {0, 0}, { 2, 2 } }];

Method arguments can be blocks. The service detects beginSheetModalForWindow:completionHandler: if you select the following lines:

    [op beginSheetModalForWindow:[self window]
               completionHandler:^(NSInteger result) {
                   if (result == NSFileHandlingPanelCancelButton)
                   {
                       return;
                   }

                   NSString *selectedFilePath = [[op URL] path];

                   if (selectedFilePath)
                   {
                       [self parseFileAtPath:selectedFilePath];
                   }
               }];

## Known issues

The algorithm can't deal with assignment. For example, it doesn't work if you select this whole line:

    BOOL didFly = [self flyToX:100 y:200 z:300];

I probably won't fix this, as it looks like it would be hairy to reliably parse all possibilities for the left-hand side. The workaround is to begin your selection after the equals sign.

## See also

* I've had this idea for a while but was only prompted to action when I saw [this tweet](http://twitter.com/mikeabdullah/status/319036829401772032) from Mike Abdullah. Please file a dupe of [Mike's Radar](http://www.openradar.me/13555307) requesting this feature in Xcode.

* Kevin Callahan's Accessorizer has a [copy-selector feature](http://www.kevincallahan.org/software/accessorizerHelp/Selectors.html), and even has an option to wrap the selector in "@selector()", which is a clever idea. I use Accessorizer all the time, but it has so many features it was easy to overlook this one. One difference CopySelector has is the ability to parse selectors from method invocations (as opposed to declarations or definitions).

* Check out this open-source [Xcode plugin](https://github.com/omz/Dash-Plugin-for-Xcode) that integrates Xcode's inline documentation viewer with [Dash](http://kapeli.com/). It could probably be modified to do what CopySelector does, and you wouldn't have to select the whole method name; you'd only have to have the cursor in it.

## Ideas

### Multi-line service

It would be nice to have a similar service to break a line containing a multi-part selectors into multiple lines. For example, start with

    - (id)browser:(NSBrowser *)browser child:(NSInteger)index ofItem:(id)item

and generate

    - (id)browser:(NSBrowser *)browser
            child:(NSInteger)index
           ofItem:(id)item

And maybe a service to do the opposite as well.

Of course, even nicer would be if all the above operations were built into Xcode -- although CopySelector could still be useful when you want to copy a selector that's not in Xcode, like in an email.

### Accessorizer's "wrapping" feature

It might be nice to have a "Copy Wrapped Selector" option along the lines of Accessorizer's "wrapped" feature.


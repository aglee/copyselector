# CopySelector

A teeny app that does nothing but provide a "Copy with Selector Awareness" system service.

"Copy with Selector Awareness" is a service that you can invoke from any application where you have selected some text. It tries to find a method name in that text, and if successful it puts the selector in the system paste buffer. If a method name is not detected, a regular Copy is performed.

For example, in Xcode if you have [self flyToX:100 y:200 z:300], you can double-click one of the square brackets to select the whole expression, then invoke this service. CopySelector will search for the method name flyToX:y:z:.

If you happen to be in BBEdit, where double-clicking a bracket selects the text inside the brackets, the service should still work. If there is leading whitespace or a cast, or newlines or comments anywhere, it should still work, so if you have lines like this you can select them all and then invoke the service:

    (void)[self flyToX:100  // cast to void to discard the return value
                     y:200
                     z:900 /*300*/];

Note that CopySelector doesn't work if there is an assignment in the selected text. For example, it won't detect the selector if you select this whole line:

    BOOL didFly = [self flyToX:100 y:200 z:300];

The workaround is to select just the message-send -- the part after the "=" -- by double-clicking one of the square brackets.

Another intended use is when you're looking at code that declares a method and you want to copy that method name. For example, you can select these lines and CopySelector will detect "browser:child:ofItem:" (the "-(id)" will be ignored):

    - (id)browser:(NSBrowser *)browser
            child:(NSInteger)index
           ofItem:(id)item

This service assumes well-formed Objective-C. You might get unexpected results otherwise. If there are nested messages, it uses the top-level one. The algorithm mainly looks at punctuation -- delimiters like brackets and a few other characters that need special treatment. The basic idea is that it ignores anything between delimiters, like (blah blah blah), [blah blah blah], or {blah blah blah}. For this reason it should work if your selected code contains blocks or the new object literals. You can often be a bit imprecise in the text you select and it will still work.

The implementation of this service uses the AKMethodExtractor class ([.h file](https://github.com/aglee/appkido/blob/master/src/GlobalClasses/AKMethodNameExtractor.h), [.m file](https://github.com/aglee/appkido/blob/master/src/GlobalClasses/AKMethodNameExtractor.m)) from the [AppKiDo](http://appkido.com) project. AppKiDo uses it to provide a similar service, except it performs a search on the selector instead of putting it in the paste buffer. You're welcome to use this class in your own code -- for example, if you want to implement your own CopySelector service.

## Credits

I've had this idea for a while but was only prompted to action when I saw [this tweet](http://twitter.com/mikeabdullah/status/319036829401772032) from Mike Abdullah. Please file a dupe of [Mike's Radar](http://www.openradar.me/13555307) requesting this feature in Xcode.

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

### App flicker

When you invoke "Copy with Selector Awareness", the app becomes active and immediately hides itself. I couldn't figure out how to make it not become active; I suspect this is not possible. I wonder if I could avoid the app flicker by installing a standalone .service bundle.


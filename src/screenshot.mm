#include "./screenshot.h"

#import <Cocoa/Cocoa.h>

using namespace v8;

class PiWorker
    : public NanAsyncWorker
{
public:
    PiWorker(NanCallback *callback, const std::string& appName)
        : NanAsyncWorker(callback)
        , appName_([NSString stringWithUTF8String:appName.c_str()])
        , img_(NULL)
    {}

    ~PiWorker() {}

    // Executed inside the worker-thread.
    // It is not safe to access V8, or V8 data structures
    // here, so everything we need for input and output
    // should go on `this`.
    void Execute() {
        if(!TakeScreenshot_(GetWindowID_())) {
            SetErrorMessage(error_.c_str());
        }
    }

    // Executed when the async work is complete
    // this function will be run inside the main event loop
    // so it is safe to use V8 again
    void HandleOKCallback() {
        NanScope();

        Local<Value> argv[] = {
            NanNull(),
            NanNewBufferHandle((const char*)img_.bytes, img_.length)
        };

        callback->Call(2, argv);
    };

private:
    ///
    int GetWindowID_() {
        CGWindowListOption listOptions = kCGWindowListOptionOnScreenOnly | kCGWindowListExcludeDesktopElements;
        CFArrayRef windowList = CGWindowListCopyWindowInfo(listOptions, kCGNullWindowID);

        for(NSMutableDictionary* entry in (NSArray*)windowList) {
            NSString* ownerName = [entry objectForKey: (id)kCGWindowOwnerName];
            NSNumber* wnumber = [entry objectForKey: (id)kCGWindowNumber];
            NSNumber* wlevel = [entry objectForKey: (id)kCGWindowLayer];

            // Only interested on windows at 0 level only
            if([wlevel integerValue] == 0 && [ownerName isEqualToString:appName_]) {
                return [wnumber integerValue];
            }
        }

        return 0;
    }

    ///
    bool TakeScreenshot_(const int windowID) {
        CGImageRef cgImage = CGWindowListCreateImage(CGRectNull, kCGWindowListOptionIncludingWindow, windowID, kCGWindowImageBoundsIgnoreFraming);

        if(cgImage == NULL) {
            error_ = "CGWindowListCreateImage failed!";
            return false;
        }

        NSBitmapImageRep* bitmapRep = [[NSBitmapImageRep alloc] initWithCGImage:cgImage];
        img_ = [bitmapRep representationUsingType: NSPNGFileType properties: nil];
        CGImageRelease(cgImage);
        return true;
    }

    NSString* appName_;
    NSData* img_;
    std::string error_;
};

NAN_METHOD(getScreenshot) {
    NanScope();

    Local<String> appName = args[0].As<String>();
    NanCallback *callback = new NanCallback(args[1].As<Function>());

    NanAsyncQueueWorker(new PiWorker(callback, *NanUtf8String(appName)));
    NanReturnUndefined();
}

#include "./screenshot.h"

#import <Cocoa/Cocoa.h>

NAN_METHOD(getScreenshot) {
  NanScope();

  // int points = args[0]->Uint32Value();
  // NanCallback *callback = new NanCallback(args[1].As<Function>());
  NSLog(@"o.O");

  NanReturnUndefined();
}

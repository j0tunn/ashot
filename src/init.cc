#include <nan.h>
#include "./screenshot.h"

using namespace v8;

///
void InitAll(Handle<Object> exports) {
    exports->Set(NanNew<String>("getScreenshot"),
        NanNew<FunctionTemplate>(getScreenshot)->GetFunction());
}

NODE_MODULE(ashot, InitAll)

\ jni library wrapper

Vocabulary jni

get-current also jni definitions

c-library jnilib
    s" ((struct JNI:*(Cell*)(x.spx[arg0])" ptr-declare $+[]!
    \c #define JNINativeInterface_ JNINativeInterface
    \c #define JNIInvokeInterface_ JNIInvokeInterface
    \c #include <jni.h>
    include unix/jni.fs
    
end-c-library

previous set-current
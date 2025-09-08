# Mantener todas las clases de Sceneform
-keep class com.google.ar.sceneform.** { *; }
-keep interface com.google.ar.sceneform.** { *; }
-dontwarn com.google.ar.sceneform.**

# Mantener ARCore
-keep class com.google.ar.core.** { *; }
-dontwarn com.google.ar.core.**

# Mantener desugar runtime
-keep class com.google.devtools.build.android.desugar.runtime.** { *; }
-dontwarn com.google.devtools.build.android.desugar.runtime.**
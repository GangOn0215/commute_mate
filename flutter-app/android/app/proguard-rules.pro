# Flutter 앱을 위한 ProGuard 규칙
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# Kakao SDK
-keep class com.kakao.sdk.** { *; }
-keep class com.kakao.** { *; }

# Gson (Dio 사용 시)
-keepattributes Signature
-keepattributes *Annotation*
-dontwarn sun.misc.**
-keep class com.google.gson.** { *; }
-keep class * implements com.google.gson.TypeAdapterFactory
-keep class * implements com.google.gson.JsonSerializer
-keep class * implements com.google.gson.JsonDeserializer

# OkHttp (Dio 내부 사용)
-dontwarn okhttp3.**
-dontwarn okio.**
-keep class okhttp3.** { *; }
-keep interface okhttp3.** { *; }

# Google Play Core (Flutter 내부 사용)
-dontwarn com.google.android.play.core.**
-keep class com.google.android.play.core.** { *; }

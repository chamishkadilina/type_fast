# Flutter Local Notifications
-keep class com.dexterous.flutterlocalnotifications.** { *; }
-keep class com.google.gson.** { *; }

# Gson specific rules
-keepattributes Signature
-keepattributes *Annotation*
-dontwarn sun.misc.**
-keep class * extends com.google.gson.TypeAdapter
-keep class * implements com.google.gson.TypeAdapterFactory
-keep class * implements com.google.gson.JsonSerializer
-keep class * implements com.google.gson.JsonDeserializer
-keepclassmembers,allowobfuscation class * {
  @com.google.gson.annotations.SerializedName <fields>;
}

# Timezone data
-keep class com.google.android.gms.common.util.DateUtils { *; }
-keepclassmembers class org.threeten.bp.** { *; }

# Flutter Local Notifications Plugin specific
-keep class com.dexterous.** { *; }
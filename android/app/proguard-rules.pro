# Suppress warnings for AutoValue (common in OpenTelemetry/Firebase)
-dontwarn com.google.auto.value.**
-keep class com.google.auto.value.** { *; }

# General fix for missing metadata warnings
-dontwarn javax.annotation.**
-dontwarn org.checkerframework.** 
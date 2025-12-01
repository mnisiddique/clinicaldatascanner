# ----- ML Kit text recognition keep rules -----
-keep class com.google.mlkit.** { *; }
-dontwarn com.google.mlkit.**

# Needed for Chinese, Japanese, Korean, Devanagari recognizers
-keep class com.google.mlkit.vision.text.chinese.** { *; }
-keep class com.google.mlkit.vision.text.japanese.** { *; }
-keep class com.google.mlkit.vision.text.korean.** { *; }
-keep class com.google.mlkit.vision.text.devanagari.** { *; }

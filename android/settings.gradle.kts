pluginManagement {
    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }

    val flutterSdkPath = run {
        val properties = java.util.Properties()
        val propertiesFile = File(settingsDir, "local.properties")
        if (propertiesFile.exists()) {
            propertiesFile.reader(Charsets.UTF_8).use { reader -> properties.load(reader) }
        }
        val sdkPath = properties.getProperty("flutter.sdk")
        requireNotNull(sdkPath) { "flutter.sdk not set in local.properties" }
        sdkPath
    }

    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")
}

plugins {
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"
    id("com.android.application") version "8.9.1" apply false
    id("org.jetbrains.kotlin.android") version "2.1.0" apply false
}

include(":app")
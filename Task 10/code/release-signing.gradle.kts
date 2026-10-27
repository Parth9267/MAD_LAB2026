// Snippet transcribed from Figure 6. Place inside the android block of
// android/app/build.gradle.kts after loading keystoreProperties locally.
signingConfigs {
    create("release") {
        keyAlias = keystoreProperties.getProperty("keyAlias")
        keyPassword = keystoreProperties.getProperty("keyPassword")
        storeFile = keystoreProperties.getProperty("storeFile")?.let { file(it) }
        storePassword = keystoreProperties.getProperty("storePassword")
    }
}
buildTypes {
    release {
        signingConfig = signingConfigs.getByName("release")
    }
}

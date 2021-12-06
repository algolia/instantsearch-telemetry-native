import com.diffplug.gradle.spotless.SpotlessExtension

plugins {
    kotlin("multiplatform")
    id("kotlinx-serialization")
    id("com.vanniktech.maven.publish")
    id("com.diffplug.spotless")
}

kotlin {
    explicitApi()
    jvm()
    ios()
    sourceSets {
        all {
            languageSettings {
                optIn("kotlin.RequiresOptIn")
                optIn("kotlinx.serialization.ExperimentalSerializationApi")
            }
        }
        val commonMain by getting {
            dependencies {
                implementation(libs.kotlinx.serialization.protobuf)
            }
        }
        val commonTest by getting {
            dependencies {
                implementation(libs.test.kotlin.common)
                implementation(libs.test.kotlin.annotations)
            }
        }
        val jvmTest by getting {
            dependencies {
                implementation(libs.test.kotlin.junit)
            }
        }
    }
}

configure<SpotlessExtension> {
    kotlin {
        target("**/*.kt")
        ktlint("0.43.0")
        trimTrailingWhitespace()
        endWithNewline()
    }
}

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
                optIn("kotlinx.serialization.ExperimentalSerializationApi")
                optIn("kotlinx.coroutines.ExperimentalCoroutinesApi")
            }
        }
        val commonMain by getting {
            dependencies {
                implementation(libs.kotlinx.coroutines.core)
                implementation(libs.kotlinx.serialization.protobuf)
                implementation(libs.kotlinx.atomicfu)
            }
        }
        val commonTest by getting {
            dependencies {
                implementation(libs.test.kotlin.common)
                implementation(libs.test.kotlin.annotations)
                implementation(libs.kotlinx.coroutines.test)
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
        trimTrailingWhitespace()
        endWithNewline()
    }
}

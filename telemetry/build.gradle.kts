import com.diffplug.gradle.spotless.SpotlessExtension
import org.jetbrains.kotlin.gradle.dsl.KotlinMultiplatformExtension
import org.jetbrains.kotlin.gradle.plugin.mpp.KotlinNativeTarget

plugins {
    kotlin("multiplatform")
    id("kotlinx-serialization")
    id("com.vanniktech.maven.publish")
    id("com.diffplug.spotless")
}

kotlin {
    explicitApi()
    jvm()
    darwin()
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

fun KotlinMultiplatformExtension.darwin() {
    val targets = mutableListOf<KotlinNativeTarget>().apply {
        // iOS
        add(iosArm32())
        add(iosArm64())
        add(iosX64())
        add(iosSimulatorArm64())
        // macOS
        add(macosArm64())
        add(macosX64())
        // tvOS
        add(tvosArm64())
        add(tvosX64())
        add(tvosSimulatorArm64())
        // watchOS
        add(watchosArm32())
        add(watchosArm64())
        add(watchosX64())
        add(watchosX86())
        add(watchosSimulatorArm64())
    }
    kotlin.sourceSets.apply {
        val darwinMain by creating { dependsOn(getByName("commonMain")) }
        val darwinTest by creating { dependsOn(getByName("commonTest")) }
        configure(targets) {
            sourceSets.getByName("${name}Main").dependsOn(darwinMain)
            sourceSets.getByName("${name}Test").dependsOn(darwinTest)
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

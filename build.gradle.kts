import com.diffplug.gradle.spotless.SpotlessExtension

buildscript {
    val kotlinVersion by extra("1.5.31")
    repositories {
        mavenCentral()
    }
    dependencies {
        classpath(kotlin("gradle-plugin", version = kotlinVersion))
        classpath(kotlin("serialization", version = kotlinVersion))
        classpath("com.vanniktech:gradle-maven-publish-plugin:0.18.0")
        classpath("com.diffplug.spotless:spotless-plugin-gradle:5.15.0")
    }
}

subprojects {
    apply(plugin = "com.diffplug.spotless")
    repositories {
        mavenCentral()
    }
    configure<SpotlessExtension> {
        kotlin {
            target("**/*.kt")
            ktlint("0.43.0")
            trimTrailingWhitespace()
            endWithNewline()
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.buildDir)
}

tasks.register<Copy>("generate") {
    dependsOn(":generator:run")
}

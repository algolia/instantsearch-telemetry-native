@Suppress("DSL_SCOPE_VIOLATION")
plugins {
    alias(libs.plugins.kotlin.multiplaform) apply false
    alias(libs.plugins.kotlinx.serialization) apply false
    alias(libs.plugins.maven.publish) apply false
    alias(libs.plugins.spotless) apply false
}

tasks.register<Delete>("clean") {
    delete(rootProject.buildDir)
}

tasks.register("generate") {
    dependsOn(":generator:run")
}

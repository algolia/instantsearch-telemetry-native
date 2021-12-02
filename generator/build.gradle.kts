plugins {
    id("org.jetbrains.kotlin.jvm")
    application
}

dependencies {
    implementation(project(":telemetry"))
    implementation(libs.kotlinx.serialization.protobuf)
}

application {
    mainClass.set("com.algolia.instantsearch.telemetry.generator.MainKt")
}

tasks.withType<JavaExec> {
    workingDir = rootDir
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
    
    // Fix namespace issue for isar_flutter_libs with newer AGP
    if (project.name == "isar_flutter_libs") {
        afterEvaluate {
            val androidExtension = project.extensions.findByName("android") as? com.android.build.gradle.LibraryExtension
            androidExtension?.namespace = "dev.isar.isar_flutter_libs"
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}

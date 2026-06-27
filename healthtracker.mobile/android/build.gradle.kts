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
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}

subprojects {
    val configureNdk: Project.() -> Unit = {
        val android = extensions.findByName("android")
        if (android != null) {
            (android as? com.android.build.api.dsl.CommonExtension<*, *, *, *, *, *>)?.apply {
                ndkVersion = "30.0.14904198"
            }
        }
    }
    if (state.executed) {
        configureNdk()
    } else {
        afterEvaluate { configureNdk() }
    }
}

#!/usr/bin/env groovy

@Library(["skillsoft-ci-pipeline"]) _

loadproperties.defaultProperties()


node('innrd87') {
    def deployOptions = [
            podName       : "mailhog-coaching",
            buildType     : "node-notest",
            // The test folder cannot be an empty string.
            testFolder    : "test-results",
            namespace     : "coaching",
            additionalTags: [],
            buildOptions  : [
                    skipLinting: true
                ]
    ]
    common(deployOptions)
}

pipeline {

    agent any

    options {
        timestamps()
    }

    stages {
        stage('Build') {
            steps {
                echo 'This is Build stage' // To be removed later   
                sh 'rm -f build.tgz' // Removing old archive
                sh 'npm install' // Installing required modules
                sh 'cd public/ && mkdir -p blogfiles && ./getblogs.sh'
                sh 'tar -czf build.tgz *' // Archiving all files into one
                archiveArtifacts artifacts: 'build.tgz', fingerprint: true, followSymlinks: false // Saving archive
            }
        }

        stage('Test') {
            parallel {
                stage('Lint') {
                    steps {
                        echo 'Linting...'
                        // catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
                        catchError {
                        sh 'npm run eslint -- -f checkstyle -o eslint.xml'
                        }
                    }
                    post {
                        always {
                        // Warnings Next Generation Plugin
                        recordIssues enabledForFailure: true, tools: [esLint(pattern: 'eslint.xml')]
                        }
                    }
                }

                stage('Unit Test') {
                    steps {
                        echo 'this is Unit Testing stage'
                        sh 'npm run test'
                    }
                }
            }
        }

        stage('Deploy') {
            steps {
                echo 'This is Deploy stage'
                // Now move artifact to AWS server and extract archive into /var/www/html
                sshPublisher(publishers: [sshPublisherDesc(configName: 'Web', 
                transfers: [sshTransfer(cleanRemote: false, excludes: '', execCommand: 'tar -xzf build.tgz -C /var/www/html/ && cd /var/www/html/ && BUILD_ID=dontKillMe ./runme.sh', execTimeout: 120000, flatten: false, makeEmptyDirs: false, noDefaultExcludes: false, patternSeparator: '[, ]+', remoteDirectory: '', remoteDirectorySDF: false, removePrefix: '', sourceFiles: 'build.tgz')], 
                usePromotionTimestamp: false, useWorkspaceInPromotion: false, verbose: false)])
            }
        }

        stage('e2e Test') {
            steps {
                echo 'This is e2e stage: cyprus'
                // Leave ssh
                // sh 'exit'
                // sh './node_modules/.bin/cypress open'
                // sh 'unset DISPLAY && DEBUG=cypress:* npx cypress run'
            }
        }
            
    }

}
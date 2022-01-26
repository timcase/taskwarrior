pipeline {
    agent any
    stages {
        stage('test') {
            steps {
                sh 'echo $SHELL'
                sh '~/.rbenv/bin/rbenv version'
            }
        }
    }
}

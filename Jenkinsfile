pipeline {
    agent any
    stages {
        stage('test') {
            steps {
                sh 'rbenv version'
                sh 'gem list bundler'
            }
        }
    }
}

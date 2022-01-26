pipeline {
    agent any
    stages {
        stage('test') {
            steps {
                sh 'source /home/jenkins/.bashrc'
                sh 'rbenv version'
                sh 'gem list bundler'
            }
        }
    }
}

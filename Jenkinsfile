pipeline {
    agent any
    stages {
        stage('test') {
            steps {
                sh 'source /home/jenkins/.bashrc; rbenv version'
                sh 'gem list bundler'
            }
        }
    }
}

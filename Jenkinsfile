pipeline {
    agent any
    stages {
        stage('test') {
            steps {
                sh 'ruby --version'
                sh 'gem list bundler'
                sh './bin/setup'
                sh '~/.rbenv/shims/rake test'
            }
        }
    }
}

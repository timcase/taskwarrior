pipeline {
    agent any
    stages {
        stage('test') {
            steps {
                sh './bin/setup'
                sh '~/.rbenv/shims/rake test'
            }
        }
    }
}

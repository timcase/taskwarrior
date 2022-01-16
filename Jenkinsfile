pipeline {
    agent any
    stages {
        stage('test') {
            steps {
                sh './Initfile'
                sh '~/.rbenv/shims/rake test'
            }
        }
    }
}

pipeline {
    agent any
    stages {
        stage('test') {
            steps {
                sh '/home/jenkins/.rbenv/shims/bundle install'
                sh '/home/jenkins/.rbenv/shims/rake test'
            }
        }
    }
}

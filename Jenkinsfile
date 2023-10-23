#!/usr/bin/env groovy

pipeline {
    agent {
        docker {
            image 'node'
            args '-u root'
        }
    }
    environment {
        CI = 'true'
    }
    options {
            timeout(time: 20, unit: 'SECONDS')
    }

    parameters {
        booleanParam(name: "TEST", defaultValue: false)
    }

    stages {
        stage('Build') {
            steps {
                echo 'Building...'
                sh 'npm install'
            }
        }
        stage('Test') {
            steps {
		script {
		    if (params.TEST) {
			sh 'npm test'
		    }
		}
            }
        }
    }
}

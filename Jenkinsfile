#!/usr/bin/env groovy

pipeline {
    agent {
        docker {
            image 'node'
            args '-u root'
        }
    }
<<<<<<< HEAD
    options {
            timeout(time: 20, unit: 'SECONDS')
    }
=======
    environment {
        CI = 'true'
    }
    options {
            timeout(time: 20, unit: 'SECONDS')
    }

    parameters {
        booleanParam(name: "TEST", defaultValue: false)
	string(name: "APP_PORT", defaultValue: '8000')
    }

>>>>>>> staging
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
			sh "APP_PORT=${params.APP_PORT} npm test"
		    }
		}
            }
        }
    }
}

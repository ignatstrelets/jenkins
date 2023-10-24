#!/usr/bin/env groovy

pipeline {

    parameters {
    booleanParam(name: "TEST", defaultValue: false)
    string(name: "APP_PORT", defaultValue: '8000')
    string(name: "REMOTE_USER", defaultValue: 'ubuntu')
    string(name: "REMOTE_HOST", defaultValue: 'ip-172-31-27-214')
    string(name: "DOCKER_IMAGE", defaultValue: '')
    }
    
    environment {
        CI = 'true'
    }
    agent none
    options {
            timeout(time: 20, unit: 'SECONDS')
    }

    stages {
        stage('Build') {
		agent {
			label 'docker'
			docker {
                	    image 'node'
        	            args "-p ${params.APP_PORT}:${params.APP_PORT} -u root "
	                }
		}
                echo 'Building...'
                sh 'npm install'
	        echo "Docker container running on ${params.APP_PORT} with CI ${env.CI}"
            }
        stage('Test') {
	    agent {
		    label 'docker'
	    }
            steps {
		script {
		    if (params.TEST) {
			sh "docker ps -a"
			sh "APP_PORT=${params.APP_PORT} npm test"
		    }
		}
            }
        }
	stage('Deploy') {
            agent any
	    steps {
		sh "whoami"
		sh "scp deploy.sh ${params.REMOTE_USER}@${params.REMOTE_HOST}:~/"
		sh "ssh ${params.REMOTE_USER}@${params.REMOTE_HOST} 'chmod +x deploy.sh'"
		sh "ssh ${params.REMOTE_USER}@${params.REMOTE_HOST} 'DOCKER_IMAGE=${params.DOCKER_IMAGE}'"
		sh "ssh ${params.REMOTE_USER}@${params.REMOTE_HOST} 'bash -s < ./deploy.sh'"
	    }
	}
    }
}

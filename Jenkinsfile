#!/usr/bin/env groovy

pipeline {

    parameters {
    booleanParam(name: "TEST", defaultValue: false)
    string(name: "APP_PORT", defaultValue: '8000')
    string(name: "REMOTE_USER", defaultValue: 'ubuntu')
    string(name: "REMOTE_HOST", defaultValue: 'ip-172-31-27-214')
    string(name: "DOCKER_REPO", defaultValue: 'ignatstrelets')
    string(name: "DOCKER_IMAGE", defaultValue: 'hello_hapi')
    }
    
    environment {
        CI = 'true'
    }
    agent any
    options {
            timeout(time: 180, unit: 'SECONDS')
    }

    stages {
        stage('Build') {
	    steps {
                echo 'Building...'
                sh "docker build --build-arg='APP_PORT=${params.APP_PORT}'  -t ${params.DOCKER_REPO}/${params.DOCKER_IMAGE}:latest ."
	        echo "Docker image. Port to expose: ${params.APP_PORT} ; CI: ${env.CI}"
            }
	}
	stage('Backup') {
            steps {
		echo 'Backup. Pushing Docker Image...'
	withCredentials([usernamePassword(credentialsId: 'dockerHub', passwordVariable: 'dockerHubPassword', usernameVariable: 'dockerHubUser')]) {
        	sh "docker login -u ${env.dockerHubUser} -p ${env.dockerHubPassword}"
        	sh "docker push ${params.DOCKER_REPO}/${params.DOCKER_IMAGE}:latest"
		}
	    }
	}		
        stage('Test') {
            steps {
		script {
		    if (params.TEST) {
			sh "docker run -d --name ${params.CONTAINER_NAME} -p ${params.APP_PORT}:${params.APP_PORT} -u root -v"
			sh "docker exec ${params.CONTAINER_NAME} npm test"
		    }
		}
            }
        }
	stage('Deploy') {
	    steps {
		sh "echo 'DOCKER_REPO=${params.DOCKER_REPO}' > sshenv"
		sh "echo 'DOCKER_IMAGE=${params.DOCKER_IMAGE}' >> sshenv"
		sh "echo 'APP_PORT=${params.APP_PORT}' >> sshenv"
		sh "sudo scp sshenv ${params.REMOTE_USER}@${params.REMOTE_HOST}:/home/ubuntu/.ssh/environment"
		sh "sudo ssh ${params.REMOTE_USER}@${params.REMOTE_HOST} cat /home/ubuntu/.ssh/environment"
		sh "sudo scp deploy.sh ${params.REMOTE_USER}@${params.REMOTE_HOST}:/home/ubuntu/"
		sh "ssh ${params.REMOTE_USER}@${params.REMOTE_HOST} 'chmod +x deploy.sh'"
		sh "ssh ${params.REMOTE_USER}@${params.REMOTE_HOST} 'sudo bash ./deploy.sh'"
		sh "docker ps"
	    }
	}
    }
}

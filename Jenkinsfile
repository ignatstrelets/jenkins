#!/usr/bin/env groovy

pipeline {

    parameters {
    booleanParam(name: "TEST", defaultValue: false)
    string(name: "APP_PORT", defaultValue: '8000')
    string(name: "REMOTE_USER", defaultValue: 'ubuntu')
    string(name: "REMOTE_HOST", defaultValue: 'ip-172-31-27-214')
    string(name: "DOCKER_REPO", defaultValue: 'ignatstrelets')
    string(name: "DOCKER_IMAGE", defaultValue: 'hello_hapi')
    string(name: "CONTAINER_NAME", defaultValue: 'hello_hapi')
    }

    environment {
        CI = 'true'
    }
    agent any
    options {
            timeout(time: 5, unit: 'MINUTES')
    }

    stages {
        stage('Build') {
	    steps {
                sh "docker build --no-cache --build-arg='APP_PORT=${params.APP_PORT}'  -t ${params.DOCKER_REPO}/${params.DOCKER_IMAGE}:latest \
		-f ./Dockerfile ./ "
	        echo "Docker image. Port to expose: ${params.APP_PORT} ; CI: ${env.CI}"
            }
	}
	stage('Backup') {
            steps {
		echo 'Backup. Pushing Docker Image...'
	withCredentials([usernamePassword(credentialsId: 'dockerHub', passwordVariable: 'dockerHubPassword', usernameVariable: 'dockerHubUser')]) {
        	sh "docker login -u $env.dockerHubUser -p $env.dockerHubPassword"
        	sh "docker push ${params.DOCKER_REPO}/${params.DOCKER_IMAGE}:latest"
		}
	    }
	}
        stage('Test') {
            steps {
		script {
		    if (params.TEST) {
			sh "docker pull ${params.DOCKER_REPO}/${params.DOCKER_IMAGE}:latest"
			sh """docker run --name=${params.CONTAINER_NAME} -d -p ${params.APP_PORT}:${params.APP_PORT} \
			${params.DOCKER_REPO}/${params.DOCKER_IMAGE}:latest -u root -v /bin/bash -c 'npm test' &&
			docker stop ${params.CONTAINER_NAME} && docker rm ${params.CONTAINER_NAME}"""
		    }
		}
            }
        }
	stage('Deploy') {
	    steps {
		sh """ sudo ssh ${params.REMOTE_USER}@${params.REMOTE_HOST} " \
		echo 'Starting to deploy docker image..' &&
		sudo docker pull ${params.DOCKER_REPO}/${params.DOCKER_IMAGE}:latest &&
		sudo docker ps -q --filter ancestor=${params.DOCKER_IMAGE} | xargs -r docker stop &&
		sudo docker run --name=${params.CONTAINER_NAME} -d -p ${params.APP_PORT}:${params.APP_PORT} ${params.DOCKER_REPO}/${params.DOCKER_IMAGE}:latest -v /bin/bash -c 'npm start'
		sudo docker ps" """

	    }
	}
    }
}

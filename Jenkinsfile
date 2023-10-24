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
	    skipDefaultCheckout(true)
            timeout(time: 5, unit: 'MINUTES')
    }

    stages {
        stage('Build') {
	    steps {
		cleanWs()
                echo 'Building...'
                sh "docker build --no-cache --build-arg='APP_PORT=${params.APP_PORT}'  -t ${params.DOCKER_REPO}/${params.DOCKER_IMAGE}:latest . "
	        echo "Docker image. Port to expose: ${params.APP_PORT} ; CI: ${env.CI}"
            }
	}
	stage('Backup') {
            steps {
		echo 'Backup. Pushing Docker Image...'
	withCredentials([usernamePassword(credentialsId: 'dockerHub', passwordVariable: 'dockerHubPassword', usernameVariable: 'dockerHubUser')]) {
        	sh 'docker login -u $env.dockerHubUser -p $env.dockerHubPassword'
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
		sh "sudo scp deploy.sh ${params.REMOTE_USER}@${params.REMOTE_HOST}:/home/ubuntu/"
		sh """ sudo ssh ${params.REMOTE_USER}@${params.REMOTE_HOST} " \
		echo "Starting to deploy docker image.." &&
		CURRENT_IMAGE=${params.DOCKER_REPO}/${params.DOCKER_IMAGE}:latest &&
		docker pull $CURRENT_IMAGE &&
		docker ps -q --filter ancestor=${params.DOCKER_IMAGE} | xargs -r docker stop &&
		docker run -d -p ${params.APP_PORT}:${params.APP_PORT} $CURRENT_IMAGE -v &&
		sudo docker ps" """
	    }
	}
    }
    post {
        always {
            cleanWs(cleanWhenNotBuilt: false,
                    deleteDirs: true,
                    disableDeferredWipeout: true,
                    notFailBuild: true,
                    patterns: [[pattern: '.gitignore', type: 'INCLUDE'],
                               [pattern: '.propsfile', type: 'EXCLUDE']])
        }
    }
}

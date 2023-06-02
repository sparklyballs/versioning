pipeline {
	agent {
	label 'DOCKER_BUILD_X86_64'
	}

options {
	skipDefaultCheckout(true)
	buildDiscarder(logRotator(numToKeepStr: '5', artifactNumToKeepStr: '5'))
	}

environment {
	CREDS_DOCKERHUB=credentials('420d305d-4feb-4f56-802b-a3382c561226')
	CREDS_GITHUB=credentials('bd8b00ff-decf-4a75-9e56-1ea2c7d0d708')
	CONTAINER_NAME = 'versioning'
	CONTAINER_REPOSITORY = 'sparklyballs/versioning'
	GITHUB_REPOSITORY = 'sparklyballs/versioning'
	HADOLINT_OPTIONS = '--ignore DL3008 --ignore DL3013 --ignore DL3018 --ignore DL3028 --format json'
	}

stages {

stage('Checkout Repository') {
steps {
	cleanWs()
	checkout scm
	}
	}

stage ("Do Some Linting") {
steps {
	sh ('curl -o linting-script.sh -L https://raw.githubusercontent.com/sparklyballs/versioning/master/linting-script.sh')
	sh ('/bin/bash linting-script.sh')
	recordIssues enabledForFailure: true, tool: hadoLint(pattern: 'hadolint-result.xml')	
	recordIssues enabledForFailure: true, tool: checkStyle(pattern: 'shellcheck-result.xml')	
	}
	}

stage('Build Docker Image') {
steps {
	sh ('docker buildx build \
	--no-cache \
	--pull \
	-t $CONTAINER_REPOSITORY:latest \
	-t $CONTAINER_REPOSITORY:$BUILD_NUMBER \
	.')
	}
	}

stage('Push Docker Image and Tags') {
steps {
	sh ('echo $CREDS_DOCKERHUB_PSW | docker login -u $CREDS_DOCKERHUB_USR --password-stdin')
	sh ('docker image push $CONTAINER_REPOSITORY:latest')
	sh ('docker image push $CONTAINER_REPOSITORY:$BUILD_NUMBER')
	}
	}

stage('Readme Sync') {
steps {
	sh('docker pull ghcr.io/linuxserver/readme-sync')
	sh('docker run --rm=true \
	-e DOCKERHUB_USERNAME=$CREDS_DOCKERHUB_USR \
	-e DOCKERHUB_PASSWORD=$CREDS_DOCKERHUB_PSW \
	-e GIT_REPOSITORY=$GITHUB_REPOSITORY \
	-e DOCKER_REPOSITORY=$CONTAINER_REPOSITORY \
	-e GIT_BRANCH=master \
	ghcr.io/linuxserver/readme-sync bash -c "node sync"')
	}
	}
}
}

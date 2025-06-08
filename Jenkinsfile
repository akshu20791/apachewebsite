pipeline {
    agent any

    environment {
        IMAGE_NAME = 'prabhatsanu1990/prabhatnewimg8june'
        TAG = 'v1'
        FULL_IMAGE = "${IMAGE_NAME}:${TAG}"
        CONTAINER_NAME = 'apache-web'
    }

    stages {
        stage('Clone Repo') {
            steps {
                git url: 'https://github.com/Prabhatsanu/apachewebsite/', branch: 'master'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh "docker build -t ${FULL_IMAGE} ."
                    sh "docker images"
                }
            }
        }

        stage('Docker Login & Push') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-pwd', passwordVariable: 'PASS', usernameVariable: 'USER')]) {
                    sh "echo $PASS | docker login -u $USER --password-stdin"
                    sh "docker push ${FULL_IMAGE}"
                }
            }
        }

        stage('Deploy Container') {
            steps {
                script {
                    sh "docker rm -f ${CONTAINER_NAME} || true"
                    sh "docker run -d --name ${CONTAINER_NAME} -p 8080:80 ${FULL_IMAGE}"
                }
            }
        }
    }
}

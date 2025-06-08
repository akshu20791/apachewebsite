pipeline {
    agent any

    environment {
        IMAGE_NAME = 'prabhatsanu1990/prabhatnewimg9june'
        TAG = 'v1'
        FULL_IMAGE = "${IMAGE_NAME}:${TAG}"
        CONTAINER_NAME = 'My-apache'
        REMOTE_USER = 'ubuntu'
        REMOTE_HOST = '172.31.6.94'
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
                withCredentials([
                    usernamePassword(
                        credentialsId: 'dockerhub-pwd',
                        passwordVariable: 'PASS',
                        usernameVariable: 'USER'
                    )
                ]) {
                    sh "echo $PASS | docker login -u $USER --password-stdin"
                    sh "docker push ${FULL_IMAGE}"
                }
            }
        }

        stage('Remote Deploy') {
            steps {
                script {
                    def removeCmd = "sudo docker rm -f ${CONTAINER_NAME} || true"
                    def runCmd = "sudo docker run -itd --name ${CONTAINER_NAME} -p 8081:80 ${FULL_IMAGE}"

                    sshagent(['sshkeypair']) {
                        sh "ssh -o StrictHostKeyChecking=no ${REMOTE_USER}@${REMOTE_HOST} '${removeCmd}'"
                        sh "ssh -o StrictHostKeyChecking=no ${REMOTE_USER}@${REMOTE_HOST} '${runCmd}'"
                    }
                }
            }
        }
    }
}

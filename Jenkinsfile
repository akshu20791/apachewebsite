pipeline {
    agent any
      environment {
        DOCKER_IMAGE = 'akshu20791/apachewebsite:latest'
        KUBECONFIG = credentials('kubeconfig')
    }

    stages {
        stage('Clone Git repository') {
            steps {
                 git 'https://github.com/akshu20791/apachewebsite/'
            }
        }
        stage('run ansibleplaybook'){
          steps{
            ansiblePlaybook credentialsId: 'ansible-ssh', installation: 'ansible2', inventory: 'inventory.ini', playbook: 'installapche.yml', vaultTmpPath: ''
          }
        }
       stage('Docker Build & Push') {
        steps {
            script {
                withDockerRegistry([credentialsId: 'docker', url: 'https://index.docker.io/v1/']) {
                    sh '''
                    echo "Building Docker image..."
                    docker build --no-cache -t $DOCKER_IMAGE -f Dockerfile .
                    echo "Pushing Docker image to Docker Hub..."
                    docker push $DOCKER_IMAGE
                    '''
                    }
                }
            }
        }
        stage('Deploy to Kubernetes') {
            steps {
                script {
                    withCredentials([file(credentialsId: 'kubeconfig', variable: 'KUBECONFIG_FILE')]) {
                        sh '''
                        echo "Deploying to Kubernetes..."
                        export KUBECONFIG=$KUBECONFIG_FILE

                        kubectl apply -f deployment.yml
                        kubectl apply -f service.yml

                        echo "Deployment and Service applied successfully!"
                        '''
                    }
                }
            }
        }
    }
}




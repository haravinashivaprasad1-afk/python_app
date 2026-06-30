pipeline {
    agent any

    triggers {
        cron('H/5 * * * *')
    }

    environment {
        DOCKER_HUB_USER = 'haravinashivaprasad1'
        IMAGE_NAME = 'python_app'
    }

    stages {
        stage('Checkout') {
            steps {
                checkut scm
            }
        }

        stage('Docker Build') {
            steps {
                sh 'docker build -t $DOCKER_HUB_USER/$IMAGE_NAME:latest .'
            }
        }

        stage('Docker Push') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'docker-hub-credentials',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
                    sh 'docker push $DOCKER_HUB_USER/$IMAGE_NAME:latest'
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh """
                    if command -v kubectl &> /dev/null; then
                        KUBECTL="kubectl"
                    elif command -v minikube &> /dev/null; then
                        KUBECTL="minikube kubectl --"
                    else
                        echo "ERROR: Neither kubectl nor minikube found"
                        exit 1
                    fi

                    if command -v minikube &> /dev/null; then
                        minikube status &> /dev/null || minikube start --driver=docker
                    fi

                    \$KUBECTL apply --validate=false -f k8s-deployment.yaml || true
                    \$KUBECTL rollout restart deployment/python-app
                """
            }
        }
    }
}

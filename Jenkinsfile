pipeline {
    agent any

    stages {
        stage('checkout') {
            steps {
                sh 'rm -rf hello-world-war'
                sh 'git clone -b k8s https://github.com/tarundanda147/hello-world-war.git'
            }
        }
        
        stage('build') {
            steps {
                dir("hello-world-war") {
                    sh 'echo "inside build"'
                    sh "docker build -t tomcat-war:${BUILD_NUMBER} ."
                }
            }
        }
        
        stage('push') {
            steps {
                withCredentials([usernamePassword(credentialsId: '773e6289-72b6-476b-9e54-19702f9fb5d3', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                    sh "docker login -u ${DOCKER_USERNAME} -p ${DOCKER_PASSWORD}"
                    sh "docker tag tomcat-war:${BUILD_NUMBER} tarundanda147/tomcat:${BUILD_NUMBER}"
                    sh "docker push tarundanda147/tomcat:${BUILD_NUMBER}"
                }
            }
        }

        stage('Helm Deploy') {
            steps {
                // Authenticate with AWS using IAM credentials stored in Jenkins
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: '03bb86f5-d824-42dd-b9c7-da3dc566f56c',
                    accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                    secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                ]]) {
                    sh "aws eks --region us-east-1 update-kubeconfig --name eks-cluster"
                    echo 'Deploying to Kubernetes using Helm'
                    // Deploy Helm chart to Kubernetes cluster
                    sh "helm upgrade first  /var/lib/jenkins/workspace/eks-docker/hello-world-war --namespace hello-world-war --set image.tag=$BUILD_NUMBER --dry-run"
                    sh "helm upgrade first  /var/lib/jenkins/workspace/eks-docker/hello-world-war --namespace hello-world-war --set image.tag=$BUILD_NUMBER"
                }
            }
        }
    }
}

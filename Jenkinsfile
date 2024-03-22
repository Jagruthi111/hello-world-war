pipeline {
    agent { label 'slave1' }
    environment {     
        DOCKERHUB_CREDENTIALS= credentials('docker-hub')     
    }
    stages {
        stage('Checkout') {
            steps {
		sh 'git --version'
		sh 'echo "checkout"'   
                sh 'rm -rf hello-world-war'
                git 'https://github.com/Jagruthi111/hello-world-war.git'
		  sh 'echo "checkout done"'
            }
        }
		
        stage('Build') {
            steps {
                sh 'echo "inside build"'
                dir("hello-world-war") {
                    sh 'echo "inside dir"'    
                    sh 'docker build -t tomcat-file:${BUILD_NUMBER} .'
                }
            }
        }
		
        stage('Login to Docker Hub') {         
            steps {                            
                sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'                 
                echo 'Login Completed'                
            }           
        }
        
        stage('Push Image to Docker Hub') {         
            steps {  
                sh "docker tag tomcat-file:${BUILD_NUMBER} jagruthi111/master-slave:${BUILD_NUMBER}"
                sh "docker push jagruthi111/master-slave:${BUILD_NUMBER}"                 
                echo 'Image pushing completed..'       
            }           
        }
        
        stage('Pull and Deploy') {
            parallel {
                stage('Deploy to node1') {
                    agent any
                    steps {
                        sh "docker pull jagruthi111/master-slave:${BUILD_NUMBER}"
                        sh "docker run -d --name my_container_1 -p 8085:8080 jagruthi111/master-slave:${BUILD_NUMBER}"
                    }
                }
                stage('Deploy to slave2') {
                    agent { label 'slave1' }
                    steps {
                        sh "docker pull jagruthi111/master-slave:${BUILD_NUMBER}"
                        sh "docker run -d --name my_container_2 -p 8086:8080 jagruthi111/master-slave:${BUILD_NUMBER}"
                    }
                }
            }
        }
    }
}

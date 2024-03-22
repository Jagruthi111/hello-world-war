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
        	sh 'git clone https://github.com/Jagruthi111/hello-world-war/'
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
                    agent { label 'slave1' }
                    steps {
                        sh "docker pull jagruthi111/master-slave:${BUILD_NUMBER}"
                        sh "docker run -d --name my_container_11 -p 8095:8080 jagruthi111/master-slave:${BUILD_NUMBER}"
                    }
                }
                stage('Deploy to slave2') {
                    agent { label 'slave1' }
                    steps {
                        sh "docker pull jagruthi111/master-slave:${BUILD_NUMBER}"
                        sh "docker run -d --name my_container_22 -p 8088:8080 jagruthi111/master-slave:${BUILD_NUMBER}"
                    }
                }
            }
        }
    }
}

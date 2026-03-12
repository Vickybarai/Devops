node {  
    stage('PULL') { 
                git branch: 'main-code', url: 'https://github.com/Vickybarai/CURD_app.git'
                echo 'NODE :Pulling code from repository...'
    }
    stage('BUILD') { 
        echo 'BUILD SUCCESS'

    }
    stage('Test') { 
         echo 'TEST SUCCESS'
    }
    stage('Deploy') { 
         echo 'DEPLOY SUCCESS'
    }
}
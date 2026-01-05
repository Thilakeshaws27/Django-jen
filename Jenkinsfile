pipeline {
    agent any

    environment {
        VENV = "venv"
    }

    stages {

        stage('Clone Repository') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/Thilakeshaws27/Django-jen.git'
            }
        }

        stage('Setup Virtual Environment') {
            steps {
                sh '''
                python3 -m venv $VENV
                . $VENV/bin/activate
                pip install --upgrade pip
                pip install -r requirements.txt
                '''
            }
        }

        stage('Django Checks') {
            steps {
                sh '''
                . $VENV/bin/activate
                python manage.py check
                '''
            }
        }

        stage('Migrate') {
            steps {
                sh '''
                . $VENV/bin/activate
                python manage.py migrate
                '''
            }
        }

        stage('Restart App') {
            steps {
                echo "Restarting Django app (manual or via gunicorn)"
            }
        }
    }
}


// pipeline {
//     agent { label 'django-slave' }  // Runs all stages on the slave

//     environment {
//         PROJECT_DIR = "/home/jenkins/myweb"   // Your Django project folder on slave
//         VENV_DIR    = "/home/jenkins/venv"    // Virtual environment path
//     }

//     stages {

//         stage('Clone or Update Repository') {
//             steps {
//                 sh '''
//                 if [ ! -d "$PROJECT_DIR" ]; then
//                     git clone https://github.com/USERNAME/REPO_NAME.git $PROJECT_DIR
//                 else
//                     cd $PROJECT_DIR && git pull origin main
//                 fi
//                 '''
//             }
//         }

//         stage('Setup Virtual Environment') {
//             steps {
//                 sh '''
//                 python3 -m venv $VENV_DIR
//                 . $VENV_DIR/bin/activate
//                 pip install --upgrade pip
//                 pip install -r $PROJECT_DIR/requirements.txt
//                 '''
//             }
//         }

//         stage('Run Django Checks') {
//             steps {
//                 sh '''
//                 . $VENV_DIR/bin/activate
//                 cd $PROJECT_DIR
//                 python manage.py check
//                 '''
//             }
//         }

//         stage('Run Migrations & Collect Static') {
//             steps {
//                 sh '''
//                 . $VENV_DIR/bin/activate
//                 cd $PROJECT_DIR
//                 python manage.py migrate
//                 python manage.py collectstatic --noinput
//                 '''
//             }
//         }

//         stage('Restart Services') {
//             steps {
//                 sh '''
//                 # Restart Gunicorn and Nginx
//                 sudo systemctl restart gunicorn
//                 sudo systemctl restart nginx
//                 '''
//             }
//         }
//     }

//     post {
//         success {
//             echo "✅ Django app deployed successfully on the slave!"
//         }
//         failure {
//             echo "❌ Deployment failed. Check logs."
//         }
//     }
// }
// '''

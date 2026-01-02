pipeline {
    agent any

    options {
        skipDefaultCheckout(true)
    }

    environment {
        APP_DIR     = "/home/ubuntu/django-app"
        VENV_DIR    = "venv"
        DJANGO_EC2  = "ubuntu@172.31.0.99"
        DJANGO_SETTINGS_MODULE = "myweb.settings"
    }

    stages {

        stage('Clone Repository') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/Thilakeshaws27/Django-jen.git'
            }
        }

        stage('Install Dependencies (Jenkins Test)') {
            steps {
                sh '''
                python3 -m venv venv
                . venv/bin/activate
                pip install --upgrade pip
                pip install -r requirements.txt
                '''
            }
        }

        stage('Run Django Basic Test') {
            steps {
                sh '''
                . venv/bin/activate
                python manage.py check
                '''
            }
        }

        stage('Deploy to Django EC2') {
            steps {
                sh '''
                ssh ${DJANGO_EC2} "mkdir -p ${APP_DIR}"

                scp -r manage.py requirements.txt myweb app1 app4 dev_django.sh ${DJANGO_EC2}:${APP_DIR}

                ssh ${DJANGO_EC2} "
                  cd ${APP_DIR} &&
                  rm -rf venv &&
                  python3 -m venv venv &&
                  . venv/bin/activate &&
                  pip install --upgrade pip &&
                  pip install -r requirements.txt &&
                  export DJANGO_SETTINGS_MODULE=${DJANGO_SETTINGS_MODULE} &&
                  python manage.py migrate &&
                  python manage.py collectstatic --noinput &&
                  chmod +x dev_django.sh &&
                  ./dev_django.sh restart
                "
                '''
            }
        }
    }
}

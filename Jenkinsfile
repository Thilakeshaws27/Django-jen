pipeline {
    agent any

    environment {
        EC2_USER = "ubuntu"
        EC2_HOST = "172.31.0.99"
        APP_DIR  = "/home/ubuntu/django-app"
        DJANGO_SETTINGS_MODULE = "myweb.settings"
        STATIC_ROOT = "/home/ubuntu/django-app/staticfiles"
    }

    stages {

        stage('Clone Repository') {
            steps {
                git url: 'https://github.com/Thilakeshaws27/Django-jen.git', branch: 'main'
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
                sh """
                ssh ${EC2_USER}@${EC2_HOST} 'mkdir -p ${APP_DIR}'

                scp -r manage.py requirements.txt myweb app1 app4 dev_django.sh \
                    ${EC2_USER}@${EC2_HOST}:${APP_DIR}

                ssh ${EC2_USER}@${EC2_HOST} '
                    cd ${APP_DIR} &&
                    rm -rf venv &&
                    python3 -m venv venv &&
                    . venv/bin/activate &&
                    pip install --upgrade pip &&
                    pip install -r requirements.txt &&
                    export DJANGO_SETTINGS_MODULE=${DJANGO_SETTINGS_MODULE} &&
                    export STATIC_ROOT=${STATIC_ROOT} &&
                    python manage.py migrate &&
                    python manage.py collectstatic --noinput &&
                    chmod +x dev_django.sh &&
                    ./dev_django.sh restart
                '
                """
            }
        }
    }

    post {
        success {
            echo "✅ Deployment completed successfully"
        }
        failure {
            echo "❌ Deployment failed"
        }
    }
}

#!/bin/sh

if [ "$DATABASE" = "postgres" ]
then
    echo "Waiting for postgres..."

    while ! nc -z $SQL_HOST $SQL_PORT; do
      sleep 0.1
    done

    echo "PostgreSQL started"
fi

python manage.py flush --no-input
python manage.py migrate
python manage.py collectstatic --no-input --clear
export DJANGO_SUPERUSER_EMAIL=admin@test.com
export DJANGO_SUPERUSER_PASSWORD=admin
export DJANGO_SUPERUSER_USERNAME=admin
python manage.py createsuperuser --no-input

exec "$@"

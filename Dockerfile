FROM python:3.7-slim

ENV PYTHONUNBUFFERED=1
ENV DJANGO_SETTINGS_MODULE=config.settings.production

RUN apt-get update && apt-get install -y \
    build-essential libpq-dev libmagic1 apache2-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY requirements/ requirements/

RUN pip install --upgrade pip setuptools wheel
RUN pip install --no-cache-dir -r requirements/production.txt
RUN pip install --no-cache-dir -r requirements/extra/pg.txt

COPY . .

RUN python manage.py collectstatic --noinput

CMD ["gunicorn", "config.wsgi", "--bind", "0.0.0.0:8000"]

ARG PROJECT_ID
FROM gcr.io/${PROJECT_ID}/docker-php:latest AS base
COPY docker/cr/php/php.ini /usr/local/etc/php/conf.d/overrides.ini
WORKDIR /application/

FROM base AS testing
COPY composer.* vendo? ./
ARG GITHUB_TOKEN
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \
    composer config -g github-oauth.github.com ${GITHUB_TOKEN} && \
    ([ "$(ls -A vendor)" ] && echo "Skipping dependency install" || composer install --prefer-dist --no-interaction;)

FROM base AS http
EXPOSE 8080
COPY docker/cr/entrypoint.sh /entrypoint.sh
RUN apt-get update -qq && \
    apt-get install -qq nginx && \
    chmod 775 /entrypoint.sh && \
    mkdir /credential && chmod 700 /credential && \
    chown -R www-data:www-data /application/
COPY docker/cr/nginx/application.conf /etc/nginx/sites-enabled/default
COPY docker/cr/php/overrides.conf /usr/local/etc/php-fpm.d/zzz-overrides.conf
COPY --from=gcr.io/berglas/berglas:latest /bin/berglas /bin/berglas
ARG PROCESS_SECRETS="true"
ENV PROCESS_SECRETS=${PROCESS_SECRETS}
ENTRYPOINT ["/entrypoint.sh"]

FROM http as http_deploy
COPY --chown=www-data:www-data . /application
ARG GITHUB_TOKEN
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \
    composer config -g github-oauth.github.com ${GITHUB_TOKEN} && \
    ([ "$(ls -A vendor)" ] && echo "Skipping dependency install" || composer install --no-scripts -o;)




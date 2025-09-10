FROM 510467250861.dkr.ecr.us-east-1.amazonaws.com/percipio-base:node-22-alpine
ARG PROJECT_KEY="PLUMA"
ARG POD_NAME="mailhog-coaching"
LABEL group=$PROJECT_KEY

ENV HOME /home/deploy
ENV NODE_ENV production
WORKDIR $HOME
COPY app/. $HOME

RUN npm install --omit=dev --omit=optional --loglevel=error; \
    chown -R ssuser:ssuser $HOME;

USER ssuser

EXPOSE 8080

CMD [ "npm", "run", "start:production" ]
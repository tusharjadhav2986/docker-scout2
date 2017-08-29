FROM python

MAINTAINER Allen Vailliencourt <allen.vailliencourt@forty8fiftylabs.com>

RUN apt-get update && apt-get install -y groff && \
    git clone https://github.com/nccgroup/Scout2 && \
    pip install -r /scout2/requirements.txt && \
    pip install awscli
# Adding non-root user
RUN groupadd -r scout2 && useradd  -ms /bin/bash -r -g scout2 scout2 && \
    chown -R scout2:scout2 /scout2

ENV AWS_PROFILE="default"
COPY scout2-entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Runs application as scout2 and not root. 
USER scout2
WORKDIR /reports

ENTRYPOINT ["/bin/sh", "/entrypoint.sh"]
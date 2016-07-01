FROM library/ubuntu
RUN apt-get -y update 
RUN apt-get install -y git python-dev python2.7 python-virtualenv \
    ca-certificates libxml2-dev libxslt1-dev build-essential libssl-dev libz-dev libjpeg-dev \
    libldap-dev zlib1g-dev libsasl2-dev libfreetype6-dev libbz2-dev libreadline-dev \
    xpdf xsltproc pdftohtml poppler-utils \
    wv unzip automake autoconf 
RUN addgroup plone && adduser --system --shell /bin/bash --ingroup plone plone
WORKDIR "/opt"
RUN git clone --single-branch https://github.com/plonegovbr/portal.buildout.git portal.buildout
RUN chown -R plone:plone portal.buildout
USER plone
WORKDIR "/opt/portal.buildout"
RUN virtualenv py27 && python py27/bin/activate_this.py
COPY buildout.cfg buildout.cfg
RUN python bootstrap.py -c buildout.cfg
RUN ls -la /usr/lib/python2.7/dist-packages/
RUN ./bin/buildout -c buildout.cfg

EXPOSE 8080
CMD ["bin/supervisord", "-n"]

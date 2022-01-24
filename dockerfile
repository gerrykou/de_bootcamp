FROM python:3.9

RUN python -m pip install pandas

WORKDIR /app

COPY pipeline.py .

ENTRYPOINT [ "python" ,"pipeline.py" ]

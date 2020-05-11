#test.sh
FROM python:3.6
RUN pip install flask
CMD ["python","/app/app.py"]
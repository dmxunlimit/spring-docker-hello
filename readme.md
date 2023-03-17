docker build -t helloworld:1.0 .

docker run -d --name helloWorld -p 8080:8080 helloworld:1.0

curl localhost:8080
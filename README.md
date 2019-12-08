1- I have created our image using this command 

        $ docker build -t breakgame .

2- I have  run the a container from our  image using the command below : 

        $ docker run -d --restart=always -p 80:8000 breakgame 
3- I Opened the web service using the dockertool box IP 192.168.99.100 and the port 80  

4-for the performance test : I have used Jmeter for apache software you will find results in the screenshots 